"""Static checks of the Terraform capability contract.

Every root module publishes an output named "capabilities": a versioned, grouped
view of the individual outputs that later deployment stages and add-ons read. The
contract repeats the expressions of those outputs, so this test compares the two
and fails when they drift apart, when a secret is added to the contract, or when
the contract gains or loses an attribute without this specification changing.
"""

import re
from pathlib import Path

import pytest

TERRAFORM_ROOT = Path(__file__).resolve().parents[3] / "deploy" / "terraform"
CONTRACT_VERSION = "1.0"

# Contract attribute -> name of the individual output it repeats.
DEPLOYER = {
    "naming": {
        "environment": "environment",
        "location_short": "location_short",
        "network_logical_name": "network_logical_name",
        "control_plane_name": "control_plane_name",
        "random_id": "random_id",
    },
    "resource_group": {
        "id": "created_resource_group_id",
        "name": "created_resource_group_name",
        "subscription_id": "created_resource_group_subscription_id",
        "location": "created_resource_group_location",
    },
    "network": {
        "vnet_id": "vnet_mgmt_id",
        "management_subnet_id": "subnet_mgmt_id",
        "management_subnet_address_prefixes": "subnet_mgmt_address_prefixes",
        "bastion_subnet_address_prefixes": "subnet_bastion_address_prefixes",
        "webapp_subnet_id": "subnet_webapp_id",
        "endpoint_subnet_id": "endpoint_subnet_id",
        "additional_network_id": "additional_network_id",
        "firewall_allowed_subnet_ids": "subnets_to_add_to_firewall_for_keyvaults_and_storage",
        "agent_ip": "Agent_IP",
        "public_network_access_enabled": "public_network_access_enabled",
        "firewall_for_keyvaults_and_storage_enabled": "enable_firewall_for_keyvaults_and_storage",
        "firewall_id": "firewall_id",
        "firewall_ip": "firewall_ip",
    },
    "network_security_perimeter": {
        "deployed": "network_security_perimeter_deployment",
        "id": "network_security_perimeter_id",
        "access_mode": "network_security_access_mode",
    },
    "identity": {
        "principal_id": "deployer_msi_id",
        "user_assigned": "deployer_uai",
        "user_assigned_identity_id": "deployer_user_assigned_identity",
        "client_id": "deployer_client_id",
        "system_assigned": "deployer_system_assigned_identity",
        "system_assigned_enabled": "add_system_assigned_identity",
        "devops_infrastructure_object_id": "DevOpsInfrastructureObjectId",
    },
    "key_vault": {
        "id": "deployer_kv_user_arm_id",
        "name": "deployer_kv_user_name",
        "ssh_key_secret_name": "deployer_sshkey_secret_name",
        "set_secret_expiry": "set_secret_expiry",
    },
    "virtual_machines": {
        "ids": "deployer_id",
        "public_ip_addresses": "deployer_public_ip_address",
        "username": "deployer_username",
        "extension_ids": "deployer_extension_ids",
    },
    "application_configuration": {
        "deployed": "app_config_deployment",
        "id": "application_configuration_id",
        "name": "application_configuration_name",
    },
    "web_app": {
        "deployed": "app_service_deployment",
        "id": "webapp_id",
        "url_base": "webapp_url_base",
        "identity": "webapp_identity",
    },
    "diagnostics": {"storage_account_id": "diagnostics_account_id"},
}

LIBRARY = {
    "naming": {"environment": "saplibrary_environment", "random_id": "random_id"},
    "resource_group": {
        "id": "created_resource_group_id",
        "name": "created_resource_group_name",
        "subscription_id": "created_resource_group_subscription_id",
    },
    "storage": {
        "tfstate_account_id": "tfstate_resource_id",
        "tfstate_account_name": "remote_state_storage_account_name",
        "sapbits_account_name": "sapbits_storage_account_name",
        "sapbits_resource_group_name": "sapbits_sa_resource_group_name",
    },
}

