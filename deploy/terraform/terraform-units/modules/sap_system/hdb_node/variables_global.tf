# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

variable "admin_subnet"                                 {
                                                          description = "The admin subnet, as returned by the common_infrastructure module (a resource or data source object, or null)"
                                                          type        = any
                                                        }

variable "AFS_enable_encryption_in_transit"             {
                                                           description = "Enable encryption in transit for Azure Files"
                                                           type        = bool
                                                           default     = false
                                                        }

variable "anchor_vm"                                    {
                                                          description = "Deployed anchor VM"
                                                          type        = any
                                                          default     = null
                                                        }
variable "cloudinit_growpart_config"                    {
                                                          description = "Rendered cloud-init configuration passed to virtual machines on first deployment, or null"
                                                          type        = any
                                                        }
variable "custom_disk_sizes_filename"                   {
                                                          description = "Disk size json file"
                                                          default     = ""
                                                          type        = string
                                                        }
variable "database"                                     {
                                                          description = "Database tier settings. use_avset and use_ppg are null when the caller leaves the placement decision open. Only the attributes this module reads are declared; Terraform discards the rest."
                                                          type        = object({
                                                                          platform                   = string
                                                                          db_sizing_key              = optional(string, "Default")
                                                                          database_vm_sku            = optional(string, "")
                                                                          high_availability          = optional(bool, false)
                                                                          scale_out                  = optional(bool, false)
                                                                          stand_by_node_count        = optional(number, 0)
                                                                          dual_network_interfaces    = optional(bool, false)
                                                                          use_ANF                    = optional(bool, false)
                                                                          instance                   = optional(object({
                                                                                                         sid    = optional(string)
                                                                                                         number = optional(string, "00")
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
                                                                          observer_vm_ips            = optional(list(string), [])
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

variable "enable_storage_nic"                           {
                                                          description = "Boolean to determine if a storage nic should be used when scale out is enabled"
                                                          type        = bool
                                                        }
variable "database_server_count"                        {
                                                          description = "The number of database servers"
                                                          type        = number
                                                          default     = 1
                                                        }
variable "database_use_premium_v2_storage"              {
                                                          description = "If true, the database tier will use premium storage"
                                                          type        = bool
                                                        }
variable "database_active_active"                       {
                                                          description = "If true, database will deployed with Active/Active (read enabled) configuration"
                                                          type        = bool
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
variable "database_vm_storage_nic_ips"                  {
                                                          description = "If provided, the database tier virtual machines will be configured with the specified IPs (storage subnet)"
                                                          type        = list(string)
                                                        }
variable "db_asg_id"                                    {
                                                          description = "Azure resource ID of the database application security group, or empty"
                                                          type        = string
                                                        }
variable "db_subnet"                                    {
                                                          description = "The database subnet, as returned by the common_infrastructure module (a resource or data source object)"
                                                          type        = any
                                                        }
variable "deployer_tfstate"                             {
                                                          description = "Outputs of the deployer Terraform state. Untyped until the deployer publishes a versioned capability contract"
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
                                                          description = "Infrastructure settings of the SAP system. resource_group is empty unless an existing or explicitly named resource group is used. Only the attributes this module reads are declared; Terraform discards the rest."
                                                          type        = object({
                                                                          region                             = string
                                                                          patch_mode                         = optional(string, "ImageDefault")
                                                                          patch_assessment_mode              = optional(string, "ImageDefault")
                                                                          encryption_at_host_enabled         = optional(bool, false)
                                                                          deploy_monitoring_extension        = optional(bool, false)
                                                                          deploy_defender_extension          = optional(bool, false)
                                                                          disk_controller_type_database_tier = optional(string, "SCSI")
                                                                          shared_access_key_enabled_nfs      = optional(bool, false)
                                                                          configuration_settings             = optional(any, {})
                                                                          resource_group                     = optional(object({
                                                                                                                 name = optional(string, "")
                                                                                                                 id   = optional(string, "")
                                                                                                               }), {})
                                                                          virtual_networks                   = object({
                                                                                                                 sap = object({
                                                                                                                         subnet_admin    = optional(object({
                                                                                                                                             name               = optional(string, "")
                                                                                                                                             id                 = optional(string, "")
                                                                                                                                             prefix             = optional(string, "")
                                                                                                                                             defined            = optional(bool, false)
                                                                                                                                             exists             = optional(bool, false)
                                                                                                                                             exists_in_workload = optional(bool, false)
                                                                                                                                             id_in_workload     = optional(string)
                                                                                                                                           }), {})
                                                                                                                         subnet_db       = optional(object({
                                                                                                                                             name               = optional(string, "")
                                                                                                                                             id                 = optional(string, "")
                                                                                                                                             prefix             = optional(string, "")
                                                                                                                                             defined            = optional(bool, false)
                                                                                                                                             exists             = optional(bool, false)
                                                                                                                                             exists_in_workload = optional(bool, false)
                                                                                                                                             id_in_workload     = optional(string)
                                                                                                                                           }), {})
                                                                                                                         subnet_app      = optional(object({
                                                                                                                                             name               = optional(string, "")
                                                                                                                                             id                 = optional(string, "")
                                                                                                                                             prefix             = optional(string, "")
                                                                                                                                             defined            = optional(bool, false)
                                                                                                                                             exists             = optional(bool, false)
                                                                                                                                             exists_in_workload = optional(bool, false)
                                                                                                                                             id_in_workload     = optional(string)
                                                                                                                                           }), {})
                                                                                                                         subnet_storage  = optional(object({
                                                                                                                                             name               = optional(string, "")
                                                                                                                                             id                 = optional(string, "")
                                                                                                                                             prefix             = optional(string, "")
                                                                                                                                             defined            = optional(bool, false)
                                                                                                                                             exists             = optional(bool, false)
                                                                                                                                             exists_in_workload = optional(bool, false)
                                                                                                                                             id_in_workload     = optional(string)
                                                                                                                                           }), {})
                                                                                                                         subnet_endpoint = optional(object({
                                                                                                                                             name               = optional(string, "")
                                                                                                                                             id                 = optional(string, "")
                                                                                                                                             prefix             = optional(string, "")
                                                                                                                                             defined            = optional(bool, false)
                                                                                                                                             exists             = optional(bool, false)
                                                                                                                                             exists_in_workload = optional(bool, false)
                                                                                                                                             id_in_workload     = optional(string)
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
                                                          default     = ""
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
variable "NFS_provider"                                 {
                                                          description = "Describes the NFS solution used"
                                                          type        = string
                                                        }
variable "options"                                      {
                                                          description = "Miscellaneous deployment options. disk_encryption_set_id is null unless a disk encryption set is used. Only the attributes this module reads are declared; Terraform discards the rest."
                                                          type        = object({
                                                                          legacy_nic_order       = optional(bool, false)
                                                                          resource_offset        = optional(number, 0)
                                                                          disk_encryption_set_id = optional(string)
                                                                        })
                                                        }
variable "ppg"                                          {
                                                          description = "Proximity placement groups, as returned by the common_infrastructure module"
                                                          type        = any
                                                        }
variable "resource_group"                               {
                                                          description = "The resource group of the SAP system, as returned by the common_infrastructure module"
                                                          type        = any
                                                        }
variable "sdu_public_key"                               {
                                                          description = "Public SSH key of the SAP system administrator"
                                                          type        = string
                                                        }
variable "sap_sid"                                      {
                                                          description = "The SAP system ID"
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
variable "storage_subnet_id"                            {
                                                          description = "Azure resource ID of the storage subnet, or empty"
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
                                                          description = "Defines if load balancers are used even for standalone deployments"
                                                          type        = bool
                                                          default     = true
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

variable "enable_firewall_for_keyvaults_and_storage"    {
                                                          description = "Boolean value indicating if firewall should be enabled for key vaults and storage"
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
                                                                          dns_zone_names                    = optional(map(string), {})
                                                                          management_dns_resourcegroup_name = optional(string, "")
                                                                          register_endpoints_with_dns       = optional(bool, false)
                                                                          register_virtual_network_to_dns   = optional(bool, false)
                                                                        })
                                                        }

#########################################################################################
#                                                                                       #
#  ANF settings                                                                         #
#                                                                                       #
#########################################################################################

variable "hana_ANF_volumes"                           {
                                                        description = "Azure NetApp Files settings for the SAP HANA data, log and shared volumes. The volume name lists hold one entry per volume and are read only when the matching use_existing flag is set. Only the attributes this module reads are declared; Terraform discards the rest."
                                                        type        = object({
                                                                        use_for_data               = optional(bool, false)
                                                                        data_volume_size           = optional(number, 512)
                                                                        use_existing_data_volume   = optional(bool, false)
                                                                        data_volume_name           = optional(list(string), [""])
                                                                        data_volume_throughput     = optional(number, 128)
                                                                        data_volume_count          = optional(number, 1)
                                                                        use_for_log                = optional(bool, false)
                                                                        log_volume_size            = optional(number, 512)
                                                                        use_existing_log_volume    = optional(bool, false)
                                                                        log_volume_name            = optional(list(string), [""])
                                                                        log_volume_throughput      = optional(number, 128)
                                                                        log_volume_count           = optional(number, 1)
                                                                        use_for_shared             = optional(bool, false)
                                                                        shared_volume_size         = optional(number, 512)
                                                                        use_existing_shared_volume = optional(bool, false)
                                                                        shared_volume_name         = optional(list(string), [""])
                                                                        shared_volume_throughput   = optional(number, 128)
                                                                        use_AVG                    = optional(bool, false)
                                                                        use_zones                  = optional(bool, false)
                                                                      })
                                                      }

#########################################################################################
#                                                                                       #
#  Tags                                                                                 #
#                                                                                       #
#########################################################################################

variable "tags"                                       {
                                                        description = "If provided, tags for all resources"
                                                        type        = map(string)
                                                      }

#########################################################################################
#                                                                                       #
#  Scale Set                                                                            #
#                                                                                       #
#########################################################################################

variable "use_scalesets_for_deployment"               {
                                                        description = "Use Flexible Virtual Machine Scale Sets for the deployment"
                                                        type        = bool
                                                      }

variable "scale_set_id"                               {
                                                        description = "Azure resource ID of the flexible virtual machine scale set, or empty"
                                                        type        = string
                                                      }


#########################################################################################
#                                                                                       #
#  Scale Out                                                                            #
#                                                                                       #
#########################################################################################


variable "hanashared_volume_size"                     {
                                                        description = "The volume size in GB for hana shared"
                                                        type        = number
                                                        default     = 128
                                                      }

variable "hanashared_id"                             {
                                                       description = "Azure Resource Identifier for an storage account"
                                                       type        = list(string)
                                                       default     = [""]
                                                     }

variable "observer_vm_tags"                          {
                                                       description = "Tags to use specifically for the observer VM"
                                                       type        = map(string)
                                                       default     = {}
                                                     }

variable "use_single_hana_shared"                    {
                                                       description = "Boolean indicating wether to use a single storage account for all HANA file shares"
                                                       type        = bool
                                                       default     = false
                                                     }


variable "use_private_endpoint"                       {
                                                         description = "Boolean value indicating if private endpoint should be used for the deployment"
                                                         default     = false
                                                         type        = bool
                                                      }

variable "hanashared_private_endpoint_id"            {
                                                       description = "Azure Resource Identifier for an private endpoint connection"
                                                       type        = list(string)
                                                       default     = [""]
                                                     }
variable "Agent_IP"                                  {
                                                       description = "The IP address of the agent"
                                                       type        = string
                                                       default     = ""
                                                     }

variable "random_id"                                 {
                                                       description = "Random hex string used to make resource names unique"
                                                       type        = string
                                                     }
