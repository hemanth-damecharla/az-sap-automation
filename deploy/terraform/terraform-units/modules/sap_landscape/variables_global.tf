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
#  infrastructure.resource_group and infrastructure.iscsi are null when the    #
#  caller leaves them out; the module then names its own resource group and    #
#  deploys no iSCSI devices.                                                   #
#                                                                              #
#######################################4#######################################8

variable "infrastructure"              {
                                         description = "Details of the Azure infrastructure to deploy the SAP landscape into"
                                         type        = object({
                                                         environment                    = string
                                                         region                         = string
                                                         codename                       = optional(string, "")
                                                         workload_zone_name             = optional(string, "")
                                                         control_plane_name             = optional(string, "")
                                                         tags                           = optional(map(string), {})
                                                         additional_network_id          = optional(string, "")
                                                         additional_subnet_id           = optional(string, "")
                                                         deploy_defender_extension      = optional(bool, false)
                                                         deploy_monitoring_extension    = optional(bool, false)
                                                         encryption_at_host_enabled     = optional(bool, false)
                                                         patch_assessment_mode          = optional(string, "ImageDefault")
                                                         patch_mode                     = optional(string, "ImageDefault")
                                                         platform_updates               = optional(string, "")
                                                         shared_access_key_enabled      = optional(bool, false)
                                                         shared_access_key_enabled_nfs  = optional(bool, false)
                                                         user_assigned_identity_id      = optional(string, "")
                                                         application_configuration_id   = optional(string, "")
                                                         use_application_configuration  = optional(bool, false)
                                                         terraform_storage_account_name = optional(string, "")
                                                         terraform_storage_account_id   = string
                                                         resource_group                 = optional(object({
                                                                                            name = optional(string, "")
                                                                                            id   = optional(string, "")
                                                                                          }))
                                                         ams_instance                   = optional(object({
                                                                                            name                = optional(string, "")
                                                                                            create_ams_instance = optional(bool, false)
                                                                                            ams_laws_id         = optional(string, "")
                                                                                          }), {})
                                                         nat_gateway                    = optional(object({
                                                                                            create_nat_gateway      = optional(bool, false)
                                                                                            name                    = optional(string, "")
                                                                                            id                      = optional(string, "")
                                                                                            region                  = optional(string, "")
                                                                                            public_ip_zones         = optional(list(string), [])
                                                                                            public_ip_id            = optional(string, "")
                                                                                            idle_timeout_in_minutes = optional(number, 4)
                                                                                            ip_tags                 = optional(map(string))
                                                                                          }), {})
                                                         iscsi                          = optional(object({
                                                                                            iscsi_count               = optional(number, 0)
                                                                                            use_DHCP                  = optional(bool, true)
                                                                                            iscsi_nic_ips             = optional(list(string), [])
                                                                                            size                      = optional(string, "Standard_D2s_v3")
                                                                                            os                        = optional(object({
                                                                                                                          source_image_id = optional(string, "")
                                                                                                                          publisher       = optional(string, "")
                                                                                                                          offer           = optional(string, "")
                                                                                                                          sku             = optional(string, "")
                                                                                                                          version         = optional(string, "")
                                                                                                                        }), {
                                                                                                                          publisher = "SUSE"
                                                                                                                          offer     = "sles-sap-15-sp5"
                                                                                                                          sku       = "gen2"
                                                                                                                          version   = "latest"
                                                                                                                        })
                                                                                            authentication            = optional(object({
                                                                                                                          type     = optional(string, "key")
                                                                                                                          username = optional(string, "azureadm")
                                                                                                                          password = optional(string)
                                                                                                                        }), {})
                                                                                            zones                     = optional(list(string), [])
                                                                                            user_assigned_identity_id = optional(string, "")
                                                                                          }))
                                                         virtual_networks               = object({
                                                                                            sap = object({
                                                                                                    name                     = optional(string, "")
                                                                                                    logical_name             = optional(string, "")
                                                                                                    flow_timeout_in_minutes  = optional(number)
                                                                                                    enable_route_propagation = optional(bool, true)
                                                                                                    id                       = optional(string, "")
                                                                                                    exists                   = optional(bool, false)
                                                                                                    address_space            = optional(list(string), [""])
                                                                                        subnet_admin    = optional(object({
                                                                                                           name    = optional(string, "")
                                                                                                           id      = optional(string, "")
                                                                                                           prefix  = optional(string, "")
                                                                                                           defined = optional(bool, false)
                                                                                                           exists  = optional(bool, false)
                                                                                                           nsg     = optional(object({
                                                                                                                       name   = optional(string, "")
                                                                                                                       id     = optional(string, "")
                                                                                                                       exists = optional(bool, false)
                                                                                                                     }), {})
                                                                                                         }), {})
                                                                                        subnet_db       = optional(object({
                                                                                                           name    = optional(string, "")
                                                                                                           id      = optional(string, "")
                                                                                                           prefix  = optional(string, "")
                                                                                                           defined = optional(bool, false)
                                                                                                           exists  = optional(bool, false)
                                                                                                           nsg     = optional(object({
                                                                                                                       name   = optional(string, "")
                                                                                                                       id     = optional(string, "")
                                                                                                                       exists = optional(bool, false)
                                                                                                                     }), {})
                                                                                                         }), {})
                                                                                        subnet_app      = optional(object({
                                                                                                           name    = optional(string, "")
                                                                                                           id      = optional(string, "")
                                                                                                           prefix  = optional(string, "")
                                                                                                           defined = optional(bool, false)
                                                                                                           exists  = optional(bool, false)
                                                                                                           nsg     = optional(object({
                                                                                                                       name   = optional(string, "")
                                                                                                                       id     = optional(string, "")
                                                                                                                       exists = optional(bool, false)
                                                                                                                     }), {})
                                                                                                         }), {})
                                                                                        subnet_endpoint = optional(object({
                                                                                                           name    = optional(string, "")
                                                                                                           id      = optional(string, "")
                                                                                                           prefix  = optional(string, "")
                                                                                                           defined = optional(bool, false)
                                                                                                           exists  = optional(bool, false)
                                                                                                           nsg     = optional(object({
                                                                                                                       name   = optional(string, "")
                                                                                                                       id     = optional(string, "")
                                                                                                                       exists = optional(bool, false)
                                                                                                                     }), {})
                                                                                                         }), {})
                                                                                        subnet_web      = optional(object({
                                                                                                           name    = optional(string, "")
                                                                                                           id      = optional(string, "")
                                                                                                           prefix  = optional(string, "")
                                                                                                           defined = optional(bool, false)
                                                                                                           exists  = optional(bool, false)
                                                                                                           nsg     = optional(object({
                                                                                                                       name   = optional(string, "")
                                                                                                                       id     = optional(string, "")
                                                                                                                       exists = optional(bool, false)
                                                                                                                     }), {})
                                                                                                         }), {})
                                                                                        subnet_storage  = optional(object({
                                                                                                           name    = optional(string, "")
                                                                                                           id      = optional(string, "")
                                                                                                           prefix  = optional(string, "")
                                                                                                           defined = optional(bool, false)
                                                                                                           exists  = optional(bool, false)
                                                                                                           nsg     = optional(object({
                                                                                                                       name   = optional(string, "")
                                                                                                                       id     = optional(string, "")
                                                                                                                       exists = optional(bool, false)
                                                                                                                     }), {})
                                                                                                         }), {})
                                                                                        subnet_anf      = optional(object({
                                                                                                           name    = optional(string, "")
                                                                                                           id      = optional(string, "")
                                                                                                           prefix  = optional(string, "")
                                                                                                           defined = optional(bool, false)
                                                                                                           exists  = optional(bool, false)
                                                                                                           nsg     = optional(object({
                                                                                                                       name   = optional(string, "")
                                                                                                                       id     = optional(string, "")
                                                                                                                       exists = optional(bool, false)
                                                                                                                     }), {})
                                                                                                         }), {})
                                                                                        subnet_iscsi    = optional(object({
                                                                                                           name    = optional(string, "")
                                                                                                           id      = optional(string, "")
                                                                                                           prefix  = optional(string, "")
                                                                                                           defined = optional(bool, false)
                                                                                                           exists  = optional(bool, false)
                                                                                                           nsg     = optional(object({
                                                                                                                       name   = optional(string, "")
                                                                                                                       id     = optional(string, "")
                                                                                                                       exists = optional(bool, false)
                                                                                                                     }), {})
                                                                                                         }), {})
                                                                                        subnet_ams      = optional(object({
                                                                                                           name    = optional(string, "")
                                                                                                           id      = optional(string, "")
                                                                                                           prefix  = optional(string, "")
                                                                                                           defined = optional(bool, false)
                                                                                                           exists  = optional(bool, false)
                                                                                                           nsg     = optional(object({
                                                                                                                       name   = optional(string, "")
                                                                                                                       id     = optional(string, "")
                                                                                                                       exists = optional(bool, false)
                                                                                                                     }), {})
                                                                                                         }), {})
                                                                                                  })
                                                                                          })
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
                                                        length(trimspace(var.infrastructure.virtual_networks.sap.logical_name)) != 0
                                                      )
                                                      error_message = "Please specify the logical VNet identifier in the infrastructure.virtual_networks.sap.name field. For deployments prior to version '2.3.3.1' please use the identifier 'sap'."
                                                    }

                                         validation {
                                                      condition = (
                                                        length(trimspace(var.infrastructure.virtual_networks.sap.id)) != 0 || length(try(var.infrastructure.virtual_networks.sap.address_space[0], "")) != 0
                                                      )
                                                      error_message = "Either the arm_id or (name and address_space) of the Virtual Network must be specified in the infrastructure.virtual_networks.sap block."
                                                    }

                                         validation {
                                                      condition     = length(split("/", var.infrastructure.terraform_storage_account_id)) == 9
                                                      error_message = "infrastructure.terraform_storage_account_id is required and needs to be the Azure resource ID of the storage account that holds the Terraform state and tfvars."
                                                    }

                                         validation {
                                                      condition     = var.infrastructure.virtual_networks.sap.flow_timeout_in_minutes == null ? true : (var.infrastructure.virtual_networks.sap.flow_timeout_in_minutes >= 4 && var.infrastructure.virtual_networks.sap.flow_timeout_in_minutes <= 30)
                                                      error_message = "The flow timeout in minutes must be between 4 and 30 if set."
                                                    }

                                         validation {
                                                      condition     = length(var.infrastructure.virtual_networks.sap.id) == 0 || length(split("/", var.infrastructure.virtual_networks.sap.id)) == 9
                                                      error_message = "If specified, infrastructure.virtual_networks.sap.id needs to be a correctly formed Azure resource ID."
                                                    }

                                         validation {
                                                      condition = alltrue([
                                                        for subnet in [
                                                          var.infrastructure.virtual_networks.sap.subnet_admin,
                                                          var.infrastructure.virtual_networks.sap.subnet_db,
                                                          var.infrastructure.virtual_networks.sap.subnet_app,
                                                          var.infrastructure.virtual_networks.sap.subnet_endpoint,
                                                          var.infrastructure.virtual_networks.sap.subnet_web,
                                                          var.infrastructure.virtual_networks.sap.subnet_storage,
                                                          var.infrastructure.virtual_networks.sap.subnet_anf,
                                                          var.infrastructure.virtual_networks.sap.subnet_iscsi,
                                                          var.infrastructure.virtual_networks.sap.subnet_ams
                                                        ] : length(subnet.id) == 0 || length(split("/", subnet.id)) == 11
                                                      ])
                                                      error_message = "If specified, each subnet id under infrastructure.virtual_networks.sap needs to be a correctly formed Azure subnet ID."
                                                    }
                                       }

