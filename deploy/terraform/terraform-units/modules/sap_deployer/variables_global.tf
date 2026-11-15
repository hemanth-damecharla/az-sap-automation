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

variable "assign_subscription_permissions"   {
                                               description = "Assign permissions on the subscription"
                                               type        = bool
                                             }

variable "authentication"                    {
                                               description = "Credentials of the deployer virtual machine administrator. An empty password or key path makes the module generate one"
                                               type        = object({
                                                               username            = optional(string, "azureadm")
                                                               password            = optional(string, "")
                                                               path_to_public_key  = optional(string, "")
                                                               path_to_private_key = optional(string, "")
                                                             })
                                             }

variable "bastion_deployment"                {
                                               description = "Value indicating if Azure Bastion should be deployed"
                                               type        = bool
                                             }

variable "bastion_sku"                       {
                                               description = "The SKU of the Bastion Host. Accepted values are Basic or Standard"
                                               type        = string
                                             }

variable "bootstrap"                         {
                                               description = "True during the first, local-backend deployment of the deployer, before the remote state exists"
                                               type        = bool
                                             }

variable "configure"                         {
                                               description = "Value indicating if deployer should be configured"
                                               type        = bool
                                             }

variable "infrastructure"                    {
                                               description = "Dictionary of information about the common infrastructure"
                                               type        = object({
                                                               environment                  = string
                                                               region                       = string
                                                               codename                     = optional(string, "")
                                                               resource_group               = object({
                                                                                                name   = optional(string, "")
                                                                                                id     = optional(string, "")
                                                                                                exists = optional(bool, false)
                                                                                              })
                                                               tags                         = optional(map(string), {})
                                                               virtual_network              = object({
                                                                                                logical_name = optional(string, "")
                                                                                                management   = object({
                                                                                                                 name                    = optional(string, "")
                                                                                                                 id                      = optional(string, "")
                                                                                                                 exists                  = optional(bool, false)
                                                                                                                 address_space           = optional(string, "")
                                                                                                                 flow_timeout_in_minutes = optional(number)
                                                                                                                 subnet_mgmt             = optional(object({
                                                                                                                                             name   = optional(string, "")
                                                                                                                                             id     = optional(string, "")
                                                                                                                                             exists = optional(bool, false)
                                                                                                                                             prefix = optional(string, "")
                                                                                                                                             nsg    = optional(object({
                                                                                                                                                        name        = optional(string, "")
                                                                                                                                                        id          = optional(string, "")
                                                                                                                                                        exists      = optional(bool, false)
                                                                                                                                                        allowed_ips = optional(list(string), [])
                                                                                                                                                      }), {})
                                                                                                                                           }), {})
                                                                                                                 subnet_firewall         = optional(object({
                                                                                                                                             id     = optional(string, "")
                                                                                                                                             exists = optional(bool, false)
                                                                                                                                             prefix = optional(string, "")
                                                                                                                                           }), {})
                                                                                                                 subnet_bastion          = optional(object({
                                                                                                                                             id     = optional(string, "")
                                                                                                                                             exists = optional(bool, false)
                                                                                                                                             prefix = optional(string, "")
                                                                                                                                           }), {})
                                                                                                                 subnet_webapp           = optional(object({
                                                                                                                                             id     = optional(string, "")
                                                                                                                                             exists = optional(bool, false)
                                                                                                                                             prefix = optional(string, "")
                                                                                                                                           }), {})
                                                                                                                 subnet_agent            = optional(object({
                                                                                                                                             name   = optional(string, "")
                                                                                                                                             id     = optional(string, "")
                                                                                                                                             exists = optional(bool, false)
                                                                                                                                             prefix = optional(string, "")
                                                                                                                                           }), {})
                                                                                                                 subnet_endpoint         = optional(object({
                                                                                                                                             name    = optional(string, "")
                                                                                                                                             id      = optional(string, "")
                                                                                                                                             exists  = optional(bool, false)
                                                                                                                                             prefix  = optional(string, "")
                                                                                                                                             defined = optional(bool, false)
                                                                                                                                             nsg     = optional(object({
                                                                                                                                                         name   = optional(string, "")
                                                                                                                                                         id     = optional(string, "")
                                                                                                                                                         exists = optional(bool, false)
                                                                                                                                                       }), {})
                                                                                                                                           }), {})
                                                                                                               })
                                                                                              })
                                                               deploy_monitoring_extension  = optional(bool, false)
                                                               deploy_defender_extension    = optional(bool, false)
                                                               custom_random_id             = optional(string, "")
                                                               bastion_public_ip_tags       = optional(map(string))
                                                               dev_center_deployment        = optional(bool, false)
                                                               devops                       = optional(object({
                                                                                                agent_ado_url                  = optional(string, "")
                                                                                                agent_ado_project              = optional(string, "")
                                                                                                agent_pat                      = optional(string, "")
                                                                                                agent_pool                     = optional(string, "")
                                                                                                ansible_core_version           = optional(string, "")
                                                                                                tf_version                     = optional(string, "")
                                                                                                DevOpsInfrastructure_object_id = optional(string, "")
                                                                                                app_token                      = optional(string, "")
                                                                                                github_pat                     = optional(string, "")
                                                                                                repository                     = optional(string, "")
                                                                                                server_url                     = optional(string, "")
                                                                                                api_url                        = optional(string, "")
                                                                                                platform                       = optional(string, "")
                                                                                                organization                   = optional(string, "")
                                                                                                branch                         = optional(string, "")
                                                                                              }), {})
                                                               tfstate_resource_id          = optional(string, "")
                                                               tfstate_storage_account_name = optional(string, "")
                                                             })

                                               validation {
                                                            condition     = length(trimspace(var.infrastructure.region)) != 0
                                                            error_message = "The region must be specified in the infrastructure.region field."
                                                          }

                                               validation {
                                                            condition     = length(trimspace(var.infrastructure.environment)) != 0
                                                            error_message = "The environment must be specified in the infrastructure.environment field."
                                                          }

                                               validation {
                                                            condition     = length(var.infrastructure.resource_group.id) == 0 || length(split("/", var.infrastructure.resource_group.id)) == 5
                                                            error_message = "If specified, infrastructure.resource_group.id needs to be a correctly formed Azure resource group ID."
                                                          }

                                               validation {
                                                            condition     = length(var.infrastructure.virtual_network.management.id) == 0 || length(split("/", var.infrastructure.virtual_network.management.id)) == 9
                                                            error_message = "If specified, infrastructure.virtual_network.management.id needs to be a correctly formed Azure resource ID."
                                                          }

                                               validation {
                                                            condition = (
                                                              length(var.infrastructure.virtual_network.management.subnet_mgmt.id) > 0 ||
                                                              length(var.infrastructure.virtual_network.management.subnet_mgmt.prefix) > 0
                                                            )
                                                            error_message = "The management subnet needs either an existing subnet id or an address prefix in infrastructure.virtual_network.management.subnet_mgmt."
                                                          }

                                               validation {
                                                            condition = alltrue([
                                                              for subnet in [
                                                                var.infrastructure.virtual_network.management.subnet_mgmt.id,
                                                                var.infrastructure.virtual_network.management.subnet_firewall.id,
                                                                var.infrastructure.virtual_network.management.subnet_bastion.id,
                                                                var.infrastructure.virtual_network.management.subnet_webapp.id,
                                                                var.infrastructure.virtual_network.management.subnet_agent.id,
                                                                var.infrastructure.virtual_network.management.subnet_endpoint.id
                                                              ] : length(subnet) == 0 || length(split("/", subnet)) == 11
                                                            ])
                                                            error_message = "If specified, each subnet id under infrastructure.virtual_network.management needs to be a correctly formed Azure subnet ID."
                                                          }
                                             }

