# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

variable "subnet_cidr_anf"                    {
                                                description = "Address prefix of the Azure NetApp Files subnet"
                                                type        = string
                                              }
variable "ansible_user"                         {
                                                  description = "The ansible remote user account to use"
                                                  type        = string
                                                  default     = "azureadm"
                                                }
variable "app_instance_number"                  {
                                                  description = "Instance number for Additional Application Server"
                                                  type        = string
                                                  default     = "00"
                                                }
variable "app_server_count"                     {
                                                  description = "Number of Application Servers"
                                                  type    = number
                                                }
variable "app_subnet_netmask"                   {
                                                  description = "Netmask length of the application subnet"
                                                  type        = string
                                                }
variable "app_tier_os_types"                    {
                                                  description = "Operating system type per application tier role, as returned by the app_tier module"
                                                  type        = any
                                                }
variable "app_vm_names"                         {
                                                  description = "Names of the application server virtual machines"
                                                  type        = list(string)
                                                }
variable "application_server_ips"               {
                                                  description = "IP addresses of the application servers"
                                                  type        = list(string)
                                                }
variable "application_server_secondary_ips"     {
                                                  description = "Secondary IP addresses of the application servers"
                                                  type        = list(string)
                                                }
variable "authentication_type"                  {
                                                  description = "VM Authentication type"
                                                  type        = string
                                                  default     = "key"
                                                }
variable "authentication"                       {
                                                  description = "Credentials specific to this SAP system. When every attribute is empty the workload zone credentials are used"
                                                  type        = object({
                                                                  username            = optional(string, "")
                                                                  password            = optional(string, "")
                                                                  path_to_public_key  = optional(string, "")
                                                                  path_to_private_key = optional(string, "")
                                                                })
                                                  default     = {}
                                                }
variable "bom_name"                             {
                                                  description = "Name of Bill of Materials file"
                                                  type        = string
                                                  default     = ""
                                                }
variable "subnet_cidr_app"                      {
                                                  description = "Address prefix of the application subnet"
                                                  type        = string
                                                }
variable "subnet_cidr_db"                       {
                                                  description = "Address prefix of the database subnet"
                                                  type        = string
                                                }
variable "subnet_cidr_client"                   {
                                                  description = "Address prefix of the client subnet"
                                                  type        = string
                                                }
variable "configuration_settings"               {
                                                  description = "Dictionary of additional values persisted to sap-parameters.yaml; values may be strings, numbers, lists or maps"
                                                  type        = any
                                                }
variable "created_resource_group_name"          {
                                                  description = "Name of the resource group of the SAP system"
                                                  type        = string
                                                }
variable "created_resource_group_subscription_id" {
                                                    description = "Subscription ID of the resource group of the SAP system"
                                                    type        = string
                                                  }
variable "database_admin_ips"                   {
                                                  description = "Admin network IP addresses of the database servers"
                                                  type        = list(string)
                                                }
variable "database_cluster_type"                {
                                                  description   = "Cluster quorum type; AFA (Azure Fencing Agent), ASD (Azure Shared Disk), ISCSI"
                                                  type          = string
                                                }
variable "database_high_availability"           {
                                                  description = "If true, the database tier will be configured for high availability"
                                                  type        = bool
                                                  default     = false
                                                }
variable "database"                             {
                                                  description = "Database tier settings. Only the attributes this module reads are declared; Terraform discards the rest."
                                                  type        = object({
                                                                  database_hana_use_saphanasr_angi = optional(bool, false)
                                                                  instance                         = optional(object({
                                                                                                       number = optional(string, "00")
                                                                                                     }), {})
                                                                })
                                                }
variable "database_authentication_type"         {
                                                  description = "Platform to use"
                                                  type        = string
                                                  default     = "key"
                                                }
variable "database_cluster_ip"                  {
                                                  description = "IP address of the database cluster (Windows Server Failover Cluster)"
                                                  type        = string
                                                }
variable "database_active_active"               {
                                                  description = "If true, database will deployed with Active/Active (read enabled) configuration, only supported for HANA"
                                                  type        = bool
                                                }
variable "database_active_active_loadbalancer_ip" {
                                                    description = "DB Active Active Load Balancer IP"
                                                    type        = string
                                                    default     = ""
                                                  }