variable "options"                     {
                                         description = "Configuration options"
                                         type        = object({
                                                         enable_secure_transfer = optional(bool, true)
                                                         use_spn                = bool
                                                         assign_permissions     = bool
                                                         spn_id                 = optional(string, "")
                                                       })
                                       }

variable "authentication"              {
                                         description = "Credentials of the virtual machine administrator. A missing password or key path makes the module generate one"
                                         type        = object({
                                                         username            = optional(string, "azureadm")
                                                         password            = optional(string)
                                                         path_to_public_key  = optional(string, "")
                                                         path_to_private_key = optional(string, "")
                                                       })
                                         default     = {}

                                         validation {
                                                      condition = (
                                                        length(trimspace(var.authentication.username)) != 0
                                                      )
                                                      error_message = "The default username for the Virtual machines must be specified."
                                                    }
                                       }

variable "key_vault"                   {
                                         description = "Key vault settings. Provide user.id to use an existing vault for the workload zone credentials; spn.id is the vault holding the deployment credentials"
                                         type        = object({
                                                         user                       = optional(object({
                                                                                        id     = optional(string, "")
                                                                                        exists = optional(bool, false)
                                                                                      }), {})
                                                         spn                        = optional(object({
                                                                                        id     = optional(string, "")
                                                                                        exists = optional(bool, false)
                                                                                      }), {})
                                                         exists                     = optional(bool, false)
                                                         private_key_secret_name    = optional(string, "")
                                                         public_key_secret_name     = optional(string, "")
                                                         username_secret_name       = optional(string, "")
                                                         password_secret_name       = optional(string, "")
                                                         kv_iscsi_sshkey_pub        = optional(string, "")
                                                         kv_iscsi_sshkey_prvt       = optional(string, "")
                                                         kv_iscsi_pwd               = optional(string, "")
                                                         kv_iscsi_username          = optional(string, "")
                                                         enable_rbac_authorization  = optional(bool, true)
                                                         set_secret_expiry          = optional(bool, false)
                                                         enable_purge_control       = optional(bool, false)
                                                         soft_delete_retention_days = optional(number, 7)
                                                       })
                                         default     = {}

                                         validation {
                                                      condition = alltrue([
                                                        for id in [var.key_vault.user.id, var.key_vault.spn.id] : length(id) == 0 || length(split("/", id)) == 9
                                                      ])
                                                      error_message = "If specified, key_vault.user.id and key_vault.spn.id need to be correctly formed Azure resource IDs."
                                                    }

                                         validation {
                                                      condition     = var.key_vault.user.exists == (length(var.key_vault.user.id) > 0)
                                                      error_message = "key_vault.user.exists must be true exactly when key_vault.user.id is provided."
                                                    }

                                         validation {
                                                      condition     = var.key_vault.soft_delete_retention_days >= 7 && var.key_vault.soft_delete_retention_days <= 90
                                                      error_message = "key_vault.soft_delete_retention_days must be between 7 and 90, the range Azure Key Vault accepts."
                                                    }
                                       }

