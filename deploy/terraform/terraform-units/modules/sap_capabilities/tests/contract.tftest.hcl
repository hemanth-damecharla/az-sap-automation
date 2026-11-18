# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Interface contract of the sap_capabilities module: how the outputs of an
# upstream state reach a later stage, with and without the capability contract.
# The module has no resources and no providers. The contract fixtures give every
# attribute a value that names its own path, so a wrong mapping is visible.

run "state_without_contract_passes_through" {
  command = plan

  variables {
    deployer_outputs = {
      environment             = "MGMT"
      deployer_kv_user_arm_id = "kv-legacy"
    }
    landscape_outputs = {
      vnet_sap_arm_id = "vnet-legacy"
    }
  }

  assert {
    condition     = output.deployer == { environment = "MGMT", deployer_kv_user_arm_id = "kv-legacy" }
    error_message = "A deployer state without the contract must be returned unchanged."
  }

  assert {
    condition     = output.landscape == { vnet_sap_arm_id = "vnet-legacy" }
    error_message = "A workload zone state without the contract must be returned unchanged."
  }

  assert {
    condition     = output.deployer_contract_version == "" && output.landscape_contract_version == ""
    error_message = "A state without the contract must report an empty contract version."
  }
}

run "missing_states_are_empty" {
  command = plan

  assert {
    condition     = length(output.deployer) == 0 && length(output.landscape) == 0
    error_message = "Without an upstream state the module must return empty objects."
  }
}