variable "database_loadbalancer_ip"             {
                                                  description = "DB Load Balancer IP"
                                                  type        = string
                                                  default     = ""
                                                }
variable "db_server_count"                      {
                                                  description = "Number of Database Servers"
                                                  type    = number
                                                }
variable "database_server_ips"                  {
                                                  description = "IP addresses of the database servers"
                                                  type        = list(string)
                                                }
variable "database_server_secondary_ips"        {
                                                  description = "Secondary IP addresses of the database servers"
                                                  type        = list(string)
                                                }
variable "database_shared_disks"                {
                                                  description = "Shared disks of the database cluster, as returned by the database modules"
                                                  type        = any
                                                }
variable "database_server_vm_names"             {
                                                  description = "Names of the database server virtual machines"
                                                  type        = list(string)
                                                }
variable "deploy_monitoring_extension"          {
                                                  description = "Defines if the Microsoft.AzureCAT.AzureEnhancedMonitoring extension will be deployed"
                                                  type        = bool
                                                }

variable "is_use_fence_kdump"                   {
                                                  description = "Configure fencing device based on the fence agent fence_kdump for both SCS and DB clusters"
                                                  type        = bool
                                                }

variable "db_sid"                               {
                                                  description = "The database system ID"
                                                  type        = string
                                                }
variable "database_subnet_netmask"              {
                                                  description = "Netmask length of the database subnet"
                                                  type        = string
                                                }
variable "disks"                                {
                                                  description = "Disk layout entries of the database virtual machines, as returned by the database modules"
                                                  type        = any
                                                }
variable "dns_zone_names"                       {
                                                  description = "Private DNS zone names"
                                                  type        = map(string)
                                                  default = {
                                                              "file_dns_zone_name"      = "privatelink.file.core.windows.net"
                                                              "blob_dns_zone_name"      = "privatelink.blob.core.windows.net"
                                                              "table_dns_zone_name"     = "privatelink.table.core.windows.net"
                                                              "vault_dns_zone_name"     = "privatelink.vaultcore.azure.net"
                                                              "appconfig_dns_zone_name" = "privatelink.azconfig.io"
                                                            }
                                                }
variable "dns"                                  {
                                                  description = "The DNS label"
                                                  type        = string
                                                  default     = ""
                                                }
variable "dns_a_records_for_secondary_names"    {
                                                  description = "Boolean value indicating if dns a records should be created for the secondary DNS names"
                                                  type        = bool
                                                }
variable "ers_instance_number"                  {
                                                  description = "Instance number for ERS"
                                                  type        = string
                                                  default     = "02"
                                                }
variable "ers_server_loadbalancer_ip"                            {
                                                                   description = "ERS Load Balancer IP"
                                                                   type        = string
                                                                   default     = ""
                                                                 }
variable "hana_data"                            {
                                                  description = "Azure NetApp Files data volumes for SAP HANA, as returned by the hdb_node module"
                                                  type        = any
                                                }
variable "hana_log"                             {
                                                  description = "Azure NetApp Files log volumes for SAP HANA, as returned by the hdb_node module"
                                                  type        = any
                                                }
variable "hana_shared"                          {
                                                  description = "Shared volumes for SAP HANA, as returned by the hdb_node module"
                                                  type        = any
                                                }
variable "infrastructure"                       {
                                                  description = "Infrastructure settings of the SAP system. Only the attributes this module reads are declared; Terraform discards the rest."
                                                  type        = object({
                                                                  disk_controller_type_app_tier      = optional(string, "SCSI")
                                                                  disk_controller_type_database_tier = optional(string, "SCSI")
                                                                })
                                                }
variable "install_path"                         {
                                                  description = "Defines the install path for mounting /usr/sap/install"
                                                  type        = string
                                                  default     = ""
                                                }
variable "iSCSI_server_ips"                     {
                                                  description = "List of IP addresses for the iSCSI Servers"
                                                  type        = list(string)
                                                  default     = []
                                                }
variable "iSCSI_server_names"                   {
                                                  description = "List of host names for the iSCSI Servers"
                                                  type        = list(string)
                                                  default     = []
                                                }