variable "additional_users_to_add_to_keyvault_policies"         {
                                                                   description = "Additional users to add to the key vault policies"
                                                                   type        = list(string)
                                                                 }

variable "keyvault_private_endpoint_id"         {
                                                   description = "Existing private endpoint for key vault"
                                                   type        = string
                                                 }

variable "diagnostics_storage_account" {
                                         description = "Storage account information for diagnostics account. Provide id to use an existing account"
                                         type        = object({
                                                         id = optional(string, "")
                                                       })
                                         default     = {}

                                         validation {
                                                      condition     = length(var.diagnostics_storage_account.id) == 0 || length(split("/", var.diagnostics_storage_account.id)) == 9
                                                      error_message = "If specified, diagnostics_storage_account.id needs to be a correctly formed Azure resource ID."
                                                    }
                                       }

variable "witness_storage_account" {
                                         description = "Storage account information for witness storage account. Provide id to use an existing account"
                                         type        = object({
                                                         id = optional(string, "")
                                                       })
                                         default     = {}

                                         validation {
                                                      condition     = length(var.witness_storage_account.id) == 0 || length(split("/", var.witness_storage_account.id)) == 9
                                                      error_message = "If specified, witness_storage_account.id needs to be a correctly formed Azure resource ID."
                                                    }
                                       }

