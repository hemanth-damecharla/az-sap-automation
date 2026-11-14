"""Tests for the HANA helper functions."""

import pytest
from ansible_collections.azure.sap_automation.plugins.module_utils import hana

SR_STATE = """
SAPCONTROL-OK: <begin>
online=true
mode=sync
operation mode=logreplay
site id=2
site name=SITEB
primary masters=hdb-primary
SAPCONTROL-OK: <end>
done.
"""


@pytest.mark.parametrize(
    "sid, number, valid",
    [("HDB", "00", True), ("hdb", "00", False), ("1DB", "00", False), ("HDB", "0", False)],
)
def test_validate_identity(sid, number, valid):
    assert (hana.validate_identity(sid, number) is None) is valid


def test_environment_points_at_instance_executables():
    env = hana.hana_environment("HDB", "03")
    assert env["LD_LIBRARY_PATH"] == "/usr/sap/HDB/HDB03/exe"
    assert env["SAPSYSTEMNAME"] == "HDB"
    assert "/usr/sap/HDB/HDB03/exe" in env["PATH"]


def test_sr_state_is_parsed_and_summarized():
    summary = hana.summarize_sr_state(hana.parse_key_values(SR_STATE))
    assert summary == {
        "mode": "sync",
        "enabled": True,
        "is_primary": False,
        "is_secondary": True,
        "online": True,
        "site_name": "SITEB",
        "site_id": "2",
        "operation_mode": "logreplay",
        "primary_masters": "hdb-primary",
    }


def test_sr_state_without_replication():
    summary = hana.summarize_sr_state(hana.parse_key_values("online=false\nmode=none\n"))
    assert not summary["enabled"] and not summary["is_primary"] and not summary["online"]


def test_instance_list_ignores_headers():
    text = (
        "GetSystemInstanceList\nOK\n"
        "hostname, instanceNr, httpPort, httpsPort, startPriority, features, dispstatus\n"
        "hdb1, 0, 50013, 50014, 0.3, HDB|HDB_WORKER, GREEN\n"
    )
    assert hana.parse_instance_list(text) == [
        {
            "hostname": "hdb1",
            "instance_number": "00",
            "features": "HDB|HDB_WORKER",
            "status": "GREEN",
        }
    ]