variable "iSCSI_servers"                        {
                                                  description = "List of host names and IPs for the iSCSI Servers"
                                                  type        = any
                                                  default     = []
                                                }
variable "landscape_tfstate"                    {
                                                  description = "Outputs of the workload zone state, as returned by the sap_capabilities module. Only the attributes this module reads are declared; Terraform discards the rest. An attribute missing from an older state takes its default"
                                                  type        = object({
                                                                  dns_label = optional(string, "")
                                                                })
                                                  default     = {}
                                                  nullable    = false
                                                }
variable "loadbalancers"                        {
                                                  description = "Load balancers of the database tier, as returned by the hdb_node module"
                                                  type        = any
                                                }
variable "management_dns_resourcegroup_name"    {
                                                  description = "String value giving the possibility to register custom dns a records in a separate resourcegroup"
                                                  default     = null
                                                  type        = string
                                                }
variable "management_dns_subscription_id"       {
                                                  description = "String value giving the possibility to register custom dns a records in a separate subscription"
                                                  default     = null
                                                  type        = string
                                                }

variable "naming"                               {
                                                  description = "Defines the names for the resources: the output of the sap_namegenerator module, or a custom names file with the same structure. Left untyped because the module also writes the whole structure to the naming information file"
                                                  type        = any
                                                }
variable "NFS_provider"                         {
                                                  description = "Defines the NFS provider"
                                                  type        = string
                                                }
variable "observer_ips"                         {
                                                  description = "IP addresses of the observer virtual machines"
                                                  type        = list(string)
                                                }
variable "observer_vms"                         {
                                                  description = "Observer virtual machines, as returned by the database modules"
                                                  type        = any
                                                }
variable "observer_shared_disks"                {
                                                  description = "Shared disks of the observer virtual machines, as returned by the database modules"
                                                  type        = any
                                                }
variable "pas_instance_number"                  {
                                                  description = "Instance number for Primary Application Server"
                                                  type        = string
                                                  default     = "00"
                                                }
variable "platform"                             {
                                                  description = "Platform to use"
                                                  type        = string
                                                  default     = "HANA"
                                                }
variable "random_id"                            {
                                                  description = "Random hex string used to make resource names unique"
                                                  type        = string
                                                }
variable "sap_mnt"                              {
                                                  description = "ANF Volume for SAP mount"
                                                  type        = string
                                                  default     = ""
                                                }
variable "sap_sid"                              {
                                                  description = "The SAP system ID"
                                                  type        = string
                                                }
variable "sap_transport"                        {
                                                  description = "ANF Volume for SAP Transport"
                                                  type        = string
                                                  default     = ""
                                                }
variable "save_naming_information"              {
                                                  description = "If defined, will save the naming information for the resources"
                                                  type        = bool
                                                  default     = false
                                                }
variable "scale_out"                            {
                                                  description = "If true, the database tier will be configured for scaleout scenario"
                                                  type        = bool
                                                }
variable "scale_out_no_standby_role"            {
                                                  description = "If true, the database scale out tier will not have a standby role"
                                                  type        = bool
                                                }
variable "scs_shared_disks"                     {
                                                  description = "Shared disks of the central services cluster, as returned by the app_tier module"
                                                  type        = any
                                                }


variable "scs_cluster_loadbalancer_ip"          {
                                                  description = "IP address of the central services cluster load balancer"
                                                  type        = string
                                                }
variable "scs_cluster_type"                     {
                                                  description   = "Cluster quorum type; AFA (Azure Fencing Agent), ASD (Azure Shared Disk), ISCSI"
                                                  type          = string
                                                }
variable "scs_high_availability"                {
                                                  description = "If true, the SAP Central Services tier will be configured for high availability"
                                                  type        = bool
                                                  default     = false
                                                }
variable "scs_instance_number"                  {
                                                  description = "Instance number for SCS"
                                                  type        = string
                                                  default     = "00"
                                                }
variable "scs_server_loadbalancer_ip"           {
                                                  description = "SCS Load Balancer IP"
                                                  type        = string
                                                  default     = ""
                                                }
variable "scs_server_count"                     {
                                                  description = "Number of SCS Servers"
                                                  type    = number
                                                }