variable "create_transport_storage"         {
                                               description = "Boolean file indicating if storage should be created for SAP transport"
                                               type        = bool
                                             }

variable "transport_volume_size"         {
                                            description = "The volume size in GB for transport volume"
                                            type        = number
                                          }

variable "install_volume_size"         {
                                          description = "The volume size in GB for install volume"
                                          type        = number
                                        }

variable "transport_storage_account_id"         {
                                                   description = "Azure Resource Identifier for an existing storage account"
                                                   type        = string

                                                   validation {
                                                                condition     = length(var.transport_storage_account_id) == 0 || length(split("/", var.transport_storage_account_id)) == 9
                                                                error_message = "If specified, transport_storage_account_id needs to be a correctly formed Azure resource ID."
                                                              }
                                                 }

variable "transport_private_endpoint_id"         {
                                                    description = "Azure Resource Identifier for an private endpoint connection"
                                                    type        = string
                                                  }

variable "install_storage_account_id"         {
                                                 description = "Azure Resource Identifier for an existing storage account"
                                                 type        = string

                                                 validation {
                                                              condition     = length(var.install_storage_account_id) == 0 || length(split("/", var.install_storage_account_id)) == 9
                                                              error_message = "If specified, install_storage_account_id needs to be a correctly formed Azure resource ID."
                                                            }
                                               }

