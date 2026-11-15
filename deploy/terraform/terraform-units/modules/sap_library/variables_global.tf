# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#######################################4#######################################8
#                                                                              #
#                         Module interface contract                           #
#                                                                              #
#  Every input is typed. Attributes that a caller may leave out are declared   #
#  with optional() and the default the module applies. A reference inside the  #
#  module to an attribute that is not part of the contract is a static error,  #
#  and a value of the wrong type is rejected where the module is called.       #
#                                                                              #
#  Terraform discards attributes that are not declared in an object type, so   #
#  an attribute a caller adds has no effect until it is declared here.         #
#                                                                              #
#######################################4#######################################8

variable "infrastructure"              {
                                         description = "Details of the Azure infrastructure to deploy the SAP library into"
                                         type        = object({
                                                         environment        = string
                                                         region             = string
                                                         codename           = optional(string, "")
                                                         resource_group     = object({
                                                                                name   = optional(string, "")
                                                                                id     = optional(string, "")
                                                                                exists = optional(bool, false)
                                                                              })
                                                         tags               = optional(map(string), {})
                                                         assign_permissions = optional(bool, false)
                                                         spn_id             = optional(string, "")
                                                       })

                                         validation {
                                                      condition = (
                                                        length(trimspace(var.infrastructure.region)) != 0
                                                      )
                                                      error_message = "The region must be specified in the infrastructure.region field."
                                                    }

                                         validation {
                                                      condition = (
                                                        length(trimspace(var.infrastructure.environment)) != 0
                                                      )
                                                      error_message = "The environment must be specified in the infrastructure.environment field."
                                                    }

                                         validation {
                                                      condition = (
                                                        length(var.infrastructure.resource_group.id) == 0 || length(split("/", var.infrastructure.resource_group.id)) == 5
                                                      )
                                                      error_message = "If specified, infrastructure.resource_group.id needs to be a correctly formed Azure resource group ID."
                                                    }

                                         validation {
                                                      condition = (
                                                        var.infrastructure.resource_group.exists == (length(var.infrastructure.resource_group.id) > 0)
                                                      )
                                                      error_message = "infrastructure.resource_group.exists must be true exactly when infrastructure.resource_group.id is provided."
                                                    }
                                       }

variable "storage_account_sapbits"     {
                                         description = "Details of the storage account for SAP installation media and the Bill of Materials files"
                                         type        = object({
                                                         id                                        = optional(string, "")
                                                         exists                                    = optional(bool, false)
                                                         name                                      = optional(string, "")
                                                         account_tier                              = optional(string, "Standard")
                                                         account_replication_type                  = optional(string, "LRS")
                                                         account_kind                              = optional(string, "StorageV2")
                                                         file_share                                = optional(object({
                                                                                                       enable_deployment = optional(bool, true)
                                                                                                       is_existing       = optional(bool, false)
                                                                                                       name              = optional(string, "sapbits")
                                                                                                     }), {})
                                                         sapbits_blob_container                    = optional(object({
                                                                                                       enable_deployment = optional(bool, true)
                                                                                                       is_existing       = optional(bool, false)
                                                                                                       name              = optional(string, "sapbits")
                                                                                                     }), {})
                                                         shared_access_key_enabled                 = optional(bool, false)
                                                         routing_preference_enabled                = optional(bool, true)
                                                         public_network_access_enabled             = optional(bool, false)
                                                         enable_firewall_for_keyvaults_and_storage = optional(bool, false)
                                                       })

                                         validation {
                                                      condition = (
                                                        length(var.storage_account_sapbits.id) == 0 || length(split("/", var.storage_account_sapbits.id)) == 9
                                                      )
                                                      error_message = "If specified, storage_account_sapbits.id needs to be a correctly formed Azure resource ID."
                                                    }

                                         validation {
                                                      condition = (
                                                        var.storage_account_sapbits.exists == (length(var.storage_account_sapbits.id) > 0)
                                                      )
                                                      error_message = "storage_account_sapbits.exists must be true exactly when storage_account_sapbits.id is provided."
                                                    }

                                         validation {
                                                      condition = (
                                                        contains(["Standard", "Premium"], var.storage_account_sapbits.account_tier)
                                                      )
                                                      error_message = "storage_account_sapbits.account_tier must be Standard or Premium."
                                                    }

                                         validation {
                                                      condition = (
                                                        contains(["LRS", "ZRS", "GRS", "RAGRS", "GZRS", "RAGZRS"], var.storage_account_sapbits.account_replication_type)
                                                      )
                                                      error_message = "storage_account_sapbits.account_replication_type must be one of LRS, ZRS, GRS, RAGRS, GZRS or RAGZRS."
                                                    }
                                       }

