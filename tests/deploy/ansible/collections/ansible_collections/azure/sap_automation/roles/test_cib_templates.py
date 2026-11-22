"""Render every role's CIB templates for each supported platform.

The roles keep platform differences in sparse ``vars/`` files that are merged
at run time. These tests replay that cascade and check that each combination
produces a document the CIB reconciler accepts, with the resource layout the
vendor procedures for SAP HANA on Azure describe.
"""

from pathlib import Path

import pytest
import yaml
from ansible.parsing.dataloader import DataLoader
from ansible.template import Templar
from ansible_collections.azure.sap_automation.plugins.module_utils import cib

ROLES = Path(__file__).parents[8] / (
    "deploy/ansible/collections/ansible_collections/azure/sap_automation/roles"
)

PLATFORMS = {
    "rhel9": ("RedHat", "RedHat", "9", "9.4"),
    "rhel10": ("RedHat", "RedHat", "10", "10.0"),
    "sles12": ("Suse", "SLES_SAP", "12", "12.5"),
    "sles15": ("Suse", "SLES_SAP", "15", "15.6"),
    "sles16": ("Suse", "SLES_SAP", "16", "16.0"),
}

INPUTS = {
    "ha_pacemaker_nodes": [
        {"name": "n1", "address": "10.0.0.1", "vm_name": "vm-n1"},
        {"name": "n2", "address": "10.0.0.2", "vm_name": "vm-n2"},
    ],
    "ha_pacemaker_config_node": "n1",
    "ha_pacemaker_core_cluster_name": "hdb_X00",
    "ha_pacemaker_fence_azure_arm_subscription_id": "sub-id",
    "ha_pacemaker_fence_azure_arm_resource_group": "rg-sap",
    "ha_pacemaker_ra_hana_scaleup_sid": "x00",
    "ha_pacemaker_ra_hana_scaleup_instance_number": "00",
    "ha_pacemaker_ra_hana_scaleup_virtual_ip": "10.0.0.9",
}


def render(role, template, platform, pacemaker="2.1.5", **overrides):
    """Render a role template with the role's own variable cascade applied."""
    os_family, distribution, major, version = PLATFORMS[platform]
    role_dir = ROLES / role
    variables = dict(INPUTS)
    for name in (
        "defaults/main.yml",
        "vars/main.yml",
        "vars/%s.yml" % os_family,
        "vars/%s.yml" % distribution,
        "vars/%s_%s.yml" % (distribution, major),
        "vars/%s_%s.yml" % (distribution, version),
    ):
        path = role_dir / name
        if path.is_file():
            variables.update(yaml.safe_load(path.read_text()) or {})
    variables.update(overrides)
    variables["ansible_facts"] = {
        "hostname": "n1",
        "os_family": os_family,
        "distribution": distribution,
        "distribution_major_version": major,
        "distribution_version": version,
        "packages": {"pacemaker": [{"version": pacemaker}]},
    }
    templar = Templar(loader=DataLoader(), variables=variables)
    text = templar.template((role_dir / "templates/cib" / template).read_text())
    sections = cib.parse_desired(text)
    for name, section in sections.items():
        if name not in cib.MERGE_SECTIONS:
            cib.assign_ids(section, name, name)
    return sections


def pairs(element):
    return {pair.get("name"): pair.get("value") for pair in element.iter("nvpair")}


def ids(section, tag):
    return [element.get("id") for element in section.iter(tag)]


@pytest.mark.parametrize("platform", PLATFORMS)
@pytest.mark.parametrize("flavor", ["classic", "angi"])
def test_hana_resources_render_for_every_platform(platform, flavor):
    sections = render(
        "ha_pacemaker_ra_hana_scaleup",
        "hana.xml.j2",
        platform,
        ha_pacemaker_ra_hana_scaleup_flavor=flavor,
    )
    resources, constraints = sections["resources"], sections["constraints"]
    all_ids = [element.get("id") for element in resources.iter() if element.get("id")]
    assert len(all_ids) == len(set(all_ids)), "duplicate ids in rendered resources"

    top_level = {child.get("id") for child in resources}
    assert constraints.find("rsc_colocation").get("with-rsc") in top_level
    assert constraints.find("rsc_order").get("first") in top_level
    assert constraints.find("rsc_order").get("then") in top_level
    assert pairs(sections["rsc_defaults"])["resource-stickiness"] == "1000"
    assert ("SAPHanaFilesystem" in [p.get("type") for p in resources.iter("primitive")]) == (
        flavor == "angi"
    )


