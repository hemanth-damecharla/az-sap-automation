# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Interface contract of the sap_deployer module: the inputs the module refuses.
# Input validation is evaluated before any resource is planned, so these runs
# need no provider behaviour beyond the mocks below. The resources themselves
# are covered by the plan-shape tests of run/sap_deployer and
# bootstrap/sap_deployer.

mock_provider "azurerm" {}
mock_provider "azurerm" {
  alias = "main"
}
mock_provider "azurerm" {
  alias = "dnsmanagement"
}
mock_provider "azurerm" {
  alias = "privatelinkdnsmanagement"
}
mock_provider "azapi" {}
mock_provider "azapi" {
  alias = "restapi"
}
mock_provider "azuread" {}
mock_provider "azuread" {
  alias = "main"
}
mock_provider "random" {}
mock_provider "tls" {}
mock_provider "local" {}
mock_provider "null" {}
mock_provider "time" {}

variables {
  # Inputs of the name generator used by the first run.
  environment = "MGMT"
  location    = "westeurope"
  random_id   = "abc123def"

  infrastructure = {
    environment    = "MGMT"
    region         = "westeurope"
    resource_group = { name = "rg-deployer" }
    virtual_network = {
      logical_name = "DEP01"
      management = {
        address_space = "10.170.20.0/24"
        subnet_mgmt   = { prefix = "10.170.20.64/28" }
      }
    }
  }
  deployer = {
    size      = "Standard_D4ds_v4"
    disk_type = "Premium_LRS"
    os        = { publisher = "SUSE", offer = "sles-sap-15-sp5", sku = "gen2", version = "latest" }
  }
  authentication     = {}
  key_vault          = {}
  firewall           = { deployment = false }
  app_service        = { use = false }
  app_config_service = { deploy = false }
  options = {
    use_spn                         = false
    assign_resource_permissions     = false
    assign_subscription_permissions = false
  }

  additional_network_id                        = ""
  additional_users_to_add_to_keyvault_policies = []
  Agent_IP                                     = ""
  arm_client_id                                = ""
  assign_subscription_permissions              = false
  auto_configure_deployer                      = false
  bastion_deployment                           = false
  bastion_sku                                  = "Basic"
  bootstrap                                    = true
  configure                                    = false
  enable_purge_control_for_keyvaults           = false
  network_logical_name                         = "DEP01"
  place_delete_lock_on_resources               = false
  public_network_access_enabled                = false
  sa_connection_string                         = ""
  set_secret_expiry                            = false
  soft_delete_retention_days                   = 7
  spn_id                                       = ""
  ssh-timeout                                  = "30s"
  use_private_endpoint                         = true
  use_service_endpoint                         = false
  webapp_client_secret                         = ""
}

# Names come from the real name generator, so the contract runs see the same
# structure the root modules pass in.
run "names" {
  command = plan

  module {
    source = "../sap_namegenerator"
  }
}

run "rejects_blank_environment" {
  command = plan

  variables {
    naming     = run.names.naming
    naming_new = run.names.naming_new
    infrastructure = {
      environment    = ""
      region         = "westeurope"
      resource_group = {}
      virtual_network = { management = {} }
    }
  }

  expect_failures = [var.infrastructure]
}

run "rejects_management_subnet_without_id_or_prefix" {
  command = plan

  variables {
    naming     = run.names.naming
    naming_new = run.names.naming_new
    infrastructure = {
      environment    = "MGMT"
      region         = "westeurope"
      resource_group = {}
      virtual_network = {
        management = { address_space = "10.170.20.0/24" }
      }
    }
  }

  expect_failures = [var.infrastructure]
}

run "rejects_malformed_subnet_id" {
  command = plan

  variables {
    naming     = run.names.naming
    naming_new = run.names.naming_new
    infrastructure = {
      environment    = "MGMT"
      region         = "westeurope"
      resource_group = {}
      virtual_network = {
        management = {
          subnet_mgmt = { id = "snet-management", exists = true }
        }
      }
    }
  }

  expect_failures = [var.infrastructure]
}

run "rejects_key_vault_flag_that_contradicts_id" {
  command = plan

  variables {
    naming     = run.names.naming
    naming_new = run.names.naming_new
    key_vault = { exists = true }
  }

  expect_failures = [var.key_vault]
}

run "rejects_soft_delete_retention_outside_key_vault_range" {
  command = plan

  variables {
    naming     = run.names.naming
    naming_new = run.names.naming_new
    soft_delete_retention_days = 3
  }

  expect_failures = [var.soft_delete_retention_days]
}

run "configured_private_ip_address_is_assigned_statically" {
  command = plan

  variables {
    naming     = run.names.naming
    naming_new = run.names.naming_new
    deployer = {
      size               = "Standard_D4ds_v4"
      disk_type          = "Premium_LRS"
      os                 = { publisher = "SUSE", offer = "sles-sap-15-sp5", sku = "gen2", version = "latest" }
      private_ip_address = ["10.170.20.70"]
    }
  }

  assert {
    condition     = azurerm_network_interface.deployer[0].ip_configuration[0].private_ip_address == "10.170.20.70" && azurerm_network_interface.deployer[0].ip_configuration[0].private_ip_address_allocation == "Static"
    error_message = "A configured address must be assigned statically to the matching deployer virtual machine."
  }
}

run "without_configured_address_allocation_stays_dynamic" {
  command = plan

  variables {
    naming     = run.names.naming
    naming_new = run.names.naming_new
  }

  assert {
    condition     = azurerm_network_interface.deployer[0].ip_configuration[0].private_ip_address_allocation == "Dynamic"
    error_message = "Without a configured address the deployer network interface must keep dynamic allocation, as before."
  }
}

run "rejects_invalid_private_ip_address" {
  command = plan

  variables {
    naming     = run.names.naming
    naming_new = run.names.naming_new
    deployer = {
      size               = "Standard_D4ds_v4"
      disk_type          = "Premium_LRS"
      os                 = { publisher = "SUSE", offer = "sles-sap-15-sp5", sku = "gen2", version = "latest" }
      private_ip_address = ["10.170.20"]
    }
  }

  expect_failures = [var.deployer]
}

run "rejects_unknown_authentication_type" {
  command = plan

  variables {
    naming     = run.names.naming
    naming_new = run.names.naming_new
    deployer = {
      size           = "Standard_D4ds_v4"
      disk_type      = "Premium_LRS"
      os             = { publisher = "SUSE", offer = "sles-sap-15-sp5", sku = "gen2", version = "latest" }
      authentication = { type = "certificate" }
    }
  }

  expect_failures = [var.deployer]
}

run "rejects_marketplace_image_without_reference" {
  command = plan

  variables {
    naming     = run.names.naming
    naming_new = run.names.naming_new
    deployer = {
      size      = "Standard_D4ds_v4"
      disk_type = "Premium_LRS"
      os        = { publisher = "SUSE" }
    }
  }

  expect_failures = [var.deployer]
}

run "rejects_unknown_image_type" {
  command = plan

  variables {
    naming     = run.names.naming
    naming_new = run.names.naming_new
    deployer = {
      size      = "Standard_D4ds_v4"
      disk_type = "Premium_LRS"
      os        = { type = "gallery", source_image_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-images/providers/Microsoft.Compute/images/deployer" }
    }
  }

  expect_failures = [var.deployer]
}

run "rejects_malformed_app_configuration_id" {
  command = plan

  variables {
    naming     = run.names.naming
    naming_new = run.names.naming_new
    app_config_service = { deploy = true, id = "appcs-controlplane", exists = true }
  }

  expect_failures = [var.app_config_service]
}
