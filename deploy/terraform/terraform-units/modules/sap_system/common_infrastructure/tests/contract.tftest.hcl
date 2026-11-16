# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Interface contract of the common_infrastructure module: the defaults a
# minimal input takes and the inputs the module refuses. Input validation is
# evaluated before any resource is planned, so the rejection runs need no
# provider behaviour beyond the mocks below. The resources themselves are
# covered by the plan-shape tests of run/sap_system.

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

override_data {
  target = data.azurerm_subnet.admin
  values = {
    id               = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.Network/virtualNetworks/vnet-sap01/subnets/admin"
    address_prefixes = ["10.1.0.0/24"]
  }
}

override_data {
  target = data.azurerm_subnet.db
  values = {
    id               = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.Network/virtualNetworks/vnet-sap01/subnets/db"
    address_prefixes = ["10.1.1.0/24"]
  }
}

override_data {
  target = data.azurerm_subnet.storage
  values = {
    id               = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.Network/virtualNetworks/vnet-sap01/subnets/storage"
    address_prefixes = ["10.1.2.0/24"]
  }
}

override_data {
  target = data.azurerm_key_vault_secret.sid_pk
  values = {
    value = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCU51GUHdJHlxNoZrvt4bYCSX20Umzij0faob4Ud13/JG6tHbCjgUUVNgmYbAfEHJT0/Vox72Wo4OezrdDdnwhMY+RmRGkcUZq1HE/x5g7yJpPvzCmrvxv25f4w3Er2B6tPeOSStA+eA42vmVbJh20hXveqmA7SsybuYRRd1SZh1VfuWNdfHIAYZQarA169XELRWR0XO8bylT17HLNNWSYiOcOzGEHftMJ7CWlpxU54n9X6hIZ8fmDrLoFBaCb8SIM7VC3dGpRA8g6HJke/ge+MdEkQtSszo0IxcAxeNRGdyIMG/4Ns/mnveudk+7IwoVvuNwn4M1SY9ApGu8RK05Jl diagnostic-only"
  }
}

override_data {
  target = data.azurerm_key_vault_secret.sid_password
  values = {
    value = "P@ssw0rd-diagnostic-only!"
  }
}

