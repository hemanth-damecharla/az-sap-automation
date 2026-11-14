"""Tests for the CIB reconciliation helpers."""

import xml.etree.ElementTree as ET

import pytest
from ansible_collections.azure.sap_automation.plugins.module_utils import cib

PRIMITIVE = """
<resources>
  <primitive id="rsc_ip" class="ocf" provider="heartbeat" type="IPaddr2">
    <instance_attributes><nvpair name="ip" value="10.0.0.5"/></instance_attributes>
    <operations><op name="monitor" interval="10s" timeout="20s"/></operations>
  </primitive>
</resources>
"""


def section(xml_text, name):
    return cib.parse_desired(xml_text)[name]


def test_parse_accepts_configuration_document_and_bare_sections():
    bare = cib.parse_desired("<resources/><constraints/>")
    wrapped = cib.parse_desired("<configuration><resources/><constraints/></configuration>")
    assert sorted(bare) == sorted(wrapped) == ["constraints", "resources"]


@pytest.mark.parametrize(
    "xml_text, message",
    [
        ("<resources>", "not well-formed"),
        ("", "no CIB sections"),
        ("<nodes/>", "unsupported top-level element"),
        ("<resources/><resources/>", "more than once"),
    ],
)
def test_parse_rejects_invalid_input(xml_text, message):
    with pytest.raises(cib.CibError, match=message):
        cib.parse_desired(xml_text)


def test_ids_are_derived_and_stable():
    new_xml, changed = cib.reconcile(None, section(PRIMITIVE, "resources"))
    root = ET.fromstring(new_xml)
    assert changed
    assert root.find("primitive/instance_attributes").get("id") == "rsc_ip-instance_attributes"
    assert root.find(".//nvpair").get("id") == "rsc_ip-instance_attributes-ip"
    assert root.find(".//op").get("id") == "rsc_ip-monitor-10s"

    _again, changed_again = cib.reconcile(new_xml, section(PRIMITIVE, "resources"))
    assert not changed_again


def test_derived_ids_cover_roles_rules_levels_and_invalid_characters():
    desired = section(
        """
        <constraints>
          <rsc_location id="loc" rsc-pattern="!health-.*">
            <rule score-attribute="#health-azure">
              <expression attribute="#uname" operation="defined"/>
            </rule>
          </rsc_location>
        </constraints>
        """,
        "constraints",
    )
    cib.assign_ids(desired, "constraints", "constraints")
    assert desired.find(".//rule").get("id") == "loc-rule"
    assert desired.find(".//expression").get("id") == "loc-rule-expr-1"

    resources = section(
        '<resources><primitive id="r"><meta_attributes>'
        '<nvpair name="#odd name" value="1"/></meta_attributes><operations>'
        '<op name="monitor" interval="59" role="Promoted"/><op name="start"/>'
        "</operations></primitive></resources>",
        "resources",
    )
    cib.assign_ids(resources, "resources", "resources")
    assert resources.find(".//nvpair").get("id") == "r-meta_attributes-_odd_name"
    ops = resources.findall(".//op")
    assert ops[0].get("id") == "r-monitor-59-Promoted"
    assert (ops[1].get("interval"), ops[1].get("id")) == ("0", "r-start-0")

    topology = section(
        '<fencing-topology><fencing-level target="node1" index="1" devices="kdump"/>'
        "</fencing-topology>",
        "fencing-topology",
    )
    cib.assign_ids(topology, "fencing-topology", "fencing-topology")
    assert topology.find("fencing-level").get("id") == "fl-node1-1"
    assert cib._clean_id("1abc") == "_1abc"


def test_nested_resource_without_id_is_rejected():
    desired = section(
        '<resources><clone id="c"><primitive class="ocf"/></clone></resources>', "resources"
    )
    with pytest.raises(cib.CibError, match="requires an explicit id"):
        cib.reconcile(None, desired)


def test_top_level_element_without_id_is_rejected_on_removal():
    with pytest.raises(cib.CibError, match="requires an explicit id"):
        cib.reconcile(
            "<resources/>", section("<resources><primitive/></resources>", "resources"), "absent"
        )


def test_changed_resource_is_replaced_in_place_and_others_are_kept():
    current, _ = cib.reconcile(None, section(PRIMITIVE, "resources"))
    current = current.replace("</resources>", '<primitive id="other"/></resources>')
    new_xml, changed = cib.reconcile(
        current, section(PRIMITIVE.replace("10.0.0.5", "10.0.0.9"), "resources")
    )
    root = ET.fromstring(new_xml)
    assert changed
    assert [child.get("id") for child in root] == ["rsc_ip", "other"]
    assert root.find(".//nvpair").get("value") == "10.0.0.9"


