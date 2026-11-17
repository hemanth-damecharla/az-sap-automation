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