def test_rhel_classic_keeps_pcs_names_and_legacy_roles():
    sections = render("ha_pacemaker_ra_hana_scaleup", "hana.xml.j2", "rhel9")
    resources = sections["resources"]
    assert ids(resources, "clone") == ["SAPHanaTopology_X00_00-clone", "SAPHana_X00_00-clone"]
    assert ids(resources.find("group"), "primitive") == ["nc_X00_00", "vip_X00_00"]
    database = resources.find("clone[@id='SAPHana_X00_00-clone']")
    assert pairs(database.find("meta_attributes"))["promotable"] == "true"
    assert pairs(database.find("primitive/meta_attributes")) == {"priority": "10"}
    assert [op.get("role") for op in database.iter("op") if op.get("role")] == ["Master", "Slave"]
    order = sections["constraints"].find("rsc_order")
    assert order.get("symmetrical") == "false" and order.get("kind") is None
    assert sections["constraints"].find("rsc_colocation").get("rsc-role") is None
    assert pairs(sections["rsc_defaults"])["priority"] == "1"
    assert pairs(resources.find(".//primitive[@id='vip_X00_00']/meta_attributes")) == {
        "priority": "5"
    }


NFS_MOUNTS = [
    {
        "node": "n%d" % n,
        "data": "anf:/d%d/hanadata" % n,
        "log": "anf:/l%d/hanalog" % n,
        "shared": "anf:/s%d/hanashared" % n,
    }
    for n in (1, 2)
]


def test_rhel_classic_nfs_follows_the_documented_layout():
    sections = render(
        "ha_pacemaker_ra_hana_scaleup",
        "hana.xml.j2",
        "rhel9",
        ha_pacemaker_ra_hana_scaleup_nfs=True,
        ha_pacemaker_ra_hana_scaleup_nfs_mounts=NFS_MOUNTS,
    )
    resources, constraints = sections["resources"], sections["constraints"]
    group = resources.find("group[@id='g_hana_X00_NFS_2']")
    assert ids(group, "primitive") == ["hana_data2", "hana_log2", "hana_shared2"]
    data = group.find("primitive[@id='hana_data2']")
    assert data.get("type") == "Filesystem"
    assert pairs(data.find("instance_attributes")) == {
        "device": "anf:/d2/hanadata",
        "directory": "/hana/data",
        "fstype": "nfs",
        "options": "rw,nfsvers=4.1,hard,timeo=600,rsize=262144,wsize=262144,noatime,lock,_netdev,sec=sys",
        "fast_stop": "no",
    }
    monitor = data.find("operations/op")
    assert (monitor.get("interval"), monitor.get("timeout"), monitor.get("on-fail")) == (
        "20s",
        "120s",
        "fence",
    )
    assert pairs(monitor) == {"OCF_CHECK_LEVEL": "20"}
    attribute = resources.find("primitive[@id='attr_hana_X00_NFS_1_active']")
    assert attribute.get("provider") == "pacemaker" and attribute.get("type") == "attribute"
    assert pairs(attribute)["name"] == "attr_hana_X00_NFS_1_active"

    location = constraints.find("rsc_location[@id='loc_g_hana_X00_NFS_1']")
    assert location.get("resource-discovery") == "never"
    expression = location.find("rule/expression")
    assert (expression.get("attribute"), expression.get("value")) == ("#uname", "n2")
    avoids = constraints.find("rsc_location[@id='loc_attr_hana_X00_NFS_2_active_avoids_n1']")
    assert (avoids.get("node"), avoids.get("score")) == ("n1", "-INFINITY")
    order = constraints.find(
        "rsc_order[@id='ord_g_hana_X00_NFS_1_then_attr_hana_X00_NFS_1_active']"
    )
    assert order.get("first") == "g_hana_X00_NFS_1"
    for clone in ("SAPHanaTopology_X00_00-clone", "SAPHana_X00_00-clone"):
        rule = constraints.find("rsc_location[@rsc='%s']/rule" % clone)
        assert (rule.get("score"), rule.get("boolean-op")) == ("-INFINITY", "and")
        assert [e.get("attribute") for e in rule] == [
            "attr_hana_X00_NFS_1_active",
            "attr_hana_X00_NFS_2_active",
        ]
        stops = [
            o
            for o in constraints.iter("rsc_order")
            if o.get("first") == clone and o.get("first-action") == "stop"
        ]
        assert {o.get("then") for o in stops} == {"g_hana_X00_NFS_1", "g_hana_X00_NFS_2"}
        assert {o.get("symmetrical") for o in stops} == {"false"}
    all_ids = [e.get("id") for s in sections.values() for e in s.iter() if e.get("id")]
    assert len(all_ids) == len(set(all_ids)), "duplicate ids"