def test_nvpair_order_is_not_a_difference_but_member_order_is():
    one = '<resources><primitive id="p"><meta_attributes id="m">%s</meta_attributes></primitive></resources>'
    a, b = '<nvpair id="a" name="a" value="1"/>', '<nvpair id="b" name="b" value="2"/>'
    current, _ = cib.reconcile(None, section(one % (a + b), "resources"))
    assert not cib.reconcile(current, section(one % (b + a), "resources"))[1]

    group = '<resources><group id="g"><primitive id="%s"/><primitive id="%s"/></group></resources>'
    current, _ = cib.reconcile(None, section(group % ("x", "y"), "resources"))
    assert cib.reconcile(current, section(group % ("y", "x"), "resources"))[1]


def test_reparenting_an_existing_resource_is_refused():
    current = '<resources><primitive id="p"/></resources>'
    desired = section(
        '<resources><clone id="c"><primitive id="p"/></clone></resources>', "resources"
    )
    with pytest.raises(cib.CibError, match="different parent"):
        cib.reconcile(current, desired)


def test_absent_removes_only_named_elements():
    current = '<resources><primitive id="a"/><primitive id="b"/></resources>'
    desired = '<resources><primitive id="a"/><primitive id="missing"/></resources>'
    new_xml, changed = cib.reconcile(current, section(desired, "resources"), "absent")
    assert changed
    assert [child.get("id") for child in ET.fromstring(new_xml)] == ["b"]
    assert not cib.reconcile(new_xml, section(desired, "resources"), "absent")[1]


PROPERTIES = """
<crm_config><cluster_property_set>
  <nvpair name="stonith-enabled" value="true"/>
  <nvpair name="stonith-timeout" value="900"/>
</cluster_property_set></crm_config>
"""


def test_properties_merge_into_existing_set_and_preserve_foreign_values():
    current = (
        '<crm_config><cluster_property_set id="cib-bootstrap-options">'
        '<nvpair id="x-dc" name="dc-version" value="2.1.5"/>'
        '<nvpair id="x-se" name="stonith-enabled" value="false"/>'
        "</cluster_property_set></crm_config>"
    )
    new_xml, changed = cib.reconcile(current, section(PROPERTIES, "crm_config"))
    values = {pair.get("name"): pair.get("value") for pair in ET.fromstring(new_xml).iter("nvpair")}
    assert changed
    assert values == {"dc-version": "2.1.5", "stonith-enabled": "true", "stonith-timeout": "900"}
    assert not cib.reconcile(new_xml, section(PROPERTIES, "crm_config"))[1]


def test_property_set_is_created_with_conventional_id_when_missing():
    new_xml, changed = cib.reconcile(
        None,
        section(
            '<rsc_defaults><meta_attributes><nvpair name="resource-stickiness" value="1000"/>'
            "</meta_attributes></rsc_defaults>",
            "rsc_defaults",
        ),
    )
    root = ET.fromstring(new_xml)
    assert changed
    assert root.find("meta_attributes").get("id") == "rsc-options"
    assert root.find(".//nvpair").get("id") == "rsc-options-resource-stickiness"


def test_property_set_selected_by_explicit_id():
    current = '<crm_config><cluster_property_set id="first"/><cluster_property_set id="second"/></crm_config>'
    desired = '<crm_config><cluster_property_set id="second"><nvpair name="a" value="1"/></cluster_property_set></crm_config>'
    new_xml, _ = cib.reconcile(current, section(desired, "crm_config"))
    sets = ET.fromstring(new_xml).findall("cluster_property_set")
    assert (len(sets[0]), len(sets[1])) == (0, 1)


def test_properties_absent_removes_named_pairs_only():
    current, _ = cib.reconcile(None, section(PROPERTIES, "crm_config"))
    desired = '<crm_config><cluster_property_set><nvpair name="stonith-timeout"/></cluster_property_set></crm_config>'
    new_xml, changed = cib.reconcile(current, section(desired, "crm_config"), "absent")
    assert changed
    assert [pair.get("name") for pair in ET.fromstring(new_xml).iter("nvpair")] == [
        "stonith-enabled"
    ]
    assert not cib.reconcile(None, section(desired, "crm_config"), "absent")[1]


def test_merge_section_rejects_wrong_child_and_bad_current_xml():
    with pytest.raises(cib.CibError, match="only accepts"):
        cib.reconcile(None, section("<crm_config><meta_attributes/></crm_config>", "crm_config"))
    with pytest.raises(cib.CibError, match="cannot parse"):
        cib.reconcile("<resources>", section("<resources/>", "resources"))
    with pytest.raises(cib.CibError, match="expected <resources>"):
        cib.reconcile("<constraints/>", section("<resources/>", "resources"))
