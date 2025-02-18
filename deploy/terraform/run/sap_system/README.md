<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 3.0.2 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.11.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 3.0.2 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.11.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_anydb_node"></a> [anydb\_node](#module\_anydb\_node) | ../../terraform-units/modules/sap_system/anydb_node | n/a |
| <a name="module_app_tier"></a> [app\_tier](#module\_app\_tier) | ../../terraform-units/modules/sap_system/app_tier | n/a |
| <a name="module_common_infrastructure"></a> [common\_infrastructure](#module\_common\_infrastructure) | ../../terraform-units/modules/sap_system/common_infrastructure | n/a |
| <a name="module_hdb_node"></a> [hdb\_node](#module\_hdb\_node) | ../../terraform-units/modules/sap_system/hdb_node | n/a |
| <a name="module_output_files"></a> [output\_files](#module\_output\_files) | ../../terraform-units/modules/sap_system/output_files | n/a |
| <a name="module_sap_namegenerator"></a> [sap\_namegenerator](#module\_sap\_namegenerator) | ../../terraform-units/modules/sap_namegenerator | n/a |

## Resources

| Name | Type |
|------|------|
| [azuread_service_principal.sp](https://registry.terraform.io/providers/hashicorp/azuread/3.0.2/docs/data-sources/service_principal) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/4.11.0/docs/data-sources/client_config) | data source |
| [azurerm_key_vault_secret.client_id](https://registry.terraform.io/providers/hashicorp/azurerm/4.11.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.client_secret](https://registry.terraform.io/providers/hashicorp/azurerm/4.11.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.cp_client_id](https://registry.terraform.io/providers/hashicorp/azurerm/4.11.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.cp_client_secret](https://registry.terraform.io/providers/hashicorp/azurerm/4.11.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.cp_subscription_id](https://registry.terraform.io/providers/hashicorp/azurerm/4.11.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.cp_tenant_id](https://registry.terraform.io/providers/hashicorp/azurerm/4.11.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.subscription_id](https://registry.terraform.io/providers/hashicorp/azurerm/4.11.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.tenant_id](https://registry.terraform.io/providers/hashicorp/azurerm/4.11.0/docs/data-sources/key_vault_secret) | data source |
| [terraform_remote_state.deployer](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.landscape](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ANF_HANA_data"></a> [ANF\_HANA\_data](#input\_ANF\_HANA\_data) | If defined, will create ANF volumes for HANA data | `bool` | `false` | no |
| <a name="input_ANF_HANA_data_use_existing_volume"></a> [ANF\_HANA\_data\_use\_existing\_volume](#input\_ANF\_HANA\_data\_use\_existing\_volume) | Use existing data volume | `bool` | `false` | no |
| <a name="input_ANF_HANA_data_volume_count"></a> [ANF\_HANA\_data\_volume\_count](#input\_ANF\_HANA\_data\_volume\_count) | If defined provides the number of data volumes | `number` | `1` | no |
| <a name="input_ANF_HANA_data_volume_name"></a> [ANF\_HANA\_data\_volume\_name](#input\_ANF\_HANA\_data\_volume\_name) | Data volume name | `list` | <pre>[<br/>  ""<br/>]</pre> | no |
| <a name="input_ANF_HANA_data_volume_size"></a> [ANF\_HANA\_data\_volume\_size](#input\_ANF\_HANA\_data\_volume\_size) | If defined provides the size of the HANA data volume | `number` | `512` | no |
| <a name="input_ANF_HANA_data_volume_throughput"></a> [ANF\_HANA\_data\_volume\_throughput](#input\_ANF\_HANA\_data\_volume\_throughput) | If defined provides the throughput of the data volume | `number` | `128` | no |
| <a name="input_ANF_HANA_log"></a> [ANF\_HANA\_log](#input\_ANF\_HANA\_log) | If defined, will create ANF volumes for HANA log | `bool` | `false` | no |
| <a name="input_ANF_HANA_log_use_existing"></a> [ANF\_HANA\_log\_use\_existing](#input\_ANF\_HANA\_log\_use\_existing) | Use existing log volume | `bool` | `false` | no |
| <a name="input_ANF_HANA_log_volume_count"></a> [ANF\_HANA\_log\_volume\_count](#input\_ANF\_HANA\_log\_volume\_count) | If defined provides the number of data volumes | `number` | `1` | no |
| <a name="input_ANF_HANA_log_volume_name"></a> [ANF\_HANA\_log\_volume\_name](#input\_ANF\_HANA\_log\_volume\_name) | Log volume name | `list` | <pre>[<br/>  ""<br/>]</pre> | no |
| <a name="input_ANF_HANA_log_volume_size"></a> [ANF\_HANA\_log\_volume\_size](#input\_ANF\_HANA\_log\_volume\_size) | If defined provides the size of the HANA log volume | `number` | `512` | no |
| <a name="input_ANF_HANA_log_volume_throughput"></a> [ANF\_HANA\_log\_volume\_throughput](#input\_ANF\_HANA\_log\_volume\_throughput) | If defined provides the throughput of the log volume | `number` | `128` | no |
| <a name="input_ANF_HANA_shared"></a> [ANF\_HANA\_shared](#input\_ANF\_HANA\_shared) | If defined, will create ANF volumes for HANA shared | `bool` | `false` | no |
| <a name="input_ANF_HANA_shared_use_existing"></a> [ANF\_HANA\_shared\_use\_existing](#input\_ANF\_HANA\_shared\_use\_existing) | Use existing shared volume | `bool` | `false` | no |
| <a name="input_ANF_HANA_shared_volume_name"></a> [ANF\_HANA\_shared\_volume\_name](#input\_ANF\_HANA\_shared\_volume\_name) | If defined provides the name of the HANA shared volume | `number` | `512` | no |
| <a name="input_ANF_HANA_shared_volume_size"></a> [ANF\_HANA\_shared\_volume\_size](#input\_ANF\_HANA\_shared\_volume\_size) | If defined provides the size of the HANA shared volume | `number` | `512` | no |
| <a name="input_ANF_HANA_shared_volume_throughput"></a> [ANF\_HANA\_shared\_volume\_throughput](#input\_ANF\_HANA\_shared\_volume\_throughput) | If defined provides the throughput of the /shared volume | `number` | `128` | no |
| <a name="input_ANF_HANA_use_AVG"></a> [ANF\_HANA\_use\_AVG](#input\_ANF\_HANA\_use\_AVG) | Use Application Volume Group for data volume | `bool` | `false` | no |
| <a name="input_ANF_HANA_use_Zones"></a> [ANF\_HANA\_use\_Zones](#input\_ANF\_HANA\_use\_Zones) | Use zonal ANF deployments | `bool` | `false` | no |
| <a name="input_ANF_sapmnt"></a> [ANF\_sapmnt](#input\_ANF\_sapmnt) | If defined, will create ANF volumes for /sapmnt | `bool` | `false` | no |
| <a name="input_ANF_sapmnt_use_clone_in_secondary_zone"></a> [ANF\_sapmnt\_use\_clone\_in\_secondary\_zone](#input\_ANF\_sapmnt\_use\_clone\_in\_secondary\_zone) | Create a clone in the secondary region | `bool` | `false` | no |
| <a name="input_ANF_sapmnt_use_existing"></a> [ANF\_sapmnt\_use\_existing](#input\_ANF\_sapmnt\_use\_existing) | Use existing sapmnt volume | `bool` | `false` | no |
| <a name="input_ANF_sapmnt_volume_name"></a> [ANF\_sapmnt\_volume\_name](#input\_ANF\_sapmnt\_volume\_name) | sapmnt volume name | `string` | `""` | no |
| <a name="input_ANF_sapmnt_volume_size"></a> [ANF\_sapmnt\_volume\_size](#input\_ANF\_sapmnt\_volume\_size) | If defined provides the size of the sapmnt volume | `number` | `64` | no |
| <a name="input_ANF_sapmnt_volume_throughput"></a> [ANF\_sapmnt\_volume\_throughput](#input\_ANF\_sapmnt\_volume\_throughput) | If defined provides the throughput of the sapmnt volume | `number` | `64` | no |
| <a name="input_ANF_usr_sap"></a> [ANF\_usr\_sap](#input\_ANF\_usr\_sap) | If defined, will create ANF volumes for /usr/sap | `bool` | `false` | no |
| <a name="input_ANF_usr_sap_throughput"></a> [ANF\_usr\_sap\_throughput](#input\_ANF\_usr\_sap\_throughput) | If defined provides the throughput of the /usr/sap volume | `number` | `128` | no |
| <a name="input_ANF_usr_sap_use_existing"></a> [ANF\_usr\_sap\_use\_existing](#input\_ANF\_usr\_sap\_use\_existing) | Use existing  /usr/sap volume | `bool` | `false` | no |
| <a name="input_ANF_usr_sap_volume_name"></a> [ANF\_usr\_sap\_volume\_name](#input\_ANF\_usr\_sap\_volume\_name) | If defined provides the name of the /usr/sap volume | `string` | `""` | no |
| <a name="input_ANF_usr_sap_volume_size"></a> [ANF\_usr\_sap\_volume\_size](#input\_ANF\_usr\_sap\_volume\_size) | If defined provides the size of the  /usr/sap volume | `number` | `512` | no |
| <a name="input_Agent_IP"></a> [Agent\_IP](#input\_Agent\_IP) | If provided, contains the IP address of the agent | `string` | `""` | no |
| <a name="input_Description"></a> [Description](#input\_Description) | This is the description for the deployment | `string` | `""` | no |
| <a name="input_NFS_provider"></a> [NFS\_provider](#input\_NFS\_provider) | NFS Provider, valid values are 'AFS', 'ANF' or 'NONE' | `string` | `"NONE"` | no |
| <a name="input_add_Agent_IP"></a> [add\_Agent\_IP](#input\_add\_Agent\_IP) | Boolean value indicating if the Agent IP should be added to the storage and key vault firewalls | `bool` | `true` | no |
| <a name="input_admin_subnet_address_prefix"></a> [admin\_subnet\_address\_prefix](#input\_admin\_subnet\_address\_prefix) | The address prefix for the admin subnet | `string` | `""` | no |
| <a name="input_admin_subnet_arm_id"></a> [admin\_subnet\_arm\_id](#input\_admin\_subnet\_arm\_id) | If provided, Azure resource id for the admin subnet | `string` | `""` | no |
| <a name="input_admin_subnet_name"></a> [admin\_subnet\_name](#input\_admin\_subnet\_name) | If provided, the name of the admin subnet | `string` | `""` | no |
| <a name="input_admin_subnet_nsg_arm_id"></a> [admin\_subnet\_nsg\_arm\_id](#input\_admin\_subnet\_nsg\_arm\_id) | If provided, Azure resource id for the admin subnet NSG | `string` | `""` | no |
| <a name="input_admin_subnet_nsg_name"></a> [admin\_subnet\_nsg\_name](#input\_admin\_subnet\_nsg\_name) | If provided, the name of the admin subnet NSG | `string` | `""` | no |
| <a name="input_ams_resource_id"></a> [ams\_resource\_id](#input\_ams\_resource\_id) | [optional] If defined, will use the specified Azure Monitor for SAP instance, else will use the AMS instance in the workload zone. | `string` | `""` | no |
| <a name="input_anchor_vm_accelerated_networking"></a> [anchor\_vm\_accelerated\_networking](#input\_anchor\_vm\_accelerated\_networking) | If defined, will enable accelerated networking for the Anchor VM | `bool` | `true` | no |
| <a name="input_anchor_vm_authentication_type"></a> [anchor\_vm\_authentication\_type](#input\_anchor\_vm\_authentication\_type) | Authentication type of the Anchor VM | `string` | `"key"` | no |
| <a name="input_anchor_vm_authentication_username"></a> [anchor\_vm\_authentication\_username](#input\_anchor\_vm\_authentication\_username) | value of the username for the Anchor VM | `string` | `"azureadm"` | no |
| <a name="input_anchor_vm_image"></a> [anchor\_vm\_image](#input\_anchor\_vm\_image) | Image of the Anchor VM | `map` | <pre>{<br/>  "offer": "sles-sap-15-sp5",<br/>  "os_type": "LINUX",<br/>  "publisher": "SUSE",<br/>  "sku": "gen2",<br/>  "source_image_id": "",<br/>  "version": "latest"<br/>}</pre> | no |
| <a name="input_anchor_vm_nic_ips"></a> [anchor\_vm\_nic\_ips](#input\_anchor\_vm\_nic\_ips) | IP addresses of the NICs for the Anchor VM | `list` | `[]` | no |
| <a name="input_anchor_vm_sku"></a> [anchor\_vm\_sku](#input\_anchor\_vm\_sku) | SKU of the Anchor VM | `string` | `"Standard_D2s_v4"` | no |
| <a name="input_anchor_vm_use_DHCP"></a> [anchor\_vm\_use\_DHCP](#input\_anchor\_vm\_use\_DHCP) | If defined, will use Azure provided IP addresses for the Anchor VM | `bool` | `false` | no |
| <a name="input_api-version"></a> [api-version](#input\_api-version) | IMDS API Version | `string` | `"2019-04-30"` | no |
| <a name="input_app_disk_sizes_filename"></a> [app\_disk\_sizes\_filename](#input\_app\_disk\_sizes\_filename) | Custom disk configuration json file for application tier | `string` | `""` | no |
| <a name="input_app_instance_number"></a> [app\_instance\_number](#input\_app\_instance\_number) | The Instance number for the Application Server Imnstance | `string` | `"00"` | no |
| <a name="input_app_proximityplacementgroup_arm_ids"></a> [app\_proximityplacementgroup\_arm\_ids](#input\_app\_proximityplacementgroup\_arm\_ids) | If provided, azure resource ids for the application proximity placement groups | `list` | `[]` | no |
| <a name="input_app_proximityplacementgroup_names"></a> [app\_proximityplacementgroup\_names](#input\_app\_proximityplacementgroup\_names) | If provided, names of the application proximity placement groups | `list` | `[]` | no |
| <a name="input_app_subnet_address_prefix"></a> [app\_subnet\_address\_prefix](#input\_app\_subnet\_address\_prefix) | The address prefix for the app subnet | `string` | `""` | no |
| <a name="input_app_subnet_arm_id"></a> [app\_subnet\_arm\_id](#input\_app\_subnet\_arm\_id) | If provided, Azure resource id for the app subnet | `string` | `""` | no |
| <a name="input_app_subnet_name"></a> [app\_subnet\_name](#input\_app\_subnet\_name) | If provided, the name of the app subnet | `string` | `""` | no |
| <a name="input_app_subnet_nsg_arm_id"></a> [app\_subnet\_nsg\_arm\_id](#input\_app\_subnet\_nsg\_arm\_id) | If provided, Azure resource id for the app subnet NSG | `string` | `""` | no |
| <a name="input_app_subnet_nsg_name"></a> [app\_subnet\_nsg\_name](#input\_app\_subnet\_nsg\_name) | If provided, the name of the app subnet NSG | `string` | `""` | no |
| <a name="input_app_tier_authentication_type"></a> [app\_tier\_authentication\_type](#input\_app\_tier\_authentication\_type) | App tier authentication type | `string` | `"key"` | no |
| <a name="input_app_tier_dual_nics"></a> [app\_tier\_dual\_nics](#input\_app\_tier\_dual\_nics) | If true, the application tier virtual machines will have two NICs | `bool` | `false` | no |
| <a name="input_app_tier_sizing_dictionary_key"></a> [app\_tier\_sizing\_dictionary\_key](#input\_app\_tier\_sizing\_dictionary\_key) | Dictionary value to sizing json | `string` | `""` | no |
| <a name="input_app_tier_use_DHCP"></a> [app\_tier\_use\_DHCP](#input\_app\_tier\_use\_DHCP) | If true, the application tier virtual machines will use Azure provided IP addresses | `bool` | `false` | no |
| <a name="input_app_tier_vm_sizing"></a> [app\_tier\_vm\_sizing](#input\_app\_tier\_vm\_sizing) | Dictionary value to sizing json | `string` | `""` | no |
| <a name="input_application_server_admin_nic_ips"></a> [application\_server\_admin\_nic\_ips](#input\_application\_server\_admin\_nic\_ips) | IP addresses for the application servers (admin subnet) | `list` | `[]` | no |
| <a name="input_application_server_app_nic_ips"></a> [application\_server\_app\_nic\_ips](#input\_application\_server\_app\_nic\_ips) | IP addresses for the application servers | `list` | `[]` | no |
| <a name="input_application_server_count"></a> [application\_server\_count](#input\_application\_server\_count) | The number of application servers | `number` | `0` | no |
| <a name="input_application_server_image"></a> [application\_server\_image](#input\_application\_server\_image) | Virtual machine image to use for the application server | `map` | <pre>{<br/>  "offer": "",<br/>  "os_type": "LINUX",<br/>  "publisher": "",<br/>  "sku": "",<br/>  "source_image_id": "",<br/>  "version": ""<br/>}</pre> | no |
| <a name="input_application_server_nic_secondary_ips"></a> [application\_server\_nic\_secondary\_ips](#input\_application\_server\_nic\_secondary\_ips) | IP addresses for the application servers | `list` | `[]` | no |
| <a name="input_application_server_no_avset"></a> [application\_server\_no\_avset](#input\_application\_server\_no\_avset) | [Obsolete]If true, the application tier will not be placed availability set | `any` | `null` | no |
| <a name="input_application_server_no_ppg"></a> [application\_server\_no\_ppg](#input\_application\_server\_no\_ppg) | [Obsolete]If provided, the application servers will not be placed in a proximity placement group | `any` | `null` | no |
| <a name="input_application_server_sku"></a> [application\_server\_sku](#input\_application\_server\_sku) | The SKU for the application servers | `string` | `""` | no |
| <a name="input_application_server_tags"></a> [application\_server\_tags](#input\_application\_server\_tags) | The tags for the application servers | `map` | `{}` | no |
| <a name="input_application_server_use_avset"></a> [application\_server\_use\_avset](#input\_application\_server\_use\_avset) | If true, the application tier will be placed in an availability set | `any` | `null` | no |
| <a name="input_application_server_use_ppg"></a> [application\_server\_use\_ppg](#input\_application\_server\_use\_ppg) | If provided, the application servers will be placed in a proximity placement group | `any` | `null` | no |
| <a name="input_application_server_vm_avset_arm_ids"></a> [application\_server\_vm\_avset\_arm\_ids](#input\_application\_server\_vm\_avset\_arm\_ids) | If provided, Azure resource ids for the availability sets to use for the application servers | `list` | `[]` | no |
| <a name="input_application_server_zones"></a> [application\_server\_zones](#input\_application\_server\_zones) | The zones for the application servers | `list` | `[]` | no |
| <a name="input_application_tier"></a> [application\_tier](#input\_application\_tier) | Details of the Application layer | `map` | <pre>{<br/>  "application_server_count": 0,<br/>  "dual_nics": false,<br/>  "enable_deployment": true,<br/>  "use_DHCP": false<br/>}</pre> | no |
| <a name="input_authentication"></a> [authentication](#input\_authentication) | Defining the SDU credentials | `map` | `{}` | no |
| <a name="input_auto-deploy-version"></a> [auto-deploy-version](#input\_auto-deploy-version) | Version for automated deployment | `string` | `"v2"` | no |
| <a name="input_automation_password"></a> [automation\_password](#input\_automation\_password) | If provided, the password for the automation account | `string` | `""` | no |
| <a name="input_automation_path_to_private_key"></a> [automation\_path\_to\_private\_key](#input\_automation\_path\_to\_private\_key) | If provided, the path to the existing private key for the automation account | `string` | `""` | no |
| <a name="input_automation_path_to_public_key"></a> [automation\_path\_to\_public\_key](#input\_automation\_path\_to\_public\_key) | If provided, the path to the existing public key for the automation account | `string` | `""` | no |
| <a name="input_automation_username"></a> [automation\_username](#input\_automation\_username) | The username for the automation account | `string` | `""` | no |
| <a name="input_azure_files_sapmnt_id"></a> [azure\_files\_sapmnt\_id](#input\_azure\_files\_sapmnt\_id) | Azure File Share ID for SAPMNT | `string` | `""` | no |
| <a name="input_bom_name"></a> [bom\_name](#input\_bom\_name) | Name of the SAP Application Bill of Material file | `string` | `""` | no |
| <a name="input_calapi_kv"></a> [calapi\_kv](#input\_calapi\_kv) | The SAP CAL API Key Vault | `string` | `""` | no |
| <a name="input_codename"></a> [codename](#input\_codename) | This is the code name for the deployment | `string` | `""` | no |
| <a name="input_configuration_settings"></a> [configuration\_settings](#input\_configuration\_settings) | This is a dictionary that will contain values persisted to the sap-parameters.file | `map` | `{}` | no |
| <a name="input_custom_disk_sizes_filename"></a> [custom\_disk\_sizes\_filename](#input\_custom\_disk\_sizes\_filename) | Custom disk configuration json file for Virtual machines | `string` | `""` | no |
| <a name="input_custom_prefix"></a> [custom\_prefix](#input\_custom\_prefix) | Optional custom prefix for the deployment | `string` | `""` | no |
| <a name="input_custom_random_id"></a> [custom\_random\_id](#input\_custom\_random\_id) | If provided, the value of the custom random id | `string` | `""` | no |
| <a name="input_data_plane_available"></a> [data\_plane\_available](#input\_data\_plane\_available) | Boolean value indicating if storage account access is via data plane | `bool` | `false` | no |
| <a name="input_database_HANA_no_standby_role"></a> [database\_HANA\_no\_standby\_role](#input\_database\_HANA\_no\_standby\_role) | If true, the database scale out tier will not have a standby role | `bool` | `false` | no |
| <a name="input_database_HANA_use_scaleout_scenario"></a> [database\_HANA\_use\_scaleout\_scenario](#input\_database\_HANA\_use\_scaleout\_scenario) | If true, the database tier will be configured for scaleout scenario | `bool` | `false` | no |
| <a name="input_database_active_active"></a> [database\_active\_active](#input\_database\_active\_active) | If true, database will deployed with Active/Active (read enabled) configuration, only supported for HANA | `bool` | `false` | no |
| <a name="input_database_cluster_disk_lun"></a> [database\_cluster\_disk\_lun](#input\_database\_cluster\_disk\_lun) | The LUN of the shared disk for the Database cluster | `number` | `8` | no |
| <a name="input_database_cluster_disk_size"></a> [database\_cluster\_disk\_size](#input\_database\_cluster\_disk\_size) | The size of the shared disk for the Database cluster | `number` | `128` | no |
| <a name="input_database_cluster_disk_type"></a> [database\_cluster\_disk\_type](#input\_database\_cluster\_disk\_type) | The storage\_account\_type of the shared disk for the Database cluster | `string` | `"Premium_ZRS"` | no |
| <a name="input_database_cluster_type"></a> [database\_cluster\_type](#input\_database\_cluster\_type) | Cluster quorum type; AFA (Azure Fencing Agent), ASD (Azure Shared Disk), ISCSI | `string` | `"AFA"` | no |
| <a name="input_database_dual_nics"></a> [database\_dual\_nics](#input\_database\_dual\_nics) | If true, the database tier will have be deployed with two network interfaces | `bool` | `false` | no |
| <a name="input_database_high_availability"></a> [database\_high\_availability](#input\_database\_high\_availability) | If true, the database tier will be configured for high availability | `bool` | `false` | no |
| <a name="input_database_instance_number"></a> [database\_instance\_number](#input\_database\_instance\_number) | The Instance number for the database server | `string` | `"00"` | no |
| <a name="input_database_loadbalancer_ips"></a> [database\_loadbalancer\_ips](#input\_database\_loadbalancer\_ips) | If provided, the database tier's load balancer will be configured with the specified load balancer IPs | `list` | `[]` | no |
| <a name="input_database_no_avset"></a> [database\_no\_avset](#input\_database\_no\_avset) | [Obsolete] If true, the database tier will not use an availability set | `any` | `null` | no |
| <a name="input_database_no_ppg"></a> [database\_no\_ppg](#input\_database\_no\_ppg) | [Obsolete] If provided, the database tier will not be placed in a proximity placement group | `any` | `null` | no |
| <a name="input_database_platform"></a> [database\_platform](#input\_database\_platform) | Database platform, supported values are HANA, DB2, ORACLE, ORACLE-ASM, ASE, SQLSERVER or NONE (in this case no database tier is deployed) | `string` | `""` | no |
| <a name="input_database_server_count"></a> [database\_server\_count](#input\_database\_server\_count) | The number of database servers | `number` | `1` | no |
| <a name="input_database_sid"></a> [database\_sid](#input\_database\_sid) | The database SID | `string` | `"HDB"` | no |
| <a name="input_database_size"></a> [database\_size](#input\_database\_size) | Dictionary key value to sizing json | `string` | `""` | no |
| <a name="input_database_tags"></a> [database\_tags](#input\_database\_tags) | If provided, the database tier virtual machines will be configured with the specified tags | `map` | `{}` | no |
| <a name="input_database_use_avset"></a> [database\_use\_avset](#input\_database\_use\_avset) | If true, the database tier will use an availability set | `any` | `null` | no |
| <a name="input_database_use_ppg"></a> [database\_use\_ppg](#input\_database\_use\_ppg) | If provided, the database tier will be placed in a proximity placement group | `any` | `null` | no |
| <a name="input_database_use_premium_v2_storage"></a> [database\_use\_premium\_v2\_storage](#input\_database\_use\_premium\_v2\_storage) | If true, the database tier will use premium storage v2 | `bool` | `false` | no |
| <a name="input_database_vm_admin_nic_ips"></a> [database\_vm\_admin\_nic\_ips](#input\_database\_vm\_admin\_nic\_ips) | If provided, the database tier virtual machines will be configured with the specified IPs (admin subnet) | `list` | <pre>[<br/>  ""<br/>]</pre> | no |
| <a name="input_database_vm_authentication_type"></a> [database\_vm\_authentication\_type](#input\_database\_vm\_authentication\_type) | Authentication type for the database server | `string` | `"key"` | no |
| <a name="input_database_vm_avset_arm_ids"></a> [database\_vm\_avset\_arm\_ids](#input\_database\_vm\_avset\_arm\_ids) | If provided, Azure resource ids for the availability sets to use for the database servers | `list` | `[]` | no |
| <a name="input_database_vm_db_nic_ips"></a> [database\_vm\_db\_nic\_ips](#input\_database\_vm\_db\_nic\_ips) | If provided, the database tier virtual machines will be configured using the specified IPs | `list` | <pre>[<br/>  ""<br/>]</pre> | no |
| <a name="input_database_vm_db_nic_secondary_ips"></a> [database\_vm\_db\_nic\_secondary\_ips](#input\_database\_vm\_db\_nic\_secondary\_ips) | If provided, the database tier virtual machines will be configured using the specified IPs as secondary IPs | `list` | <pre>[<br/>  ""<br/>]</pre> | no |
| <a name="input_database_vm_image"></a> [database\_vm\_image](#input\_database\_vm\_image) | Virtual machine image to use for the database server | `map` | <pre>{<br/>  "offer": "",<br/>  "os_type": "LINUX",<br/>  "publisher": "",<br/>  "sku": "",<br/>  "source_image_id": "",<br/>  "type": "custom",<br/>  "version": ""<br/>}</pre> | no |
| <a name="input_database_vm_sku"></a> [database\_vm\_sku](#input\_database\_vm\_sku) | The Virtual Machine SKU to use for the database virtual machines | `string` | `""` | no |
| <a name="input_database_vm_storage_nic_ips"></a> [database\_vm\_storage\_nic\_ips](#input\_database\_vm\_storage\_nic\_ips) | If provided, the database tier virtual machines will be configured with the specified IPs (storage subnet) | `list` | <pre>[<br/>  ""<br/>]</pre> | no |
| <a name="input_database_vm_use_DHCP"></a> [database\_vm\_use\_DHCP](#input\_database\_vm\_use\_DHCP) | If true, the database server will use Azure provided IP addresses | `bool` | `false` | no |
| <a name="input_database_vm_zones"></a> [database\_vm\_zones](#input\_database\_vm\_zones) | If provided, the database tier will be deployed in the specified zones | `list` | `[]` | no |
| <a name="input_databases"></a> [databases](#input\_databases) | Details of the database node | `list` | <pre>[<br/>  {<br/>    "use_DHCP": false<br/>  }<br/>]</pre> | no |
| <a name="input_db_disk_sizes_filename"></a> [db\_disk\_sizes\_filename](#input\_db\_disk\_sizes\_filename) | Custom disk configuration json file for database tier | `string` | `""` | no |
| <a name="input_db_sizing_dictionary_key"></a> [db\_sizing\_dictionary\_key](#input\_db\_sizing\_dictionary\_key) | Dictionary value to sizing json | `string` | `""` | no |
| <a name="input_db_subnet_address_prefix"></a> [db\_subnet\_address\_prefix](#input\_db\_subnet\_address\_prefix) | The address prefix for the db subnet | `string` | `""` | no |
| <a name="input_db_subnet_arm_id"></a> [db\_subnet\_arm\_id](#input\_db\_subnet\_arm\_id) | If provided, Azure resource id for the db subnet | `string` | `""` | no |
| <a name="input_db_subnet_name"></a> [db\_subnet\_name](#input\_db\_subnet\_name) | If provided, the name of the db subnet | `string` | `""` | no |
| <a name="input_db_subnet_nsg_arm_id"></a> [db\_subnet\_nsg\_arm\_id](#input\_db\_subnet\_nsg\_arm\_id) | If provided, Azure resource id for the db subnet NSG | `string` | `""` | no |
| <a name="input_db_subnet_nsg_name"></a> [db\_subnet\_nsg\_name](#input\_db\_subnet\_nsg\_name) | If provided, the name of the db subnet NSG | `string` | `""` | no |
| <a name="input_deploy_anchor_vm"></a> [deploy\_anchor\_vm](#input\_deploy\_anchor\_vm) | If defined, will deploy the Anchor VM to anchor the PPG | `bool` | `false` | no |
| <a name="input_deploy_application_security_groups"></a> [deploy\_application\_security\_groups](#input\_deploy\_application\_security\_groups) | Defines if application security groups should be deployed | `bool` | `true` | no |
| <a name="input_deploy_defender_extension"></a> [deploy\_defender\_extension](#input\_deploy\_defender\_extension) | If defined, will add the Microsoft.Azure.Security.Monitoring extension to the virtual machines | `bool` | `false` | no |
| <a name="input_deploy_monitoring_extension"></a> [deploy\_monitoring\_extension](#input\_deploy\_monitoring\_extension) | If defined, will add the Microsoft.Azure.Monitor.AzureMonitorLinuxAgent extension to the virtual machines | `bool` | `true` | no |
| <a name="input_deploy_v1_monitoring_extension"></a> [deploy\_v1\_monitoring\_extension](#input\_deploy\_v1\_monitoring\_extension) | Defines if the Microsoft.AzureCAT.AzureEnhancedMonitoring extension will be deployed | `bool` | `true` | no |
| <a name="input_deployer_tfstate_key"></a> [deployer\_tfstate\_key](#input\_deployer\_tfstate\_key) | The key of deployer's remote tfstate file | `string` | `""` | no |
| <a name="input_deployment"></a> [deployment](#input\_deployment) | The type of deployment | `string` | `"update"` | no |
| <a name="input_dns_a_records_for_secondary_names"></a> [dns\_a\_records\_for\_secondary\_names](#input\_dns\_a\_records\_for\_secondary\_names) | Boolean value indicating if dns a records should be created for the secondary DNS names | `bool` | `true` | no |
| <a name="input_dns_zone_names"></a> [dns\_zone\_names](#input\_dns\_zone\_names) | Private DNS zone names | `map(string)` | <pre>{<br/>  "blob_dns_zone_name": "privatelink.blob.core.windows.net",<br/>  "file_dns_zone_name": "privatelink.file.core.windows.net",<br/>  "vault_dns_zone_name": "privatelink.vaultcore.azure.net"<br/>}</pre> | no |
| <a name="input_enable_app_tier_deployment"></a> [enable\_app\_tier\_deployment](#input\_enable\_app\_tier\_deployment) | If true, the application tier will be deployed | `bool` | `true` | no |
| <a name="input_enable_firewall_for_keyvaults_and_storage"></a> [enable\_firewall\_for\_keyvaults\_and\_storage](#input\_enable\_firewall\_for\_keyvaults\_and\_storage) | Boolean value indicating if firewall should be enabled for key vaults and storage | `bool` | `true` | no |
| <a name="input_enable_ha_monitoring"></a> [enable\_ha\_monitoring](#input\_enable\_ha\_monitoring) | If defined, will enable prometheus high availability cluster monitoring | `bool` | `false` | no |
| <a name="input_enable_os_monitoring"></a> [enable\_os\_monitoring](#input\_enable\_os\_monitoring) | If defined, will enable prometheus os monitoring | `bool` | `false` | no |
| <a name="input_enable_purge_control_for_keyvaults"></a> [enable\_purge\_control\_for\_keyvaults](#input\_enable\_purge\_control\_for\_keyvaults) | Disables the purge protection for Azure keyvaults. | `bool` | `false` | no |
| <a name="input_enable_sap_cal"></a> [enable\_sap\_cal](#input\_enable\_sap\_cal) | If true, will enable the SAP CAL integration | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | This is the environment name for the deployment | `string` | `""` | no |
| <a name="input_ers_instance_number"></a> [ers\_instance\_number](#input\_ers\_instance\_number) | The instance number for ERS | `string` | `"02"` | no |
| <a name="input_fencing_role_name"></a> [fencing\_role\_name](#input\_fencing\_role\_name) | If specified the role name to use for the fencing agent | `string` | `"Virtual Machine Contributor"` | no |
| <a name="input_hanashared_id"></a> [hanashared\_id](#input\_hanashared\_id) | The Azure Resource identifier for the HANA shared volume storage account | `list` | `[]` | no |
| <a name="input_hanashared_private_endpoint_id"></a> [hanashared\_private\_endpoint\_id](#input\_hanashared\_private\_endpoint\_id) | The Azure Resource identifier for the private endpoint connection to the HANA shared volume | `list` | `[]` | no |
| <a name="input_idle_timeout_scs_ers"></a> [idle\_timeout\_scs\_ers](#input\_idle\_timeout\_scs\_ers) | Sets the idle timeout setting for the SCS and ERS loadbalancer | `number` | `30` | no |
| <a name="input_infrastructure"></a> [infrastructure](#input\_infrastructure) | Details of the Azure infrastructure to deploy the SAP landscape into | `map` | `{}` | no |
| <a name="input_key_vault"></a> [key\_vault](#input\_key\_vault) | Details of keyvault | `map` | `{}` | no |
| <a name="input_landscape_tfstate_key"></a> [landscape\_tfstate\_key](#input\_landscape\_tfstate\_key) | The key of sap landscape's remote tfstate file | `any` | n/a | yes |
| <a name="input_legacy_nic_order"></a> [legacy\_nic\_order](#input\_legacy\_nic\_order) | If defined, will reverse the order of the NICs | `bool` | `false` | no |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | Specifies the license type for the OS | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region for the resources | `string` | `""` | no |
| <a name="input_management_dns_resourcegroup_name"></a> [management\_dns\_resourcegroup\_name](#input\_management\_dns\_resourcegroup\_name) | String value giving the possibility to register custom dns a records in a separate resourcegroup | `string` | `""` | no |
| <a name="input_management_dns_subscription_id"></a> [management\_dns\_subscription\_id](#input\_management\_dns\_subscription\_id) | String value giving the possibility to register custom dns a records in a separate subscription | `string` | `""` | no |
| <a name="input_name_override_file"></a> [name\_override\_file](#input\_name\_override\_file) | If provided, contains a json formatted file defining the name overrides | `string` | `""` | no |
| <a name="input_network_logical_name"></a> [network\_logical\_name](#input\_network\_logical\_name) | The logical name of the virtual network, used for resource naming | `string` | `""` | no |
| <a name="input_nsg_asg_with_vnet"></a> [nsg\_asg\_with\_vnet](#input\_nsg\_asg\_with\_vnet) | If true, the network security group will be placed in the resource group containing the VNet | `bool` | `false` | no |
| <a name="input_observer_nic_ips"></a> [observer\_nic\_ips](#input\_observer\_nic\_ips) | If provided, the database tier observer virtual machines will be configured with the specified IPs (db subnet) | `list` | <pre>[<br/>  ""<br/>]</pre> | no |
| <a name="input_options"></a> [options](#input\_options) | Configuration options | `map` | <pre>{<br/>  "legacy_nic_order": false,<br/>  "nsg_asg_with_vnet": false,<br/>  "resource_offset": 0<br/>}</pre> | no |
| <a name="input_pas_instance_number"></a> [pas\_instance\_number](#input\_pas\_instance\_number) | The Instance number for the Primary Application Server | `string` | `"00"` | no |
| <a name="input_patch_assessment_mode"></a> [patch\_assessment\_mode](#input\_patch\_assessment\_mode) | If defined, define the patch mode for the virtual machines | `string` | `"ImageDefault"` | no |
| <a name="input_patch_mode"></a> [patch\_mode](#input\_patch\_mode) | If defined, define the patch mode for the virtual machines | `string` | `"ImageDefault"` | no |
| <a name="input_prevent_deletion_if_contains_resources"></a> [prevent\_deletion\_if\_contains\_resources](#input\_prevent\_deletion\_if\_contains\_resources) | Controls if resource groups are deleted even if they contain resources | `bool` | `true` | no |
| <a name="input_privatelink_dns_resourcegroup_name"></a> [privatelink\_dns\_resourcegroup\_name](#input\_privatelink\_dns\_resourcegroup\_name) | String value giving the possibility to register custom PrivateLink DNS A records in a separate resourcegroup | `string` | `""` | no |
| <a name="input_privatelink_dns_subscription_id"></a> [privatelink\_dns\_subscription\_id](#input\_privatelink\_dns\_subscription\_id) | String value giving the possibility to register custom PrivateLink DNS A records in a separate subscription | `string` | `""` | no |
| <a name="input_proximityplacementgroup_arm_ids"></a> [proximityplacementgroup\_arm\_ids](#input\_proximityplacementgroup\_arm\_ids) | If provided, azure resource ids for the proximity placement groups | `list` | `[]` | no |
| <a name="input_proximityplacementgroup_names"></a> [proximityplacementgroup\_names](#input\_proximityplacementgroup\_names) | If provided, names of the proximity placement groups | `list` | `[]` | no |
| <a name="input_register_endpoints_with_dns"></a> [register\_endpoints\_with\_dns](#input\_register\_endpoints\_with\_dns) | Boolean value indicating if endpoints should be registered to the dns zone | `bool` | `true` | no |
| <a name="input_register_storage_accounts_keyvaults_with_dns"></a> [register\_storage\_accounts\_keyvaults\_with\_dns](#input\_register\_storage\_accounts\_keyvaults\_with\_dns) | Boolean value indicating if storage accounts and key vaults should be registered to the corresponding dns zones | `bool` | `true` | no |
| <a name="input_resource_offset"></a> [resource\_offset](#input\_resource\_offset) | Provides an offset for the resource names (Server00 vs Server01) | `number` | `0` | no |
| <a name="input_resourcegroup_arm_id"></a> [resourcegroup\_arm\_id](#input\_resourcegroup\_arm\_id) | If provided, the Azure resource group id | `string` | `""` | no |
| <a name="input_resourcegroup_name"></a> [resourcegroup\_name](#input\_resourcegroup\_name) | If provided, the name of the resource group to be created | `string` | `""` | no |
| <a name="input_resourcegroup_tags"></a> [resourcegroup\_tags](#input\_resourcegroup\_tags) | If provided, tags for the resource group | `map` | `{}` | no |
| <a name="input_sap_cal_product_name"></a> [sap\_cal\_product\_name](#input\_sap\_cal\_product\_name) | If defined, will use SAP CAL for system installation | `string` | `""` | no |
| <a name="input_sapmnt_private_endpoint_id"></a> [sapmnt\_private\_endpoint\_id](#input\_sapmnt\_private\_endpoint\_id) | Azure Resource Identifier for an private endpoint connection | `string` | `""` | no |
| <a name="input_sapmnt_volume_size"></a> [sapmnt\_volume\_size](#input\_sapmnt\_volume\_size) | sapmnt volume size in GB | `number` | `128` | no |
| <a name="input_save_naming_information"></a> [save\_naming\_information](#input\_save\_naming\_information) | If defined, will save the naming information for the resources | `bool` | `false` | no |
| <a name="input_scaleset_id"></a> [scaleset\_id](#input\_scaleset\_id) | If defined the Flexible Virtual Machine Scale Sets for the deployment | `string` | `""` | no |
| <a name="input_scenario"></a> [scenario](#input\_scenario) | Deployment Scenario | `string` | `"HANA Database"` | no |
| <a name="input_scs_cluster_disk_lun"></a> [scs\_cluster\_disk\_lun](#input\_scs\_cluster\_disk\_lun) | The LUN of the shared disk for the SAP Central Services cluster | `number` | `5` | no |
| <a name="input_scs_cluster_disk_size"></a> [scs\_cluster\_disk\_size](#input\_scs\_cluster\_disk\_size) | The size of the shared disk for the SAP Central Services cluster | `number` | `128` | no |
| <a name="input_scs_cluster_disk_type"></a> [scs\_cluster\_disk\_type](#input\_scs\_cluster\_disk\_type) | The storage\_account\_type of the shared disk for the SAP Central Services cluster | `string` | `"Premium_ZRS"` | no |
| <a name="input_scs_cluster_type"></a> [scs\_cluster\_type](#input\_scs\_cluster\_type) | Cluster quorum type; AFA (Azure Fencing Agent), ASD (Azure Shared Disk), ISCSI | `string` | `"AFA"` | no |
| <a name="input_scs_high_availability"></a> [scs\_high\_availability](#input\_scs\_high\_availability) | If true, the SAP Central Services tier will be configured for high availability | `bool` | `false` | no |
| <a name="input_scs_instance_number"></a> [scs\_instance\_number](#input\_scs\_instance\_number) | The instance number for SCS | `string` | `"00"` | no |
| <a name="input_scs_server_admin_nic_ips"></a> [scs\_server\_admin\_nic\_ips](#input\_scs\_server\_admin\_nic\_ips) | If provided, the SAP Central Services virtual machines will be configured with the specified IPs  (admin subnet) | `list` | `[]` | no |
| <a name="input_scs_server_app_nic_ips"></a> [scs\_server\_app\_nic\_ips](#input\_scs\_server\_app\_nic\_ips) | If provided, the SAP Central Services virtual machines will be configured with the specified IPs | `list` | `[]` | no |
| <a name="input_scs_server_count"></a> [scs\_server\_count](#input\_scs\_server\_count) | The number of SAP Central Services servers to deploy | `number` | `0` | no |
| <a name="input_scs_server_image"></a> [scs\_server\_image](#input\_scs\_server\_image) | Virtual machine image to use for the SAP Central Services server(s) | `map` | <pre>{<br/>  "offer": "",<br/>  "os_type": "LINUX",<br/>  "publisher": "",<br/>  "sku": "",<br/>  "source_image_id": "",<br/>  "type": "Custom",<br/>  "version": ""<br/>}</pre> | no |
| <a name="input_scs_server_loadbalancer_ips"></a> [scs\_server\_loadbalancer\_ips](#input\_scs\_server\_loadbalancer\_ips) | If provided, the SAP Central Services virtual machines will be configured with the specified load balancer IPs | `list` | `[]` | no |
| <a name="input_scs_server_nic_secondary_ips"></a> [scs\_server\_nic\_secondary\_ips](#input\_scs\_server\_nic\_secondary\_ips) | If provided, the SAP Central Services virtual machines will be configured with the specified IPs as secondary IPs | `list` | `[]` | no |
| <a name="input_scs_server_no_avset"></a> [scs\_server\_no\_avset](#input\_scs\_server\_no\_avset) | [Obsolete] If true, the SAP Central Services tier will not use an availability set | `any` | `null` | no |
| <a name="input_scs_server_no_ppg"></a> [scs\_server\_no\_ppg](#input\_scs\_server\_no\_ppg) | [Obsolete] If provided, the Central Services will not be placed in a proximity placement group | `any` | `null` | no |
| <a name="input_scs_server_sku"></a> [scs\_server\_sku](#input\_scs\_server\_sku) | The Virtual Machine SKU to use for the SAP Central Services virtual machines | `string` | `""` | no |
| <a name="input_scs_server_tags"></a> [scs\_server\_tags](#input\_scs\_server\_tags) | If provided, the SAP Central Services tier will be configured with the specified tags | `map` | `{}` | no |
| <a name="input_scs_server_use_avset"></a> [scs\_server\_use\_avset](#input\_scs\_server\_use\_avset) | If true, the SAP Central Services tier will be placed in an availability set | `any` | `null` | no |
| <a name="input_scs_server_use_ppg"></a> [scs\_server\_use\_ppg](#input\_scs\_server\_use\_ppg) | If provided, the Central Services will be placed in a proximity placement group | `any` | `null` | no |
| <a name="input_scs_server_zones"></a> [scs\_server\_zones](#input\_scs\_server\_zones) | If provided, the SAP Central Services tier will be deployed in the specified zones | `list` | `[]` | no |
| <a name="input_shared_access_key_enabled"></a> [shared\_access\_key\_enabled](#input\_shared\_access\_key\_enabled) | Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. | `bool` | `false` | no |
| <a name="input_shared_access_key_enabled_nfs"></a> [shared\_access\_key\_enabled\_nfs](#input\_shared\_access\_key\_enabled\_nfs) | Indicates whether the storage account used for NFS permits requests to be authorized with the account access key via Shared Key. | `bool` | `false` | no |
| <a name="input_shared_home"></a> [shared\_home](#input\_shared\_home) | If defined provides shared-home support | `bool` | `false` | no |
| <a name="input_sid"></a> [sid](#input\_sid) | Application SID | `string` | `""` | no |
| <a name="input_spn_keyvault_id"></a> [spn\_keyvault\_id](#input\_spn\_keyvault\_id) | If provided, the Azure resource identifier of the deployment credential keyvault | `string` | `""` | no |
| <a name="input_ssh-timeout"></a> [ssh-timeout](#input\_ssh-timeout) | Timeout for connection that is used by provisioner | `string` | `"30s"` | no |
| <a name="input_stand_by_node_count"></a> [stand\_by\_node\_count](#input\_stand\_by\_node\_count) | The number of standby nodes | `number` | `0` | no |
| <a name="input_storage_subnet_address_prefix"></a> [storage\_subnet\_address\_prefix](#input\_storage\_subnet\_address\_prefix) | The address prefix for the storage subnet | `string` | `""` | no |
| <a name="input_storage_subnet_arm_id"></a> [storage\_subnet\_arm\_id](#input\_storage\_subnet\_arm\_id) | If provided, Azure resource id for the storage subnet | `string` | `""` | no |
| <a name="input_storage_subnet_name"></a> [storage\_subnet\_name](#input\_storage\_subnet\_name) | If provided, the name of the storage subnet | `string` | `""` | no |
| <a name="input_storage_subnet_nsg_arm_id"></a> [storage\_subnet\_nsg\_arm\_id](#input\_storage\_subnet\_nsg\_arm\_id) | If provided, Azure resource id for the storage subnet NSG | `string` | `""` | no |
| <a name="input_storage_subnet_nsg_name"></a> [storage\_subnet\_nsg\_name](#input\_storage\_subnet\_nsg\_name) | If provided, the name of the storage subnet NSG | `string` | `""` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Target subscription | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | If provided, tags for all resources | `map` | `{}` | no |
| <a name="input_terraform_template_version"></a> [terraform\_template\_version](#input\_terraform\_template\_version) | The version of Terraform templates that were identified in the state file | `string` | `""` | no |
| <a name="input_tfstate_resource_id"></a> [tfstate\_resource\_id](#input\_tfstate\_resource\_id) | Resource id of tfstate storage account | `any` | n/a | yes |
| <a name="input_upgrade_packages"></a> [upgrade\_packages](#input\_upgrade\_packages) | If defined, will upgrade the packages on the virtual machines | `bool` | `false` | no |
| <a name="input_use_app_proximityplacementgroups"></a> [use\_app\_proximityplacementgroups](#input\_use\_app\_proximityplacementgroups) | Boolean value indicating if an proximity placement group should be used for the app tier VMs | `bool` | `false` | no |
| <a name="input_use_custom_dns_a_registration"></a> [use\_custom\_dns\_a\_registration](#input\_use\_custom\_dns\_a\_registration) | Boolean value indicating if a custom dns a record should be created when using private endpoints | `bool` | `false` | no |
| <a name="input_use_fence_kdump"></a> [use\_fence\_kdump](#input\_use\_fence\_kdump) | Configure fencing device based on the fence agent fence\_kdump for both SCS and DB clusters | `bool` | `false` | no |
| <a name="input_use_fence_kdump_lun_db"></a> [use\_fence\_kdump\_lun\_db](#input\_use\_fence\_kdump\_lun\_db) | Default lun number of the kdump disk which will be attached to the VMs which are part of DB cluster | `number` | `8` | no |
| <a name="input_use_fence_kdump_lun_scs"></a> [use\_fence\_kdump\_lun\_scs](#input\_use\_fence\_kdump\_lun\_scs) | Default lun number of the kdump disk which will be attached to the VMs which are part of SCS cluster | `number` | `4` | no |
| <a name="input_use_fence_kdump_size_gb_db"></a> [use\_fence\_kdump\_size\_gb\_db](#input\_use\_fence\_kdump\_size\_gb\_db) | Default size of the kdump disk which will be attached to the VMs which are part DB cluster | `number` | `128` | no |
| <a name="input_use_fence_kdump_size_gb_scs"></a> [use\_fence\_kdump\_size\_gb\_scs](#input\_use\_fence\_kdump\_size\_gb\_scs) | Default size of the kdump disk which will be attached to the VMs which are part of SCS cluster | `number` | `64` | no |
| <a name="input_use_loadbalancers_for_standalone_deployments"></a> [use\_loadbalancers\_for\_standalone\_deployments](#input\_use\_loadbalancers\_for\_standalone\_deployments) | If defined, will use load balancers for standalone deployments | `bool` | `true` | no |
| <a name="input_use_msi_for_clusters"></a> [use\_msi\_for\_clusters](#input\_use\_msi\_for\_clusters) | If true, the Pacemaker cluser will use a managed identity | `bool` | `false` | no |
| <a name="input_use_observer"></a> [use\_observer](#input\_use\_observer) | If true, an observer virtual machine will be used | `bool` | `true` | no |
| <a name="input_use_prefix"></a> [use\_prefix](#input\_use\_prefix) | Defines if the resources are to be prefixed | `bool` | `true` | no |
| <a name="input_use_private_endpoint"></a> [use\_private\_endpoint](#input\_use\_private\_endpoint) | Boolean value indicating if private endpoint should be used for the deployment | `bool` | `true` | no |
| <a name="input_use_random_id_for_storageaccounts"></a> [use\_random\_id\_for\_storageaccounts](#input\_use\_random\_id\_for\_storageaccounts) | If true, will use random id for storage accounts | `bool` | `false` | no |
| <a name="input_use_scalesets_for_deployment"></a> [use\_scalesets\_for\_deployment](#input\_use\_scalesets\_for\_deployment) | Use Flexible Virtual Machine Scale Sets for the deployment | `bool` | `false` | no |
| <a name="input_use_secondary_ips"></a> [use\_secondary\_ips](#input\_use\_secondary\_ips) | Defines if secondary IPs are used for the SAP Systems virtual machines | `bool` | `false` | no |
| <a name="input_use_simple_mount"></a> [use\_simple\_mount](#input\_use\_simple\_mount) | Determine if simple mount needs to be added for SCS and DB clusters | `bool` | `false` | no |
| <a name="input_use_sles_saphanasr_angi"></a> [use\_sles\_saphanasr\_angi](#input\_use\_sles\_saphanasr\_angi) | If true, the SAP HANA SR cluster will be configured with SAP HANA SR - An Next Generation Interface | `bool` | `false` | no |
| <a name="input_use_spn"></a> [use\_spn](#input\_use\_spn) | Log in using a service principal when performing the deployment | `bool` | `false` | no |
| <a name="input_use_zonal_markers"></a> [use\_zonal\_markers](#input\_use\_zonal\_markers) | n/a | `bool` | `true` | no |
| <a name="input_user_assigned_identity_id"></a> [user\_assigned\_identity\_id](#input\_user\_assigned\_identity\_id) | If provided defines the user assigned identity to assign to the virtual machines | `string` | `""` | no |
| <a name="input_user_keyvault_id"></a> [user\_keyvault\_id](#input\_user\_keyvault\_id) | If provided, the Azure resource identifier of the credentials keyvault | `string` | `""` | no |
| <a name="input_vm_disk_encryption_set_id"></a> [vm\_disk\_encryption\_set\_id](#input\_vm\_disk\_encryption\_set\_id) | If provided, the VM disks will be encrypted with the specified disk encryption set | `string` | `""` | no |
| <a name="input_web_instance_number"></a> [web\_instance\_number](#input\_web\_instance\_number) | The Instance number for the Web dispatcher | `string` | `"00"` | no |
| <a name="input_web_sid"></a> [web\_sid](#input\_web\_sid) | The sid of the web dispatchers | `string` | `""` | no |
| <a name="input_web_subnet_address_prefix"></a> [web\_subnet\_address\_prefix](#input\_web\_subnet\_address\_prefix) | The address prefix for the web subnet | `string` | `""` | no |
| <a name="input_web_subnet_arm_id"></a> [web\_subnet\_arm\_id](#input\_web\_subnet\_arm\_id) | If provided, Azure resource id for the web subnet | `string` | `""` | no |
| <a name="input_web_subnet_name"></a> [web\_subnet\_name](#input\_web\_subnet\_name) | If provided, the name of the web subnet | `string` | `""` | no |
| <a name="input_web_subnet_nsg_arm_id"></a> [web\_subnet\_nsg\_arm\_id](#input\_web\_subnet\_nsg\_arm\_id) | If provided, Azure resource id for the web subnet NSG | `string` | `""` | no |
| <a name="input_web_subnet_nsg_name"></a> [web\_subnet\_nsg\_name](#input\_web\_subnet\_nsg\_name) | If provided, the name of the web subnet NSG | `string` | `""` | no |
| <a name="input_webdispatcher_server_admin_nic_ips"></a> [webdispatcher\_server\_admin\_nic\_ips](#input\_webdispatcher\_server\_admin\_nic\_ips) | The IP addresses for the web dispatchers (admin subnet) | `list` | `[]` | no |
| <a name="input_webdispatcher_server_app_nic_ips"></a> [webdispatcher\_server\_app\_nic\_ips](#input\_webdispatcher\_server\_app\_nic\_ips) | The IP addresses for the web dispatchers | `list` | `[]` | no |
| <a name="input_webdispatcher_server_count"></a> [webdispatcher\_server\_count](#input\_webdispatcher\_server\_count) | The number of web dispatchers | `number` | `0` | no |
| <a name="input_webdispatcher_server_image"></a> [webdispatcher\_server\_image](#input\_webdispatcher\_server\_image) | Virtual machine image to use for the web dispatchers | `map` | <pre>{<br/>  "offer": "",<br/>  "os_type": "LINUX",<br/>  "publisher": "",<br/>  "sku": "",<br/>  "source_image_id": "",<br/>  "version": ""<br/>}</pre> | no |
| <a name="input_webdispatcher_server_loadbalancer_ips"></a> [webdispatcher\_server\_loadbalancer\_ips](#input\_webdispatcher\_server\_loadbalancer\_ips) | If provided, the Web Dispatcher tier will be configured with the specified load balancer IPs | `list` | `[]` | no |
| <a name="input_webdispatcher_server_nic_secondary_ips"></a> [webdispatcher\_server\_nic\_secondary\_ips](#input\_webdispatcher\_server\_nic\_secondary\_ips) | If provided, the Web Dispatchers will be configured with the specified IPs as secondary IPs | `list` | `[]` | no |
| <a name="input_webdispatcher_server_no_avset"></a> [webdispatcher\_server\_no\_avset](#input\_webdispatcher\_server\_no\_avset) | [OBSOLUTE]If true, the Web Dispatcher tier will not use an availability set | `any` | `null` | no |
| <a name="input_webdispatcher_server_no_ppg"></a> [webdispatcher\_server\_no\_ppg](#input\_webdispatcher\_server\_no\_ppg) | [OBSOLUTE]If provided, the web dispatchers will not be placed in a proximity placement group | `any` | `null` | no |
| <a name="input_webdispatcher_server_sku"></a> [webdispatcher\_server\_sku](#input\_webdispatcher\_server\_sku) | The SKU for the web dispatchers | `string` | `""` | no |
| <a name="input_webdispatcher_server_tags"></a> [webdispatcher\_server\_tags](#input\_webdispatcher\_server\_tags) | The tags for the web dispatchers | `map` | `{}` | no |
| <a name="input_webdispatcher_server_use_avset"></a> [webdispatcher\_server\_use\_avset](#input\_webdispatcher\_server\_use\_avset) | If true, the Web Dispatcher tier will will be placed in an availability set | `bool` | `false` | no |
| <a name="input_webdispatcher_server_use_ppg"></a> [webdispatcher\_server\_use\_ppg](#input\_webdispatcher\_server\_use\_ppg) | If provided, the web dispatchers will be placed in a proximity placement group | `any` | `null` | no |
| <a name="input_webdispatcher_server_zones"></a> [webdispatcher\_server\_zones](#input\_webdispatcher\_server\_zones) | The zones for the web dispatchers | `list` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_id_used"></a> [app\_id\_used](#output\_app\_id\_used) | The App ID used in the deployment |
| <a name="output_app_vm_ids"></a> [app\_vm\_ids](#output\_app\_vm\_ids) | Virtual Machine IDs for the application servers |
| <a name="output_app_vm_ips"></a> [app\_vm\_ips](#output\_app\_vm\_ips) | Application Virtual Machine IPs |
| <a name="output_automation_version"></a> [automation\_version](#output\_automation\_version) | Defines the version of the terraform templates used in the deloyment |
| <a name="output_configuration_settings"></a> [configuration\_settings](#output\_configuration\_settings) | Additional configuration settings |
| <a name="output_created_resource_group_id"></a> [created\_resource\_group\_id](#output\_created\_resource\_group\_id) | Created resource group ID |
| <a name="output_created_resource_group_name"></a> [created\_resource\_group\_name](#output\_created\_resource\_group\_name) | Created resource group name |
| <a name="output_created_resource_group_subscription_id"></a> [created\_resource\_group\_subscription\_id](#output\_created\_resource\_group\_subscription\_id) | Created resource group' subscription ID |
| <a name="output_database_loadbalancer_id"></a> [database\_loadbalancer\_id](#output\_database\_loadbalancer\_id) | Database Loadbalancer Id |
| <a name="output_database_loadbalancer_ip"></a> [database\_loadbalancer\_ip](#output\_database\_loadbalancer\_ip) | DNS information for the database load balancer |
| <a name="output_database_server_vm_ids"></a> [database\_server\_vm\_ids](#output\_database\_server\_vm\_ids) | VM IDs for the AnyDB Servers |
| <a name="output_db_vm_ips"></a> [db\_vm\_ips](#output\_db\_vm\_ips) | Database Virtual Machine IPs |
| <a name="output_db_vm_secondary_ips"></a> [db\_vm\_secondary\_ips](#output\_db\_vm\_secondary\_ips) | Database Virtual Machine secondary IPs |
| <a name="output_disks"></a> [disks](#output\_disks) | Disks attached to the virtual machines |
| <a name="output_dns_information_anydb"></a> [dns\_information\_anydb](#output\_dns\_information\_anydb) | DNS information for the anydb servers |
| <a name="output_dns_information_app"></a> [dns\_information\_app](#output\_dns\_information\_app) | DNS information for the app tier servers |
| <a name="output_dns_information_hanadb"></a> [dns\_information\_hanadb](#output\_dns\_information\_hanadb) | DNS information for the HANA servers |
| <a name="output_dns_information_loadbalancers_anydb"></a> [dns\_information\_loadbalancers\_anydb](#output\_dns\_information\_loadbalancers\_anydb) | DNS information for the anydb loadbalancer |
| <a name="output_dns_information_loadbalancers_app"></a> [dns\_information\_loadbalancers\_app](#output\_dns\_information\_loadbalancers\_app) | DNS information for the application servers |
| <a name="output_dns_information_loadbalancers_hanadb"></a> [dns\_information\_loadbalancers\_hanadb](#output\_dns\_information\_loadbalancers\_hanadb) | DNS information for the HANA load balancer |
| <a name="output_environment"></a> [environment](#output\_environment) | Name of environment |
| <a name="output_hanadb_vm_ids"></a> [hanadb\_vm\_ids](#output\_hanadb\_vm\_ids) | VM IDs for the HANA Servers |
| <a name="output_management_dns_resourcegroup_name"></a> [management\_dns\_resourcegroup\_name](#output\_management\_dns\_resourcegroup\_name) | Resource group name for DNS resource group |
| <a name="output_management_dns_subscription_id"></a> [management\_dns\_subscription\_id](#output\_management\_dns\_subscription\_id) | Subscription Id for DNS resource group |
| <a name="output_random_id"></a> [random\_id](#output\_random\_id) | Random ID for system |
| <a name="output_region"></a> [region](#output\_region) | Azure region |
| <a name="output_sapmnt_path"></a> [sapmnt\_path](#output\_sapmnt\_path) | Path to the sapmnt folder |
| <a name="output_scs_loadbalancer_id"></a> [scs\_loadbalancer\_id](#output\_scs\_loadbalancer\_id) | SCS Loadbalancer Id |
| <a name="output_scs_loadbalancer_ips"></a> [scs\_loadbalancer\_ips](#output\_scs\_loadbalancer\_ips) | SCS Loadbalancer IP |
| <a name="output_scs_vm_ids"></a> [scs\_vm\_ids](#output\_scs\_vm\_ids) | Virtual Machine IDs for the Central Services servers |
| <a name="output_sid"></a> [sid](#output\_sid) | SID of the system |
| <a name="output_subscription_id_used"></a> [subscription\_id\_used](#output\_subscription\_id\_used) | The Subscription ID configured in the key vault |
| <a name="output_use_custom_dns_a_registration"></a> [use\_custom\_dns\_a\_registration](#output\_use\_custom\_dns\_a\_registration) | Use custom DNS registration |
| <a name="output_web_vm_ids"></a> [web\_vm\_ids](#output\_web\_vm\_ids) | Virtual Machine IDs for the Web Dispatcher servers |
<!-- END_TF_DOCS -->