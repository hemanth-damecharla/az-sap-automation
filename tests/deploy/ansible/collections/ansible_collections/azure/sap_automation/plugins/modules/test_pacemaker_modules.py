"""Tests for the Pacemaker modules."""

from ansible_collections.azure.sap_automation.plugins.modules import (
    pacemaker_attribute,
    pacemaker_cib,
    pacemaker_cluster_info,
)

DESIRED = """
<crm_config><cluster_property_set><nvpair name="stonith-enabled" value="true"/></cluster_property_set></crm_config>
<resources><primitive id="rsc_st_azure" class="stonith" type="fence_azure_arm"/></resources>
"""
CRM_CONFIG = '<crm_config><cluster_property_set id="cib-bootstrap-options"/></crm_config>'


def test_cib_creates_missing_elements_in_dependency_order(run_module):
    run_module.commands.add(out=CRM_CONFIG).add().add(out="<resources/>").add()
    result = run_module(pacemaker_cib.main, {"xml": DESIRED})
    assert result["changed"] and result["sections"] == ["crm_config", "resources"]
    argv = run_module.commands.argv
    assert argv[1] == ["/usr/sbin/cibadmin", "--replace", "--scope", "crm_config", "--xml-pipe"]
    assert argv[3][3] == "resources"
    assert 'id="rsc_st_azure"' in run_module.commands.calls[3][1]["data"]


def test_cib_is_idempotent(run_module):
    live = '<resources><primitive id="rsc_st_azure" class="stonith" type="fence_azure_arm"/></resources>'
    run_module.commands.add(out=live)
    result = run_module(pacemaker_cib.main, {"xml": live})
    assert not result["changed"] and len(run_module.commands.calls) == 1


def test_cib_check_mode_reports_without_writing(run_module):
    run_module.commands.add(out=CRM_CONFIG).add(out="<resources/>")
    result = run_module(pacemaker_cib.main, {"xml": DESIRED}, check_mode=True)
    assert result["changed"] and "rsc_st_azure" in result["diff"]["after"]
    assert len(run_module.commands.calls) == 2


def test_cib_diff_masks_secrets_of_other_resources(run_module):
    fence = (
        '<primitive id="rsc_st_azure" class="stonith" type="fence_azure_arm">'
        '<instance_attributes id="ia"><nvpair id="p" name="passwd" value="s3cret"/>'
        '<nvpair id="l" name="login" value="client-1"/></instance_attributes></primitive>'
    )
    live = "<resources>%s</resources>" % fence
    run_module.commands.add(out=live).add()
    result = run_module(
        pacemaker_cib.main,
        {"xml": '<resources><primitive id="rsc_ip" class="ocf" type="IPaddr2"/></resources>'},
    )
    assert result["changed"]
    diff = result["diff"]["before"] + result["diff"]["after"]
    assert "s3cret" not in diff and "********" in diff and "client-1" in diff
    assert "s3cret" in run_module.commands.calls[1][1]["data"], "the CIB keeps the real value"


def test_cib_creates_section_that_does_not_exist(run_module):
    run_module.commands.add(rc=105).add()
    xml = '<rsc_defaults><meta_attributes><nvpair name="migration-threshold" value="3"/></meta_attributes></rsc_defaults>'
    assert run_module(pacemaker_cib.main, {"xml": xml})["changed"]
    assert run_module.commands.argv[1][1:4] == ["--create", "--scope", "configuration"]


def test_cib_absent_processes_sections_in_reverse(run_module):
    run_module.commands.add(out='<resources><primitive id="rsc_st_azure"/></resources>').add()
    run_module.commands.add(out=CRM_CONFIG)
    result = run_module(pacemaker_cib.main, {"xml": DESIRED, "state": "absent"})
    assert result["sections"] == ["resources"]


