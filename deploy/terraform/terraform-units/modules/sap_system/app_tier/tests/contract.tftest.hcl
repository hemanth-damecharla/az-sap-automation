# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Interface contract of the app_tier module: a minimal input plans no
# application tier, and an enabled tier takes the declared defaults. The module
# declares no input validation of its own; the shared objects are validated by
# common_infrastructure, which the root module always calls with the same
# values. The resources themselves are covered by the plan-shape tests of
# run/sap_system.

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

override_data {
  target = data.azurerm_subnet.subnet_sap_app
  values = {
    id               = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.Network/virtualNetworks/vnet-sap01/subnets/app"
    address_prefixes = ["10.1.3.0/24"]
  }
}

variables {
  # Inputs of the name generator used by the first run.
  environment      = "DEV"
  location         = "westeurope"
  random_id        = "abc123def"
  sap_vnet_name    = "SAP01"
  sap_sid          = "ABC"
  app_server_count = 1
  scs_server_count = 1

  # The smallest input the module accepts: the application subnet of the
  # workload zone and every other optional attribute left to its declared
  # default.
  application_tier = { sid = "ABC" }
  infrastructure = {
    environment = "DEV"
    region      = "westeurope"
    virtual_networks = {
      sap = {
        subnet_app = {
          exists_in_workload = true
          id_in_workload     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.Network/virtualNetworks/vnet-sap01/subnets/app"
        }
      }
    }
  }
  options      = {}
  dns_settings = {}

  # Values handed over by common_infrastructure.
  admin_subnet = null
  resource_group = [{
    id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-abc"
    name     = "rg-abc"
    location = "westeurope"
  }]
  ppg                       = []
  cloudinit_growpart_config = null
  order_deployment          = null
  firewall_id               = ""
  route_table_id            = ""
  network_location          = "westeurope"
  network_resource_group    = "rg-landscape"
  scale_set_id              = ""
  sid_keyvault_user_id      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.KeyVault/vaults/kv-user"
  sid_username              = "azureadm"
  sid_password              = "P@ssw0rd-diagnostic-only!"
  sdu_public_key            = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCU51GUHdJHlxNoZrvt4bYCSX20Umzij0faob4Ud13/JG6tHbCjgUUVNgmYbAfEHJT0/Vox72Wo4OezrdDdnwhMY+RmRGkcUZq1HE/x5g7yJpPvzCmrvxv25f4w3Er2B6tPeOSStA+eA42vmVbJh20hXveqmA7SsybuYRRd1SZh1VfuWNdfHIAYZQarA169XELRWR0XO8bylT17HLNNWSYiOcOzGEHftMJ7CWlpxU54n9X6hIZ8fmDrLoFBaCb8SIM7VC3dGpRA8g6HJke/ge+MdEkQtSszo0IxcAxeNRGdyIMG/4Ns/mnveudk+7IwoVvuNwn4M1SY9ApGu8RK05Jl diagnostic-only"
  storage_bootdiag_endpoint = "https://stlandscapediag.blob.core.windows.net/"

  landscape_tfstate = {
    automation_version = "5.0.0"
    vnet_sap_arm_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.Network/virtualNetworks/vnet-sap01"
    app_subnet_id      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.Network/virtualNetworks/vnet-sap01/subnets/app"
    dns_label          = ""
  }

  custom_disk_sizes_filename         = ""
  deploy_application_security_groups = false
  deployment                         = "new"
  fencing_role_name                  = "Virtual Machine Contributor"
  license_type                       = ""
  NFS_provider                       = "NONE"
  terraform_template_version         = "3.16.0.0"
  use_admin_nic_for_asg              = false
  use_msi_for_clusters               = true
  use_scalesets_for_deployment       = false
  tags                               = {}
}

# Names come from the real name generator, so the contract runs see the same
# structure the root module passes in.
run "names" {
  command = plan

  module {
    source = "../../sap_namegenerator"
  }
}

