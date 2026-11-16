# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Interface contract of the output_files module: the defaults the typed
# database, infrastructure and authentication objects take, and how their
# attributes reach the generated sap-parameters file. The module declares no
# input validation. The generated files as a whole are covered by the output
# tests of run/sap_system.

mock_provider "azurerm" {
  mock_data "azurerm_client_config" {
    defaults = {
      tenant_id = "00000000-0000-0000-0000-000000000000"
    }
  }
}

mock_provider "azurerm" {
  alias = "main"
}

mock_provider "azurerm" {
  alias = "dnsmanagement"
}

mock_provider "azurerm" {
  alias = "deployer"
  mock_data "azurerm_storage_container" {
    defaults = {
      id = "/subscriptions/22222222-2222-2222-2222-222222222222/resourceGroups/rg-tfstate/providers/Microsoft.Storage/storageAccounts/sttfstate001/blobServices/default/containers/tfvars"
    }
  }
  mock_resource "azurerm_storage_blob" {
    defaults = {
      id = "mock-blob-id"
    }
  }
}

variables {
  tfstate_resource_id = "/subscriptions/22222222-2222-2222-2222-222222222222/resourceGroups/rg-tfstate/providers/Microsoft.Storage/storageAccounts/sttfstate001"

  naming = {
    separator             = "-"
    prefix                = {
      SDU           = "DEV-WEEU-SAP01-X00"
      WORKLOAD_ZONE = "DEV-WEEU-SAP01"
    }
    resource_suffixes     = { ansible = "ansible" }
    virtualmachine_names  = {
      HANA_COMPUTERNAME          = ["x00dhdb00l0"]
      HANA_SECONDARY_DNSNAME     = ["x00dhdb00l0-secondary"]
      ANYDB_COMPUTERNAME         = []
      ANYDB_SECONDARY_DNSNAME    = []
      APP_COMPUTERNAME           = []
      APP_SECONDARY_DNSNAME      = []
      SCS_COMPUTERNAME           = []
      SCS_SECONDARY_DNSNAME      = []
      WEB_COMPUTERNAME           = []
      WEB_SECONDARY_DNSNAME      = []
      OBSERVER_COMPUTERNAME      = []
    }
  }

  sap_sid                                 = "X00"
  platform                                = "HANA"
  db_sid                                  = "HDB"
  scale_out                               = false
  scale_out_no_standby_role               = false
  shared_home                             = false
  use_secondary_ips                       = false
  use_local_credentials                   = true
  use_msi_for_clusters                    = false
  use_AFS_encryption_in_transit           = false
  suse_subscription_id                    = ""
  authentication_type                     = "key"
  configuration_settings                  = {}
  database                                = {}
  deploy_monitoring_extension              = false
  database_admin_ips                      = ["10.0.4.4"]
  database_server_ips                     = ["10.0.4.4"]
  database_server_secondary_ips           = []
  database_server_vm_names                = ["x00dhdb00l0"]
  database_shared_disks                   = []
  database_authentication_type            = "key"
  database_cluster_ip                     = ""
  database_cluster_type                   = "AFA"
  database_high_availability              = false
  database_active_active                  = false
  database_active_active_loadbalancer_ip  = ""
  database_loadbalancer_ip                = ""
  database_subnet_netmask                 = "26"
  db_server_count                         = 1
  app_server_count                        = 0
  scs_server_count                        = 0
  web_server_count                        = 0
  app_tier_os_types                       = { scs = "linux", app = "linux", web = "linux" }
  app_vm_names                            = []
  application_server_ips                  = []
  application_server_secondary_ips        = []
  ansible_user                            = "azureadm"
  app_subnet_netmask                      = "26"
  app_instance_number                     = "00"
  pas_instance_number                     = "00"
  ers_instance_number                     = "02"
  ers_server_loadbalancer_ip              = ""
  sid_keyvault_user_id                    = "/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg-mock/providers/Microsoft.KeyVault/vaults/kv-mock-user"
  scs_shared_disks                        = []
  scs_cluster_loadbalancer_ip             = ""
  scs_cluster_type                        = "AFA"
  scs_high_availability                   = false
  scs_instance_number                     = "00"
  scs_server_loadbalancer_ip              = ""
  scs_server_ips                          = []
  scs_server_secondary_ips                = []
  scs_server_vm_resource_ids               = []
  scs_vm_names                            = []
  webdispatcher_server_ips                = []
  webdispatcher_server_secondary_ips      = []
  webdispatcher_server_vm_names           = []
  web_sid                                 = ""
  web_instance_number                     = "00"
  observer_ips                            = []
  observer_vms                            = []
  observer_shared_disks                   = []
  disks                                   = []
  hana_data                               = []
  hana_log                                = []
  hana_shared                             = []
  install_path                            = ""
  iSCSI_server_ips                        = []
  iSCSI_server_names                      = []
  iSCSI_servers                           = []
  landscape_tfstate                       = {}
  loadbalancers                           = []
  NFS_provider                            = "NONE"
  sap_mnt                                 = ""
  sap_transport                           = ""
  save_naming_information                 = false
  created_resource_group_name             = "rg-mock-sap-system"
  created_resource_group_subscription_id  = "22222222-2222-2222-2222-222222222222"
  subnet_cidr_anf                         = ""
  subnet_cidr_app                         = "10.9.9.0/26"
  subnet_cidr_client                      = ""
  subnet_cidr_db                          = "10.9.12.0/26"
  subnet_cidr_storage                     = ""
  is_use_fence_kdump                      = false
  infrastructure                          = {}
  upgrade_packages                        = false
  usr_sap                                 = ""
  user_assigned_identity_id               = ""
  use_custom_dns_a_registration           = false
  dns_a_records_for_secondary_names       = false
  dns                                     = ""
  management_dns_resourcegroup_name       = null
  ams_resource_id                         = ""
  enable_os_monitoring                    = false
  enable_ha_monitoring                    = false
  site_information                        = ""
  random_id                               = "abcd"
}