LANDSCAPE = {
    "naming": {
        "workload_zone_name": "workload_zone_name",
        "workload_zone_prefix": "workload_zone_prefix",
        "control_plane_name": "control_plane_name",
        "control_plane_environment": "controlplane_environment",
        "random_id": "random_id",
    },
    "resource_group": {
        "id": "created_resource_group_id",
        "name": "created_resource_group_name",
        "subscription_id": "created_resource_group_subscription_id",
    },
    "network": {
        "vnet_id": "vnet_sap_arm_id",
        "route_table_id": "route_table_id",
        "management_subnet_id": "subnet_mgmt_id",
        "public_network_access_enabled": "public_network_access_enabled",
        "use_separate_storage_subnet": "use_separate_storage_subnet",
        "subnets": {
            "admin": {"id": "admin_subnet_id", "nsg_id": "admin_nsg_id"},
            "db": {"id": "db_subnet_id", "nsg_id": "db_nsg_id"},
            "app": {"id": "app_subnet_id", "nsg_id": "app_nsg_id"},
            "web": {"id": "web_subnet_id", "nsg_id": "web_nsg_id"},
            "storage": {"id": "storage_subnet_id", "nsg_id": "storage_nsg_id"},
            "endpoint": {"id": "endpoint_subnet_id", "nsg_id": "endpoint_nsg_id"},
            "ams": {"id": "ams_subnet_id"},
        },
    },
    "identity": {"use_spn": "use_spn"},
    "key_vault": {
        "user_id": "landscape_key_vault_user_arm_id",
        "private_id": "landscape_key_vault_private_arm_id",
        "spn_id": "landscape_key_vault_spn_arm_id",
        "name": "workloadzone_kv_name",
        "user_credential_vault_id": "user_credential_vault_id",
        "spn_credential_vault_id": "spn_credential_vault_id",
        "sid_username_secret_name": "sid_username_secret_name",
        "sid_password_secret_name": "sid_password_secret_name",
        "sid_public_key_secret_name": "sid_public_key_secret_name",
    },
    "dns": {
        "label": "dns_label",
        "resource_group_name": "dns_resource_group_name",
        "management_resource_group_name": "management_dns_resourcegroup_name",
        "management_subscription_id": "management_dns_subscription_id",
        "privatelink_resource_group_name": "privatelink_dns_resourcegroup_name",
        "privatelink_subscription_id": "privatelink_dns_subscription_id",
        "privatelink_file_id": "privatelink_file_id",
        "register_virtual_network": "register_virtual_network_to_dns",
        "register_storage_accounts_and_key_vaults": "register_storage_accounts_keyvaults_with_dns",
        "use_custom_a_registration": "use_custom_dns_a_registration",
    },
    "storage": {
        "diagnostics_account_name": "storageaccount_name",
        "diagnostics_resource_group_name": "storageaccount_rg_name",
        "transport_account_id": "transport_storage_account_id",
        "witness_account": "witness_storage_account",
        "utility_account_ids": "utility_storage_account_ids",
        "utility_account_names": "utility_storage_account_names",
        "install_path": "install_path",
        "transport_path": "saptransport_path",
        "netapp_pool": "ANF_pool_settings",
    },
    "iscsi": {
        "authentication_type": "iscsi_authentication_type",
        "authentication_username": "iscsi_authentication_username",
        "private_ips": "iscsi_private_ip",
        "server_ips": "iSCSI_server_ips",
        "server_names": "iSCSI_server_names",
        "servers": "iSCSI_servers",
        "dns_records": "dns_info_iscsi",
    },
    "application_configuration": {
        "id": "application_configuration_id",
        "name": "application_configuration_name",
    },
}

SYSTEM = {
    "naming": {
        "environment": "environment",
        "region": "region",
        "sid": "sid",
        "random_id": "random_id",
        "workload_zone_automation_version": "workload_automation_version",
    },
    "resource_group": {
        "id": "created_resource_group_id",
        "name": "created_resource_group_name",
        "subscription_id": "created_resource_group_subscription_id",
    },
    "hosts": {
        "application": {
            "vm_ids": "app_vm_ids",
            "ips": "app_vm_ips",
            "subnet_netmask": "app_subnet_netmask",
        },
        "central_services": {
            "vm_ids": "scs_vm_ids",
            "loadbalancer_id": "scs_loadbalancer_id",
            "loadbalancer_ips": "scs_loadbalancer_ips",
        },
        "web_dispatcher": {"vm_ids": "web_vm_ids"},
        "database": {
            "hana_vm_ids": "hanadb_vm_ids",
            "anydb_vm_ids": "database_server_vm_ids",
            "ips": "db_vm_ips",
            "admin_ips": "db_vm_admin_ips",
            "secondary_ips": "db_vm_secondary_ips",
            "loadbalancer_id": "database_loadbalancer_id",
            "loadbalancer_ip": "database_loadbalancer_ip",
        },
    },
    "network": {"application_security_group_ids": "asg_ids"},
    "dns": {
        "use_custom_a_registration": "use_custom_dns_a_registration",
        "management_subscription_id": "management_dns_subscription_id",
        "management_resource_group_name": "management_dns_resourcegroup_name",
        "records": {
            "application": "dns_information_app",
            "application_loadbalancers": "dns_information_loadbalancers_app",
            "hana": "dns_information_hanadb",
            "hana_loadbalancers": "dns_information_loadbalancers_hanadb",
            "anydb": "dns_information_anydb",
            "anydb_loadbalancers": "dns_information_loadbalancers_anydb",
        },
    },
    "storage": {
        "disks": "disks",
        "sapmnt_path": "sapmnt_path",
        "hana_shared_afs_path": "hana_shared_afs_path",
    },
    "configuration_settings": "configuration_settings",
}