def test_cib_failures(run_module):
    assert run_module(pacemaker_cib.main, {"xml": "<nodes/>"})["failed"]

    run_module.commands.add(rc=102, err="Connection refused")
    assert "could not read" in run_module(pacemaker_cib.main, {"xml": DESIRED})["msg"]

    run_module.commands.add(rc=102, err="Connection refused")
    down = run_module(pacemaker_cib.main, {"xml": DESIRED}, check_mode=True)
    assert down["changed"] and not down["failed"]

    run_module.commands.add(out='<resources><primitive id="p"/></resources>')
    clash = '<resources><clone id="c"><primitive id="p"/></clone></resources>'
    assert "different parent" in run_module(pacemaker_cib.main, {"xml": clash})["msg"]

    run_module.commands.add(out="<resources/>").add(rc=203, err="schema validation failed")
    rejected = run_module(pacemaker_cib.main, {"xml": '<resources><primitive id="p"/></resources>'})
    assert rejected["failed"] and "schema validation" in rejected["msg"]


CRM_MON = """
<pacemaker-result>
  <summary>
    <current_dc present="true" with_quorum="true"/>
    <cluster_options stonith-enabled="true" maintenance-mode="true"/>
  </summary>
  <nodes>
    <node name="n1" online="true" standby="false" maintenance="false" unclean="false"/>
    <node name="n2" online="false" standby="false" maintenance="false" unclean="true"/>
  </nodes>
  <resources>
    <clone id="cln"><resource id="rsc" resource_agent="ocf:heartbeat:azure-events-az"
      role="Started" active="true" failed="false" managed="true"><node name="n1"/></resource></clone>
  </resources>
</pacemaker-result>
"""


def test_cluster_info_parses_status(run_module):
    run_module.commands.add(out=CRM_MON)
    result = run_module(pacemaker_cluster_info.main, {})
    assert result["running"] and result["maintenance_mode"] and result["with_quorum"]
    assert result["online_nodes"] == ["n1"] and result["nodes"][1]["unclean"]
    assert result["resources"][0]["nodes"] == ["n1"] and not result["changed"]


def test_cluster_info_falls_back_and_tolerates_stopped_cluster(run_module):
    run_module.commands.add(rc=1).add(out=CRM_MON)
    assert run_module(pacemaker_cluster_info.main, {})["running"]
    assert run_module.commands.argv[1][-1] == "--as-xml"

    run_module.commands.add(rc=102).add(rc=102)
    assert not run_module(pacemaker_cluster_info.main, {})["running"]

    run_module.commands.add(out="<broken")
    assert run_module(pacemaker_cluster_info.main, {})["failed"]


def test_cluster_info_without_pacemaker_installed(run_module, monkeypatch):
    from ansible.module_utils import basic

    monkeypatch.setattr(basic.AnsibleModule, "get_bin_path", lambda *_a, **_k: None)
    assert not run_module(pacemaker_cluster_info.main, {})["running"]


ATTRIBUTE = {"name": "#health-azure", "node": "n1", "value": "0"}


def test_attribute_sets_only_when_different(run_module):
    run_module.commands.add(rc=105).add()
    result = run_module(pacemaker_attribute.main, ATTRIBUTE)
    assert result["changed"] and result["previous_value"] == ""
    assert run_module.commands.argv[1][-2:] == ["--update", "0"]

    run_module.commands.add(out="0\n")
    assert not run_module(pacemaker_attribute.main, ATTRIBUTE)["changed"]


def test_attribute_removal_check_mode_and_failure(run_module):
    run_module.commands.add(out="1\n").add()
    removed = run_module(pacemaker_attribute.main, dict(ATTRIBUTE, state="absent"))
    assert removed["changed"] and run_module.commands.argv[1][-1] == "--delete"

    run_module.commands.add(out="1\n")
    assert run_module(pacemaker_attribute.main, ATTRIBUTE, check_mode=True)["changed"]
    assert len(run_module.commands.calls) == 3

    run_module.commands.add(out="1\n").add(rc=1, err="boom")
    assert run_module(pacemaker_attribute.main, ATTRIBUTE)["failed"]


def test_cib_without_replace_keeps_an_existing_element(run_module):
    live = '<resources><primitive id="rsc_ip" class="ocf" provider="heartbeat" type="IPaddr2"/></resources>'
    run_module.commands.add(out=live)
    desired = (
        '<resources><primitive id="rsc_ip" class="ocf" provider="heartbeat" type="IPaddr2">'
        '<instance_attributes><nvpair name="ip" value="10.0.0.5"/></instance_attributes>'
        "</primitive></resources>"
    )
    result = run_module(pacemaker_cib.main, {"xml": desired, "replace": False})
    assert not result["changed"] and len(run_module.commands.calls) == 1
