# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Interface contract of the hdb_node module: the defaults a minimal input
# takes, and the platform switch that decides whether the module plans
# anything. The module declares no input validation of its own; the shared
# objects are validated by common_infrastructure, which the root module always
# calls with the same values. The resources themselves are covered by the
# plan-shape tests of run/sap_system.

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

variables {
  # Inputs of the name generator used by the first run.
  environment     = "DEV"
  location        = "westeurope"
  random_id       = "abc123def"
  sap_vnet_name   = "SAP01"
  sap_sid         = "ABC"
  db_sid          = "HDB"
  db_server_count = 1

  # The smallest input the module plans with: one database server and every
  # optional attribute left to its declared default.
  database = {
    platform  = "HANA"
    use_avset = false
    use_ppg   = false
  }
  infrastructure = {
    region = "westeurope"
    virtual_networks = {
      sap = {}
    }
  }
  options          = {}
  dns_settings     = {}
  hana_ANF_volumes = {}

  # Values handed over by common_infrastructure.
  admin_subnet = null
  db_subnet = {
    id               = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.Network/virtualNetworks/vnet-sap01/subnets/db"
    address_prefixes = ["10.1.1.0/24"]
  }
  resource_group = [{
    id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-abc"
    name     = "rg-abc"
    location = "westeurope"
  }]
  ppg                       = []
  cloudinit_growpart_config = null
  db_asg_id                 = ""
  storage_subnet_id         = ""
  scale_set_id              = ""
  sid_keyvault_user_id      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.KeyVault/vaults/kv-user"
  sid_username              = "azureadm"
  sid_password              = "P@ssw0rd-diagnostic-only!"
  sdu_public_key            = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCU51GUHdJHlxNoZrvt4bYCSX20Umzij0faob4Ud13/JG6tHbCjgUUVNgmYbAfEHJT0/Vox72Wo4OezrdDdnwhMY+RmRGkcUZq1HE/x5g7yJpPvzCmrvxv25f4w3Er2B6tPeOSStA+eA42vmVbJh20hXveqmA7SsybuYRRd1SZh1VfuWNdfHIAYZQarA169XELRWR0XO8bylT17HLNNWSYiOcOzGEHftMJ7CWlpxU54n9X6hIZ8fmDrLoFBaCb8SIM7VC3dGpRA8g6HJke/ge+MdEkQtSszo0IxcAxeNRGdyIMG/4Ns/mnveudk+7IwoVvuNwn4M1SY9ApGu8RK05Jl diagnostic-only"
  storage_bootdiag_endpoint = "https://stlandscapediag.blob.core.windows.net/"

  deployer_tfstate = null
  landscape_tfstate = {
    automation_version = "5.0.0"
    vnet_sap_arm_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.Network/virtualNetworks/vnet-sap01"
    dns_label          = ""
  }

  enable_storage_nic                        = false
  database_use_premium_v2_storage           = false
  database_active_active                    = false
  database_vm_admin_nic_ips                 = []
  database_vm_db_nic_ips                    = []
  database_vm_db_nic_secondary_ips          = []
  database_vm_storage_nic_ips               = []
  deploy_application_security_groups        = false
  deployment                                = "new"
  fencing_role_name                         = "Virtual Machine Contributor"
  NFS_provider                              = "NONE"
  terraform_template_version                = "3.16.0.0"
  use_admin_nic_suffix_for_observer         = false
  use_admin_nic_for_asg                     = false
  use_msi_for_clusters                      = true
  use_observer                              = false
  observer_vm_size                          = "Standard_D4s_v3"
  observer_vm_zones                         = []
  enable_firewall_for_keyvaults_and_storage = false
  use_scalesets_for_deployment              = false
  tags                                      = {}
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
    condition     = output.hdb_sid == "ABC"
    error_message = "Without database.instance.sid the database SID must be the SAP SID."
  }

  assert {
    condition     = length(output.database_server_vm_names) == 1
    error_message = "One database server must be planned by default."
  }

  assert {
    condition     = length(output.db_admin_ips) == 0
    error_message = "Without dual network interfaces no admin addresses may be reported."
  }

  assert {
    condition     = length(output.database_server_secondary_ips) == 0
    error_message = "Secondary addresses must be off unless use_secondary_ips is set."
  }

  assert {
    condition     = length(output.observer_ips) == 0
    error_message = "No observer may be planned unless use_observer is set."
  }

  assert {
    condition     = length(output.hana_data_ANF_volumes) == 0 && length(output.hana_log_ANF_volumes) == 0
    error_message = "No Azure NetApp Files volumes may be planned unless hana_ANF_volumes asks for them."
  }

  assert {
    condition     = length(output.hana_shared_afs_path) == 0
    error_message = "No Azure Files share for /hana/shared may be planned outside a scale-out deployment."
  }
}

