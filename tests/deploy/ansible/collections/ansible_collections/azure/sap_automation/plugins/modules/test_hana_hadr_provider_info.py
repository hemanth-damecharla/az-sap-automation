"""Tests for hana_hadr_provider_info."""

import os

from ansible_collections.azure.sap_automation.plugins.modules import hana_hadr_provider_info

LINE = (
    "[14162]{-1}[-1/-1] 2026-11-21 12:53:55.728027 i ha_dr_provider  "
    "HADRProviderManager.cpp(00083) : loading HA/DR Provider '%s' from %s\n"
)


def trace(directory, name, providers, mtime):
    path = directory / name
    path.write_text(
        "unrelated line\n" + "".join(LINE % (provider, where) for provider, where in providers)
    )
    os.utime(path, (mtime, mtime))


def args(tmp_path, **extra):
    return dict({"sid": "HDB", "instance_number": "00", "trace_dir": str(tmp_path)}, **extra)


def test_latest_load_wins_across_files(run_module, tmp_path):
    # The newer file was written later, although its name sorts first.
    trace(
        tmp_path, "nameserver_n1.30001.001.trc", [("susHanaSR", "/usr/share/SAPHanaSR-angi/")], 200
    )
    trace(
        tmp_path,
        "nameserver_n1.30001.002.trc",
        [("SAPHanaSR", "/usr/share/SAPHanaSR"), ("susHanaSR", "/hana/shared/myHooks")],
        100,
    )
    (tmp_path / "indexserver_n1.30003.000.trc").write_text(LINE % ("Other", "/x"))
    result = run_module(
        hana_hadr_provider_info.main,
        args(tmp_path, providers=["susHanaSR"], path="/usr/share/SAPHanaSR-angi"),
    )
    assert not result["changed"] and result["missing"] == []
    assert result["loaded"] == {
        "SAPHanaSR": "/usr/share/SAPHanaSR",
        "susHanaSR": "/usr/share/SAPHanaSR-angi",
    }


def test_missing_and_wrong_path(run_module, tmp_path):
    trace(tmp_path, "nameserver_n1.30001.000.trc", [("SAPHanaSR", "/usr/share/SAPHanaSR")], 100)
    result = run_module(
        hana_hadr_provider_info.main,
        args(tmp_path, providers=["SAPHanaSR", "susChkSrv"], path="/hana/shared/myHooks/"),
    )
    assert result["missing"] == ["SAPHanaSR", "susChkSrv"]
    result = run_module(hana_hadr_provider_info.main, args(tmp_path, providers=["SAPHanaSR"]))
    assert result["missing"] == [], "without path any load counts"


def test_default_trace_dir_and_failures(run_module, monkeypatch):
    result = run_module(
        hana_hadr_provider_info.main, {"sid": "HDB", "instance_number": "00", "host_name": "vh1"}
    )
    assert result["failed"] and result["trace_dir"] == "/usr/sap/HDB/HDB00/vh1/trace"
    monkeypatch.setattr(hana_hadr_provider_info.socket, "gethostname", lambda: "n1.example")
    result = run_module(hana_hadr_provider_info.main, {"sid": "HDB", "instance_number": "00"})
    assert result["trace_dir"] == "/usr/sap/HDB/HDB00/n1/trace"
    result = run_module(hana_hadr_provider_info.main, {"sid": "hdb", "instance_number": "00"})
    assert result["failed"] and "sid" in result["msg"]


def test_normalize_keeps_the_root():
    assert hana_hadr_provider_info.normalize("/") == "/"
    assert hana_hadr_provider_info.normalize("/usr/share/sap-hana-ha//") == "/usr/share/sap-hana-ha"
