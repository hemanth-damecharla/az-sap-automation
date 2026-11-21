"""Run the HA/DR hook role with real Ansible against a HANA layout in files.

``library/fake_platform.py`` presents the node as SLES or RHEL, the role's
paths point into a temporary directory, and a trace file stands in for the
name server's record of the providers it loaded. HANA is never restarted:
the runs use ``activation=none``, or ``restart`` when nothing changed.
"""

import configparser
import getpass
import grp
import os
import shutil
import subprocess
from pathlib import Path

import pytest

HERE = Path(__file__).parent
COLLECTIONS = Path(__file__).parents[8] / "deploy/ansible/collections"

pytestmark = pytest.mark.skipif(
    shutil.which("ansible-playbook") is None, reason="ansible-playbook is not installed"
)


@pytest.fixture
def hana(tmp_path):
    root = tmp_path / "hana"
    (root / "hooks").mkdir(parents=True)
    (root / "trace").mkdir()
    for script in ("SAPHanaSR", "susChkSrv", "susHanaSR", "HanaSR", "ChkSrv"):
        (root / "hooks" / (script + ".py")).write_text("")
    (root / "global.ini").write_text("[persistence]\nbasepath_datavolumes = /hana/data/X00\n")
    user = getpass.getuser()
    env = dict(
        os.environ,
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
    )
    # The files belong to the test user instead of <sid>adm and root.
    owners = [
        "-e",
        "__sap_db_hana_hadr_hooks_admin_user=%s" % user,
        "-e",
        "__sap_db_hana_hadr_hooks_sudoers_owner=%s" % user,
        "-e",
        "__sap_db_hana_hadr_hooks_sudoers_owner_group=%s" % grp.getgrgid(os.getgid()).gr_name,
    ]
    if shutil.which("visudo") is None:
        owners += ["-e", "sap_db_hana_hadr_hooks_sudoers_validate="]

    def play(*extra, succeed=True):
        result = subprocess.run(
            ["ansible-playbook", str(HERE / "hadr_hooks.yml"), "-e", "root=%s" % root]
            + owners
            + list(extra),
            env=env,
            capture_output=True,
            text=True,
            check=False,
        )
        play.output = result.stdout + result.stderr
        assert (result.returncode == 0) == succeed, play.output
        recap = result.stdout.rsplit("PLAY RECAP", 1)[1]
        return int(recap.split("changed=")[1].split()[0])

    def loaded(*providers, path=None):
        lines = [
            "[1]{-1}[-1/-1] 2026-11-21 i ha_dr_provider HADRProviderManager.cpp(00083) : "
            "loading HA/DR Provider '%s' from %s\n" % (provider, path or root / "hooks")
            for provider in providers
        ]
        (root / "trace" / "nameserver_n1.30001.000.trc").write_text("".join(lines))

    def ini():
        parser = configparser.ConfigParser()
        parser.optionxform = str
        parser.read(root / "global.ini")
        return {section: dict(parser[section]) for section in parser.sections()}

    play.root = root
    play.loaded = loaded
    play.ini = ini
    play.sudoers = lambda: (root / "20-saphana").read_text()
    return play


def test_sles_classic_check_mode_apply_and_verified_second_run(hana):
    before = (hana.root / "global.ini").read_text()
    assert hana("--check") > 0
    assert (hana.root / "global.ini").read_text() == before, "check mode must not write"
    assert not (hana.root / "20-saphana").exists()

    assert hana() == 2
    assert "HANA loads SAPHanaSR, susChkSrv at its next start" in hana.output
    hooks = str(hana.root / "hooks")
    assert hana.ini() == {
        "persistence": {"basepath_datavolumes": "/hana/data/X00"},
        "ha_dr_provider_SAPHanaSR": {
            "provider": "SAPHanaSR",
            "path": hooks,
            "execution_order": "1",
        },
        "trace": {"ha_dr_saphanasr": "info"},
        "ha_dr_provider_suschksrv": {
            "provider": "susChkSrv",
            "path": hooks,
            "execution_order": "3",
            "action_on_lost": "fence",
        },
    }
    sudoers = hana.sudoers()
    assert (
        "Cmnd_Alias SOK_SITEA = /usr/sbin/crm_attribute -n hana_x00_site_srHook_SITEA"
        " -v SOK -t crm_config -s SAPHanaSR" in sudoers
    )
    assert (
        "HELPER_TAKEOVER = /usr/sbin/SAPHanaSR-hookHelper --sid=X00 --case=checkTakeover" in sudoers
    )
    assert sudoers.rstrip().endswith(
        "NOPASSWD: SOK_SITEA, SFAIL_SITEA, SOK_SITEB, SFAIL_SITEB, HELPER_TAKEOVER, HELPER_FENCE"
    )

    # Nothing changed, so restart mode does not restart and only verifies.
    hana.loaded("SAPHanaSR", "susChkSrv")
    assert hana("-e", "activation=restart") == 0
    assert "Wait until the name server loaded the hooks" in hana.output


def test_switching_to_angi_removes_the_classic_hook_and_verifies_the_new_one(hana):
    hana()
    assert hana("-e", "flavor=angi") > 0
    sections = hana.ini()
    assert "ha_dr_provider_SAPHanaSR" not in sections
    assert sections["ha_dr_provider_sushanasr"]["provider"] == "susHanaSR"
    assert sections["trace"] == {"ha_dr_sushanasr": "info", "ha_dr_suschksrv": "info"}
    assert "/usr/bin/SAPHanaSR-hookHelper" in hana.sudoers()

    # The name server still reports the classic hook: the check must fail.
    hana.loaded("SAPHanaSR", "susChkSrv")
    hana("-e", "flavor=angi", "-e", "activation=restart", succeed=False)
    assert '"missing": ["susHanaSR"]' in hana.output

    hana.loaded("SAPHanaSR", "susChkSrv", "susHanaSR")
    assert hana("-e", "flavor=angi", "-e", "activation=restart") == 0


@pytest.mark.parametrize(
    "flavor, srhook, action, sudoers",
    [
        (
            "classic",
            "ha_dr_provider_SAPHanaSR",
            "kill",
            "Defaults!SITEA_SOK, SITEA_SFAIL, SITEB_SOK, SITEB_SFAIL !requiretty",
        ),
        ("angi", "ha_dr_provider_hanasr", "fence", "NOPASSWD: /usr/bin/SAPHanaSR-hookHelper"),
    ],
)
def test_rhel_follows_the_documented_configuration(hana, flavor, srhook, action, sudoers):
    platform = ["-e", "os_family=RedHat", "-e", "flavor=%s" % flavor]
    assert hana(*platform) > 0
    sections = hana.ini()
    assert sections[srhook]["execution_order"] == "1"
    assert sections["ha_dr_provider_chksrv"] == {
        "provider": "ChkSrv",
        "path": str(hana.root / "hooks"),
        "execution_order": "2",
        "action_on_lost": action,
    }
    assert sections["trace"]["ha_dr_chksrv"] == "info"
    assert sudoers in hana.sudoers()

    # The name server may report the directory with a trailing slash.
    provider = sections[srhook]["provider"]
    hana.loaded(provider, "ChkSrv", path=str(hana.root / "hooks") + "/")
    assert hana(*platform, "-e", "activation=restart") == 0


def test_missing_hook_script_stops_the_role_before_global_ini_changes(hana):
    (hana.root / "hooks" / "susChkSrv.py").unlink()
    before = (hana.root / "global.ini").read_text()
    hana(succeed=False)
    assert "Hook scripts not found" in hana.output and "susChkSrv" in hana.output
    assert (hana.root / "global.ini").read_text() == before