run "minimal_input_takes_documented_defaults" {
  command = plan

  providers = {
    azurerm               = azurerm
    azurerm.main          = azurerm
    azurerm.dnsmanagement = azurerm.dnsmanagement
    azurerm.deployer      = azurerm.deployer
  }

  assert {
    condition     = can(regex("(?m)^db_instance_number:\\s+\"00\"$", nonsensitive(output.sap_parameters_content)))
    error_message = "Without database.instance.number the database instance number must be 00."
  }

  assert {
    condition     = can(regex("(?m)^use_hanasr_angi:\\s+false$", nonsensitive(output.sap_parameters_content)))
    error_message = "The SAPHanaSR-angi interface must be off unless the database asks for it."
  }

  assert {
    condition     = !can(regex("use_nvme_disks\\s+: true", nonsensitive(output.hosts_file_content)))
    error_message = "NVMe disks must be off for both tiers unless infrastructure asks for the NVMe disk controller."
  }
}

run "database_settings_reach_the_parameter_file" {
  command = plan

  providers = {
    azurerm               = azurerm
    azurerm.main          = azurerm
    azurerm.dnsmanagement = azurerm.dnsmanagement
    azurerm.deployer      = azurerm.deployer
  }

  variables {
    database = {
      database_hana_use_saphanasr_angi = true
      instance                         = { number = "10" }
    }
  }

  assert {
    condition     = can(regex("(?m)^db_instance_number:\\s+\"10\"$", nonsensitive(output.sap_parameters_content)))
    error_message = "database.instance.number must be written to the parameter file."
  }

  assert {
    condition     = can(regex("(?m)^use_hanasr_angi:\\s+true$", nonsensitive(output.sap_parameters_content)))
    error_message = "database.database_hana_use_saphanasr_angi must be written to the parameter file."
  }
}

run "nvme_disk_controller_reaches_the_inventory" {
  command = plan

  providers = {
    azurerm               = azurerm
    azurerm.main          = azurerm
    azurerm.dnsmanagement = azurerm.dnsmanagement
    azurerm.deployer      = azurerm.deployer
  }

  variables {
    infrastructure = {
      disk_controller_type_database_tier = "NVMe"
    }
  }

  assert {
    condition     = can(regex("(?m)^\\s+use_nvme_disks\\s+: true$", nonsensitive(output.hosts_file_content)))
    error_message = "The NVMe disk controller of the database tier must be written to the inventory."
  }
}
