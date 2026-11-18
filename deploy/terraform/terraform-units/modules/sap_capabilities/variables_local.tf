# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Upstream states written since the capability contract was introduced publish a
# "capabilities" output. When it is present its attributes are used; they are
# mapped back to the names of the individual outputs, which is what the child
# modules read. States written before that are passed through unchanged.

locals {
  // Version of the capability contract in the deployer state, empty when the state predates the contract
  deployer_contract_version = try(tostring(var.deployer_outputs.capabilities.contract_version), "")

  // Attributes of the deployer contract under the names of the individual outputs. The mapping is
  // dropped as a whole when the state has no contract.
  deployer_contract         = try({
    environment                                          = var.deployer_outputs.capabilities.naming.environment
    location_short                                       = var.deployer_outputs.capabilities.naming.location_short
    network_logical_name                                 = var.deployer_outputs.capabilities.naming.network_logical_name
    control_plane_name                                   = var.deployer_outputs.capabilities.naming.control_plane_name
    random_id                                            = var.deployer_outputs.capabilities.naming.random_id
    created_resource_group_id                            = var.deployer_outputs.capabilities.resource_group.id
    created_resource_group_name                          = var.deployer_outputs.capabilities.resource_group.name
    created_resource_group_subscription_id               = var.deployer_outputs.capabilities.resource_group.subscription_id
    created_resource_group_location                      = var.deployer_outputs.capabilities.resource_group.location
    vnet_mgmt_id                                         = var.deployer_outputs.capabilities.network.vnet_id
    subnet_mgmt_id                                       = var.deployer_outputs.capabilities.network.management_subnet_id
    subnet_mgmt_address_prefixes                         = var.deployer_outputs.capabilities.network.management_subnet_address_prefixes
    subnet_bastion_address_prefixes                      = var.deployer_outputs.capabilities.network.bastion_subnet_address_prefixes
    subnet_webapp_id                                     = var.deployer_outputs.capabilities.network.webapp_subnet_id
    endpoint_subnet_id                                   = var.deployer_outputs.capabilities.network.endpoint_subnet_id
    additional_network_id                                = var.deployer_outputs.capabilities.network.additional_network_id
    subnets_to_add_to_firewall_for_keyvaults_and_storage = var.deployer_outputs.capabilities.network.firewall_allowed_subnet_ids
    Agent_IP                                             = var.deployer_outputs.capabilities.network.agent_ip
    public_network_access_enabled                        = var.deployer_outputs.capabilities.network.public_network_access_enabled
    enable_firewall_for_keyvaults_and_storage            = var.deployer_outputs.capabilities.network.firewall_for_keyvaults_and_storage_enabled
    firewall_id                                          = var.deployer_outputs.capabilities.network.firewall_id
    firewall_ip                                          = var.deployer_outputs.capabilities.network.firewall_ip
    network_security_perimeter_deployment                = var.deployer_outputs.capabilities.network_security_perimeter.deployed
    network_security_perimeter_id                        = var.deployer_outputs.capabilities.network_security_perimeter.id
    network_security_access_mode                         = var.deployer_outputs.capabilities.network_security_perimeter.access_mode
    deployer_msi_id                                      = var.deployer_outputs.capabilities.identity.principal_id
    deployer_uai                                         = var.deployer_outputs.capabilities.identity.user_assigned
    deployer_user_assigned_identity                      = var.deployer_outputs.capabilities.identity.user_assigned_identity_id
    deployer_client_id                                   = var.deployer_outputs.capabilities.identity.client_id
    deployer_system_assigned_identity                    = var.deployer_outputs.capabilities.identity.system_assigned
    add_system_assigned_identity                         = var.deployer_outputs.capabilities.identity.system_assigned_enabled
    DevOpsInfrastructureObjectId                         = var.deployer_outputs.capabilities.identity.devops_infrastructure_object_id
    deployer_kv_user_arm_id                              = var.deployer_outputs.capabilities.key_vault.id
    deployer_kv_user_name                                = var.deployer_outputs.capabilities.key_vault.name
    deployer_sshkey_secret_name                          = var.deployer_outputs.capabilities.key_vault.ssh_key_secret_name
    set_secret_expiry                                    = var.deployer_outputs.capabilities.key_vault.set_secret_expiry
    deployer_id                                          = var.deployer_outputs.capabilities.virtual_machines.ids
    deployer_public_ip_address                           = var.deployer_outputs.capabilities.virtual_machines.public_ip_addresses
    deployer_username                                    = var.deployer_outputs.capabilities.virtual_machines.username
    deployer_extension_ids                               = var.deployer_outputs.capabilities.virtual_machines.extension_ids
    app_config_deployment                                = var.deployer_outputs.capabilities.application_configuration.deployed
    application_configuration_id                         = var.deployer_outputs.capabilities.application_configuration.id
    application_configuration_name                       = var.deployer_outputs.capabilities.application_configuration.name
    app_service_deployment                               = var.deployer_outputs.capabilities.web_app.deployed
    webapp_id                                            = var.deployer_outputs.capabilities.web_app.id
    webapp_url_base                                      = var.deployer_outputs.capabilities.web_app.url_base
    webapp_identity                                      = var.deployer_outputs.capabilities.web_app.identity
    diagnostics_account_id                               = var.deployer_outputs.capabilities.diagnostics.storage_account_id
    automation_version                                   = var.deployer_outputs.capabilities.automation_version
  }, {})

  deployer                  = merge(try({ for name, value in var.deployer_outputs : name => value }, {}), local.deployer_contract)

  // Version of the capability contract in the workload zone state, empty when the state predates the contract
  landscape_contract_version = try(tostring(var.landscape_outputs.capabilities.contract_version), "")

  // Attributes of the workload zone contract under the names of the individual outputs. The mapping is
  // dropped as a whole when the state has no contract.
  landscape_contract         = try({
    workload_zone_name                           = var.landscape_outputs.capabilities.naming.workload_zone_name
    workload_zone_prefix                         = var.landscape_outputs.capabilities.naming.workload_zone_prefix
    control_plane_name                           = var.landscape_outputs.capabilities.naming.control_plane_name
    controlplane_environment                     = var.landscape_outputs.capabilities.naming.control_plane_environment
    random_id                                    = var.landscape_outputs.capabilities.naming.random_id
    created_resource_group_id                    = var.landscape_outputs.capabilities.resource_group.id
    created_resource_group_name                  = var.landscape_outputs.capabilities.resource_group.name
    created_resource_group_subscription_id       = var.landscape_outputs.capabilities.resource_group.subscription_id
    vnet_sap_arm_id                              = var.landscape_outputs.capabilities.network.vnet_id
    route_table_id                               = var.landscape_outputs.capabilities.network.route_table_id
    subnet_mgmt_id                               = var.landscape_outputs.capabilities.network.management_subnet_id
    public_network_access_enabled                = var.landscape_outputs.capabilities.network.public_network_access_enabled
    use_separate_storage_subnet                  = var.landscape_outputs.capabilities.network.use_separate_storage_subnet
    admin_subnet_id                              = var.landscape_outputs.capabilities.network.subnets.admin.id
    admin_nsg_id                                 = var.landscape_outputs.capabilities.network.subnets.admin.nsg_id
    db_subnet_id                                 = var.landscape_outputs.capabilities.network.subnets.db.id
    db_nsg_id                                    = var.landscape_outputs.capabilities.network.subnets.db.nsg_id
    app_subnet_id                                = var.landscape_outputs.capabilities.network.subnets.app.id
    app_nsg_id                                   = var.landscape_outputs.capabilities.network.subnets.app.nsg_id
    web_subnet_id                                = var.landscape_outputs.capabilities.network.subnets.web.id
    web_nsg_id                                   = var.landscape_outputs.capabilities.network.subnets.web.nsg_id
    storage_subnet_id                            = var.landscape_outputs.capabilities.network.subnets.storage.id
    storage_nsg_id                               = var.landscape_outputs.capabilities.network.subnets.storage.nsg_id
    endpoint_subnet_id                           = var.landscape_outputs.capabilities.network.subnets.endpoint.id
    endpoint_nsg_id                              = var.landscape_outputs.capabilities.network.subnets.endpoint.nsg_id
    ams_subnet_id                                = var.landscape_outputs.capabilities.network.subnets.ams.id
    use_spn                                      = var.landscape_outputs.capabilities.identity.use_spn
    landscape_key_vault_user_arm_id              = var.landscape_outputs.capabilities.key_vault.user_id
    landscape_key_vault_private_arm_id           = var.landscape_outputs.capabilities.key_vault.private_id
    landscape_key_vault_spn_arm_id               = var.landscape_outputs.capabilities.key_vault.spn_id
    workloadzone_kv_name                         = var.landscape_outputs.capabilities.key_vault.name
    user_credential_vault_id                     = var.landscape_outputs.capabilities.key_vault.user_credential_vault_id
    spn_credential_vault_id                      = var.landscape_outputs.capabilities.key_vault.spn_credential_vault_id
    sid_username_secret_name                     = var.landscape_outputs.capabilities.key_vault.sid_username_secret_name
    sid_password_secret_name                     = var.landscape_outputs.capabilities.key_vault.sid_password_secret_name
    sid_public_key_secret_name                   = var.landscape_outputs.capabilities.key_vault.sid_public_key_secret_name
    dns_label                                    = var.landscape_outputs.capabilities.dns.label
    dns_resource_group_name                      = var.landscape_outputs.capabilities.dns.resource_group_name
    management_dns_resourcegroup_name            = var.landscape_outputs.capabilities.dns.management_resource_group_name
    management_dns_subscription_id               = var.landscape_outputs.capabilities.dns.management_subscription_id
    privatelink_dns_resourcegroup_name           = var.landscape_outputs.capabilities.dns.privatelink_resource_group_name
    privatelink_dns_subscription_id              = var.landscape_outputs.capabilities.dns.privatelink_subscription_id
    privatelink_file_id                          = var.landscape_outputs.capabilities.dns.privatelink_file_id
    register_virtual_network_to_dns              = var.landscape_outputs.capabilities.dns.register_virtual_network
    register_storage_accounts_keyvaults_with_dns = var.landscape_outputs.capabilities.dns.register_storage_accounts_and_key_vaults
    use_custom_dns_a_registration                = var.landscape_outputs.capabilities.dns.use_custom_a_registration
    storageaccount_name                          = var.landscape_outputs.capabilities.storage.diagnostics_account_name
    storageaccount_rg_name                       = var.landscape_outputs.capabilities.storage.diagnostics_resource_group_name
    transport_storage_account_id                 = var.landscape_outputs.capabilities.storage.transport_account_id
    witness_storage_account                      = var.landscape_outputs.capabilities.storage.witness_account
    utility_storage_account_ids                  = var.landscape_outputs.capabilities.storage.utility_account_ids
    utility_storage_account_names                = var.landscape_outputs.capabilities.storage.utility_account_names
    install_path                                 = var.landscape_outputs.capabilities.storage.install_path
    saptransport_path                            = var.landscape_outputs.capabilities.storage.transport_path
    ANF_pool_settings                            = var.landscape_outputs.capabilities.storage.netapp_pool
    iscsi_authentication_type                    = var.landscape_outputs.capabilities.iscsi.authentication_type
    iscsi_authentication_username                = var.landscape_outputs.capabilities.iscsi.authentication_username
    iscsi_private_ip                             = var.landscape_outputs.capabilities.iscsi.private_ips
    iSCSI_server_ips                             = var.landscape_outputs.capabilities.iscsi.server_ips
    iSCSI_server_names                           = var.landscape_outputs.capabilities.iscsi.server_names
    iSCSI_servers                                = var.landscape_outputs.capabilities.iscsi.servers
    dns_info_iscsi                               = var.landscape_outputs.capabilities.iscsi.dns_records
    application_configuration_id                 = var.landscape_outputs.capabilities.application_configuration.id
    application_configuration_name               = var.landscape_outputs.capabilities.application_configuration.name
    automation_version                           = var.landscape_outputs.capabilities.automation_version
    spn_kv_id                                    = var.landscape_outputs.capabilities.key_vault.spn_credential_vault_id
  }, {})

  landscape                  = merge(try({ for name, value in var.landscape_outputs : name => value }, {}), local.landscape_contract)
}