def test_sles_classic_nfs_adds_the_shared_check_clone():
    sections = render(
        "ha_pacemaker_ra_hana_scaleup",
        "hana.xml.j2",
        "sles15",
        ha_pacemaker_ra_hana_scaleup_nfs=True,
    )
    clone = sections["resources"].find("clone[@id='cln_fs_check_X00_HDB00']")
    assert pairs(clone.find("meta_attributes")) == {"clone-node-max": "1", "interleave": "true"}
    check = clone.find("primitive[@id='rsc_fs_check_X00_HDB00']")
    parameters = pairs(check.find("instance_attributes"))
    assert parameters["device"] == "/hana/shared/X00/check/"
    assert parameters["directory"] == "/hana/shared/check/" and parameters["fstype"] == "nfs"
    assert parameters["options"].startswith("bind,defaults,rw,hard,timeo=600,")
    monitor = check.find("operations/op[@name='monitor']")
    assert (monitor.get("on-fail"), pairs(monitor)) == ("fence", {"OCF_CHECK_LEVEL": "20"})
    assert not [e for e in sections["constraints"] if "fs_check" in (e.get("rsc") or "")]


@pytest.mark.parametrize("platform", ["rhel9", "sles15"])
def test_angi_nfs_adds_nothing_beyond_saphanafilesystem(platform):
    plain = render(
        "ha_pacemaker_ra_hana_scaleup",
        "hana.xml.j2",
        platform,
        ha_pacemaker_ra_hana_scaleup_flavor="angi",
    )
    nfs = render(
        "ha_pacemaker_ra_hana_scaleup",
        "hana.xml.j2",
        platform,
        ha_pacemaker_ra_hana_scaleup_flavor="angi",
        ha_pacemaker_ra_hana_scaleup_nfs=True,
        ha_pacemaker_ra_hana_scaleup_nfs_mounts=NFS_MOUNTS,
    )
    assert {name: cib.ET.tostring(s) for name, s in nfs.items()} == {
        name: cib.ET.tostring(s) for name, s in plain.items()
    }


def test_rhel10_uses_promoted_role_names():
    sections = render("ha_pacemaker_ra_hana_scaleup", "hana.xml.j2", "rhel10")
    roles = [op.get("role") for op in sections["resources"].iter("op") if op.get("role")]
    assert roles == ["Promoted", "Unpromoted"]
    assert sections["constraints"].find("rsc_colocation").get("with-rsc-role") == "Promoted"


def test_sles_classic_layout():
    sections = render("ha_pacemaker_ra_hana_scaleup", "hana.xml.j2", "sles15")
    resources = sections["resources"]
    database = resources.find("clone[@id='msl_SAPHana_X00_HDB00']")
    assert database.find("primitive").get("provider") == "suse"
    assert pairs(database.find("meta_attributes")) == {
        "notify": "true",
        "clone-max": "2",
        "clone-node-max": "1",
        "interleave": "true",
        "target-role": "Started",
        "priority": "100",
        "promotable": "true",
    }
    assert ids(resources.find("group"), "primitive") == ["rsc_ip_X00_HDB00", "rsc_nc_X00_HDB00"]
    start = resources.find(".//primitive[@id='rsc_ip_X00_HDB00']/operations/op[@name='start']")
    assert start.get("on-fail") == "fence"
    colocation = sections["constraints"].find("rsc_colocation")
    assert (colocation.get("rsc-role"), colocation.get("with-rsc-role")) == ("Started", "Master")
    assert sections["constraints"].find("rsc_order").get("kind") == "Optional"