variable "naming"                            {
                                               description = "Defines the names for the resources: the 'naming' output of the sap_namegenerator module, or a custom names file with the same structure"
                                               type        = any
                                             }

variable "naming_new"                        {
                                               description = "Defines the additional names for the resources: the 'naming_new' output of the sap_namegenerator module"
                                               type        = any
                                             }

variable "options"                           {
                                               description = "Dictionary of miscallaneous parameters"
                                               type        = object({
                                                               enable_deployer_public_ip       = optional(bool, false)
                                                               enable_secure_transfer          = optional(bool, true)
                                                               disk_encryption_set_id          = optional(string)
                                                               use_spn                         = bool
                                                               assign_resource_permissions     = bool
                                                               assign_subscription_permissions = bool
                                                               network_security_perimeter      = optional(object({
                                                                                                   name                         = optional(string, "")
                                                                                                   id                           = optional(string, "")
                                                                                                   exists                       = optional(bool, false)
                                                                                                   deploy                       = optional(bool, false)
                                                                                                   network_security_access_mode = optional(string, "Enforced")
                                                                                                 }), {})
                                                             })
                                             }

variable "place_delete_lock_on_resources"    {
                                               description = "If true, a delete lock will be placed on the key resources"
                                               type        = bool
                                             }

variable "ssh-timeout"                       {
                                               description = "SSH timeout"
                                               type        = string
                                             }