variable "install_private_endpoint_id"         {
                                                  description = "Azure Resource Identifier for an private endpoint connection"
                                                  type        = string
                                                }

variable "install_always_create_fileshares"         {
                                                       description = "Value indicating if file shares are created ehen using existing storage accounts"
                                                       type        = bool
                                                     }

variable "install_create_smb_shares"         {
                                                description = "Value indicating if SMB shares should be created"
                                                type        = bool
                                                default     = true
                                              }

variable "storage_account_replication_type"         {
                                                       description = "Storage account replication type"
                                                       type        = string
                                                       default     = "ZRS"

                                                       validation {
                                                                    condition     = contains(["LRS", "ZRS", "GRS", "RAGRS", "GZRS", "RAGZRS"], var.storage_account_replication_type)
                                                                    error_message = "storage_account_replication_type must be one of LRS, ZRS, GRS, RAGRS, GZRS or RAGZRS."
                                                                  }
                                                     }

variable "deployment"                  {
                                          description = "The type of deployment"
                                          type        = string
                                          default     = "update"
                                        }

variable "terraform_template_version"         {
                                                 description = "The version of Terraform templates that were identified in the state file"
                                                 type        = string
                                               }

variable "deployer_tfstate"            {
                                          description = "Outputs of the deployer Terraform state. Untyped until the deployer publishes a versioned capability contract; only the attributes this module reads are used"
                                          type        = any
                                        }

variable "naming"                      {
                                          description = "Defines the names for the resources: the 'naming' output of the sap_namegenerator module, or a custom names file with the same structure. Only the groups this module reads are declared; Terraform discards the rest. The groups are maps and lists, so a custom names file may leave out entries the deployment does not use."
                                          type        = object({
                                                          separator            = string
                                                          prefix               = optional(map(string), {})
                                                          resource_prefixes    = optional(map(string), {})
                                                          resource_suffixes    = optional(map(string), {})
                                                          keyvault_names       = optional(map(map(string)), {})
                                                          virtualmachine_names = optional(map(list(string)), {})
                                                          storageaccount_names = optional(object({
                                                                                   WORKLOAD_ZONE = optional(object({
                                                                                     landscape_storageaccount_name                   = optional(string)
                                                                                     witness_storageaccount_name                     = optional(string)
                                                                                     landscape_shared_transport_storage_account_name = optional(string)
                                                                                     landscape_shared_install_storage_account_name   = optional(string)
                                                                                     landscape_utility_storage_account_names         = optional(list(string), [])
                                                                                   }))
                                                                                 }), {})
                                                        })
                                        }

variable "use_deployer"                {
                                          description = "Use the deployer"
                                          type        = bool
                                        }