variables {
  # Inputs of the name generator used by the first run.
  environment      = "DEV"
  location         = "westeurope"
  random_id        = "abc123def"
  sap_vnet_name    = "SAP01"
  sap_sid          = "ABC"
  db_sid           = "HDB"
  db_server_count  = 1
  app_server_count = 1
  scs_server_count = 1

  # The smallest input the module plans with: the subnets of the workload zone,
  # the workload zone key vault, and every other optional attribute left to its
  # declared default.
  application_tier = { sid = "ABC" }
  database = {
    platform      = "HANA"
    db_sizing_key = "Default"
    use_ppg       = false
  }
  infrastructure = {
    environment = "DEV"
    region      = "westeurope"
    virtual_networks = {
      sap = {
        logical_name = "SAP01"
        subnet_admin = {
          exists_in_workload = true
          id_in_workload     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.Network/virtualNetworks/vnet-sap01/subnets/admin"
        }
        subnet_db = {
          exists_in_workload = true
          id_in_workload     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.Network/virtualNetworks/vnet-sap01/subnets/db"
        }
        subnet_app = {
          exists_in_workload = true
          id_in_workload     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.Network/virtualNetworks/vnet-sap01/subnets/app"
        }
        subnet_storage = {
          exists_in_workload = true
          id_in_workload     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.Network/virtualNetworks/vnet-sap01/subnets/storage"
        }
      }
    }
  }
  options = {}
  key_vault = {
    user = { id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.KeyVault/vaults/kv-user" }
  }
  dns_settings     = {}
  hana_ANF_volumes = {}

  ha_validator                              = "00-NONE"
  deployer_tfstate                          = null
  deployment                                = "new"
  terraform_template_version                = "3.16.0.0"
  enable_purge_control_for_keyvaults        = false
  sapmnt_volume_size                        = 128
  NFS_provider                              = "NONE"
  use_random_id_for_storageaccounts         = true
  enable_firewall_for_keyvaults_and_storage = false
  deploy_application_security_groups        = true
  use_scalesets_for_deployment              = false
  tags                                      = {}

  landscape_tfstate = {
    automation_version                     = "5.0.0"
    random_id                              = "abc"
    created_resource_group_id              = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape"
    created_resource_group_name            = "rg-landscape"
    created_resource_group_subscription_id = "00000000-0000-0000-0000-000000000000"
    vnet_sap_arm_id                        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.Network/virtualNetworks/vnet-sap01"
    admin_subnet_id                        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.Network/virtualNetworks/vnet-sap01/subnets/admin"
    db_subnet_id                           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.Network/virtualNetworks/vnet-sap01/subnets/db"
    app_subnet_id                          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.Network/virtualNetworks/vnet-sap01/subnets/app"
    storage_subnet_id                      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.Network/virtualNetworks/vnet-sap01/subnets/storage"
    landscape_key_vault_user_arm_id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.KeyVault/vaults/kv-user"
    sid_password_secret_name               = "sid-password"
    sid_public_key_secret_name             = "sid-public-key"
    sid_username_secret_name               = "sid-username"
    storageaccount_name                    = "stlandscapediag"
    storageaccount_rg_name                 = "rg-landscape"
    route_table_id                         = ""
    use_separate_storage_subnet            = true
  }
}

# Names come from the real name generator, so the contract runs see the same
# structure the root module passes in.
run "names" {
  command = plan

  module {
    source = "../../sap_namegenerator"
  }
}

run "minimal_input_takes_documented_defaults" {
  command = plan

  variables {
    naming = run.names.naming
  }

  assert {
    condition     = output.use_local_credentials == false
    error_message = "With no authentication input the workload zone credentials must be used."
  }

  assert {
    condition     = output.use_AFS_encryption_in_transit == false
    error_message = "Encryption in transit for Azure Files must be off unless requested."
  }

  assert {
    condition     = output.anchor_vm == ""
    error_message = "No anchor virtual machine may be planned unless infrastructure.anchor_vms asks for one."
  }

  assert {
    condition     = output.scale_set_id == ""
    error_message = "No scale set may be planned unless use_scalesets_for_deployment is set."
  }

  assert {
    condition     = output.network_resource_group == "rg-landscape"
    error_message = "The network resource group must be read from the workload zone virtual network id."
  }

  assert {
    condition     = output.firewall_id == ""
    error_message = "Without a deployer state the firewall id must be empty."
  }
}

run "rejects_application_sid_that_is_not_three_characters" {
  command = plan

  variables {
    naming = run.names.naming
    application_tier = { sid = "ABCD" }
  }

  expect_failures = [var.application_tier]
}

run "rejects_web_dispatchers_without_web_sid" {
  command = plan

  variables {
    naming = run.names.naming
    application_tier = {
      sid                 = "ABC"
      webdispatcher_count = 1
    }
  }

  expect_failures = [var.application_tier]
}

# A zone redundant shared disk spans two zones, a locally redundant one a single zone.
run "rejects_shared_disk_cluster_across_more_zones_than_the_disk_supports" {
  command = plan

  variables {
    naming = run.names.naming
    application_tier = {
      sid                   = "ABC"
      scs_high_availability = true
      scs_cluster_type      = "ASD"
      scs_cluster_disk_type = "Premium_LRS"
      scs_zones             = ["1", "2"]
    }
  }

  expect_failures = [var.application_tier]
}

run "rejects_blank_database_platform" {
  command = plan

  variables {
    naming = run.names.naming
    database = {
      platform      = " "
      db_sizing_key = "Default"
      use_ppg       = false
    }
  }

  expect_failures = [var.database]
}

run "rejects_blank_database_sizing_key" {
  command = plan

  variables {
    naming = run.names.naming
    database = {
      platform = "HANA"
      use_ppg  = false
    }
  }

  expect_failures = [var.database]
}

run "rejects_blank_region" {
  command = plan

  variables {
    naming = run.names.naming
    infrastructure = {
      environment = "DEV"
      region      = ""
      virtual_networks = {
        sap = {
          logical_name = "SAP01"
        }
      }
    }
  }

  expect_failures = [var.infrastructure]
}

run "rejects_blank_environment" {
  command = plan

  variables {
    naming = run.names.naming
    infrastructure = {
      environment = ""
      region      = "westeurope"
      virtual_networks = {
        sap = {
          logical_name = "SAP01"
        }
      }
    }
  }

  expect_failures = [var.infrastructure]
}

run "rejects_blank_logical_network_name" {
  command = plan

  variables {
    naming = run.names.naming
    infrastructure = {
      environment = "DEV"
      region      = "westeurope"
      virtual_networks = {
        sap = {
          logical_name = ""
        }
      }
    }
  }

  expect_failures = [var.infrastructure]
}

run "rejects_new_admin_subnet_without_id_or_prefix" {
  command = plan

  variables {
    naming = run.names.naming
    infrastructure = {
      environment = "DEV"
      region      = "westeurope"
      virtual_networks = {
        sap = {
          logical_name = "SAP01"
          subnet_admin = {
            defined = true
          }
        }
      }
    }
  }

  expect_failures = [var.infrastructure]
}

run "rejects_new_app_subnet_without_id_or_prefix" {
  command = plan

  variables {
    naming = run.names.naming
    infrastructure = {
      environment = "DEV"
      region      = "westeurope"
      virtual_networks = {
        sap = {
          logical_name = "SAP01"
          subnet_app = {
            defined = true
          }
        }
      }
    }
  }

  expect_failures = [var.infrastructure]
}

run "rejects_new_db_subnet_without_id_or_prefix" {
  command = plan

  variables {
    naming = run.names.naming
    infrastructure = {
      environment = "DEV"
      region      = "westeurope"
      virtual_networks = {
        sap = {
          logical_name = "SAP01"
          subnet_db = {
            defined = true
          }
        }
      }
    }
  }

  expect_failures = [var.infrastructure]
}

run "rejects_malformed_deployment_credentials_key_vault_id" {
  command = plan

  variables {
    naming = run.names.naming
    key_vault = {
      keyvault_id_for_deployment_credentials = "kv-deployment"
    }
  }

  expect_failures = [var.key_vault]
}

run "rejects_malformed_system_credentials_key_vault_id" {
  command = plan

  variables {
    naming = run.names.naming
    key_vault = {
      keyvault_id_for_system_credentials = "kv-system"
    }
  }

  expect_failures = [var.key_vault]
}

run "rejects_high_availability_without_nfs_provider" {
  command = plan

  variables {
    naming = run.names.naming
    ha_validator = "10-NONE"
  }

  expect_failures = [var.ha_validator]
}

run "rejects_workload_zone_state_without_virtual_network" {
  command = plan

  variables {
    naming = run.names.naming
    landscape_tfstate = {
      vnet_sap_arm_id = ""
    }
  }

  expect_failures = [var.landscape_tfstate]
}
