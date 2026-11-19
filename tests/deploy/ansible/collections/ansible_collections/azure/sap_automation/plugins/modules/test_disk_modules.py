"""Tests for the SBD and disk modules."""

import os

from ansible_collections.azure.sap_automation.plugins.modules import disk_by_id, sbd_device


def devices(tmp_path, *names):
    paths = []
    for name in names:
        path = tmp_path / name
        path.write_text("")
        paths.append(str(path))
    return paths


def test_sbd_initializes_only_devices_without_header(run_module, tmp_path):
    first, second = devices(tmp_path, "sbd1", "sbd2")
    run_module.commands.add(rc=0).add(rc=1).add()
    result = run_module(sbd_device.main, {"devices": [first, second]})
    assert result["changed"]
    assert result["initialized"] == [first] and result["created"] == [second]
    assert run_module.commands.argv[2] == [
        "/usr/sbin/sbd",
        "-d",
        second,
        "-1",
        "60",
        "-4",
        "120",
        "create",
    ]


def test_sbd_leaves_initialized_devices_alone(run_module, tmp_path):
    (first,) = devices(tmp_path, "sbd1")
    run_module.commands.add(rc=0)
    result = run_module(sbd_device.main, {"devices": [first]})
    assert not result["changed"] and len(run_module.commands.calls) == 1


def test_sbd_check_mode_and_custom_timeouts(run_module, tmp_path):
    (first,) = devices(tmp_path, "sbd1")
    run_module.commands.add(rc=1)
    result = run_module(sbd_device.main, {"devices": [first]}, check_mode=True)
    assert result["changed"] and result["created"] == [first]
    assert len(run_module.commands.calls) == 1, "check mode must not write a header"

    run_module.commands.add(rc=1).add()
    run_module(sbd_device.main, {"devices": [first], "watchdog_timeout": 30, "msgwait_timeout": 60})
    assert run_module.commands.argv[-1][-5:] == ["-1", "30", "-4", "60", "create"]


def test_sbd_failures(run_module, tmp_path):
    assert "at least one" in run_module(sbd_device.main, {"devices": []})["msg"]
    missing = str(tmp_path / "missing")
    assert "does not exist" in run_module(sbd_device.main, {"devices": [missing]})["msg"]
    (first,) = devices(tmp_path, "sbd1")
    run_module.commands.add(rc=1).add(rc=1, err="device busy")
    result = run_module(sbd_device.main, {"devices": [first]})
    assert result["failed"] and "device busy" in result["msg"]


def by_id_tree(tmp_path):
    """A fake device, its by-id links, and an Azure LUN link pointing to it."""
    device = tmp_path / "sdc"
    device.write_text("")
    other = tmp_path / "sdd"
    other.write_text("")
    by_id = tmp_path / "by-id"
    by_id.mkdir()
    os.symlink(device, by_id / "wwn-0x600")
    os.symlink(device, by_id / "scsi-3600")
    os.symlink(device, by_id / "scsi-SMsft_Virtual_Disk")
    os.symlink(other, by_id / "scsi-3700")
    lun = tmp_path / "lun0"
    os.symlink(device, lun)
    return device, by_id, lun


def test_disk_by_id_prefers_the_wwn_based_scsi_name(run_module, tmp_path):
    device, by_id, lun = by_id_tree(tmp_path)
    result = run_module(disk_by_id.main, {"path": str(lun), "by_id_dir": str(by_id)})
    assert not result["changed"] and result["device"] == str(device)
    assert result["by_id"] == str(by_id / "scsi-3600")
    assert result["links"] == [
        str(by_id / name) for name in ("scsi-3600", "scsi-SMsft_Virtual_Disk", "wwn-0x600")
    ]


def test_disk_by_id_falls_back_to_the_first_link(run_module, tmp_path):
    _device, by_id, lun = by_id_tree(tmp_path)
    result = run_module(
        disk_by_id.main, {"path": str(lun), "by_id_dir": str(by_id), "prefer": ["nvme-"]}
    )
    assert result["by_id"] == str(by_id / "scsi-3600")


def test_disk_by_id_failures(run_module, tmp_path):
    missing = str(tmp_path / "missing")
    assert "does not exist" in run_module(disk_by_id.main, {"path": missing})["msg"]
    lonely = tmp_path / "sde"
    lonely.write_text("")
    result = run_module(
        disk_by_id.main, {"path": str(lonely), "by_id_dir": str(tmp_path / "no-such-dir")}
    )
    assert result["failed"] and "no link" in result["msg"]
