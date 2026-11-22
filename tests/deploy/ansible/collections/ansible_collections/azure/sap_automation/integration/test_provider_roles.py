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
        # The collection under test first, then where its dependencies such as
        # community.general are installed (ANSIBLE_HOME is redirected below).
        ANSIBLE_COLLECTIONS_PATH=os.pathsep.join(
            [str(COLLECTIONS)]
            + (
                [os.environ["ANSIBLE_COLLECTIONS_PATH"]]
                if os.environ.get("ANSIBLE_COLLECTIONS_PATH")
                else []
            )
            + [os.path.expanduser("~/.ansible/collections"), "/usr/share/ansible/collections"]
        ),
        ANSIBLE_LOCALHOST_WARNING="false",
        ANSIBLE_INVENTORY_UNPARSED_WARNING="false",
        ANSIBLE_HOME=str(tmp_path / "ansible"),
        no_proxy="127.0.0.1",
    )

    def play(flavor, *extra, playbook="provider_roles.yml"):
        result = subprocess.run(
            [
                "ansible-playbook",
                str(HERE / playbook),
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


def test_sbd_fencing_cib_step_is_idempotent(cluster):
    assert cluster("classic", playbook="sbd_cib.yml") > 0
    configuration = ET.parse(cluster.cib).getroot().find("configuration")
    properties = {
        p.get("name"): p.get("value") for p in configuration.find("crm_config").iter("nvpair")
    }
    assert properties["stonith-enabled"] == "true" and properties["stonith-timeout"] == "210"
    assert properties["dc-version"] == "2.1.5"
    fence = configuration.find("resources/primitive[@class='stonith']")
    assert fence is not None and fence.get("id") in ("sbd", "stonith-sbd")
    assert cluster("classic", playbook="sbd_cib.yml") == 0, "second run must not change anything"


def test_nvme_shared_disks_use_the_azure_lun_links(cluster):
    cluster("classic", playbook="az_sbd_devices_nvme.yml")
    assert (
        "SBD_DEVICES=/dev/disk/azure/data/by-lun/0;/dev/disk/azure/data/by-lun/1" in cluster.output
    )


@pytest.mark.parametrize("flavor", ["classic", "angi"])
def test_hana_nfs_resources_apply_and_second_run(cluster, flavor):
    # The pacemaker.service drop-in is written outside the CIB; leave it out.
    extra = ("-e", "__ha_pacemaker_ra_hana_scaleup_service_dropin=false")
    assert cluster(flavor, "--check", *extra, playbook="nfs_resources.yml") > 0
    assert cluster.writes() == []
    assert cluster(flavor, *extra, playbook="nfs_resources.yml") > 0
    assert cluster(flavor, *extra, playbook="nfs_resources.yml") == 0, "second run must not change"

    configuration = ET.parse(cluster.cib).getroot().find("configuration")
    resources, constraints = configuration.find("resources"), configuration.find("constraints")
    groups = [g.get("id") for g in resources.iter("group") if "NFS" in g.get("id")]
    if flavor == "angi":
        assert groups == [] and not [c for c in constraints if "NFS" in c.get("id")]
        return
    assert groups == ["g_hana_X00_NFS_1", "g_hana_X00_NFS_2"]
    assert resources.find("group/primitive[@id='hana_log2']") is not None
    assert len([c for c in constraints if "NFS" in c.get("id")]) == 10


@pytest.mark.parametrize("os_family", ["Suse", "RedHat"])
@pytest.mark.parametrize("enqueue", ["ensa1", "ensa2"])
def test_ascs_ers_steps_apply_and_repeat_without_change(cluster, os_family, enqueue):
    extra = ("-e", "os_family=%s enqueue=%s" % (os_family, enqueue))
    assert cluster("classic", "--check", *extra, playbook="ascs_ers.yml") > 0
    assert cluster.writes() == []
    assert cluster("classic", *extra, playbook="ascs_ers.yml") > 0
    assert cluster("classic", *extra, playbook="ascs_ers.yml") == 0, "a second pass must not change"

    configuration = ET.parse(cluster.cib).getroot().find("configuration")
    resources, constraints = configuration.find("resources"), configuration.find("constraints")
    ascs = resources.find("group[@id='g-S01_ASCS']")
    assert [p.get("type") for p in ascs.iter("primitive")][-1] == "SAPInstance"
    assert resources.find("group[@id='g-S01_ERS']/primitive[@id='rsc_sap_S01_ERS01']") is not None
    assert {c.get("id") for c in constraints} >= {
        "col_sap_S01_no_both",
        "ord_sap_S01_first_start_ascs",
    }
    assert (constraints.find("rsc_location") is not None) == (enqueue == "ensa1")
    properties = {
        p.get("name"): p.get("value") for p in configuration.find("crm_config").iter("nvpair")
    }
    assert properties["maintenance-mode"] == "false"
    if os_family == "Suse":
        assert properties.get("priority-fencing-delay") == ("30" if enqueue == "ensa2" else None)


@pytest.mark.parametrize("os_family, flavor", [("RedHat", "classic"), ("Suse", "angi")])
def test_hana_scaleout_apply_and_second_run(cluster, os_family, flavor):
    extra = ("-e", "os_family=%s flavor=%s" % (os_family, flavor))
    assert cluster(flavor, "--check", *extra, playbook="hana_scaleout.yml") > 0
    assert cluster.writes() == []
    assert cluster(flavor, *extra, playbook="hana_scaleout.yml") > 0
    assert cluster(flavor, *extra, playbook="hana_scaleout.yml") == 0, "second run must not change"

    configuration = ET.parse(cluster.cib).getroot().find("configuration")
    controller = configuration.find(".//primitive[@type='SAPHanaController']")
    assert controller is not None
    attributes = Path(str(cluster.cib) + ".attrs.json")
    if os_family == "RedHat":
        assert json.loads(attributes.read_text()) == {
            "n1/NFS_HN1_SITE": "S1",
            "n3/NFS_HN1_SITE": "S2",
        }
        assert configuration.find("alerts") is None
    else:
        assert not attributes.exists()
        assert configuration.find("alerts/alert[@id='fencing-1']") is not None
