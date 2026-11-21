"""Tests for nfs_mount."""

import os

import pytest

from ansible_collections.azure.sap_automation.plugins.modules import nfs_mount

SRC = "10.0.2.4:/hanadb1-data-mnt00001"
OPTS = "rw,nfsvers=4.1,hard,timeo=600,rsize=262144,wsize=262144,noatime,lock,_netdev,sec=sys"


@pytest.fixture
def system(tmp_path, monkeypatch):
    """A mount table, an fstab and a temporary directory under tmp_path."""
    mountinfo = tmp_path / "mountinfo"
    mountinfo.write_text(
        "22 1 8:1 / / rw,relatime shared:1 - xfs /dev/sda1 rw\n"
        "40 22 0:50 / /hana/old rw shared:2 - nfs4 10.0.0.9:/old rw\n"
    )
    fstab = tmp_path / "fstab"
    fstab.write_text("/dev/sda1 / xfs defaults 0 0\n")
    share = tmp_path / "share"
    share.mkdir()
    monkeypatch.setattr(nfs_mount, "MOUNTINFO", str(mountinfo))
    monkeypatch.setattr(nfs_mount.tempfile, "mkdtemp", lambda prefix: str(share))
    monkeypatch.setattr(nfs_mount.os, "rmdir", lambda path: None)
    monkeypatch.setattr(nfs_mount.time, "sleep", lambda seconds: None)

    def mounted(path, source, fstype="nfs4"):
        with open(mountinfo, "a") as handle:
            handle.write("41 22 0:51 / %s rw shared:3 - %s %s rw\n" % (path, fstype, source))

    system = type("System", (), {})()
    system.root = tmp_path
    system.fstab = fstab
    system.share = share
    system.mounted = mounted
    return system


def params(system, **extra):
    base = {
        "src": SRC,
        "subdir": "hanadata",
        "path": str(system.root / "hana" / "data"),
        "opts": OPTS,
        "fstab": str(system.fstab),
        "owner": str(os.getuid()),
        "group": str(os.getgid()),
    }
    base.update(extra)
    return base


def test_first_mount_creates_subdir_mount_point_and_fstab_entry(run_module, system):
    run_module.commands.add().add().add()
    result = run_module(nfs_mount.main, params(system))
    path = str(system.root / "hana" / "data")
    assert result["changed"] and result["mounted"] and result["subdir_created"]
    assert result["source"] == SRC + "/hanadata"
    assert (system.share / "hanadata").is_dir()
    assert oct((system.share / "hanadata").stat().st_mode & 0o777) == "0o755"
    assert os.path.isdir(path)
    assert run_module.commands.argv == [
        ["/usr/sbin/mount", "-t", "nfs4", "-o", OPTS, SRC, str(system.share)],
        ["/usr/sbin/umount", str(system.share)],
        ["/usr/sbin/mount", "-t", "nfs4", "-o", OPTS, SRC + "/hanadata", path],
    ]
    assert system.fstab.read_text().splitlines() == [
        "/dev/sda1 / xfs defaults 0 0",
        "%s/hanadata %s nfs4 %s 0 0" % (SRC, path, OPTS),
    ]
    assert result["diff"]["after"].endswith("0 0\n")


def test_mounted_and_recorded_changes_nothing(run_module, system):
    path = str(system.root / "hana" / "data")
    system.mounted(path, SRC + "/hanadata/")
    system.fstab.write_text("%s/hanadata %s nfs4 %s 0 0\n" % (SRC, path, OPTS))
    result = run_module(nfs_mount.main, params(system))
    assert not result["changed"] and result["mounted"] and not result["remount_required"]
    assert run_module.commands.calls == [], "nothing may be mounted or checked on the share"


def test_existing_subdir_is_left_alone(run_module, system):
    (system.share / "hanadata").mkdir(mode=0o700)
    run_module.commands.add().add().add()
    result = run_module(nfs_mount.main, params(system, persist=False))
    assert result["changed"] and not result["subdir_created"]
    assert oct((system.share / "hanadata").stat().st_mode & 0o777) == "0o700"
    assert system.fstab.read_text() == "/dev/sda1 / xfs defaults 0 0\n"


def test_cluster_managed_mount_drops_its_fstab_entries(run_module, system):
    path = str(system.root / "hana" / "data")
    system.mounted(path, SRC + "/hanadata")
    system.fstab.write_text(
        "/dev/sda1 / xfs defaults 0 0\n# %s comment\n%s/hanadata %s nfs4 %s 0 0\n"
        "%s/hanadata %s/ nfs4 defaults\n" % (path, SRC, path, OPTS, SRC, path)
    )
    result = run_module(nfs_mount.main, params(system, persist=False))
    assert result["changed"] and result["fstab_changed"] and not result["remount_required"]
    assert system.fstab.read_text() == "/dev/sda1 / xfs defaults 0 0\n# %s comment\n" % path


def test_changed_options_are_recorded_but_not_remounted(run_module, system):
    path = str(system.root / "hana" / "data")
    system.mounted(path, SRC + "/hanadata")
    system.fstab.write_text("%s/hanadata %s nfs4 rw,hard 0 0\n" % (SRC, path))
    result = run_module(nfs_mount.main, params(system))
    assert result["changed"] and result["remount_required"]
    assert run_module.commands.calls == []
    assert system.fstab.read_text() == "%s/hanadata %s nfs4 %s 0 0\n" % (SRC, path, OPTS)