run "deployer_contract_is_read_under_individual_output_names" {
  command = plan

  variables {
    deployer_outputs = {
      capabilities = {
        contract_version = "1.0"
        stage            = "deployer"
        application_configuration  = {
          deployed = "deployer:application_configuration.deployed"
          id       = "deployer:application_configuration.id"
          name     = "deployer:application_configuration.name"
        }
        automation_version         = "deployer:automation_version"
        diagnostics                = {
          storage_account_id = "deployer:diagnostics.storage_account_id"
        }
        identity                   = {
          client_id                       = "deployer:identity.client_id"
          devops_infrastructure_object_id = "deployer:identity.devops_infrastructure_object_id"
          principal_id                    = "deployer:identity.principal_id"
          system_assigned                 = "deployer:identity.system_assigned"
          system_assigned_enabled         = "deployer:identity.system_assigned_enabled"
          user_assigned                   = "deployer:identity.user_assigned"
          user_assigned_identity_id       = "deployer:identity.user_assigned_identity_id"
        }
        key_vault                  = {
          id                  = "deployer:key_vault.id"
          name                = "deployer:key_vault.name"
          set_secret_expiry   = "deployer:key_vault.set_secret_expiry"
          ssh_key_secret_name = "deployer:key_vault.ssh_key_secret_name"
        }
        naming                     = {
          control_plane_name   = "deployer:naming.control_plane_name"
          environment          = "deployer:naming.environment"
          location_short       = "deployer:naming.location_short"
          network_logical_name = "deployer:naming.network_logical_name"
          random_id            = "deployer:naming.random_id"
        }
        network                    = {
          additional_network_id                      = "deployer:network.additional_network_id"
          agent_ip                                   = "deployer:network.agent_ip"
          bastion_subnet_address_prefixes            = "deployer:network.bastion_subnet_address_prefixes"
          endpoint_subnet_id                         = "deployer:network.endpoint_subnet_id"
          firewall_allowed_subnet_ids                = "deployer:network.firewall_allowed_subnet_ids"
          firewall_for_keyvaults_and_storage_enabled = "deployer:network.firewall_for_keyvaults_and_storage_enabled"
          firewall_id                                = "deployer:network.firewall_id"
          firewall_ip                                = "deployer:network.firewall_ip"
          management_subnet_address_prefixes         = "deployer:network.management_subnet_address_prefixes"
          management_subnet_id                       = "deployer:network.management_subnet_id"
          public_network_access_enabled              = "deployer:network.public_network_access_enabled"
          vnet_id                                    = "deployer:network.vnet_id"
          webapp_subnet_id                           = "deployer:network.webapp_subnet_id"
        }
        network_security_perimeter = {
          access_mode = "deployer:network_security_perimeter.access_mode"
          deployed    = "deployer:network_security_perimeter.deployed"
          id          = "deployer:network_security_perimeter.id"
        }
        resource_group             = {
          id              = "deployer:resource_group.id"
          location        = "deployer:resource_group.location"
          name            = "deployer:resource_group.name"
          subscription_id = "deployer:resource_group.subscription_id"
        }
        virtual_machines           = {
          extension_ids       = "deployer:virtual_machines.extension_ids"
          ids                 = "deployer:virtual_machines.ids"
          public_ip_addresses = "deployer:virtual_machines.public_ip_addresses"
          username            = "deployer:virtual_machines.username"
        }
        web_app                    = {
          deployed = "deployer:web_app.deployed"
          id       = "deployer:web_app.id"
          identity = "deployer:web_app.identity"
          url_base = "deployer:web_app.url_base"
        }
      }
    }
  }

  assert {
    condition     = output.deployer_contract_version == "1.0"
    error_message = "The contract version of the state must be reported."
  }

  assert {
    condition = alltrue([
      output.deployer.environment                                          == "deployer:naming.environment",
      output.deployer.location_short                                       == "deployer:naming.location_short",
      output.deployer.network_logical_name                                 == "deployer:naming.network_logical_name",
      output.deployer.control_plane_name                                   == "deployer:naming.control_plane_name",
      output.deployer.random_id                                            == "deployer:naming.random_id",
      output.deployer.created_resource_group_id                            == "deployer:resource_group.id",
      output.deployer.created_resource_group_name                          == "deployer:resource_group.name",
      output.deployer.created_resource_group_subscription_id               == "deployer:resource_group.subscription_id",
      output.deployer.created_resource_group_location                      == "deployer:resource_group.location",
      output.deployer.vnet_mgmt_id                                         == "deployer:network.vnet_id",
      output.deployer.subnet_mgmt_id                                       == "deployer:network.management_subnet_id",
      output.deployer.subnet_mgmt_address_prefixes                         == "deployer:network.management_subnet_address_prefixes",
    ])
    error_message = "Every attribute of the deployer contract must be returned under the name of the individual output it repeats."
  }

  assert {
    condition = alltrue([
      output.deployer.subnet_bastion_address_prefixes                      == "deployer:network.bastion_subnet_address_prefixes",
      output.deployer.subnet_webapp_id                                     == "deployer:network.webapp_subnet_id",
      output.deployer.endpoint_subnet_id                                   == "deployer:network.endpoint_subnet_id",
      output.deployer.additional_network_id                                == "deployer:network.additional_network_id",
      output.deployer.subnets_to_add_to_firewall_for_keyvaults_and_storage == "deployer:network.firewall_allowed_subnet_ids",
      output.deployer.Agent_IP                                             == "deployer:network.agent_ip",
      output.deployer.public_network_access_enabled                        == "deployer:network.public_network_access_enabled",
      output.deployer.enable_firewall_for_keyvaults_and_storage            == "deployer:network.firewall_for_keyvaults_and_storage_enabled",
      output.deployer.firewall_id                                          == "deployer:network.firewall_id",
      output.deployer.firewall_ip                                          == "deployer:network.firewall_ip",
      output.deployer.network_security_perimeter_deployment                == "deployer:network_security_perimeter.deployed",
      output.deployer.network_security_perimeter_id                        == "deployer:network_security_perimeter.id",
    ])
    error_message = "Every attribute of the deployer contract must be returned under the name of the individual output it repeats."
  }

  assert {
    condition = alltrue([
      output.deployer.network_security_access_mode                         == "deployer:network_security_perimeter.access_mode",
      output.deployer.deployer_msi_id                                      == "deployer:identity.principal_id",
      output.deployer.deployer_uai                                         == "deployer:identity.user_assigned",
      output.deployer.deployer_user_assigned_identity                      == "deployer:identity.user_assigned_identity_id",
      output.deployer.deployer_client_id                                   == "deployer:identity.client_id",
      output.deployer.deployer_system_assigned_identity                    == "deployer:identity.system_assigned",
      output.deployer.add_system_assigned_identity                         == "deployer:identity.system_assigned_enabled",
      output.deployer.DevOpsInfrastructureObjectId                         == "deployer:identity.devops_infrastructure_object_id",
      output.deployer.deployer_kv_user_arm_id                              == "deployer:key_vault.id",
      output.deployer.deployer_kv_user_name                                == "deployer:key_vault.name",
      output.deployer.deployer_sshkey_secret_name                          == "deployer:key_vault.ssh_key_secret_name",
      output.deployer.set_secret_expiry                                    == "deployer:key_vault.set_secret_expiry",
    ])
    error_message = "Every attribute of the deployer contract must be returned under the name of the individual output it repeats."
  }

  assert {
    condition = alltrue([
      output.deployer.deployer_id                                          == "deployer:virtual_machines.ids",
      output.deployer.deployer_public_ip_address                           == "deployer:virtual_machines.public_ip_addresses",
      output.deployer.deployer_username                                    == "deployer:virtual_machines.username",
      output.deployer.deployer_extension_ids                               == "deployer:virtual_machines.extension_ids",
      output.deployer.app_config_deployment                                == "deployer:application_configuration.deployed",
      output.deployer.application_configuration_id                         == "deployer:application_configuration.id",
      output.deployer.application_configuration_name                       == "deployer:application_configuration.name",
      output.deployer.app_service_deployment                               == "deployer:web_app.deployed",
      output.deployer.webapp_id                                            == "deployer:web_app.id",
      output.deployer.webapp_url_base                                      == "deployer:web_app.url_base",
      output.deployer.webapp_identity                                      == "deployer:web_app.identity",
      output.deployer.diagnostics_account_id                               == "deployer:diagnostics.storage_account_id",
    ])
    error_message = "Every attribute of the deployer contract must be returned under the name of the individual output it repeats."
  }

  assert {
    condition = alltrue([
      output.deployer.automation_version                                   == "deployer:automation_version",
    ])
    error_message = "Every attribute of the deployer contract must be returned under the name of the individual output it repeats."
  }
}

