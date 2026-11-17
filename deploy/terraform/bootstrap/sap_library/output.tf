# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#######################################4#######################################8
#                                                                              #
#                          Resource group definitions                          #
#                                                                              #
#######################################4#######################################8

output "created_resource_group_id"               {
                                                   description = "Created resource group ID"
                                                   value       = module.sap_library.created_resource_group_id
                                                 }

output "created_resource_group_name"             {
                                                   description = "Created resource group name"
                                                   value       = module.sap_library.created_resource_group_name
                                                 }

output "created_resource_group_subscription_id"  {
                                                   description = "Created resource group' subscription ID"
                                                   value       = module.sap_library.created_resource_group_subscription_id
                                                 }

output "random_id"                               {
                                                   description = "Random ID for library"
                                                   value       = substr(coalesce(var.custom_random_id, module.sap_library.random_id), 0, 3)
                                                 }

###############################################################################
#                                                                             #
#                             Storage accounts                                #
#                                                                             #
###############################################################################

output "sapbits_storage_account_name"           {
                                                   description = "Storage account name for SAP Binaries"
                                                   value       = module.sap_library.sapbits_storage_account_name
                                                 }

output "sapbits_sa_resource_group_name"          {
                                                   description = "Resource group name for SAP Binaries"
                                                   value       = module.sap_library.sapbits_sa_resource_group_name
                                                 }

output "saplibrary_subscription_id"              {
                                                   description = "Subscription Id for SAP installation media"
                                                   sensitive   = true
                                                   value       = data.azurerm_client_config.current.subscription_id
                                                 }

output "tfstate_resource_id"                     {
                                                   description = "Azure Resource identifier for Terraform remote state"
                                                   value       = module.sap_library.tfstate_resource_id
                                                 }

output "remote_state_storage_account_name"       {
                                                   description = "Storage account name for Terraform remote state"
                                                   value       = module.sap_library.remote_state_storage_account_name
                                                 }

output "saplibrary_environment"                  {
                                                   description = "Name of enfironment"
                                                   value       = local.infrastructure.environment
                                                 }

output "automation_version"                      {
                                                   description = "Version of automation"
                                                   value = local.version_label
                                                 }

output "sa_connection_string"                    {
                                                   description = "Connection string to storage account"
                                                   sensitive   = true
                                                   value       = module.sap_library.sa_connection_string
                                                 }

#######################################4#######################################8
#                                                                              #
#                            Capability contract                               #
#                                                                              #
#######################################4#######################################8


output "capabilities"                            {
                                                   description = "Versioned contract of the SAP library for later deployment stages and add-ons. The attributes repeat the individual outputs above in a stable, grouped form; secrets are never included. contract_version changes only when an attribute is removed or changes meaning"
                                                   value       = {
                                                                   contract_version   = "1.0"
                                                                   stage              = "library"
                                                                   automation_version = local.version_label
                                                                   naming             = {
                                                                                          environment = local.infrastructure.environment
                                                                                          random_id   = substr(coalesce(var.custom_random_id, module.sap_library.random_id), 0, 3)
                                                                                        }
                                                                   resource_group     = {
                                                                                          id              = module.sap_library.created_resource_group_id
                                                                                          name            = module.sap_library.created_resource_group_name
                                                                                          subscription_id = module.sap_library.created_resource_group_subscription_id
                                                                                        }
                                                                   storage            = {
                                                                                          tfstate_account_id          = module.sap_library.tfstate_resource_id
                                                                                          tfstate_account_name        = module.sap_library.remote_state_storage_account_name
                                                                                          sapbits_account_name        = module.sap_library.sapbits_storage_account_name
                                                                                          sapbits_resource_group_name = module.sap_library.sapbits_sa_resource_group_name
                                                                                        }
                                                                 }
                                                 }
