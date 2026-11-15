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
                                                          description = "Database tier settings assembled by the root module's transform. Untyped: its attributes are conditional and shared by five modules; it will be typed together with them"
                                                          type        = any
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
                                                          description = "Infrastructure settings assembled by the root module's transform. Untyped: its attributes are conditional and shared by five modules; it will be typed together with them"
                                                          type        = any
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
                                                          description = "Defines the names for the resources: the output of the sap_namegenerator module, or a custom names file with the same structure"
                                                          type        = any
                                                        }
variable "observer_vm_tags"                             {
                                                          description = "Tags to use specifically for the observer VM"
                                                          type        = map(string)
                                                        }
variable "options"                                      {
                                                          description = "Miscellaneous deployment options assembled by the root module's transform. Untyped: shared by five modules; it will be typed together with them"
                                                          type        = any
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
                                                          description = "DNS Settings"
                                                          type        = any
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
                                                          description = "Azure resource ID of the flexible virtual machine scale set, or null"
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