run "workload_zone_contract_is_read_under_individual_output_names" {
  command = plan

  variables {
    landscape_outputs = {
      capabilities = {
        contract_version = "1.0"
        stage            = "workload_zone"
        application_configuration = {
          id   = "landscape:application_configuration.id"
          name = "landscape:application_configuration.name"
        }
        automation_version        = "landscape:automation_version"
        dns                       = {
          label                                    = "landscape:dns.label"
          management_resource_group_name           = "landscape:dns.management_resource_group_name"
          management_subscription_id               = "landscape:dns.management_subscription_id"
          privatelink_file_id                      = "landscape:dns.privatelink_file_id"
          privatelink_resource_group_name          = "landscape:dns.privatelink_resource_group_name"
          privatelink_subscription_id              = "landscape:dns.privatelink_subscription_id"
          register_storage_accounts_and_key_vaults = "landscape:dns.register_storage_accounts_and_key_vaults"
          register_virtual_network                 = "landscape:dns.register_virtual_network"
          resource_group_name                      = "landscape:dns.resource_group_name"
          use_custom_a_registration                = "landscape:dns.use_custom_a_registration"
        }
        identity                  = {
          use_spn = "landscape:identity.use_spn"
        }
        iscsi                     = {
          authentication_type     = "landscape:iscsi.authentication_type"
          authentication_username = "landscape:iscsi.authentication_username"
          dns_records             = "landscape:iscsi.dns_records"
          private_ips             = "landscape:iscsi.private_ips"
          server_ips              = "landscape:iscsi.server_ips"
          server_names            = "landscape:iscsi.server_names"
          servers                 = "landscape:iscsi.servers"
        }
        key_vault                 = {
          name                       = "landscape:key_vault.name"
          private_id                 = "landscape:key_vault.private_id"
          sid_password_secret_name   = "landscape:key_vault.sid_password_secret_name"
          sid_public_key_secret_name = "landscape:key_vault.sid_public_key_secret_name"
          sid_username_secret_name   = "landscape:key_vault.sid_username_secret_name"
          spn_credential_vault_id    = "landscape:key_vault.spn_credential_vault_id"
          spn_id                     = "landscape:key_vault.spn_id"
          user_credential_vault_id   = "landscape:key_vault.user_credential_vault_id"
          user_id                    = "landscape:key_vault.user_id"
        }
        naming                    = {
          control_plane_environment = "landscape:naming.control_plane_environment"
          control_plane_name        = "landscape:naming.control_plane_name"
          random_id                 = "landscape:naming.random_id"
          workload_zone_name        = "landscape:naming.workload_zone_name"
          workload_zone_prefix      = "landscape:naming.workload_zone_prefix"
        }
        network                   = {
          management_subnet_id          = "landscape:network.management_subnet_id"
          public_network_access_enabled = "landscape:network.public_network_access_enabled"
          route_table_id                = "landscape:network.route_table_id"
          subnets                       = {
            admin    = {
              id     = "landscape:network.subnets.admin.id"
              nsg_id = "landscape:network.subnets.admin.nsg_id"
            }
            ams      = {
              id = "landscape:network.subnets.ams.id"
            }
            app      = {
              id     = "landscape:network.subnets.app.id"
              nsg_id = "landscape:network.subnets.app.nsg_id"
            }
            db       = {
              id     = "landscape:network.subnets.db.id"
              nsg_id = "landscape:network.subnets.db.nsg_id"
            }
            endpoint = {
              id     = "landscape:network.subnets.endpoint.id"
              nsg_id = "landscape:network.subnets.endpoint.nsg_id"
            }
            storage  = {
              id     = "landscape:network.subnets.storage.id"
              nsg_id = "landscape:network.subnets.storage.nsg_id"
            }
            web      = {
              id     = "landscape:network.subnets.web.id"
              nsg_id = "landscape:network.subnets.web.nsg_id"
            }
          }
          use_separate_storage_subnet   = "landscape:network.use_separate_storage_subnet"
          vnet_id                       = "landscape:network.vnet_id"
        }
        resource_group            = {
          id              = "landscape:resource_group.id"
          name            = "landscape:resource_group.name"
          subscription_id = "landscape:resource_group.subscription_id"
        }
        storage                   = {
          diagnostics_account_name        = "landscape:storage.diagnostics_account_name"
          diagnostics_resource_group_name = "landscape:storage.diagnostics_resource_group_name"
          install_path                    = "landscape:storage.install_path"
          netapp_pool                     = "landscape:storage.netapp_pool"
          transport_account_id            = "landscape:storage.transport_account_id"
          transport_path                  = "landscape:storage.transport_path"
          utility_account_ids             = "landscape:storage.utility_account_ids"
          utility_account_names           = "landscape:storage.utility_account_names"
          witness_account                 = "landscape:storage.witness_account"
        }
      }
    }
  }

  assert {
    condition     = output.landscape_contract_version == "1.0"
    error_message = "The contract version of the state must be reported."
  }

  assert {
    condition = alltrue([
      output.landscape.workload_zone_name                           == "landscape:naming.workload_zone_name",
      output.landscape.workload_zone_prefix                         == "landscape:naming.workload_zone_prefix",
      output.landscape.control_plane_name                           == "landscape:naming.control_plane_name",
      output.landscape.controlplane_environment                     == "landscape:naming.control_plane_environment",
      output.landscape.random_id                                    == "landscape:naming.random_id",
      output.landscape.created_resource_group_id                    == "landscape:resource_group.id",
      output.landscape.created_resource_group_name                  == "landscape:resource_group.name",
      output.landscape.created_resource_group_subscription_id       == "landscape:resource_group.subscription_id",
      output.landscape.vnet_sap_arm_id                              == "landscape:network.vnet_id",
      output.landscape.route_table_id                               == "landscape:network.route_table_id",
      output.landscape.subnet_mgmt_id                               == "landscape:network.management_subnet_id",
      output.landscape.public_network_access_enabled                == "landscape:network.public_network_access_enabled",
    ])
    error_message = "Every attribute of the workload zone contract must be returned under the name of the individual output it repeats."
  }

  assert {
    condition = alltrue([
      output.landscape.use_separate_storage_subnet                  == "landscape:network.use_separate_storage_subnet",
      output.landscape.admin_subnet_id                              == "landscape:network.subnets.admin.id",
      output.landscape.admin_nsg_id                                 == "landscape:network.subnets.admin.nsg_id",
      output.landscape.db_subnet_id                                 == "landscape:network.subnets.db.id",
      output.landscape.db_nsg_id                                    == "landscape:network.subnets.db.nsg_id",
      output.landscape.app_subnet_id                                == "landscape:network.subnets.app.id",
      output.landscape.app_nsg_id                                   == "landscape:network.subnets.app.nsg_id",
      output.landscape.web_subnet_id                                == "landscape:network.subnets.web.id",
      output.landscape.web_nsg_id                                   == "landscape:network.subnets.web.nsg_id",
      output.landscape.storage_subnet_id                            == "landscape:network.subnets.storage.id",
      output.landscape.storage_nsg_id                               == "landscape:network.subnets.storage.nsg_id",
      output.landscape.endpoint_subnet_id                           == "landscape:network.subnets.endpoint.id",
    ])
    error_message = "Every attribute of the workload zone contract must be returned under the name of the individual output it repeats."
  }

  assert {
    condition = alltrue([
      output.landscape.endpoint_nsg_id                              == "landscape:network.subnets.endpoint.nsg_id",
      output.landscape.ams_subnet_id                                == "landscape:network.subnets.ams.id",
      output.landscape.use_spn                                      == "landscape:identity.use_spn",
      output.landscape.landscape_key_vault_user_arm_id              == "landscape:key_vault.user_id",
      output.landscape.landscape_key_vault_private_arm_id           == "landscape:key_vault.private_id",
      output.landscape.landscape_key_vault_spn_arm_id               == "landscape:key_vault.spn_id",
      output.landscape.workloadzone_kv_name                         == "landscape:key_vault.name",
      output.landscape.user_credential_vault_id                     == "landscape:key_vault.user_credential_vault_id",
      output.landscape.spn_credential_vault_id                      == "landscape:key_vault.spn_credential_vault_id",
      output.landscape.sid_username_secret_name                     == "landscape:key_vault.sid_username_secret_name",
      output.landscape.sid_password_secret_name                     == "landscape:key_vault.sid_password_secret_name",
      output.landscape.sid_public_key_secret_name                   == "landscape:key_vault.sid_public_key_secret_name",
    ])
    error_message = "Every attribute of the workload zone contract must be returned under the name of the individual output it repeats."
  }

  assert {
    condition = alltrue([
      output.landscape.dns_label                                    == "landscape:dns.label",
      output.landscape.dns_resource_group_name                      == "landscape:dns.resource_group_name",
      output.landscape.management_dns_resourcegroup_name            == "landscape:dns.management_resource_group_name",
      output.landscape.management_dns_subscription_id               == "landscape:dns.management_subscription_id",
      output.landscape.privatelink_dns_resourcegroup_name           == "landscape:dns.privatelink_resource_group_name",
      output.landscape.privatelink_dns_subscription_id              == "landscape:dns.privatelink_subscription_id",
      output.landscape.privatelink_file_id                          == "landscape:dns.privatelink_file_id",
      output.landscape.register_virtual_network_to_dns              == "landscape:dns.register_virtual_network",
      output.landscape.register_storage_accounts_keyvaults_with_dns == "landscape:dns.register_storage_accounts_and_key_vaults",
      output.landscape.use_custom_dns_a_registration                == "landscape:dns.use_custom_a_registration",
      output.landscape.storageaccount_name                          == "landscape:storage.diagnostics_account_name",
      output.landscape.storageaccount_rg_name                       == "landscape:storage.diagnostics_resource_group_name",
    ])
    error_message = "Every attribute of the workload zone contract must be returned under the name of the individual output it repeats."
  }

  assert {
    condition = alltrue([
      output.landscape.transport_storage_account_id                 == "landscape:storage.transport_account_id",
      output.landscape.witness_storage_account                      == "landscape:storage.witness_account",
      output.landscape.utility_storage_account_ids                  == "landscape:storage.utility_account_ids",
      output.landscape.utility_storage_account_names                == "landscape:storage.utility_account_names",
      output.landscape.install_path                                 == "landscape:storage.install_path",
      output.landscape.saptransport_path                            == "landscape:storage.transport_path",
      output.landscape.ANF_pool_settings                            == "landscape:storage.netapp_pool",
      output.landscape.iscsi_authentication_type                    == "landscape:iscsi.authentication_type",
      output.landscape.iscsi_authentication_username                == "landscape:iscsi.authentication_username",
      output.landscape.iscsi_private_ip                             == "landscape:iscsi.private_ips",
      output.landscape.iSCSI_server_ips                             == "landscape:iscsi.server_ips",
      output.landscape.iSCSI_server_names                           == "landscape:iscsi.server_names",
    ])
    error_message = "Every attribute of the workload zone contract must be returned under the name of the individual output it repeats."
  }

  assert {
    condition = alltrue([
      output.landscape.iSCSI_servers                                == "landscape:iscsi.servers",
      output.landscape.dns_info_iscsi                               == "landscape:iscsi.dns_records",
      output.landscape.application_configuration_id                 == "landscape:application_configuration.id",
      output.landscape.application_configuration_name               == "landscape:application_configuration.name",
      output.landscape.automation_version                           == "landscape:automation_version",
      output.landscape.spn_kv_id                                    == "landscape:key_vault.spn_credential_vault_id",
    ])
    error_message = "Every attribute of the workload zone contract must be returned under the name of the individual output it repeats."
  }
}