variable "scs_server_ips"                       {
                                                  description = "IP addresses of the central services servers"
                                                  type        = list(string)
                                                }
variable "scs_server_secondary_ips"             {
                                                  description = "Secondary IP addresses of the central services servers"
                                                  type        = list(string)
                                                }
variable "scs_server_vm_resource_ids"           {
                                                  description = "Azure resource IDs of the central services virtual machines"
                                                  type        = list(string)
                                                }
variable "scs_vm_names"                         {
                                                  description = "Names of the central services virtual machines"
                                                  type        = list(string)
                                                }
variable "shared_home"                          {
                                                  description = "If defined provides shared-home support"
                                                  type        = bool
                                                }
variable "sid_keyvault_user_id"                 {
                                                  description = "Azure resource ID of the key vault holding the SAP system credentials"
                                                  type        = string
                                                }
variable "subnet_cidr_storage"                  {
                                                  description = "Address prefix of the storage subnet"
                                                  type        = string
                                                }
variable "tfstate_resource_id"                  {
                                                  description = "Azure resource ID of the storage account holding the Terraform state"
                                                  type        = string
                                                }
variable "upgrade_packages"                     {
                                                  description = "If defined, will upgrade the packages on the virtual machines"
                                                  type        = bool
                                                }
variable "use_AFS_encryption_in_transit"        {
                                                  description = "True when Azure Files shares are mounted with encryption in transit"
                                                  type        = bool
                                                }
variable "suse_subscription_id"                  {
                                                   description = "SUSE registration code for BYOS/BYOL images"
                                                   type        = string
                                                   default     = ""
                                                 }
variable "use_custom_dns_a_registration"        {
                                                  description = "Boolean value indicating if a custom dns a record should be created when using private endpoints"
                                                  default     = false
                                                  type        = bool
                                                }
variable "use_local_credentials"                {
                                                  description = "True when the SAP system has its own credentials instead of the workload zone's"
                                                  type        = bool
                                                }
variable "use_msi_for_clusters"                 {
                                                  description = "If true, the Pacemaker cluser will use a managed identity"
                                                  type        = bool
                                                }
variable "use_secondary_ips"                    {
                                                  description = "Defines if secondary IPs are used for the SAP Systems virtual machines"
                                                  type        = bool
                                                }
variable "use_simple_mount"                     {
                                                  description = "Use simple mount"
                                                  type        = bool
                                                  default     = true
                                                }
variable "usr_sap"                              {
                                                  description = "NFS path of the /usr/sap share, or empty"
                                                  type        = string
                                                }
variable "user_assigned_identity_id"            {
                                                  description = "If provided defines the user assigned identity to assign to the virtual machines"
                                                  type        = string
                                                }
variable "web_instance_number"                  {
                                                  description = "The Instance number for Web Dispatcher"
                                                  type        = string
                                                  default     = "00"
                                                }
variable "web_server_count"                     {
                                                  description = "Number of Web Dispatchers"
                                                  type    = number
                                                }
variable "web_sid"                              {
                                                  description = "The sid of the web dispatchers"
                                                  type        = string
                                                  default     = ""
                                                }
variable "webdispatcher_server_ips"             {
                                                  description = "IP addresses of the web dispatchers"
                                                  type        = list(string)
                                                }
variable "webdispatcher_server_secondary_ips"   {
                                                  description = "Secondary IP addresses of the web dispatchers"
                                                  type        = list(string)
                                                }
variable "webdispatcher_server_vm_names"        {
                                                  description = "Names of the web dispatcher virtual machines"
                                                  type        = list(string)
                                                }

variable "ams_resource_id"                      {
                                                  description = "Azure resource ID of the Azure Monitor for SAP instance, or empty"
                                                  type        = string
                                                }
variable "enable_os_monitoring"                 {
                                                  description = "If defined, will enable prometheus os monitoring"
                                                  type        = bool
                                                }
variable "enable_ha_monitoring"                 {
                                                  description = "If defined, will enable prometheus high availability cluster monitoring"
                                                  type        = bool
                                                }

variable "site_information"                     {
                                                  description = "Site assignment of the SAP HANA nodes, as returned by the hdb_node module"
                                                  type        = any
                                                }