def test_sles12_uses_master_element():
    resources = render("ha_pacemaker_ra_hana_scaleup", "hana.xml.j2", "sles12")["resources"]
    master = resources.find("master")
    assert master.get("id") == "msl_SAPHana_X00_HDB00"
    assert "promotable" not in pairs(master.find("meta_attributes"))


def test_angi_layout_differs_by_platform():
    sles = render(
        "ha_pacemaker_ra_hana_scaleup",
        "hana.xml.j2",
        "sles16",
        ha_pacemaker_ra_hana_scaleup_flavor="angi",
    )["resources"]
    rhel = render(
        "ha_pacemaker_ra_hana_scaleup",
        "hana.xml.j2",
        "rhel9",
        ha_pacemaker_ra_hana_scaleup_flavor="angi",
    )["resources"]
    assert "mst_SAPHanaCon_X00_HDB00" in ids(sles, "clone")
    assert "cln_SAPHanaController_X00_HDB00" in ids(rhel, "clone")
    sles_ops = {
        op.get("name") for op in sles.find(".//primitive[@type='SAPHanaController']").iter("op")
    }
    rhel_ops = {
        op.get("name") for op in rhel.find(".//primitive[@type='SAPHanaController']").iter("op")
    }
    assert sles_ops == {"start", "stop", "promote", "demote", "monitor"}
    assert rhel_ops == {"stop", "monitor"}
    assert ids(rhel.find("group"), "primitive") == ["rsc_nc_X00_HDB00", "rsc_ip_X00_HDB00"]


@pytest.mark.parametrize(
    "platform, expected, unexpected, delay",
    [
        ("rhel9", {"pcmk_monitor_timeout": "120"}, "pcmk_delay_max", "15"),
        ("sles15", {"pcmk_delay_max": "15"}, "pcmk_monitor_timeout", None),
    ],
)
def test_fence_agent_parameters(platform, expected, unexpected, delay):
    sections = render("ha_pacemaker_fence_azure_arm", "stonith.xml.j2", platform)
    primitive = sections["resources"].find("primitive")
    parameters = pairs(primitive.find("instance_attributes"))
    assert parameters["msi"] == "true"
    assert parameters["pcmk_host_map"] == "n1:vm-n1;n2:vm-n2"
    assert parameters["subscriptionId"] == "sub-id" and parameters["resourceGroup"] == "rg-sap"
    assert expected.items() <= parameters.items() and unexpected not in parameters
    assert not {"login", "passwd", "username", "password", "tenantId"} & parameters.keys()
    properties = pairs(sections["crm_config"])
    assert properties["stonith-enabled"] == "true" and properties["stonith-timeout"] == "900"
    assert properties.get("priority-fencing-delay") == delay


@pytest.mark.parametrize(
    "platform, login, password",
    [("rhel9", "username", "password"), ("sles15", "login", "passwd")],
)
def test_fence_agent_service_principal(platform, login, password):
    sections = render(
        "ha_pacemaker_fence_azure_arm",
        "stonith.xml.j2",
        platform,
        ha_pacemaker_fence_azure_arm_authentication="spn",
        ha_pacemaker_fence_azure_arm_tenant_id="tenant-id",
        ha_pacemaker_fence_azure_arm_client_id="client-id",
        ha_pacemaker_fence_azure_arm_client_secret="client-secret",
    )
    parameters = pairs(sections["resources"].find("primitive/instance_attributes"))
    assert "msi" not in parameters
    assert parameters["tenantId"] == "tenant-id"
    assert parameters[login] == "client-id" and parameters[password] == "client-secret"
    assert not {"login", "passwd", "username", "password"} - {login, password} & parameters.keys()
    assert parameters["pcmk_host_map"] == "n1:vm-n1;n2:vm-n2"


@pytest.mark.parametrize(
    "platform, resource_id, agent, parameters",
    [
        ("rhel9", "sbd", "fence_sbd", {"devices": "/dev/disk/by-id/a,/dev/disk/by-id/b"}),
        ("rhel10", "sbd", "fence_sbd", {"devices": "/dev/disk/by-id/a,/dev/disk/by-id/b"}),
        ("sles15", "stonith-sbd", "external/sbd", {"pcmk_delay_max": "15"}),
        ("sles16", "stonith-sbd", "external/sbd", {"pcmk_delay_max": "15"}),
    ],
)
def test_sbd_fence_agent(platform, resource_id, agent, parameters):
    sections = render(
        "ha_pacemaker_fence_sbd",
        "stonith.xml.j2",
        platform,
        ha_pacemaker_fence_sbd_devices=["/dev/disk/by-id/a", "/dev/disk/by-id/b"],
    )
    primitive = sections["resources"].find("primitive")
    assert primitive.get("id") == resource_id and primitive.get("type") == agent
    assert pairs(primitive.find("instance_attributes")) == parameters
    monitor = primitive.find("operations/op")
    assert (monitor.get("interval"), monitor.get("timeout")) == ("600", "120")
    assert pairs(sections["crm_config"]) == {"stonith-enabled": "true", "stonith-timeout": "210"}