run "database_instance_sid_overrides_the_sap_sid" {
  command = plan

  variables {
    naming = run.names.naming
    database = {
      platform  = "HANA"
      use_avset = false
      use_ppg   = false
      instance  = { sid = "HDB" }
    }
  }

  assert {
    condition     = output.hdb_sid == "HDB"
    error_message = "database.instance.sid must be used as the database SID when it is set."
  }
}

# The root module always calls this module and passes a server count of zero
# when the database platform is not HANA.
run "other_platform_plans_no_database_servers" {
  command = plan

  variables {
    naming = run.names.naming
    database = {
      platform  = "SQLSERVER"
      use_avset = false
      use_ppg   = false
    }
    database_server_count = 0
  }

  assert {
    condition     = length(output.hanadb_vm_ids) == 0
    error_message = "No HANA virtual machines may be planned for another database platform."
  }

  assert {
    condition     = length(output.database_disks) == 0
    error_message = "No HANA disks may be planned for another database platform."
  }

  assert {
    condition     = output.dns_info_vms == null
    error_message = "No DNS records may be reported for another database platform."
  }
}

# The upstream states are typed. A deployer state that is absent (null) or empty
# and a workload zone state written before these attributes existed take the
# declared defaults.
run "absent_and_older_states_take_defaults" {
  command = plan

  variables {
    naming            = run.names.naming
    deployer_tfstate  = {}
    landscape_tfstate = {}
  }

  assert {
    condition     = length(data.azurerm_network_security_perimeter.perimeter) == 0
    error_message = "Without a deployer state no network security perimeter may be looked up."
  }

  assert {
    condition     = length(output.database_server_vm_names) == 1
    error_message = "The database server must still be planned from an empty workload zone state."
  }
}

# The deployer state switches the network security perimeter on.
run "deployer_state_with_perimeter_looks_up_the_perimeter" {
  command = plan

  override_data {
    target = data.azurerm_network_security_perimeter.perimeter
    values = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mgmt/providers/Microsoft.Network/networkSecurityPerimeters/nsp-dev"
    }
  }

  variables {
    naming = run.names.naming
    deployer_tfstate = {
      network_security_perimeter_deployment = true
      network_security_perimeter_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mgmt/providers/Microsoft.Network/networkSecurityPerimeters/nsp-dev"
      network_security_access_mode          = "Learning"
    }
  }

  assert {
    condition     = length(data.azurerm_network_security_perimeter.perimeter) == 1
    error_message = "A deployer state with a network security perimeter must make the module look it up."
  }

  assert {
    condition     = data.azurerm_network_security_perimeter.perimeter[0].name == "nsp-dev" && data.azurerm_network_security_perimeter.perimeter[0].resource_group_name == "rg-mgmt"
    error_message = "The perimeter must be looked up by the name and resource group in the deployer state."
  }
}

# This is the object the workload zone publishes when it does not use Azure
# NetApp Files: empty strings, size_in_tb as a string, and no qos_type. It must
# keep converting to the declared type.
run "workload_zone_without_netapp_files_converts" {
  command = plan

  variables {
    naming = run.names.naming
    landscape_tfstate = {
      ANF_pool_settings = {
        use_ANF             = false
        account_name        = ""
        account_id          = ""
        pool_name           = ""
        service_level       = ""
        size_in_tb          = ""
        subnet_id           = ""
        resource_group_name = ""
        location            = ""
      }
    }
  }

  assert {
    condition     = length(output.hana_data_ANF_volumes) == 0 && length(output.hana_log_ANF_volumes) == 0
    error_message = "No Azure NetApp Files volume may be planned when the workload zone does not use them."
  }
}

# use_separate_storage_subnet decides whether the storage interfaces are
# planned. A state that predates the attribute leaves it null, and the module
# then falls back to its own scale-out storage subnet rule.
run "separate_storage_subnet_plans_storage_interfaces" {
  command = plan

  variables {
    naming             = run.names.naming
    enable_storage_nic = true
    storage_subnet_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.Network/virtualNetworks/vnet-sap01/subnets/storage"
    landscape_tfstate  = { use_separate_storage_subnet = true }
    infrastructure = {
      region = "westeurope"
      virtual_networks = {
        sap = {
          subnet_storage = {
            id     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.Network/virtualNetworks/vnet-sap01/subnets/storage"
            prefix = "10.1.2.0/24"
          }
        }
      }
    }
  }

  assert {
    condition     = length(azurerm_network_interface.nics_dbnodes_storage) == 1
    error_message = "With a separate storage subnet in the workload zone one storage interface per server must be planned."
  }
}

run "state_without_storage_subnet_flag_uses_the_module_rule" {
  command = plan

  variables {
    naming             = run.names.naming
    enable_storage_nic = true
    landscape_tfstate  = {}
  }

  assert {
    condition     = length(azurerm_network_interface.nics_dbnodes_storage) == 0
    error_message = "Without the flag and outside a scale-out deployment no storage interface may be planned."
  }
}