variable "storage_account_tfstate"     {
                                         description = "Details of the storage account for Terraform"
                                         type        = object({
                                                         id                                        = optional(string, "")
                                                         exists                                    = optional(bool, false)
                                                         name                                      = optional(string, "")
                                                         account_tier                              = optional(string, "Standard")
                                                         account_replication_type                  = optional(string, "LRS")
                                                         account_kind                              = optional(string, "StorageV2")
                                                         tfstate_blob_container                    = optional(object({
                                                                                                       is_existing = optional(bool, false)
                                                                                                       name        = optional(string, "tfstate")
                                                                                                     }), {})
                                                         tfvars_blob_container                     = optional(object({
                                                                                                       is_existing = optional(bool, false)
                                                                                                       name        = optional(string, "tfvars")
                                                                                                     }), {})
                                                         ansible_blob_container                    = optional(object({
                                                                                                       is_existing = optional(bool, false)
                                                                                                       name        = optional(string, "ansible")
                                                                                                     }), {})
                                                         shared_access_key_enabled                 = optional(bool, false)
                                                         routing_preference_enabled                = optional(bool, true)
                                                         public_network_access_enabled             = optional(bool, false)
                                                         enable_firewall_for_keyvaults_and_storage = optional(bool, false)
                                                       })

                                         validation {
                                                      condition = (
                                                        length(var.storage_account_tfstate.id) == 0 || length(split("/", var.storage_account_tfstate.id)) == 9
                                                      )
                                                      error_message = "If specified, storage_account_tfstate.id needs to be a correctly formed Azure resource ID."
                                                    }

                                         validation {
                                                      condition = (
                                                        var.storage_account_tfstate.exists == (length(var.storage_account_tfstate.id) > 0)
                                                      )
                                                      error_message = "storage_account_tfstate.exists must be true exactly when storage_account_tfstate.id is provided."
                                                    }

                                         validation {
                                                      condition = (
                                                        contains(["Standard", "Premium"], var.storage_account_tfstate.account_tier)
                                                      )
                                                      error_message = "storage_account_tfstate.account_tier must be Standard or Premium."
                                                    }

                                         validation {
                                                      condition = (
                                                        contains(["LRS", "ZRS", "GRS", "RAGRS", "GZRS", "RAGZRS"], var.storage_account_tfstate.account_replication_type)
                                                      )
                                                      error_message = "storage_account_tfstate.account_replication_type must be one of LRS, ZRS, GRS, RAGRS, GZRS or RAGZRS."
                                                    }
                                       }

variable "dns_settings"                {
                                         description = "DNS details for the deployment"
                                         type        = object({
                                                         use_custom_dns_a_registration                = optional(bool, false)
                                                         dns_label                                    = optional(string, "")
                                                         dns_zone_names                               = optional(map(string), {})
                                                         management_dns_resourcegroup_name            = optional(string, "")
                                                         management_dns_subscription_id               = optional(string, "")
                                                         privatelink_dns_subscription_id              = optional(string, "")
                                                         privatelink_dns_resourcegroup_name           = optional(string, "")
                                                         register_storage_accounts_keyvaults_with_dns = bool
                                                         register_endpoints_with_dns                  = optional(bool, false)
                                                         create_privatelink_dns_zones                 = bool
                                                         additional_network_id                        = optional(string, "")
                                                       })

                                         validation {
                                                      condition = (
                                                        length(var.dns_settings.additional_network_id) == 0 || length(split("/", var.dns_settings.additional_network_id)) == 9
                                                      )
                                                      error_message = "If specified, dns_settings.additional_network_id needs to be a correctly formed Azure resource ID."
                                                    }
                                       }

variable "deployer"                    {
                                         description = "Details of deployer. management_network_id is required unless the deployer state provides the management network"
                                         type        = object({
                                                         use                          = bool
                                                         application_configuration_id = optional(string, "")
                                                         control_plane_name           = optional(string, "")
                                                         resource_group_name          = optional(string, "")
                                                         management_network_id        = optional(string, "")
                                                       })

                                         validation {
                                                      condition = (
                                                        length(var.deployer.management_network_id) == 0 || length(split("/", var.deployer.management_network_id)) == 9
                                                      )
                                                      error_message = "If specified, deployer.management_network_id needs to be a correctly formed Azure resource ID."
                                                    }
                                       }

variable "key_vault"                   {
                                         description = "The Azure Key Vault that holds the deployment credentials"
                                         type        = object({
                                                         id = optional(string, "")
                                                       })

                                         validation {
                                                      condition = (
                                                        length(var.key_vault.id) == 0 || length(split("/", var.key_vault.id)) == 9
                                                      )
                                                      error_message = "If specified, key_vault.id needs to be a correctly formed Azure resource ID."
                                                    }
                                       }

variable "naming"                     {
                                        description = "Naming convention data structure: the 'naming' output of the sap_namegenerator module, or a custom names file with the same structure"
                                        type        = any
                                      }

variable "deployer_tfstate"           {
                                        description = "Outputs of the deployer Terraform state. Untyped until the deployer publishes a versioned capability contract; only the attributes this module reads are used"
                                        type        = any
                                        default     = {}
                                      }

variable "use_private_endpoint"       {
                                        description = "Boolean value indicating if private endpoint should be used for the deployment"
                                        default     = false
                                        type        = bool
                                      }

variable "use_custom_dns_a_registration" {
                                           description = "Boolean value indicating if a custom dns a record should be created when using private endpoints"
                                           default     = false
                                           type        = bool
                                         }

variable "enable_purge_control_for_keyvaults" {
                                                description = "Allow the deployment to control the purge protection"
                                                type        = bool
                                                default     = true
                                              }

variable "application_configuration_deployment" {
                                                  description = "Boolean value indicating if the Azure App Configuration of the control plane is deployed and should receive the library settings"
                                                  type        = bool
                                                  default     = false
                                                }

variable "place_delete_lock_on_resources" {
                                            description = "If true, a delete lock will be placed on the key resources"
                                            type        = bool
                                            default     = false
                                          }

variable "Agent_IP"                       {
                                            description = "If provided, contains the IP address of the agent"
                                            type        = string
                                            default     = ""
                                          }

variable "bootstrap"                      {
                                            description = "True during the first, local-backend deployment of the library, before the remote state and the deployer network integration exist"
                                            type        = bool
                                          }

variable "short_named_endpoints_nics"     {
                                            description = "If true, uses short names for private endpoints nics"
                                            type        = bool
                                            default     = false
                                          }