def test_fence_agent_cloud_and_overrides():
    sections = render(
        "ha_pacemaker_fence_azure_arm",
        "stonith.xml.j2",
        "sles15",
        ha_pacemaker_fence_azure_arm_cloud="usgov",
        ha_pacemaker_fence_azure_arm_parameters={"power_timeout": "300"},
    )
    parameters = pairs(sections["resources"].find("primitive/instance_attributes"))
    assert parameters["cloud"] == "usgov" and parameters["power_timeout"] == "300"


@pytest.mark.parametrize(
    "platform, pacemaker, clone_id, on_clone",
    [
        ("rhel9", "2.1.5", "health-azure-events-clone", True),
        ("sles15", "2.1.5", "health-azure-events-cln", True),
        ("sles15", "2.0.5", "health-azure-events-cln", False),
    ],
)
def test_azure_events_agent(platform, pacemaker, clone_id, on_clone):
    sections = render("ha_pacemaker_core", "azure_events.xml.j2", platform, pacemaker=pacemaker)
    clone = sections["resources"].find("clone")
    assert clone.get("id") == clone_id
    clone_meta = clone.find("meta_attributes")
    assert (clone_meta is not None) == on_clone
    primitive_meta = pairs(clone.find("primitive/meta_attributes"))
    assert ("allow-unhealthy-nodes" in primitive_meta) != on_clone
    rule = sections["constraints"].find("rsc_location/rule")
    assert rule.get("score-attribute") == "#health-azure"
    assert pairs(sections["crm_config"]) == {"node-health-strategy": "custom"}


def test_kdump_fencing_topology():
    sections = render("ha_pacemaker_fence_kdump", "kdump.xml.j2", "rhel9")
    parameters = pairs(sections["resources"].find("primitive"))
    assert parameters == {"pcmk_reboot_action": "off", "pcmk_host_list": "n1 n2", "timeout": "30"}
    levels = [
        (level.get("id"), level.get("devices"))
        for level in sections["fencing-topology"].iter("fencing-level")
    ]
    assert levels == [
        ("fl-n1-1", "rsc_st_kdump"),
        ("fl-n1-2", "rsc_st_azure"),
        ("fl-n2-1", "rsc_st_kdump"),
        ("fl-n2-2", "rsc_st_azure"),
    ]


ASCS_ERS = {
    "ha_pacemaker_ra_sap_ascs_ers_sid": "s01",
    "ha_pacemaker_ra_sap_ascs_ers_ascs_instance_number": "00",
    "ha_pacemaker_ra_sap_ascs_ers_ers_instance_number": "01",
    "ha_pacemaker_ra_sap_ascs_ers_ascs_virtual_hostname": "s01scs00cl1",
    "ha_pacemaker_ra_sap_ascs_ers_ers_virtual_hostname": "s01ers01cl2",
    "ha_pacemaker_ra_sap_ascs_ers_ascs_virtual_ip": "10.0.1.20",
    "ha_pacemaker_ra_sap_ascs_ers_ers_virtual_ip": "10.0.1.21",
    "ha_pacemaker_ra_sap_ascs_ers_ascs_device": "10.0.2.4:/sapS01/usrsapS01ascs00",
    "ha_pacemaker_ra_sap_ascs_ers_ers_device": "10.0.2.4:/sapS01/usrsapS01ers01",
    "ha_pacemaker_ra_sap_ascs_ers_nfs_options": "sec=sys,nfsvers=4.1",
    "ha_pacemaker_ra_sap_ascs_ers_fs_monitor_timeout": 105,
    "ha_pacemaker_ra_sap_ascs_ers_sap_monitor_timeout": 105,
}


