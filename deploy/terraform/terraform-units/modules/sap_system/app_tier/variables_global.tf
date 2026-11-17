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
variable "application_tier"                             {
                                                          description = "Application tier settings: central services, application servers and web dispatchers. Only the attributes this module reads are declared; Terraform discards the rest."
                                                          type        = object({
                                                                          sid                            = string
                                                                          enable_deployment              = optional(bool, false)
                                                                          use_DHCP                       = optional(bool, false)
                                                                          dual_network_interfaces        = optional(bool, false)
                                                                          vm_sizing_dictionary_key       = optional(string, "")
                                                                          user_assigned_identity_id      = optional(string, "")
                                                                          authentication                 = optional(object({
                                                                                                             type = optional(string, "key")
                                                                                                           }), {})
                                                                          application_server_count       = optional(number, 0)
                                                                          app_sku                        = optional(string, "")
                                                                          app_use_ppg                    = optional(bool, false)
                                                                          app_use_avset                  = optional(bool, false)
                                                                          avset_arm_ids                  = optional(list(string), [])
                                                                          avset_arm_ids_count            = optional(number, 0)
                                                                          app_zone_count                 = optional(number, 0)
                                                                          app_zones                      = optional(list(string), [])
                                                                          app_os                         = optional(object({
                                                                                                             os_type         = optional(string, "LINUX")
                                                                                                             type            = optional(string, "marketplace")
                                                                                                             source_image_id = optional(string, "")
                                                                                                             publisher       = optional(string, "")
                                                                                                             offer           = optional(string, "")
                                                                                                             sku             = optional(string, "")
                                                                                                             version         = optional(string, "")
                                                                                                           }), {})
                                                                          app_nic_ips                    = optional(list(string), [])
                                                                          app_nic_secondary_ips          = optional(list(string), [])
                                                                          app_admin_nic_ips              = optional(list(string), [])
                                                                          app_tags                       = optional(map(string), {})
                                                                          scs_server_count               = optional(number, 0)
                                                                          scs_high_availability          = optional(bool, false)
                                                                          scs_cluster_type               = optional(string, "AFA")
                                                                          scs_cluster_disk_lun           = optional(number, 5)
                                                                          scs_cluster_disk_size          = optional(number, 128)
                                                                          scs_cluster_disk_type          = optional(string, "Premium_ZRS")
                                                                          scs_instance_number            = optional(string, "00")
                                                                          ers_instance_number            = optional(string, "02")
                                                                          scs_sku                        = optional(string, "")
                                                                          scs_use_ppg                    = optional(bool, false)
                                                                          scs_use_avset                  = optional(bool, false)
                                                                          scs_zones                      = optional(list(string), [])
                                                                          scs_os                         = optional(object({
                                                                                                             os_type         = optional(string, "LINUX")
                                                                                                             type            = optional(string, "marketplace")
                                                                                                             source_image_id = optional(string, "")
                                                                                                             publisher       = optional(string, "")
                                                                                                             offer           = optional(string, "")
                                                                                                             sku             = optional(string, "")
                                                                                                             version         = optional(string, "")
                                                                                                           }), {})
                                                                          scs_nic_ips                    = optional(list(string), [])
                                                                          scs_nic_secondary_ips          = optional(list(string), [])
                                                                          scs_admin_nic_ips              = optional(list(string), [])
                                                                          scs_server_loadbalancer_ips    = optional(list(string), [])
                                                                          scs_tags                       = optional(map(string), {})
                                                                          fence_kdump_disk_size          = optional(number, 0)
                                                                          fence_kdump_lun_number         = optional(number, -1)
                                                                          webdispatcher_count            = optional(number, 0)
                                                                          web_instance_number            = optional(string, "00")
                                                                          web_sku                        = optional(string, "")
                                                                          web_use_ppg                    = optional(bool, false)
                                                                          web_use_avset                  = optional(bool, false)
                                                                          web_zones                      = optional(list(string), [])
                                                                          web_os                         = optional(object({
                                                                                                             os_type         = optional(string, "LINUX")
                                                                                                             type            = optional(string, "marketplace")
                                                                                                             source_image_id = optional(string, "")
                                                                                                             publisher       = optional(string, "")
                                                                                                             offer           = optional(string, "")
                                                                                                             sku             = optional(string, "")
                                                                                                             version         = optional(string, "")
                                                                                                           }), {})
                                                                          web_nic_ips                    = optional(list(string), [])
                                                                          web_nic_secondary_ips          = optional(list(string), [])
                                                                          web_admin_nic_ips              = optional(list(string), [])
                                                                          webdispatcher_loadbalancer_ips = optional(list(string), [])
                                                                          web_tags                       = optional(map(string), {})
                                                                        })
                                                        }
variable "cloudinit_growpart_config"                    {
                                                          description = "Rendered cloud-init configuration passed to virtual machines on first deployment, or null"
                                                          type        = any
                                                        }
variable "custom_disk_sizes_filename"                   {
                                                          description = "Custom disk sizing file"
                                                          type        = string
                                                        }
variable "deploy_application_security_groups"           {
                                                          description = "Defines if application security groups should be deployed"
                                                          type        = bool
                                                        }