ROOTS = [
    ("run/sap_deployer", "deployer", DEPLOYER),
    ("bootstrap/sap_deployer", "deployer", DEPLOYER),
    ("run/sap_library", "library", LIBRARY),
    ("bootstrap/sap_library", "library", LIBRARY),
    ("run/sap_landscape", "workload_zone", LANDSCAPE),
    ("run/sap_system", "sap_system", SYSTEM),
]
HEADER = ("contract_version", "stage", "automation_version")
OPENING = "({["
CLOSING = ")}]"


def _strip_comments(text):
    return re.sub(r"(?m)(^|\s)(#|//).*$", "", text)


def _normalise(text):
    return re.sub(r"\s+", "", text)


def _matching_brace(text, start):
    depth = 0
    for position in range(start, len(text)):
        if text[position] == "{":
            depth += 1
        elif text[position] == "}":
            depth -= 1
            if depth == 0:
                return position
    raise AssertionError("unbalanced braces")


def _output_blocks(text):
    blocks = {}
    for match in re.finditer(r'(?m)^output\s+"([^"]+)"\s*\{', text):
        end = _matching_brace(text, match.end() - 1)
        blocks[match.group(1)] = text[match.end() : end]
    return blocks


def _attributes(body):
    """Split the body of a block or object into its top-level attributes."""
    attributes = {}
    depth = 0
    name = None
    start = 0
    for match in re.finditer(r"[({\[\])}]|(?m:^\s*([A-Za-z_][\w-]*)\s*=(?!=))", body):
        token = match.group(0)
        if token in OPENING:
            depth += 1
        elif token in CLOSING:
            depth -= 1
        elif depth == 0:
            if name is not None:
                attributes[name] = body[start : match.start()].strip()
            name = match.group(1)
            start = match.end()
    if name is not None:
        attributes[name] = body[start:].strip()
    return attributes


def _object_body(expression):
    assert expression.startswith("{"), "expected an object, found: %s" % expression[:40]
    return expression[1 : _matching_brace(expression, 0)]


def _leaves(specification, prefix=""):
    for key, value in specification.items():
        if isinstance(value, dict):
            yield from _leaves(value, prefix + key + ".")
        else:
            yield prefix + key, value


def _contract_leaves(expression, specification, prefix=""):
    """Walk the contract object along the specification and return its leaves."""
    attributes = _attributes(_object_body(expression))
    expected = set(specification) | (set(HEADER) if not prefix else set())
    assert set(attributes) == expected, "attributes of capabilities.%s differ" % prefix
    leaves = {}
    for key, value in specification.items():
        if isinstance(value, dict):
            leaves.update(_contract_leaves(attributes[key], value, prefix + key + "."))
        else:
            leaves[prefix + key] = attributes[key]
    if not prefix:
        leaves.update({key: attributes[key] for key in HEADER})
    return leaves


@pytest.fixture(params=ROOTS, ids=[root for root, _, _ in ROOTS])
def root_module(request):
    root, stage, specification = request.param
    text = _strip_comments((TERRAFORM_ROOT / root / "output.tf").read_text())
    blocks = {name: _attributes(body) for name, body in _output_blocks(text).items()}
    assert "capabilities" in blocks, "%s has no capabilities output" % root
    contract = _contract_leaves(blocks["capabilities"]["value"], specification)
    return stage, specification, blocks, contract


def test_contract_identifies_version_and_stage(root_module):
    stage, _, blocks, contract = root_module
    assert contract["contract_version"] == '"%s"' % CONTRACT_VERSION
    assert contract["stage"] == '"%s"' % stage
    assert _normalise(contract["automation_version"]) == _normalise(
        blocks["automation_version"]["value"]
    )


def test_contract_repeats_the_individual_outputs(root_module):
    _, specification, blocks, contract = root_module
    for path, output_name in _leaves(specification):
        assert output_name in blocks, "output %s does not exist" % output_name
        assert _normalise(contract[path]) == _normalise(
            blocks[output_name]["value"]
        ), "capabilities.%s no longer matches output %s" % (path, output_name)


def test_contract_carries_no_secrets(root_module):
    _, specification, blocks, _ = root_module
    assert "sensitive" not in blocks["capabilities"]
    for path, output_name in _leaves(specification):
        assert (
            blocks[output_name].get("sensitive") != "true"
        ), "capabilities.%s repeats the sensitive output %s" % (path, output_name)