def ascs_ers(platform, enqueue="ensa2", step="main", pacemaker="2.1.5", **extra):
    overrides = dict(ASCS_ERS, ha_pacemaker_ra_sap_ascs_ers_enqueue=enqueue, **extra)
    if step == "main":
        overrides.update(
            __ha_pacemaker_ra_sap_ascs_ers_render=["ascs", "ers"],
            __ha_pacemaker_ra_sap_ascs_ers_with_sap=["ascs", "ers"],
            __ha_pacemaker_ra_sap_ascs_ers_constraints=True,
        )
    else:
        overrides.update(
            __ha_pacemaker_ra_sap_ascs_ers_render=[step],
            __ha_pacemaker_ra_sap_ascs_ers_with_sap=[],
            __ha_pacemaker_ra_sap_ascs_ers_constraints=False,
        )
    return render(
        "ha_pacemaker_ra_sap_ascs_ers", "ascs_ers.xml.j2", platform, pacemaker, **overrides
    )


def ops(primitive):
    return [
        {key: value for key, value in op.attrib.items() if key != "id"}
        for op in primitive.iter("op")
    ]


@pytest.mark.parametrize("platform", PLATFORMS)
@pytest.mark.parametrize("enqueue", ["ensa1", "ensa2"])
def test_ascs_ers_renders_for_every_platform(platform, enqueue):
    sections = ascs_ers(platform, enqueue)
    resources = sections["resources"]
    assert ids(resources, "group") == ["g-S01_ASCS", "g-S01_ERS"]
    all_ids = [e.get("id") for s in sections.values() for e in s.iter() if e.get("id")]
    assert len(all_ids) == len(set(all_ids)), "duplicate ids"
    ascs = resources.find(".//primitive[@id='rsc_sap_S01_ASCS00']")
    assert pairs(ascs.find("instance_attributes")) == {
        "InstanceName": "S01_ASCS00_s01scs00cl1",
        "START_PROFILE": "/sapmnt/S01/profile/S01_ASCS00_s01scs00cl1",
        "AUTOMATIC_RECOVER": "false",
    }
    ers = resources.find(".//primitive[@id='rsc_sap_S01_ERS01']")
    assert pairs(ers.find("instance_attributes"))["IS_ERS"] == "true"
    assert pairs(resources.find("group[@id='g-S01_ASCS']/meta_attributes")) == {
        "resource-stickiness": "3000"
    }
    colocation = sections["constraints"].find("rsc_colocation")
    assert (colocation.get("rsc"), colocation.get("with-rsc"), colocation.get("score")) == (
        "g-S01_ERS",
        "g-S01_ASCS",
        "-5000",
    )
    location = sections["constraints"].find("rsc_location")
    assert (location is not None) == (enqueue == "ensa1")


def test_ascs_ers_sles_follows_the_suse_guide():
    sections = ascs_ers("sles15", "ensa2")
    group = sections["resources"].find("group[@id='g-S01_ASCS']")
    assert [p.get("id") for p in group.iter("primitive")] == [
        "fs_S01_ASCS",
        "nc_S01_ASCS",
        "vip_S01_ASCS",
        "rsc_sap_S01_ASCS00",
    ]
    fs = group.find("primitive[@id='fs_S01_ASCS']")
    assert pairs(fs) == {
        "device": "10.0.2.4:/sapS01/usrsapS01ascs00",
        "directory": "/usr/sap/S01/ASCS00",
        "fstype": "nfs",
        "options": "sec=sys,nfsvers=4.1",
        "fast_stop": "no",
    }
    assert ops(fs) == [
        {"name": "start", "interval": "0", "timeout": "60s"},
        {"name": "stop", "interval": "0", "timeout": "60s"},
        {"name": "monitor", "interval": "20s", "timeout": "105s"},
    ]
    sap = group.find("primitive[@id='rsc_sap_S01_ASCS00']")
    assert sap.find("operations").get("id") == "rsc_sap_S01_ASCS00-operations"
    assert ops(sap) == [
        {"name": "monitor", "interval": "11", "timeout": "105", "on-fail": "restart"}
    ]
    assert pairs(sap.find("meta_attributes")) == {"resource-stickiness": "5000", "priority": "100"}
    order = sections["constraints"].find("rsc_order")
    assert (order.get("first"), order.get("then"), order.get("kind")) == (
        "rsc_sap_S01_ASCS00",
        "rsc_sap_S01_ERS01",
        "Optional",
    )
    assert pairs(sections["crm_config"]) == {"priority-fencing-delay": "30"}
    assert "rsc_defaults" not in sections