variable "ANF_settings"                {
                                         description = "Azure NetApp Files settings. Provide id to use an existing NetApp account"
                                         type        = object({
                                                         use                              = optional(bool, false)
                                                         name                             = optional(string, "")
                                                         id                               = optional(string, "")
                                                         pool_name                        = optional(string, "")
                                                         use_existing_pool                = optional(bool, false)
                                                         service_level                    = optional(string, "Standard")
                                                         size_in_tb                       = optional(number, 4)
                                                         qos_type                         = optional(string, "Manual")
                                                         use_existing_transport_volume    = optional(bool, false)
                                                         transport_volume_name            = optional(string, "")
                                                         transport_volume_size            = optional(number, 32)
                                                         transport_volume_throughput      = optional(number, 32)
                                                         transport_volume_zone            = optional(string, "")
                                                         export_policy_client_access_list = optional(list(string), [])
                                                         use_existing_install_volume      = optional(bool, false)
                                                         install_volume_name              = optional(string, "")
                                                         install_volume_size              = optional(number, 128)
                                                         install_volume_throughput        = optional(number, 32)
                                                         install_volume_zone              = optional(string, "")
                                                       })
                                         default     = {}

                                         validation {
                                                      condition     = length(var.ANF_settings.id) == 0 || length(split("/", var.ANF_settings.id)) == 9
                                                      error_message = "If specified, ANF_settings.id needs to be a correctly formed Azure resource ID."
                                                    }

                                         validation {
                                                      condition     = contains(["Auto", "Manual"], var.ANF_settings.qos_type)
                                                      error_message = "ANF_settings.qos_type must be Auto or Manual."
                                                    }
                                       }

variable "place_delete_lock_on_resources"         {
                                                     description = "If true, a delete lock will be placed on the key resources"
                                                     type        = bool
                                                   }

variable "additional_network_id"         {
                                            description = "Agent Network resource ID"
                                            type        = string
                                            default     = ""

                                            validation {
                                                         condition     = length(var.additional_network_id) == 0 || length(split("/", var.additional_network_id)) == 9
                                                         error_message = "If specified, additional_network_id needs to be a correctly formed Azure resource ID."
                                                       }
                                          }

variable "dns_settings"                {
                                         description = "DNS details for the deployment"
                                         type        = object({
                                                         use_custom_dns_a_registration                = optional(bool, false)
                                                         dns_label                                    = optional(string, "")
                                                         dns_zone_names                               = optional(map(string), {})
                                                         dns_server_list                              = optional(list(string), [])
                                                         management_dns_resourcegroup_name            = optional(string, "")
                                                         management_dns_subscription_id               = optional(string, "")
                                                         privatelink_dns_resourcegroup_name           = optional(string, "")
                                                         privatelink_dns_subscription_id              = optional(string, "")
                                                         privatelink_file_id                          = optional(string, "")
                                                         privatelink_keyvault_id                      = optional(string, "")
                                                         privatelink_storage_id                       = optional(string, "")
                                                         register_storage_accounts_keyvaults_with_dns = optional(bool, false)
                                                         register_endpoints_with_dns                  = optional(bool, false)
                                                         register_virtual_network_to_dns              = optional(bool, false)
                                                       })
                                       }

variable "use_private_endpoint"                          {
                                                           description = "Boolean value indicating if private endpoint should be used for the deployment"
                                                           default     = false
                                                           type        = bool
                                                         }

variable "private_endpoint_network_policies"             {
                                                           description = "Controls network policy support for private endpoints on workload zone subnets"
                                                           default     = "Enabled"
                                                           type        = string
                                                           validation {
                                                             condition     = contains(["Disabled", "Enabled", "NetworkSecurityGroupEnabled", "RouteTableEnabled"], var.private_endpoint_network_policies)
                                                             error_message = "The private_endpoint_network_policies value must be Disabled, Enabled, NetworkSecurityGroupEnabled, or RouteTableEnabled."
                                                           }
                                                         }

variable "use_service_endpoint"                          {
                                                           description = "Boolean value indicating if service endpoints should be used for the deployment"
                                                           default     = false
                                                           type        = bool
                                                         }

variable "NFS_provider"                {
                                          description = "Describes the NFS solution used"
                                          type        = string
                                        }

variable "Agent_IP"                                      {
                                                           description = "If provided, contains the IP address of the agent"
                                                           type        = string
                                                           default     = ""
                                                         }