run "minimal_input_plans_no_application_tier" {
  command = plan

  variables {
    naming = run.names.naming
  }

  assert {
    condition     = length(output.app_vm_ids) == 0 && length(output.scs_vm_ids) == 0 && length(output.webdispatcher_server_vm_ids) == 0
    error_message = "No virtual machines may be planned unless application_tier.enable_deployment is set."
  }

  assert {
    condition     = output.scs_high_availability == false
    error_message = "Central services high availability must be off by default."
  }

  assert {
    condition     = length(output.apptier_disks) == 0
    error_message = "No disks may be planned unless application_tier.enable_deployment is set."
  }
}

# The operating system images have no default: an enabled tier has to name
# them.
run "enabled_tier_takes_documented_defaults" {
  command = plan

  variables {
    naming = run.names.naming
    application_tier = {
      sid                      = "ABC"
      enable_deployment        = true
      application_server_count = 1
      scs_server_count         = 1
      app_os                   = { publisher = "SUSE", offer = "sles-sap-15-sp5", sku = "gen2", version = "latest" }
      scs_os                   = { publisher = "SUSE", offer = "sles-sap-15-sp5", sku = "gen2", version = "latest" }
    }
  }

  assert {
    condition     = length(output.app_vm_names) == 1 && length(output.scs_vm_names) == 1
    error_message = "One application server and one central services server must be planned."
  }

  assert {
    condition     = length(output.webdispatcher_server_vm_names) == 0
    error_message = "No web dispatcher may be planned unless webdispatcher_count asks for one."
  }

  assert {
    condition     = length(output.application_server_secondary_ips) == 0 && length(output.scs_server_secondary_ips) == 0
    error_message = "Secondary addresses must be off unless use_secondary_ips is set."
  }

  assert {
    condition     = length(output.scs_asd) == 0
    error_message = "No shared cluster disk may be planned without central services high availability."
  }

  assert {
    condition     = output.app_tier_os_types.app == "LINUX" && output.app_tier_os_types.scs == "LINUX"
    error_message = "The operating system type must default to LINUX."
  }
}

# The workload zone state is typed. A state written before the DNS attributes
# existed takes their empty defaults, so no DNS record is registered even when
# registration is switched on.
run "state_without_dns_attributes_registers_no_dns_record" {
  command = plan

  variables {
    naming       = run.names.naming
    dns_settings = { register_virtual_network_to_dns = true }
    application_tier = {
      sid                      = "ABC"
      enable_deployment        = true
      application_server_count = 1
      scs_server_count         = 1
      app_os                   = { publisher = "SUSE", offer = "sles-sap-15-sp5", sku = "gen2", version = "latest" }
      scs_os                   = { publisher = "SUSE", offer = "sles-sap-15-sp5", sku = "gen2", version = "latest" }
    }
    landscape_tfstate = {
      vnet_sap_arm_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.Network/virtualNetworks/vnet-sap01"
    }
  }

  assert {
    condition     = length(azurerm_private_dns_a_record.scs) == 0 && length(azurerm_private_dns_a_record.ers) == 0
    error_message = "Without a DNS label in the workload zone state no DNS record may be planned."
  }
}

run "state_with_dns_label_registers_the_central_services_records" {
  command = plan

  variables {
    naming       = run.names.naming
    dns_settings = { register_virtual_network_to_dns = true }
    application_tier = {
      sid                      = "ABC"
      enable_deployment        = true
      application_server_count = 1
      scs_server_count         = 1
      app_os                   = { publisher = "SUSE", offer = "sles-sap-15-sp5", sku = "gen2", version = "latest" }
      scs_os                   = { publisher = "SUSE", offer = "sles-sap-15-sp5", sku = "gen2", version = "latest" }
    }
    landscape_tfstate = {
      vnet_sap_arm_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landscape/providers/Microsoft.Network/virtualNetworks/vnet-sap01"
      dns_label               = "sap.contoso.net"
      dns_resource_group_name = "rg-dns"
    }
  }

  assert {
    condition     = length(azurerm_private_dns_a_record.scs) == 1 && length(azurerm_private_dns_a_record.ers) == 1
    error_message = "With a DNS label in the workload zone state the central services load balancer must be registered."
  }

  assert {
    condition     = azurerm_private_dns_a_record.scs[0].zone_name == "sap.contoso.net" && azurerm_private_dns_a_record.scs[0].resource_group_name == "rg-dns"
    error_message = "The DNS record must use the zone and resource group from the workload zone state."
  }
}