def test_ascs_ers_sles_ensa1_uses_the_failover_rule():
    sections = ascs_ers("sles15", "ensa1")
    resources = sections["resources"]
    assert pairs(resources.find(".//primitive[@id='rsc_sap_S01_ASCS00']/meta_attributes")) == {
        "resource-stickiness": "5000",
        "failure-timeout": "105",
        "migration-threshold": "1",
        "priority": "10",
    }
    assert pairs(resources.find(".//primitive[@id='rsc_sap_S01_ERS01']/meta_attributes")) == {
        "priority": "1000"
    }
    rule = sections["constraints"].find("rsc_location[@rsc='rsc_sap_S01_ASCS00']/rule")
    expression = rule.find("expression")
    assert rule.get("score") == "2000"
    assert (expression.get("attribute"), expression.get("value")) == ("runs_ers_S01", "1")
    assert "crm_config" not in sections, "the ENSA1 procedure removes priority-fencing-delay"


def test_ascs_ers_rhel_follows_the_red_hat_guide():
    sections = ascs_ers("rhel9", "ensa1")
    group = sections["resources"].find("group[@id='g-S01_ERS']")
    assert [p.get("id") for p in group.iter("primitive")] == [
        "fs_S01_ERS",
        "vip_S01_ERS",
        "nc_S01_ERS",
        "rsc_sap_S01_ERS01",
    ]
    fs = group.find("primitive[@id='fs_S01_ERS']")
    assert pairs(fs)["force_unmount"] == "safe"
    assert ops(fs)[1:] == [
        {"name": "stop", "interval": "0", "timeout": "120"},
        {"name": "monitor", "interval": "200", "timeout": "105"},
    ]
    assert ops(group.find("primitive[@id='vip_S01_ERS']")) == []
    assert ops(group.find("primitive[@id='rsc_sap_S01_ERS01']")) == [
        {"name": "monitor", "interval": "20", "timeout": "105", "on-fail": "restart"},
        {"name": "start", "interval": "0", "timeout": "600"},
        {"name": "stop", "interval": "0", "timeout": "600"},
    ]
    ascs_meta = sections["resources"].find(".//primitive[@id='rsc_sap_S01_ASCS00']/meta_attributes")
    assert pairs(ascs_meta) == {
        "resource-stickiness": "5000",
        "migration-threshold": "1",
        "failure-timeout": "60",
        "priority": "10",
    }
    order = sections["constraints"].find("rsc_order")
    assert (order.get("first"), order.get("then")) == ("g-S01_ASCS", "g-S01_ERS")
    assert pairs(sections["rsc_defaults"]) == {
        "resource-stickiness": "1",
        "migration-threshold": "3",
        "priority": "1",
    }
    assert pairs(sections["crm_config"]) == {"priority-fencing-delay": "15s"}


def test_ascs_ers_rhel_without_priority_fencing_support():
    sections = ascs_ers("rhel9", "ensa2", pacemaker="2.0.3")
    assert pairs(sections["rsc_defaults"]) == {
        "resource-stickiness": "1",
        "migration-threshold": "3",
    }
    meta = sections["resources"].find(".//primitive[@id='rsc_sap_S01_ASCS00']/meta_attributes")
    assert pairs(meta) == {"resource-stickiness": "5000"}
    assert "crm_config" not in sections


@pytest.mark.parametrize("platform", ["rhel9", "sles15"])
def test_ascs_ers_group_step_creates_one_group_without_constraints(platform):
    sections = ascs_ers(platform, step="ers", ha_pacemaker_ra_sap_ascs_ers_cidr_netmask="24")
    resources = sections["resources"]
    assert ids(resources, "group") == ["g-S01_ERS"]
    assert "SAPInstance" not in [p.get("type") for p in resources.iter("primitive")]
    assert "constraints" not in sections and "crm_config" not in sections
    vip = resources.find(".//primitive[@id='vip_S01_ERS']")
    assert pairs(vip) == {"ip": "10.0.1.21", "cidr_netmask": "24"}
    assert pairs(resources.find(".//primitive[@id='nc_S01_ERS']")) == {"port": "62101"}
