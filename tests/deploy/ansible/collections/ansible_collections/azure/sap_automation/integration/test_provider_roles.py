"""Run the provider roles with real Ansible against test doubles.

``bin/`` holds stand-ins for ``cibadmin``, ``crm_mon`` and ``crm_resource``
that keep the CIB in an XML file, and a local HTTP server stands in for the
Azure Instance Metadata Service. This exercises what unit tests cannot:
argument validation, the variable cascade, check mode and idempotency of the
roles as Ansible actually executes them.
"""

import json
import os
import shutil
import subprocess
import threading
import xml.etree.ElementTree as ET
from http.server import BaseHTTPRequestHandler, HTTPServer
from pathlib import Path

import pytest

HERE = Path(__file__).parent
COLLECTIONS = Path(__file__).parents[8] / "deploy/ansible/collections"
EMPTY_CIB = (
    "<cib><configuration><crm_config>"
    '<cluster_property_set id="cib-bootstrap-options">'
    '<nvpair id="dc" name="dc-version" value="2.1.5"/>'
    "</cluster_property_set></crm_config><nodes/><resources/><constraints/>"
    "</configuration></cib>"
)
METADATA = {
    "compute": {
        "name": "vm-n1",
        "subscriptionId": "sub-1",
        "resourceGroupName": "rg-sap",
        "azEnvironment": "AzurePublicCloud",
    },
    "network": {
        "interface": [{"ipv4": {"ipAddress": [{"privateIpAddress": "10.0.0.1"}]}}],
    },
}

pytestmark = pytest.mark.skipif(
    shutil.which("ansible-playbook") is None, reason="ansible-playbook is not installed"
)


class MetadataHandler(BaseHTTPRequestHandler):
    def do_GET(self):  # pylint: disable=invalid-name
        self.send_response(200 if self.headers.get("Metadata") == "true" else 400)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(json.dumps(METADATA).encode())

    def log_message(self, *_args):
        return


@pytest.fixture(scope="module")
def imds_port():
    server = HTTPServer(("127.0.0.1", 0), MetadataHandler)
    threading.Thread(target=server.serve_forever, daemon=True).start()
    yield server.server_address[1]
    server.shutdown()


@pytest.fixture
def cluster(tmp_path, imds_port):
    cib = tmp_path / "cib.xml"
    cib.write_text(EMPTY_CIB)
    env = dict(
        os.environ,
        FAKE_CIB=str(cib),
        PATH="%s%s%s" % (HERE / "bin", os.pathsep, os.environ["PATH"]),
        ANSIBLE_COLLECTIONS_PATH=str(COLLECTIONS),
        ANSIBLE_LOCALHOST_WARNING="false",
        ANSIBLE_INVENTORY_UNPARSED_WARNING="false",
        ANSIBLE_HOME=str(tmp_path / "ansible"),
        no_proxy="127.0.0.1",
    )

    def play(flavor, *extra):
        result = subprocess.run(
            [
                "ansible-playbook",
                str(HERE / "provider_roles.yml"),
                "-e",
                "flavor=%s imds_port=%d" % (flavor, imds_port),
                *extra,
            ],
            env=env,
            capture_output=True,
            text=True,
            check=False,
        )
        assert result.returncode == 0, result.stdout + result.stderr
        play.output = result.stdout + result.stderr
        recap = result.stdout.rsplit("PLAY RECAP", 1)[1]
        return int(recap.split("changed=")[1].split()[0])

    play.cib = cib
    play.writes = lambda: (
        Path(str(cib) + ".log").read_text().splitlines() if Path(str(cib) + ".log").exists() else []
    )
    return play


@pytest.mark.parametrize("flavor", ["classic", "angi"])
def test_check_mode_apply_and_second_run(cluster, flavor):
    assert cluster(flavor, "--check") > 0
    assert cluster.writes() == [], "check mode must not write to the CIB"

    assert cluster(flavor) > 0
    writes = cluster.writes()
    assert "--create --scope configuration --xml-pipe" in writes  # rsc_defaults did not exist
    assert writes.index("--replace --scope resources --xml-pipe") < writes.index(
        "--replace --scope constraints --xml-pipe"
    )

    assert cluster(flavor) == 0, "second run must not change anything"
    assert cluster.writes() == writes

    configuration = ET.parse(cluster.cib).getroot().find("configuration")
    properties = {
        p.get("name"): p.get("value") for p in configuration.find("crm_config").iter("nvpair")
    }
    assert properties["dc-version"] == "2.1.5"
    assert properties["stonith-enabled"] == "true" and properties["maintenance-mode"] == "false"
    fence = configuration.find("resources/primitive[@id='rsc_st_azure']")
    parameters = {p.get("name"): p.get("value") for p in fence.iter("nvpair")}
    assert parameters["pcmk_host_map"] == "n1:vm-n1;n2:vm-n2"
    assert parameters["subscriptionId"] == "sub-1" and parameters["resourceGroup"] == "rg-sap"
    types = {p.get("type") for p in configuration.find("resources").iter("primitive")}
    assert ("SAPHanaController" in types) == (flavor == "angi")
    assert len(configuration.find("constraints")) == 2


def test_service_principal_fencing_keeps_the_secret_out_of_the_output(cluster):
    assert cluster("classic", "-e", "auth=spn", "--diff", "-v") > 0
    assert "not-a-real-secret-7f3a" not in cluster.output

    configuration = ET.parse(cluster.cib).getroot().find("configuration")
    fence = configuration.find("resources/primitive[@id='rsc_st_azure']")
    parameters = {p.get("name"): p.get("value") for p in fence.iter("nvpair")}
    assert "msi" not in parameters
    assert parameters["tenantId"] == "tenant-1"
    credentials = {parameters.get(name) for name in ("login", "username", "passwd", "password")}
    assert {"client-1", "not-a-real-secret-7f3a"} <= credentials

    assert cluster("classic", "-e", "auth=spn") == 0, "second run must not change anything"
