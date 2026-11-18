# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Interface contract of the sap_library module: the defaults applied to
# attributes a caller leaves out, and the inputs the module refuses.

mock_provider "azurerm" {}
mock_provider "azurerm" {
  alias = "main"
}
mock_provider "azurerm" {
  alias = "deployer"
}
mock_provider "azurerm" {
  alias = "dnsmanagement"
}
mock_provider "azurerm" {
  alias = "privatelinkdnsmanagement"
}
mock_provider "random" {}

override_resource {
  target = azurerm_resource_group.library
  values = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-library"
  }
}

# The smallest input the module can plan with. Everything else takes its
# default. With only the separator in the naming structure the resource group
# name must be given, and without a deployer state the management network must
# be given.
variables {
  bootstrap = false
  naming    = { separator = "-" }
  infrastructure = {
    environment    = "DEV"
    region         = "westeurope"
    resource_group = { name = "rg-library" }
  }
  deployer = {
    use                   = false
    management_network_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-management"
  }
  key_vault = {}
  dns_settings = {
    register_storage_accounts_keyvaults_with_dns = false
    create_privatelink_dns_zones                 = false
  }
  storage_account_tfstate = { name = "sttfstatecontract" }
  storage_account_sapbits = { name = "stsapbitscontract" }
}

run "minimal_input_takes_documented_defaults" {
  command = plan

  assert {
    condition     = azurerm_storage_account.storage_tfstate[0].account_tier == "Standard" && azurerm_storage_account.storage_tfstate[0].account_replication_type == "LRS" && azurerm_storage_account.storage_tfstate[0].account_kind == "StorageV2"
    error_message = "The tfstate storage account must default to Standard / LRS / StorageV2."
  }

  assert {
    condition     = !azurerm_storage_account.storage_tfstate[0].public_network_access_enabled && !azurerm_storage_account.storage_sapbits[0].public_network_access_enabled
    error_message = "Public network access must default to disabled for both storage accounts."
  }

  assert {
    condition     = !azurerm_storage_account.storage_sapbits[0].shared_access_key_enabled
    error_message = "Shared key access must default to disabled."
  }

  assert {
    condition     = length(azurerm_management_lock.storage_tfstate) == 0
    error_message = "No delete lock may be placed unless place_delete_lock_on_resources is set."
  }
}

run "rejects_blank_region" {
  command = plan

  variables {
    infrastructure = {
      environment    = "DEV"
      region         = " "
      resource_group = {}
    }
  }

  expect_failures = [var.infrastructure]
}

run "rejects_malformed_resource_group_id" {
  command = plan

  variables {
    infrastructure = {
      environment    = "DEV"
      region         = "westeurope"
      resource_group = { id = "rg-library", exists = true }
    }
  }

  expect_failures = [var.infrastructure]
}

run "rejects_resource_group_flag_that_contradicts_id" {
  command = plan

  variables {
    infrastructure = {
      environment    = "DEV"
      region         = "westeurope"
      resource_group = { exists = true }
    }
  }

  expect_failures = [var.infrastructure]
}

run "rejects_unknown_storage_tier" {
  command = plan

  variables {
    storage_account_sapbits = { name = "stsapbitscontract", account_tier = "Basic" }
  }

  expect_failures = [var.storage_account_sapbits]
}

run "rejects_unknown_replication_type" {
  command = plan

  variables {
    storage_account_tfstate = { name = "sttfstatecontract", account_replication_type = "XRS" }
  }

  expect_failures = [var.storage_account_tfstate]
}

run "rejects_malformed_storage_account_id" {
  command = plan

  variables {
    storage_account_tfstate = { id = "sttfstatecontract", exists = true }
  }

  expect_failures = [var.storage_account_tfstate]
}

run "rejects_malformed_key_vault_id" {
  command = plan

  variables {
    key_vault = { id = "my-key-vault" }
  }

  expect_failures = [var.key_vault]
}

run "rejects_malformed_management_network_id" {
  command = plan

  variables {
    deployer = { use = true, management_network_id = "vnet-management" }
  }

  expect_failures = [var.deployer]
}

# The deployer state is typed. additional_network_id keeps three meanings: not
# published by the deployer state (null), published but empty, and a network.
# The DNS links for the agent network depend on which one it is.
# No deployer state: only the network given in dns_settings is linked.
run "deployer_state_without_additional_network_links_no_agent_network" {
  command = plan

  variables {
    dns_settings = {
      register_storage_accounts_keyvaults_with_dns = true
      create_privatelink_dns_zones                 = false
      privatelink_dns_resourcegroup_name           = "rg-privatelink-dns"
      management_dns_resourcegroup_name            = "rg-management-dns"
      additional_network_id                        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-agent/providers/Microsoft.Network/virtualNetworks/vnet-agent"
      dns_zone_names = {
        appconfig_dns_zone_name = "privatelink.appconfig.example"
        blob_dns_zone_name      = "privatelink.blob.example"
        file_dns_zone_name      = "privatelink.file.example"
        table_dns_zone_name     = "privatelink.table.example"
        vault_dns_zone_name     = "privatelink.vault.example"
      }
    }
    naming = {
      separator         = "-"
      prefix            = { LIBRARY = "MGMT-WEEU-SAP_LIBRARY" }
      resource_prefixes = {
        appconfig_link           = ""
        dns_link                 = ""
        library_rg               = ""
        nic                      = ""
        private_endpoint_nic     = ""
        storage_private_link_sap = ""
        storage_private_link_tf  = ""
        storage_private_svc_sap  = ""
        storage_private_svc_tf   = ""
      }
      resource_suffixes = {
        appconfig_link           = "appconfig-link"
        dns_link                 = "dns-link"
        library_rg               = "library-rg"
        nic                      = "nic"
        private_endpoint_nic     = "private-endpoint-nic"
        storage_private_link_sap = "storage-private-link-sap"
        storage_private_link_tf  = "storage-private-link-tf"
        storage_private_svc_sap  = "storage-private-svc-sap"
        storage_private_svc_tf   = "storage-private-svc-tf"
      }
    }
  }

  assert {
    condition     = length(azurerm_private_dns_zone_virtual_network_link.blob_agent) == 0
    error_message = "Without additional_network_id in the deployer state the agent network link must not be planned."
  }

  assert {
    condition     = length(azurerm_private_dns_zone_virtual_network_link.vnet_mgmt_blob-agent) == 0
    error_message = "Without additional_network_id in the deployer state the deployer network link must not be planned."
  }
}