variable "network_logical_name"              {
                                               description = "Logical name of the network"
                                               type        = string
                                             }

variable "use_private_endpoint"              {
                                               description = "Boolean value indicating if private endpoint should be used for the deployment"
                                               type        = bool
                                             }

variable "use_service_endpoint"              {
                                               description = "Boolean value indicating if service endpoints should be used for the deployment"
                                               type        = bool
                                             }

variable "firewall"                          {
                                               description = "Dictionary of Firewall settings"
                                               type        = object({
                                                               deployment          = bool
                                                               rule_subnets        = optional(list(string), [])
                                                               allowed_ipaddresses = optional(list(string), [])
                                                               ip_tags             = optional(map(string))
                                                             })
                                             }

variable "additional_users_to_add_to_keyvault_policies" {
                                                          description = "List of object IDs to add to key vault policies"
                                                          type        = list(string)
                                                        }

variable "enable_purge_control_for_keyvaults" {
                                                description = "Disables the purge protection for Azure keyvaults."
                                                type        = bool
                                              }

variable "key_vault"                         {
                                               description = "The Azure Key Vault for the deployment credentials. Provide id to use an existing vault"
                                               type        = object({
                                                               id                        = optional(string, "")
                                                               exists                    = optional(bool, false)
                                                               private_key_secret_name   = optional(string, "")
                                                               public_key_secret_name    = optional(string, "")
                                                               username_secret_name      = optional(string, "")
                                                               password_secret_name      = optional(string, "")
                                                               enable_rbac_authorization = optional(bool, true)
                                                             })

                                               validation {
                                                            condition     = length(var.key_vault.id) == 0 || length(split("/", var.key_vault.id)) == 9
                                                            error_message = "If specified, key_vault.id needs to be a correctly formed Azure resource ID."
                                                          }

                                               validation {
                                                            condition     = var.key_vault.exists == (length(var.key_vault.id) > 0)
                                                            error_message = "key_vault.exists must be true exactly when key_vault.id is provided."
                                                          }
                                             }

variable "set_secret_expiry"                 {
                                               description = "Set expiry date for secrets"
                                               type        = bool
                                             }

variable "soft_delete_retention_days"        {
                                               description = "The number of days that items should be retained in the soft delete period"
                                               type        = number

                                               validation {
                                                            condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
                                                            error_message = "soft_delete_retention_days must be between 7 and 90, the range Azure Key Vault accepts."
                                                          }
                                             }

variable "sa_connection_string"              {
                                               description = "Storage account connection string"
                                               type        = string
                                             }

variable "webapp_client_secret"              {
                                               description = "App registration client secret"
                                               type        = string
                                             }

variable "enable_firewall_for_keyvaults_and_storage" {
                                                       description = "Boolean value indicating if firewall should be enabled for key vaults and storage"
                                                       default     = false
                                                       type        = bool
                                                     }

variable "public_network_access_enabled"     {
                                               description = "Defines if the public access should be enabled for keyvaults and storage accounts"
                                               type        = bool
                                             }

variable "subnets_to_add"                    {
                                               description = "List of subnets to add to storage account and keyvaults firewall"
                                               type        = list(string)
                                               default     = []
                                             }

variable "dns_settings"                      {
                                               description = "DNS details for the deployment"
                                               type        = object({
                                                               use_custom_dns_a_registration                = optional(bool, false)
                                                               register_storage_accounts_keyvaults_with_dns = optional(bool, false)
                                                               register_endpoints_with_dns                  = optional(bool, false)
                                                               dns_zone_names                               = optional(map(string), {})
                                                               local_dns_resourcegroup_name                 = optional(string, "")
                                                               management_dns_resourcegroup_name            = optional(string, "")
                                                               management_dns_subscription_id               = optional(string, "")
                                                               privatelink_dns_subscription_id              = optional(string, "")
                                                               privatelink_dns_resourcegroup_name           = optional(string, "")
                                                             })
                                               default     = {}
                                             }

variable "auto_configure_deployer"           {
                                               description = "Value indicating if the deployer should be configured automatically"
                                               type        = bool
                                             }

