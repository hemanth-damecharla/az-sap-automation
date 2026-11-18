# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#######################################4#######################################8
#                                                                              #
#                                Parameters                                    #
#                                                                              #
#######################################4#######################################8

variable "admin_subnet"                                 {
                                                          description = "The admin subnet, as returned by the common_infrastructure module (a resource or data source object, or null)"
                                                          type        = any
                                                        }
variable "anchor_vm"                                    {
                                                          description = "The anchor virtual machine of the common_infrastructure module; passed only to order deployment after it"
                                                          type        = any
                                                        }
variable "cloudinit_growpart_config"                    {
                                                          description = "Rendered cloud-init configuration passed to virtual machines on first deployment, or null"
                                                          type        = any
                                                        }
variable "custom_disk_sizes_filename"                   {
                                                          description = "Custom disk sizing file"
                                                          type        = string
                                                        }
variable "database_server_count"                        {
                                                          description = "The number of database servers"
                                                          type        = number
                                                          default     = 1
                                                        }
variable "database_vm_admin_nic_ips"                    {
                                                          description = "If provided, the database tier virtual machines will be configured with the specified IPs (admin subnet)"
                                                          type        = list(string)
                                                        }
variable "database_vm_db_nic_ips"                       {
                                                          description = "If provided, the database tier virtual machines will be configured using the specified IPs"
                                                          type        = list(string)
                                                        }
variable "database_vm_db_nic_secondary_ips"             {
                                                          description = "If provided, the database tier virtual machines will be configured using the specified IPs as secondary IPs"
                                                          type        = list(string)
                                                        }
variable "database"                                     {
                                                          description = "Database tier settings. use_avset and use_ppg are null when the caller leaves the placement decision open. Only the attributes this module reads are declared; Terraform discards the rest."
                                                          type        = object({
                                                                          platform                   = string
                                                                          db_sizing_key              = optional(string, "Default")
                                                                          database_vm_sku            = optional(string, "")
                                                                          high_availability          = optional(bool, false)
                                                                          dual_network_interfaces    = optional(bool, false)
                                                                          instance                   = optional(object({
                                                                                                         sid = optional(string)
                                                                                                       }), {})
                                                                          authentication             = optional(object({
                                                                                                         type = optional(string, "key")
                                                                                                       }), {})
                                                                          os                         = optional(object({
                                                                                                         os_type         = optional(string, "LINUX")
                                                                                                         type            = optional(string, "marketplace")
                                                                                                         source_image_id = optional(string, "")
                                                                                                         publisher       = optional(string, "SUSE")
                                                                                                         offer           = optional(string, "sles-sap-15-sp5")
                                                                                                         sku             = optional(string, "gen2")
                                                                                                         version         = optional(string, "latest")
                                                                                                       }), {})
                                                                          loadbalancer               = optional(object({
                                                                                                         frontend_ips = optional(list(string), [])
                                                                                                       }), {})
                                                                          database_cluster_type      = optional(string, "AFA")
                                                                          database_cluster_disk_lun  = optional(number, 8)
                                                                          database_cluster_disk_size = optional(number, 128)
                                                                          database_cluster_disk_type = optional(string, "Premium_ZRS")
                                                                          fence_kdump_disk_size      = optional(number, 128)
                                                                          fence_kdump_lun_number     = optional(number, -1)
                                                                          use_DHCP                   = optional(bool, false)
                                                                          use_avset                  = optional(bool)
                                                                          use_ppg                    = optional(bool)
                                                                          avset_arm_ids              = optional(list(string), [])
                                                                          zones                      = optional(list(string), [])
                                                                          user_assigned_identity_id  = optional(string, "")
                                                                          tags                       = optional(map(string), {})
                                                                        })
                                                        }
variable "db_asg_id"                                    {
                                                          description = "Azure resource ID of the database application security group, or empty"
                                                          type        = string
                                                        }
variable "db_subnet"                                    {
                                                          description = "The database subnet, as returned by the common_infrastructure module (a resource or data source object)"
                                                          type        = any
                                                        }
variable "deploy_application_security_groups"           {
                                                          description = "Defines if application security groups should be deployed"
                                                          type        = bool
                                                        }
variable "deployment"                                   {
                                                          description = "The type of deployment: new or update"
                                                          type        = string
                                                        }
variable "fencing_role_name"                            {
                                                          description = "If specified the role name to use for the fencing agent"
                                                          type        = string
                                                        }
variable "infrastructure"                               {
                                                          description = "Infrastructure settings of the SAP system. Only the attributes this module reads are declared; Terraform discards the rest."
                                                          type        = object({
                                                                          region                             = string
                                                                          patch_mode                         = optional(string, "ImageDefault")
                                                                          patch_assessment_mode              = optional(string, "ImageDefault")
                                                                          encryption_at_host_enabled         = optional(bool, false)
                                                                          deploy_monitoring_extension        = optional(bool, false)
                                                                          deploy_defender_extension          = optional(bool, false)
                                                                          disk_controller_type_database_tier = optional(string, "SCSI")
                                                                          configuration_settings             = optional(any, {})
                                                                        })
                                                        }
variable "landscape_tfstate"                            {
                                                          description = "Outputs of the workload zone state, as returned by the sap_capabilities module. Only the attributes this module reads are declared; Terraform discards the rest. An attribute missing from an older state takes its default"
                                                          type        = object({
                                                                          dns_label               = optional(string, "")
                                                                          dns_resource_group_name = optional(string, "")
                                                                        })
                                                          default     = {}
                                                          nullable    = false
                                                        }