variable "deployer_user"                                {
                                                          description = "Details of the users"
                                                          type        = any
                                                          default     = []
                                                        }
variable "deployment"                                   {
                                                          description = "The type of deployment: new or update"
                                                          type        = string
                                                        }
variable "fencing_role_name"                            {
                                                          description = "If specified the role name to use for the fencing agent"
                                                          type        = string
                                                        }
variable "firewall_id"                                  {
                                                          description = "Azure resource ID of the firewall of the control plane, or empty"
                                                          type        = string
                                                        }
variable "idle_timeout_scs_ers"                         {
                                                          description = "Sets the idle timeout setting for the SCS and ERS loadbalancer"
                                                          type        = number
                                                          default     = 4
                                                        }
variable "infrastructure"                               {
                                                          description = "Infrastructure settings of the SAP system. resource_group is empty unless an existing or explicitly named resource group is used. Only the attributes this module reads are declared; Terraform discards the rest."
                                                          type        = object({
                                                                          environment                   = string
                                                                          region                        = string
                                                                          patch_mode                    = optional(string, "ImageDefault")
                                                                          patch_assessment_mode         = optional(string, "ImageDefault")
                                                                          encryption_at_host_enabled    = optional(bool, false)
                                                                          deploy_monitoring_extension   = optional(bool, false)
                                                                          deploy_defender_extension     = optional(bool, false)
                                                                          disk_controller_type_app_tier = optional(string, "SCSI")
                                                                          configuration_settings        = optional(any, {})
                                                                          resource_group                = optional(object({
                                                                                                            name = optional(string, "")
                                                                                                            id   = optional(string, "")
                                                                                                          }), {})
                                                                          virtual_networks              = object({
                                                                                                            sap = object({
                                                                                                                    subnet_app = optional(object({
                                                                                                                                   name               = optional(string, "")
                                                                                                                                   id                 = optional(string, "")
                                                                                                                                   prefix             = optional(string, "")
                                                                                                                                   defined            = optional(bool, false)
                                                                                                                                   exists             = optional(bool, false)
                                                                                                                                   exists_in_workload = optional(bool, false)
                                                                                                                                   id_in_workload     = optional(string)
                                                                                                                                   nsg                = optional(object({
                                                                                                                                                          name               = optional(string, "")
                                                                                                                                                          id                 = optional(string, "")
                                                                                                                                                          exists             = optional(bool, false)
                                                                                                                                                          exists_in_workload = optional(bool, false)
                                                                                                                                                          id_in_workload     = optional(string)
                                                                                                                                                        }), {})
                                                                                                                                 }), {})
                                                                                                                    subnet_web = optional(object({
                                                                                                                                   name               = optional(string, "")
                                                                                                                                   id                 = optional(string, "")
                                                                                                                                   prefix             = optional(string, "")
                                                                                                                                   defined            = optional(bool, false)
                                                                                                                                   exists             = optional(bool, false)
                                                                                                                                   exists_in_workload = optional(bool, false)
                                                                                                                                   id_in_workload     = optional(string)
                                                                                                                                   nsg                = optional(object({
                                                                                                                                                          name               = optional(string, "")
                                                                                                                                                          id                 = optional(string, "")
                                                                                                                                                          exists             = optional(bool, false)
                                                                                                                                                          exists_in_workload = optional(bool, false)
                                                                                                                                                          id_in_workload     = optional(string)
                                                                                                                                                        }), {})
                                                                                                                                 }), {})
                                                                                                                  })
                                                                                                          })
                                                                        })
                                                        }
variable "landscape_tfstate"                            {
                                                          description = "Outputs of the workload zone Terraform state. Untyped until the workload zone publishes a versioned capability contract"
                                                          type        = any
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
                                                                        })
                                                        }
variable "network_location"                             {
                                                          description = "Azure region of the SAP virtual network"
                                                          type        = string
                                                        }
variable "network_resource_group"                       {
                                                          description = "Resource group of the SAP virtual network"
                                                          type        = string
                                                        }
variable "NFS_provider"                                 {
                                                          description = "NFS Provider, valid values are 'AFS', 'ANF' or 'NONE'"
                                                          type        = string
                                                        }
variable "options"                                      {
                                                          description = "Miscellaneous deployment options. disk_encryption_set_id is null unless a disk encryption set is used. Only the attributes this module reads are declared; Terraform discards the rest."
                                                          type        = object({
                                                                          nsg_asg_with_vnet      = optional(bool, false)
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
variable "route_table_id"                               {
                                                          description = "Azure resource ID of the route table of the SAP virtual network, or empty"
                                                          type        = string
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
variable "use_admin_nic_for_asg"                        {
                                                          description = "If true, the admin nic will be assigned to the ASG instead of the second nic"
                                                          type        = bool
                                                        }
variable "use_loadbalancers_for_standalone_deployments" {
                                                          description = "Defines if load balancers are used even for standalone deployments"
                                                          type        = bool
                                                          default     = true
                                                        }
variable "use_secondary_ips"                            {
                                                          description = "Use secondary IPs for the SAP System"
                                                          type        = bool
                                                          default     = false
                                                        }
variable "use_msi_for_clusters"                         {
                                                          description = "If true, the Pacemaker cluser will use a managed identity"
                                                          type        = bool
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