variable "vm_settings"                 {
                                         description = "Details of the utility virtual machines to deploy"
                                         type        = object({
                                                         count              = optional(number, 0)
                                                         size               = optional(string, "")
                                                         use_DHCP           = optional(bool, true)
                                                         image              = optional(object({
                                                                                os_type         = optional(string, "WINDOWS")
                                                                                source_image_id = optional(string, "")
                                                                                publisher       = optional(string, "")
                                                                                offer           = optional(string, "")
                                                                                sku             = optional(string, "")
                                                                                version         = optional(string, "")
                                                                              }), {})
                                                         private_ip_address = optional(list(string), [])
                                                         disk_size          = optional(number, 128)
                                                         disk_type          = optional(string, "Premium_LRS")
                                                         zones              = optional(list(string), [])
                                                       })
                                         default     = {}
                                       }

variable "utility_storage_settings"                      {
                                                           description = "List of utility storage account configurations normalized from transform.tf."
                                                           type = list(object({
                                                             name                       = string
                                                             account_kind               = string
                                                             account_tier               = string
                                                             account_replication_type    = string
                                                             https_traffic_only_enabled = bool
                                                             file_shares = list(object({
                                                               name     = string
                                                               quota    = number
                                                               protocol = string
                                                             }))
                                                             blob_containers = list(object({
                                                               name = string
                                                               immutability_policy = optional(object({
                                                                 immutability_period_in_days = optional(number, 30)
                                                                 locked                      = optional(bool, false)
                                                                 allow_irreversible_lock     = optional(bool, false)
                                                                 protected_append_writes     = optional(string, "none")
                                                               }), null)
                                                             }))
                                                             versioning_enabled = optional(bool, false)
                                                             version_level_immutability = optional(object({
                                                               immutability_period_in_days   = optional(number, 30)
                                                               state                         = optional(string, "Unlocked")
                                                               allow_protected_append_writes = optional(bool, false)
                                                               allow_irreversible_lock       = optional(bool, false)
                                                             }), null)
                                                           }))
                                                           default = []
                                                           validation {
                                                             condition = alltrue(flatten([
                                                               for account in var.utility_storage_settings : [
                                                                 for container in account.blob_containers :
                                                                 container.immutability_policy == null ? true : (
                                                                   container.immutability_policy.immutability_period_in_days >= 1 &&
                                                                   container.immutability_policy.immutability_period_in_days <= 146000
                                                                 )
                                                               ]
                                                             ]))
                                                             error_message = "Each configured utility blob container immutability period must be between 1 and 146000 days."
                                                           }
                                                           validation {
                                                             condition = alltrue(flatten([
                                                               for account in var.utility_storage_settings : [
                                                                 for container in account.blob_containers :
                                                                 container.immutability_policy == null ? true : contains(
                                                                   ["none", "append_blobs", "all"],
                                                                   container.immutability_policy.protected_append_writes
                                                                 )
                                                               ]
                                                             ]))
                                                             error_message = "Each configured utility blob container protected append mode must be none, append_blobs, or all."
                                                           }
                                                           validation {
                                                             condition = alltrue(flatten([
                                                               for account in var.utility_storage_settings : [
                                                                 for container in account.blob_containers :
                                                                 container.immutability_policy == null ? true : (
                                                                   !container.immutability_policy.locked ||
                                                                   container.immutability_policy.allow_irreversible_lock
                                                                 )
                                                               ]
                                                             ]))
                                                             error_message = "A locked utility blob container immutability policy requires allow_irreversible_lock to be true. Locking is irreversible: Azure never permits deleting a locked time-based retention policy, so terraform destroy for the container, the storage account and the workload zone is blocked permanently, not just until retention expires. Teardown then requires an out-of-band procedure."
                                                           }
                                                           validation {
                                                             condition = alltrue(flatten([
                                                               for account in var.utility_storage_settings : [
                                                                 for container in account.blob_containers :
                                                                 container.immutability_policy == null ? true : (
                                                                   length(trimspace(account.name)) > 0 &&
                                                                   length(trimspace(container.name)) > 0
                                                                 )
                                                               ]
                                                             ]))
                                                             error_message = "Utility storage accounts and blob containers with an immutability policy must have explicit non-empty names."
                                                           }
                                                           validation {
                                                             condition = length(flatten([
                                                               for account in var.utility_storage_settings : [
                                                                 for container in account.blob_containers : "${account.name}/${container.name}"
                                                                 if container.immutability_policy != null
                                                               ]
                                                             ])) == length(distinct(flatten([
                                                               for account in var.utility_storage_settings : [
                                                                 for container in account.blob_containers : "${account.name}/${container.name}"
                                                                 if container.immutability_policy != null
                                                               ]
                                                             ])))
                                                             error_message = "Utility blob containers with immutability policies must have unique account and container name pairs."
                                                           }
                                                           validation {
                                                             condition = alltrue([
                                                               for account in var.utility_storage_settings :
                                                               account.version_level_immutability == null || account.versioning_enabled
                                                             ])
                                                             error_message = "A utility storage account with version_level_immutability must also set versioning_enabled to true. Azure requires blob versioning before version-level immutability can be enabled."
                                                           }
                                                           validation {
                                                             condition = alltrue([
                                                               for account in var.utility_storage_settings :
                                                               !account.versioning_enabled || contains(["StorageV2", "BlockBlobStorage"], account.account_kind)
                                                             ])
                                                             error_message = "Blob versioning and version-level immutability are only supported on StorageV2 or BlockBlobStorage utility storage accounts; they are not available on FileStorage accounts."
                                                           }
                                                           validation {
                                                             condition = alltrue([
                                                               for account in var.utility_storage_settings :
                                                               account.version_level_immutability == null ? true : (
                                                                 account.version_level_immutability.immutability_period_in_days >= 1 &&
                                                                 account.version_level_immutability.immutability_period_in_days <= 146000
                                                               )
                                                             ])
                                                             error_message = "Each configured utility storage account version-level immutability period must be between 1 and 146000 days."
                                                           }
                                                           validation {
                                                             condition = alltrue([
                                                               for account in var.utility_storage_settings :
                                                               account.version_level_immutability == null ? true : contains(
                                                                 ["Disabled", "Unlocked", "Locked"],
                                                                 account.version_level_immutability.state
                                                               )
                                                             ])
                                                             error_message = "Each configured utility storage account version-level immutability state must be Disabled, Unlocked, or Locked."
                                                           }
                                                           validation {
                                                             condition = alltrue([
                                                               for account in var.utility_storage_settings :
                                                               account.version_level_immutability == null ? true : (
                                                                 account.version_level_immutability.state != "Locked" ||
                                                                 account.version_level_immutability.allow_irreversible_lock
                                                               )
                                                             ])
                                                             error_message = "A Locked utility storage account version-level immutability policy requires allow_irreversible_lock to be true. Locking is irreversible: Azure never permits returning the account policy to Unlocked or Disabled, and the account cannot be deleted until every protected blob version is removed after its retention period."
                                                           }
                                                         }

variable "peer_with_control_plane_vnet"         {
                                                   description = "Defines in the SAP VNet will be peered with the controlplane VNet"
                                                   type        = bool
                                                 }

variable "enable_firewall_for_keyvaults_and_storage"         {
                                                                description = "Boolean value indicating if firewall should be enabled for key vaults and storage"
                                                                type        = bool
                                                              }

variable "public_network_access_enabled"         {
                                                    description = "Defines if the public access should be enabled for keyvaults and storage accounts"
                                                    type        = bool
                                                  }

variable "use_AFS_for_shared_storage"                    {
                                                           description = "If true, will use AFS for installation media."
                                                           type        = bool
                                                           default     = false
                                                         }

variable "AFS_enable_encryption_in_transit"              {
                                                           description = "Enable encryption in transit for Azure Files"
                                                           type        = bool
                                                           default     = false
                                                         }

variable "tags"                        {
                                          description = "List of tags to associate to all resources"
                                          type        = map(string)
                                        }

variable "data_plane_available"                          {
                                                           description = "Boolean value indicating if storage account access is via data plane"
                                                           default     = true
                                                           type        = bool
                                                         }
