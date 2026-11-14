"""Tests for the SAP HANA administration modules."""

import pytest
from ansible_collections.azure.sap_automation.plugins.modules import (
    hana_hsr,
    hana_hsr_info,
    hana_system,
)

IDENTITY = {"sid": "HDB", "instance_number": "00"}
INSTANCES = "hdb1, 0, 50013, 50014, 0.3, HDB, %s\nhdb2, 0, 50013, 50014, 0.3, HDB, %s\n"


@pytest.fixture(autouse=True)
def no_sleep(monkeypatch):
    monkeypatch.setattr(hana_system.time, "sleep", lambda _seconds: None)


def test_system_noop_when_already_in_state(run_module):
    run_module.commands.add(rc=3)
    result = run_module(hana_system.main, dict(IDENTITY, state="started"))
    assert not result["changed"] and result["status"] == "started"
    argv, kwargs = run_module.commands.calls[0]
    assert argv[:3] == ["/usr/sap/HDB/HDB00/exe/sapcontrol", "-nr", "00"]
    assert kwargs["environ_update"]["SAPSYSTEMNAME"] == "HDB"


def test_system_stops_instance_and_waits(run_module):
    run_module.commands.add(rc=3).add().add(rc=2).add(rc=4)
    result = run_module(hana_system.main, dict(IDENTITY, state="stopped"))
    assert result["changed"] and result["status"] == "started"
    assert run_module.commands.argv[1][-2:] == ["-function", "Stop"]


def test_system_scope_uses_instance_list(run_module):
    run_module.commands.add(out=INSTANCES % ("GRAY", "GRAY")).add()
    run_module.commands.add(out=INSTANCES % ("GREEN", "YELLOW")).add(
        out=INSTANCES % ("GREEN", "GREEN")
    )
    result = run_module(hana_system.main, dict(IDENTITY, state="started", scope="system"))
    assert result["changed"] and result["status"] == "stopped"
    assert run_module.commands.argv[1][-3:] == ["-function", "StartSystem", "HDB"]


def test_system_check_mode_invalid_input_and_failures(run_module, monkeypatch):
    run_module.commands.add(rc=4)
    assert run_module(hana_system.main, dict(IDENTITY, state="started"), check_mode=True)["changed"]
    assert len(run_module.commands.calls) == 1

    assert run_module(
        hana_system.main, {"sid": "bad", "instance_number": "00", "state": "started"}
    )["failed"]

    run_module.commands.add(rc=4).add(rc=1, err="denied")
    assert (
        "sapcontrol failed" in run_module(hana_system.main, dict(IDENTITY, state="started"))["msg"]
    )

    ticks = iter([0, 1000])
    monkeypatch.setattr(hana_system.time, "monotonic", lambda: next(ticks))
    run_module.commands.add(rc=4).add().add(rc=2)
    assert "did not reach" in run_module(hana_system.main, dict(IDENTITY, state="started"))["msg"]


def sr_state(mode="none", online="false", site="", masters="", operation=""):
    return "online=%s\nmode=%s\nsite name=%s\nprimary masters=%s\noperation mode=%s\n" % (
        online,
        mode,
        site,
        masters,
        operation,
    )


PRIMARY = dict(IDENTITY, state="primary", site_name="SITEA")
SECONDARY = dict(IDENTITY, state="secondary", site_name="SITEB", remote_host="hdb1")


def test_hsr_enables_primary_once(run_module):
    run_module.commands.add(out=sr_state(online="true")).add()
    assert run_module(hana_hsr.main, PRIMARY)["changed"]
    assert run_module.commands.argv[1][1:] == ["-sr_enable", "--name=SITEA"]

    run_module.commands.add(out=sr_state("primary", "true", "SITEA"))
    assert not run_module(hana_hsr.main, PRIMARY)["changed"]


def test_hsr_registers_secondary_only_when_stopped(run_module):
    run_module.commands.add(out=sr_state()).add()
    assert run_module(hana_hsr.main, SECONDARY)["changed"]
    assert run_module.commands.argv[1][1:] == [
        "-sr_register",
        "--remoteHost=hdb1",
        "--remoteInstance=00",
        "--replicationMode=sync",
        "--operationMode=logreplay",
        "--name=SITEB",
    ]

    run_module.commands.add(out=sr_state(online="true"))
    assert "must be stopped" in run_module(hana_hsr.main, SECONDARY)["msg"]

    run_module.commands.add(out=sr_state("sync", "true", "SITEB", "hdb1", "logreplay"))
    assert not run_module(hana_hsr.main, SECONDARY)["changed"]


def test_hsr_disable_paths(run_module):
    disabled = dict(IDENTITY, state="disabled")
    run_module.commands.add(out=sr_state("sync", site="SITEB")).add()
    assert run_module(hana_hsr.main, disabled)["changed"]
    assert run_module.commands.argv[1][1:] == ["-sr_unregister"]

    run_module.commands.add(out=sr_state("primary", "true", "SITEA")).add()
    run_module(hana_hsr.main, disabled)
    assert run_module.commands.argv[3][1:] == ["-sr_disable"]

    run_module.commands.add(out=sr_state())
    assert not run_module(hana_hsr.main, disabled)["changed"]


def test_hsr_check_mode_and_failures(run_module):
    run_module.commands.add(out=sr_state())
    assert run_module(hana_hsr.main, PRIMARY, check_mode=True)["changed"]
    assert len(run_module.commands.calls) == 1

    assert run_module(hana_hsr.main, dict(PRIMARY, instance_number="0"))["failed"]

    run_module.commands.add(rc=1, err="no instance")
    assert "sr_state failed" in run_module(hana_hsr.main, PRIMARY)["msg"]

    run_module.commands.add(out=sr_state()).add(rc=1, out="backup required")
    assert "backup required" in run_module(hana_hsr.main, PRIMARY)["msg"]


def test_hsr_info(run_module):
    run_module.commands.add(out=sr_state("primary", "true", "SITEA"))
    result = run_module(hana_hsr_info.main, IDENTITY)
    assert result["replication"]["is_primary"] and result["raw"]["mode"] == "primary"
    assert not result["changed"]

    run_module.commands.add(rc=1, err="down")
    assert run_module(hana_hsr_info.main, IDENTITY)["failed"]
    assert run_module(hana_hsr_info.main, {"sid": "x", "instance_number": "00"})["failed"]