# The deployer publishes an empty value when no additional network is configured.
run "deployer_state_with_empty_additional_network_links_the_agent_network" {
  command = plan

  variables {
    dns_settings = {
      register_storage_accounts_keyvaults_with_dns = true
      create_privatelink_dns_zones                 = false
      privatelink_dns_resourcegroup_name           = "rg-privatelink-dns"
      management_dns_resourcegroup_name            = "rg-management-dns"
      additional_network_id                        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-agent/providers/Microsoft.Network/virtualNetworks/vnet-agent"
      dns_zone_names = {
        appconfig_dns_zone_name = "privatelink.appconfig.example"
        blob_dns_zone_name      = "privatelink.blob.example"
        file_dns_zone_name      = "privatelink.file.example"
        table_dns_zone_name     = "privatelink.table.example"
        vault_dns_zone_name     = "privatelink.vault.example"
      }
    }
    naming = {
      separator         = "-"
      prefix            = { LIBRARY = "MGMT-WEEU-SAP_LIBRARY" }
      resource_prefixes = {
        appconfig_link           = ""
        dns_link                 = ""
        library_rg               = ""
        nic                      = ""
        private_endpoint_nic     = ""
        storage_private_link_sap = ""
        storage_private_link_tf  = ""
        storage_private_svc_sap  = ""
        storage_private_svc_tf   = ""
      }
      resource_suffixes = {
        appconfig_link           = "appconfig-link"
        dns_link                 = "dns-link"
        library_rg               = "library-rg"
        nic                      = "nic"
        private_endpoint_nic     = "private-endpoint-nic"
        storage_private_link_sap = "storage-private-link-sap"
        storage_private_link_tf  = "storage-private-link-tf"
        storage_private_svc_sap  = "storage-private-svc-sap"
        storage_private_svc_tf   = "storage-private-svc-tf"
      }
    }
    deployer_tfstate = { additional_network_id = "" }
  }

  assert {
    condition     = length(azurerm_private_dns_zone_virtual_network_link.blob_agent) == 1
    error_message = "An empty additional_network_id in the deployer state differs from dns_settings, so the agent network must be linked."
  }

  assert {
    condition     = length(azurerm_private_dns_zone_virtual_network_link.vnet_mgmt_blob-agent) == 0
    error_message = "An empty additional_network_id is not a network, so the deployer network link must not be planned."
  }
}

# The deployer and dns_settings name the same network, which is linked once.
run "deployer_state_with_the_same_network_links_it_once" {
  command = plan

  variables {
    dns_settings = {
      register_storage_accounts_keyvaults_with_dns = true
      create_privatelink_dns_zones                 = false
      privatelink_dns_resourcegroup_name           = "rg-privatelink-dns"
      management_dns_resourcegroup_name            = "rg-management-dns"
      additional_network_id                        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-agent/providers/Microsoft.Network/virtualNetworks/vnet-agent"
      dns_zone_names = {
        appconfig_dns_zone_name = "privatelink.appconfig.example"
        blob_dns_zone_name      = "privatelink.blob.example"
        file_dns_zone_name      = "privatelink.file.example"
        table_dns_zone_name     = "privatelink.table.example"
        vault_dns_zone_name     = "privatelink.vault.example"
      }
    }
    naming = {
      separator         = "-"
      prefix            = { LIBRARY = "MGMT-WEEU-SAP_LIBRARY" }
      resource_prefixes = {
        appconfig_link           = ""
        dns_link                 = ""
        library_rg               = ""
        nic                      = ""
        private_endpoint_nic     = ""
        storage_private_link_sap = ""
        storage_private_link_tf  = ""
        storage_private_svc_sap  = ""
        storage_private_svc_tf   = ""
      }
      resource_suffixes = {
        appconfig_link           = "appconfig-link"
        dns_link                 = "dns-link"
        library_rg               = "library-rg"
        nic                      = "nic"
        private_endpoint_nic     = "private-endpoint-nic"
        storage_private_link_sap = "storage-private-link-sap"
        storage_private_link_tf  = "storage-private-link-tf"
        storage_private_svc_sap  = "storage-private-svc-sap"
        storage_private_svc_tf   = "storage-private-svc-tf"
      }
    }
    deployer_tfstate = { additional_network_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-agent/providers/Microsoft.Network/virtualNetworks/vnet-agent" }
  }

  assert {
    condition     = length(azurerm_private_dns_zone_virtual_network_link.blob_agent) == 0
    error_message = "When the deployer state and dns_settings name the same network the agent network link must not be duplicated."
  }

  assert {
    condition     = length(azurerm_private_dns_zone_virtual_network_link.vnet_mgmt_blob-agent) == 1
    error_message = "A network in the deployer state must be linked."
  }
}