variable "deployer"                          {
                                               description = "Dictionary of information about the deployer"
                                               type        = object({
                                                               size                                = string
                                                               disk_type                           = string
                                                               use_DHCP                            = optional(bool, false)
                                                               authentication                      = optional(object({
                                                                                                       type     = optional(string, "key")
                                                                                                       password = optional(string)
                                                                                                     }), {})
                                                               add_system_assigned_identity        = optional(bool, false)
                                                               os                                  = object({
                                                                                                       os_type         = optional(string, "LINUX")
                                                                                                       type            = optional(string, "marketplace")
                                                                                                       source_image_id = optional(string, "")
                                                                                                       publisher       = optional(string, "")
                                                                                                       offer           = optional(string, "")
                                                                                                       sku             = optional(string, "")
                                                                                                       version         = optional(string, "")
                                                                                                     })
                                                               # Kept untyped: the module indexes this value per virtual machine, while
                                                               # the root modules currently pass a single string.
                                                               private_ip_address                  = optional(any, "")
                                                               deployer_diagnostics_account_arm_id = optional(string, "")
                                                               app_service_SKU                     = optional(string, "")
                                                               user_assigned_identity_id           = optional(string, "")
                                                               shared_access_key_enabled           = optional(bool, false)
                                                               devops_authentication_type          = optional(string, "")
                                                               encryption_at_host_enabled          = optional(bool, false)
                                                               deployer_public_ip_tags             = optional(map(string))
                                                               license_type                        = optional(string, "")
                                                               tags                                = optional(map(string), { "Role" = "Deployer" })
                                                             })

                                               validation {
                                                            condition     = contains(["key", "password"], var.deployer.authentication.type)
                                                            error_message = "deployer.authentication.type must be key or password."
                                                          }

                                               validation {
                                                            condition = (
                                                              length(var.deployer.os.source_image_id) > 0 ||
                                                              alltrue([for part in [var.deployer.os.publisher, var.deployer.os.offer, var.deployer.os.sku, var.deployer.os.version] : length(part) > 0])
                                                            )
                                                            error_message = "deployer.os needs either source_image_id or all of publisher, offer, sku and version."
                                                          }

                                               validation {
                                                            condition     = contains(["marketplace", "marketplace_with_plan", "custom"], var.deployer.os.type)
                                                            error_message = "deployer.os.type must be marketplace, marketplace_with_plan or custom."
                                                          }
                                             }

variable "deployer_vm_count"                 {
                                               description = "Number of deployer VMs to create"
                                               type        = number
                                               default     = 1
                                             }

variable "arm_client_id"                     {
                                               description = "ARM client id"
                                               type        = string
                                             }

variable "platform"                          {
                                               description = "Type of agent to be used"
                                               type        = string
                                               default     = "devops"
                                             }

variable "Agent_IP"                          {
                                               description = "If provided, contains the IP address of the agent"
                                               type        = string
                                             }

variable "spn_id"                            {
                                               description = "SPN ID to be used for the deployment"
                                               type        = string
                                             }

variable "app_service"                       {
                                               description = "Details of the Application Service"
                                               type        = object({
                                                               use                            = bool
                                                               app_registration_id            = optional(string, "")
                                                               client_secret                  = optional(string, "")
                                                               tfstate_storage_account_name   = optional(string, "")
                                                               app_service_allowed_groups     = optional(list(string), [])
                                                               app_service_allowed_identities = optional(list(string), [])
                                                             })
                                             }

variable "app_config_service"                {
                                               description = "Details of the Application Configuration Service"
                                               type        = object({
                                                               name               = optional(string, "")
                                                               id                 = optional(string, "")
                                                               exists             = optional(bool, false)
                                                               deploy             = bool
                                                               control_plane_name = optional(string, "")
                                                             })

                                               validation {
                                                            condition     = length(var.app_config_service.id) == 0 || length(split("/", var.app_config_service.id)) == 9
                                                            error_message = "If specified, app_config_service.id needs to be a correctly formed Azure resource ID."
                                                          }
                                             }

variable "additional_network_id"             {
                                               description = "Additional network ID"
                                               type        = string

                                               validation {
                                                            condition     = length(var.additional_network_id) == 0 || length(split("/", var.additional_network_id)) == 9
                                                            error_message = "If specified, additional_network_id needs to be a correctly formed Azure resource ID."
                                                          }
                                             }