# Both forms are present in a state written by the current release.
run "contract_wins_over_individual_outputs" {
  command = plan

  variables {
    deployer_outputs = {
      environment  = "from-individual-output"
      other_output = "kept"
      capabilities = {
        contract_version = "1.0"
        stage            = "deployer"
        application_configuration  = {
          deployed = "deployer:application_configuration.deployed"
          id       = "deployer:application_configuration.id"
          name     = "deployer:application_configuration.name"
        }
        automation_version         = "deployer:automation_version"
        diagnostics                = {
          storage_account_id = "deployer:diagnostics.storage_account_id"
        }
        identity                   = {
          client_id                       = "deployer:identity.client_id"
          devops_infrastructure_object_id = "deployer:identity.devops_infrastructure_object_id"
          principal_id                    = "deployer:identity.principal_id"
          system_assigned                 = "deployer:identity.system_assigned"
          system_assigned_enabled         = "deployer:identity.system_assigned_enabled"
          user_assigned                   = "deployer:identity.user_assigned"
          user_assigned_identity_id       = "deployer:identity.user_assigned_identity_id"
        }
        key_vault                  = {
          id                  = "deployer:key_vault.id"
          name                = "deployer:key_vault.name"
          set_secret_expiry   = "deployer:key_vault.set_secret_expiry"
          ssh_key_secret_name = "deployer:key_vault.ssh_key_secret_name"
        }
        naming                     = {
          control_plane_name   = "deployer:naming.control_plane_name"
          environment          = "deployer:naming.environment"
          location_short       = "deployer:naming.location_short"
          network_logical_name = "deployer:naming.network_logical_name"
          random_id            = "deployer:naming.random_id"
        }
        network                    = {
          additional_network_id                      = "deployer:network.additional_network_id"
          agent_ip                                   = "deployer:network.agent_ip"
          bastion_subnet_address_prefixes            = "deployer:network.bastion_subnet_address_prefixes"
          endpoint_subnet_id                         = "deployer:network.endpoint_subnet_id"
          firewall_allowed_subnet_ids                = "deployer:network.firewall_allowed_subnet_ids"
          firewall_for_keyvaults_and_storage_enabled = "deployer:network.firewall_for_keyvaults_and_storage_enabled"
          firewall_id                                = "deployer:network.firewall_id"
          firewall_ip                                = "deployer:network.firewall_ip"
          management_subnet_address_prefixes         = "deployer:network.management_subnet_address_prefixes"
          management_subnet_id                       = "deployer:network.management_subnet_id"
          public_network_access_enabled              = "deployer:network.public_network_access_enabled"
          vnet_id                                    = "deployer:network.vnet_id"
          webapp_subnet_id                           = "deployer:network.webapp_subnet_id"
        }
        network_security_perimeter = {
          access_mode = "deployer:network_security_perimeter.access_mode"
          deployed    = "deployer:network_security_perimeter.deployed"
          id          = "deployer:network_security_perimeter.id"
        }
        resource_group             = {
          id              = "deployer:resource_group.id"
          location        = "deployer:resource_group.location"
          name            = "deployer:resource_group.name"
          subscription_id = "deployer:resource_group.subscription_id"
        }
        virtual_machines           = {
          extension_ids       = "deployer:virtual_machines.extension_ids"
          ids                 = "deployer:virtual_machines.ids"
          public_ip_addresses = "deployer:virtual_machines.public_ip_addresses"
          username            = "deployer:virtual_machines.username"
        }
        web_app                    = {
          deployed = "deployer:web_app.deployed"
          id       = "deployer:web_app.id"
          identity = "deployer:web_app.identity"
          url_base = "deployer:web_app.url_base"
        }
      }
    }
  }

  assert {
    condition     = output.deployer.environment == "deployer:naming.environment"
    error_message = "When a state has both forms the contract value must be used."
  }

  assert {
    condition     = output.deployer.other_output == "kept"
    error_message = "Outputs outside the contract must still be returned."
  }
}

# A later minor version may add attributes; a contract that lacks an attribute
# this release reads is not used.
run "incomplete_contract_falls_back_to_individual_outputs" {
  command = plan

  variables {
    deployer_outputs = {
      environment = "MGMT"
      capabilities = {
        contract_version = "1.0"
        stage            = "deployer"
      }
    }
  }

  assert {
    condition     = output.deployer.environment == "MGMT"
    error_message = "An incomplete contract must not replace the individual outputs."
  }
}

run "rejects_unknown_deployer_contract_version" {
  command = plan

  variables {
    deployer_outputs = {
      capabilities = {
        contract_version = "2.0"
      }
    }
  }

  expect_failures = [output.deployer]
}

run "rejects_unknown_workload_zone_contract_version" {
  command = plan

  variables {
    landscape_outputs = {
      capabilities = {
        contract_version = "2.0"
      }
    }
  }

  expect_failures = [output.landscape]
}