def test_entry_added_for_a_mount_without_one_does_not_ask_for_a_remount(run_module, system):
    path = str(system.root / "hana" / "data")
    system.mounted(path, SRC + "/hanadata")
    result = run_module(nfs_mount.main, params(system))
    assert result["fstab_changed"] and not result["remount_required"]


def test_mount_from_another_source_is_refused(run_module, system):
    result = run_module(nfs_mount.main, params(system, path="/hana/old"))
    assert result["failed"] and "mounted from 10.0.0.9:/old" in result["msg"]


def test_aznfs_sources_are_not_compared(run_module, system):
    path = str(system.root / "sapmnt")
    system.mounted(path, "10.161.100.100:/sapnfs/sapmnt", fstype="nfs4")
    result = run_module(
        nfs_mount.main,
        params(
            system,
            src="acct.file.core.windows.net:/acct/sapnfs",
            subdir=None,
            path=path,
            fstype="aznfs",
        ),
    )
    assert not result["failed"] and result["fstab_changed"]
    assert "acct.file.core.windows.net:/acct/sapnfs %s aznfs" % path in system.fstab.read_text()


def test_check_mode_writes_nothing(run_module, system):
    result = run_module(nfs_mount.main, params(system, immutable=True), check_mode=True)
    assert result["changed"] and result["subdir_created"] and result["fstab_changed"]
    assert run_module.commands.calls == []
    assert not (system.root / "hana").exists()
    assert system.fstab.read_text() == "/dev/sda1 / xfs defaults 0 0\n"


def test_immutable_mount_point_and_retry(run_module, system):
    path = str(system.root / "sapmnt" / "X00")
    run_module.commands.add(out="--------------e------- %s\n" % path).add().add(
        rc=32, err="access denied"
    ).add()
    result = run_module(nfs_mount.main, params(system, subdir=None, path=path, immutable=True))
    assert result["changed"]
    assert [call[0] for call in run_module.commands.argv] == [
        "/usr/sbin/lsattr",
        "/usr/sbin/chattr",
        "/usr/sbin/mount",
        "/usr/sbin/mount",
    ]

    # Already immutable: no chattr.
    run_module.commands.add(out="----i---------e------- %s\n" % path).add()
    run_module(nfs_mount.main, params(system, subdir=None, path=path, immutable=True))
    assert run_module.commands.argv[-2][0] == "/usr/sbin/lsattr"
    assert run_module.commands.argv[-1][0] == "/usr/sbin/mount"


def test_mount_failures(run_module, system):
    run_module.commands.add(rc=32, err="no route").add(rc=32, err="no route")
    result = run_module(nfs_mount.main, params(system, subdir=None))
    assert result["failed"] and "no route" in result["msg"]

    run_module.commands.add().add(rc=16, err="busy")
    result = run_module(nfs_mount.main, params(system))
    assert result["failed"] and "umount" in result["msg"] and "busy" in result["msg"]

    target = system.root / "file"
    target.write_text("")
    assert "not a directory" in run_module(nfs_mount.main, params(system, path=str(target)))["msg"]
    assert (
        "unknown user" in run_module(nfs_mount.main, params(system, owner="no-such-user-x"))["msg"]
    )
    assert (
        "unknown group"
        in run_module(nfs_mount.main, params(system, group="no-such-group-x"))["msg"]
    )


def test_unmounted_and_absent(run_module, system):
    path = str(system.root / "hana" / "data")
    system.mounted(path, SRC + "/hanadata")
    system.fstab.write_text("%s/hanadata %s nfs4 %s 0 0\n" % (SRC, path, OPTS))
    run_module.commands.add()
    result = run_module(
        nfs_mount.main, {"path": path, "state": "unmounted", "fstab": str(system.fstab)}
    )
    assert result["changed"] and not result["fstab_changed"]
    assert run_module.commands.argv == [["/usr/sbin/umount", path]]

    run_module.commands.add()
    result = run_module(
        nfs_mount.main, {"path": path, "state": "absent", "fstab": str(system.fstab)}
    )
    assert result["changed"] and result["fstab_changed"] and system.fstab.read_text() == ""

    result = run_module(
        nfs_mount.main,
        {"path": "/not/mounted", "state": "absent", "fstab": str(system.root / "missing")},
    )
    assert not result["changed"]


def test_helpers(monkeypatch, tmp_path):
    monkeypatch.setattr(nfs_mount, "MOUNTINFO", str(tmp_path / "missing"))
    assert nfs_mount.mount_source("/x") is None
    assert nfs_mount.normalize("srv:/a//b/") == "srv:/a/b"
    assert nfs_mount.normalize("/dev/sda1/") == "/dev/sda1" and nfs_mount.normalize("/") == "/"
    assert nfs_mount.join_source("srv:/vol/", "/sub/") == "srv:/vol/sub"
    assert nfs_mount.unescape("/a\\040b") == "/a b"
    lines = ["a /x nfs4 o\n", "b /y nfs4 o 0 0"]
    assert nfs_mount.desired_fstab(lines, "/x", "a /x nfs4 o 0 0") == lines
    assert nfs_mount.desired_fstab(lines, "/z", "c /z nfs4 o 0 0")[-2:] == [
        "b /y nfs4 o 0 0\n",
        "c /z nfs4 o 0 0\n",
    ]
