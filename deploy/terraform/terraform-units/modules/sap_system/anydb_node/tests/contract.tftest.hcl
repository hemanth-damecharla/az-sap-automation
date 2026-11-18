# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Interface contract of the anydb_node module: the defaults a minimal input
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
  db_sid          = "DB2"
  db_ostype       = "LINUX"
  db_server_count = 1

  # The smallest input the module plans with: one database server and every
  # optional attribute left to its declared default.
  database = {
    platform  = "DB2"
    use_avset = false
    use_ppg   = false
  }
  infrastructure = { region = "westeurope" }
  options        = {}
  dns_settings   = {}

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
  anchor_vm                 = ""
  order_deployment          = null
  cloudinit_growpart_config = null
  db_asg_id                 = ""
  scale_set_id              = ""
  sid_keyvault_user_id      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.KeyVault/vaults/kv-user"
  sid_username              = "azureadm"
  sid_password              = "P@ssw0rd-diagnostic-only!"
  sdu_public_key            = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCU51GUHdJHlxNoZrvt4bYCSX20Umzij0faob4Ud13/JG6tHbCjgUUVNgmYbAfEHJT0/Vox72Wo4OezrdDdnwhMY+RmRGkcUZq1HE/x5g7yJpPvzCmrvxv25f4w3Er2B6tPeOSStA+eA42vmVbJh20hXveqmA7SsybuYRRd1SZh1VfuWNdfHIAYZQarA169XELRWR0XO8bylT17HLNNWSYiOcOzGEHftMJ7CWlpxU54n9X6hIZ8fmDrLoFBaCb8SIM7VC3dGpRA8g6HJke/ge+MdEkQtSszo0IxcAxeNRGdyIMG/4Ns/mnveudk+7IwoVvuNwn4M1SY9ApGu8RK05Jl diagnostic-only"
  storage_bootdiag_endpoint = "https://stlandscapediag.blob.core.windows.net/"

  landscape_tfstate = {
    automation_version = "5.0.0"
    vnet_sap_arm_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.Network/virtualNetworks/vnet-sap01"
    dns_label          = ""
  }

  database_vm_admin_nic_ips                 = []
  database_vm_db_nic_ips                    = []
  database_vm_db_nic_secondary_ips          = []
  deploy_application_security_groups        = false
  deployment                                = "new"
  custom_disk_sizes_filename                = ""
  license_type                              = ""
  observer_vm_tags                          = {}
  use_loadbalancers_for_standalone_deployments = true
  fencing_role_name                         = "Virtual Machine Contributor"
  terraform_template_version                = "3.16.0.0"
  use_admin_nic_suffix_for_observer         = false
  use_admin_nic_for_asg                     = false
  use_msi_for_clusters                      = true
  use_observer                              = false
  observer_vm_size                          = "Standard_D4s_v3"
  observer_vm_zones                         = []
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
    condition     = length(output.database_server_vm_names) == 1
    error_message = "One database server must be planned by default."
  }

  assert {
    condition     = length(output.database_server_admin_ips) == 1
    error_message = "Without dual network interfaces the database interface must be reported as the admin interface."
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
    condition     = length(output.database_shared_disks) == 0
    error_message = "No shared cluster disk may be planned without high availability."
  }
}

# Every platform sizing file has the "Default" entry the sizing key defaults to.
run "oracle_plans_with_the_default_sizing_key" {
  command = plan

  variables {
    naming = run.names.naming
    database = {
      platform  = "ORACLE"
      use_avset = false
      use_ppg   = false
    }
  }

  assert {
    condition     = length(output.database_server_ips) == 1
    error_message = "One database server must be planned with the default sizing key."
  }

  assert {
    condition     = length(output.database_disks) > 0
    error_message = "The default sizing key must resolve to a disk layout."
  }
}

run "oracle_asm_plans_with_the_default_sizing_key" {
  command = plan

  variables {
    naming = run.names.naming
    database = {
      platform  = "ORACLE-ASM"
      use_avset = false
      use_ppg   = false
    }
  }

  assert {
    condition     = length(output.database_server_ips) == 1
    error_message = "One database server must be planned with the default sizing key."
  }

  assert {
    condition     = length(output.database_disks) > 0
    error_message = "The default sizing key must resolve to a disk layout."
  }
}

run "sybase_plans_with_the_default_sizing_key" {
  command = plan

  variables {
    naming = run.names.naming
    database = {
      platform  = "SYBASE"
      use_avset = false
      use_ppg   = false
    }
  }

  assert {
    condition     = length(output.database_server_ips) == 1
    error_message = "One database server must be planned with the default sizing key."
  }

  assert {
    condition     = length(output.database_disks) > 0
    error_message = "The default sizing key must resolve to a disk layout."
  }
}

run "sql_server_plans_with_the_default_sizing_key" {
  command = plan

  variables {
    naming = run.names.naming
    database = {
      platform  = "SQLSERVER"
      use_avset = false
      use_ppg   = false
    }
  }

  assert {
    condition     = length(output.database_server_ips) == 1
    error_message = "One database server must be planned with the default sizing key."
  }

  assert {
    condition     = length(output.database_disks) > 0
    error_message = "The default sizing key must resolve to a disk layout."
  }
}

# The root module always calls this module and passes a server count of zero
# when the database platform is HANA.
run "hana_platform_plans_no_database_servers" {
  command = plan

  variables {
    naming = run.names.naming
    database = {
      platform  = "HANA"
      use_avset = false
      use_ppg   = false
    }
    database_server_count = 0
  }

  assert {
    condition     = length(output.database_server_ips) == 0
    error_message = "No network interfaces may be planned for the HANA platform."
  }

  assert {
    condition     = length(output.database_disks) == 0
    error_message = "No disks may be planned for the HANA platform."
  }
}

# The workload zone state is typed. A state written before the DNS attributes
# existed takes their empty defaults, so no DNS record is registered even when
# registration is switched on.
run "state_without_dns_attributes_registers_no_dns_record" {
  command = plan

  variables {
    naming            = run.names.naming
    dns_settings      = { register_virtual_network_to_dns = true }
    landscape_tfstate = {}
  }

  assert {
    condition     = length(azurerm_private_dns_a_record.db) == 0
    error_message = "Without a DNS label in the workload zone state no DNS record may be planned."
  }
}

run "state_with_dns_label_registers_the_database_record" {
  command = plan

  variables {
    naming       = run.names.naming
    dns_settings = { register_virtual_network_to_dns = true }
    landscape_tfstate = {
      dns_label               = "sap.contoso.net"
      dns_resource_group_name = "rg-dns"
    }
  }

  assert {
    condition     = length(azurerm_private_dns_a_record.db) == 1
    error_message = "With a DNS label in the workload zone state the database load balancer must be registered."
  }

  assert {
    condition     = azurerm_private_dns_a_record.db[0].zone_name == "sap.contoso.net" && azurerm_private_dns_a_record.db[0].resource_group_name == "rg-dns"
    error_message = "The DNS record must use the zone and resource group from the workload zone state."
  }
}