variable "license_type"                                 {
                                                          description = "Specifies the license type for the OS"
                                                          type        = string
                                                        }
variable "naming"                                       {
                                                          description = "Defines the names for the resources: the 'naming' output of the sap_namegenerator module, or a custom names file with the same structure. Only the groups this module reads are declared; Terraform discards the rest. The groups are maps and lists, so a custom names file may leave out entries the deployment does not use."
                                                          type        = object({
                                                                          separator             = string
                                                                          prefix                = optional(map(string), {})
                                                                          resource_prefixes     = optional(map(string), {})
                                                                          resource_suffixes     = optional(map(string), {})
                                                                          virtualmachine_names  = optional(map(list(string)), {})
                                                                          availabilityset_names = optional(map(list(string)), {})
                                                                          storageaccount_names  = optional(object({
                                                                                                    SDU = optional(string)
                                                                                                  }), {})
                                                                        })
                                                        }
variable "observer_vm_tags"                             {
                                                          description = "Tags to use specifically for the observer VM"
                                                          type        = map(string)
                                                        }
variable "options"                                      {
                                                          description = "Miscellaneous deployment options. disk_encryption_set_id is null unless a disk encryption set is used. Only the attributes this module reads are declared; Terraform discards the rest."
                                                          type        = object({
                                                                          legacy_nic_order       = optional(bool, false)
                                                                          resource_offset        = optional(number, 0)
                                                                          disk_encryption_set_id = optional(string)
                                                                        })
                                                        }
variable "order_deployment"                             {
                                                          description = "Value used only to order this module after another one; its content is not read"
                                                          type        = any
                                                        }
variable "ppg"                                          {
                                                          description = "Proximity placement groups, as returned by the common_infrastructure module"
                                                          type        = any
                                                        }
variable "resource_group"                               {
                                                          description = "The resource group of the SAP system, as returned by the common_infrastructure module"
                                                          type        = any
                                                        }
variable "sap_sid"                                      {
                                                          description = "The SAP system ID"
                                                          type        = string
                                                        }
variable "sdu_public_key"                               {
                                                          description = "Public SSH key of the SAP system administrator"
                                                          type        = string
                                                        }
variable "sid_keyvault_user_id"                         {
                                                          description = "Azure resource ID of the key vault holding the SAP system credentials"
                                                          type        = string
                                                        }
variable "sid_password"                                 {
                                                          description = "Password of the SAP system administrator"
                                                          type        = string
                                                        }
variable "sid_username"                                 {
                                                          description = "User name of the SAP system administrator"
                                                          type        = string
                                                        }
variable "storage_bootdiag_endpoint"                    {
                                                          description = "Blob endpoint of the boot diagnostics storage account"
                                                          type        = string
                                                        }
variable "terraform_template_version"                   {
                                                          description = "The version of Terraform templates that were identified in the state file"
                                                          type        = string
                                                        }
variable "use_admin_nic_suffix_for_observer"            {
                                                          description = "If true, the admin nic suffix will be used for the observer"
                                                          type        = bool
                                                        }
variable "use_admin_nic_for_asg"                        {
                                                          description = "If true, the admin nic will be assigned to the ASG instead of the second nic"
                                                          type        = bool
                                                        }
variable "use_loadbalancers_for_standalone_deployments" {
                                                          description = "If defined, will use load balancers for standalone deployments"
                                                          type        = bool
                                                        }
variable "use_msi_for_clusters"                         {
                                                          description = "If true, the Pacemaker cluser will use a managed identity"
                                                          type        = bool
                                                        }
variable "use_observer"                                 {
                                                          description = "If true, an observer virtual machine will be used"
                                                          type        = bool
                                                        }
variable "observer_vm_size"                             {
                                                          description = "The VM size to use for the observer"
                                                          type        = string
                                                        }
variable "observer_vm_zones"                            {
                                                          description = "The zone to deploy the observer in"
                                                          type        = list(string)
                                                        }
variable "use_secondary_ips"                            {
                                                          description = "Use secondary IPs for the SAP System"
                                                          type        = bool
                                                          default     = false
                                                        }


#########################################################################################
#                                                                                       #
#  DNS settings                                                                         #
#                                                                                       #
#########################################################################################

variable "dns_settings"                                 {
                                                          description = "DNS settings. Only the attributes this module reads are declared; Terraform discards the rest."
                                                          type        = object({
                                                                          management_dns_resourcegroup_name = optional(string, "")
                                                                          register_virtual_network_to_dns   = optional(bool, false)
                                                                        })
                                                        }

#########################################################################################
#                                                                                       #
#  Scale Set                                                                            #
#                                                                                       #
#########################################################################################

variable "use_scalesets_for_deployment"                 {
                                                          description = "Use Flexible Virtual Machine Scale Sets for the deployment"
                                                          type        = bool
                                                        }
variable "scale_set_id"                                 {
                                                          description = "Azure resource ID of the flexible virtual machine scale set, or empty"
                                                          type        = string
                                                        }

#########################################################################################
#                                                                                       #
#  Tags                                                                                 #
#                                                                                       #
#########################################################################################

variable "tags"                                         {
                                                          description = "If provided, tags for all resources"
                                                          type        = map(string)
                                                        }
