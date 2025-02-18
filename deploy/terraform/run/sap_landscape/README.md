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
| <a name="module_sap_landscape"></a> [sap\_landscape](#module\_sap\_landscape) | ../../terraform-units/modules/sap_landscape | n/a |
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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ANF_account_arm_id"></a> [ANF\_account\_arm\_id](#input\_ANF\_account\_arm\_id) | If provided, The resource identifier for the NetApp account | `string` | `""` | no |
| <a name="input_ANF_account_name"></a> [ANF\_account\_name](#input\_ANF\_account\_name) | If provided, the NetApp account name | `string` | `""` | no |
| <a name="input_ANF_install_volume_name"></a> [ANF\_install\_volume\_name](#input\_ANF\_install\_volume\_name) | Install volume name | `string` | `""` | no |
| <a name="input_ANF_install_volume_size"></a> [ANF\_install\_volume\_size](#input\_ANF\_install\_volume\_size) | If defined provides the size of the install volume | `number` | `1024` | no |
| <a name="input_ANF_install_volume_throughput"></a> [ANF\_install\_volume\_throughput](#input\_ANF\_install\_volume\_throughput) | If defined provides the throughput of the install volume | `number` | `128` | no |
| <a name="input_ANF_install_volume_use_existing"></a> [ANF\_install\_volume\_use\_existing](#input\_ANF\_install\_volume\_use\_existing) | Use existing install volume | `bool` | `false` | no |
| <a name="input_ANF_install_volume_zone"></a> [ANF\_install\_volume\_zone](#input\_ANF\_install\_volume\_zone) | Install volume availability zone | `list` | <pre>[<br/>  ""<br/>]</pre> | no |
| <a name="input_ANF_pool_name"></a> [ANF\_pool\_name](#input\_ANF\_pool\_name) | If provided, the NetApp capacity pool name (if any) | `string` | `""` | no |
| <a name="input_ANF_pool_size"></a> [ANF\_pool\_size](#input\_ANF\_pool\_size) | The NetApp Pool size in TB | `number` | `4` | no |
| <a name="input_ANF_qos_type"></a> [ANF\_qos\_type](#input\_ANF\_qos\_type) | The Quality of Service type of the pool (Auto or Manual) | `string` | `"Manual"` | no |
| <a name="input_ANF_service_level"></a> [ANF\_service\_level](#input\_ANF\_service\_level) | The NetApp Service Level | `string` | `"Premium"` | no |
| <a name="input_ANF_transport_volume_name"></a> [ANF\_transport\_volume\_name](#input\_ANF\_transport\_volume\_name) | If defined provides the Transport volume name | `bool` | `false` | no |
| <a name="input_ANF_transport_volume_size"></a> [ANF\_transport\_volume\_size](#input\_ANF\_transport\_volume\_size) | If defined provides the size of the transport volume | `number` | `128` | no |
| <a name="input_ANF_transport_volume_throughput"></a> [ANF\_transport\_volume\_throughput](#input\_ANF\_transport\_volume\_throughput) | If defined provides the throughput of the transport volume | `number` | `128` | no |
| <a name="input_ANF_transport_volume_use_existing"></a> [ANF\_transport\_volume\_use\_existing](#input\_ANF\_transport\_volume\_use\_existing) | Use existing transport volume | `bool` | `false` | no |
| <a name="input_ANF_transport_volume_zone"></a> [ANF\_transport\_volume\_zone](#input\_ANF\_transport\_volume\_zone) | Transport volume availability zone | `list` | <pre>[<br/>  ""<br/>]</pre> | no |
| <a name="input_ANF_use_existing_pool"></a> [ANF\_use\_existing\_pool](#input\_ANF\_use\_existing\_pool) | Use existing storage pool | `bool` | `false` | no |
| <a name="input_Agent_IP"></a> [Agent\_IP](#input\_Agent\_IP) | If provided, contains the IP address of the agent | `string` | `""` | no |
| <a name="input_Description"></a> [Description](#input\_Description) | This is the description for the deployment | `string` | `""` | no |
| <a name="input_NFS_provider"></a> [NFS\_provider](#input\_NFS\_provider) | n/a | `string` | `"NONE"` | no |
| <a name="input_add_Agent_IP"></a> [add\_Agent\_IP](#input\_add\_Agent\_IP) | Boolean value indicating if the Agent IP should be added to the storage and key vault firewalls | `bool` | `true` | no |
| <a name="input_additional_network_id"></a> [additional\_network\_id](#input\_additional\_network\_id) | Agent Network resource ID | `string` | `""` | no |
| <a name="input_additional_users_to_add_to_keyvault_policies"></a> [additional\_users\_to\_add\_to\_keyvault\_policies](#input\_additional\_users\_to\_add\_to\_keyvault\_policies) | List of object IDs to add to key vault policies | `list` | <pre>[<br/>  ""<br/>]</pre> | no |
| <a name="input_admin_subnet_address_prefix"></a> [admin\_subnet\_address\_prefix](#input\_admin\_subnet\_address\_prefix) | The address prefix for the admin subnet | `string` | `""` | no |
| <a name="input_admin_subnet_arm_id"></a> [admin\_subnet\_arm\_id](#input\_admin\_subnet\_arm\_id) | If provided, Azure resource id for the admin subnet | `string` | `""` | no |
| <a name="input_admin_subnet_name"></a> [admin\_subnet\_name](#input\_admin\_subnet\_name) | If provided, the name of the admin subnet | `string` | `""` | no |
| <a name="input_admin_subnet_nsg_arm_id"></a> [admin\_subnet\_nsg\_arm\_id](#input\_admin\_subnet\_nsg\_arm\_id) | If provided, Azure resource id for the admin subnet NSG | `string` | `""` | no |
| <a name="input_admin_subnet_nsg_name"></a> [admin\_subnet\_nsg\_name](#input\_admin\_subnet\_nsg\_name) | If provided, the name of the admin subnet NSG | `string` | `""` | no |
| <a name="input_ams_instance_name"></a> [ams\_instance\_name](#input\_ams\_instance\_name) | If provided, the name of the AMS instance | `string` | `""` | no |
| <a name="input_ams_laws_arm_id"></a> [ams\_laws\_arm\_id](#input\_ams\_laws\_arm\_id) | If provided, Azure resource id for the Log analytics workspace in AMS | `string` | `""` | no |
| <a name="input_ams_subnet_address_prefix"></a> [ams\_subnet\_address\_prefix](#input\_ams\_subnet\_address\_prefix) | The address prefix for the ams subnet | `string` | `""` | no |
| <a name="input_ams_subnet_arm_id"></a> [ams\_subnet\_arm\_id](#input\_ams\_subnet\_arm\_id) | If provided, Azure resource id for the ams subnet | `string` | `""` | no |
| <a name="input_ams_subnet_name"></a> [ams\_subnet\_name](#input\_ams\_subnet\_name) | If provided, the name of the ams subnet | `string` | `""` | no |
| <a name="input_ams_subnet_nsg_arm_id"></a> [ams\_subnet\_nsg\_arm\_id](#input\_ams\_subnet\_nsg\_arm\_id) | If provided, Azure resource id for the AMS subnet NSG | `string` | `""` | no |
| <a name="input_ams_subnet_nsg_name"></a> [ams\_subnet\_nsg\_name](#input\_ams\_subnet\_nsg\_name) | If provided, the name of the AMS subnet NSG | `string` | `""` | no |
| <a name="input_anf_subnet_address_prefix"></a> [anf\_subnet\_address\_prefix](#input\_anf\_subnet\_address\_prefix) | The address prefix for the ANF subnet | `string` | `""` | no |
| <a name="input_anf_subnet_arm_id"></a> [anf\_subnet\_arm\_id](#input\_anf\_subnet\_arm\_id) | If provided, Azure resource id for the ANF subnet | `string` | `""` | no |
| <a name="input_anf_subnet_name"></a> [anf\_subnet\_name](#input\_anf\_subnet\_name) | If provided, the name of the ANF subnet | `string` | `""` | no |
| <a name="input_anf_subnet_nsg_arm_id"></a> [anf\_subnet\_nsg\_arm\_id](#input\_anf\_subnet\_nsg\_arm\_id) | If provided, Azure resource id for the ANF subnet NSG | `string` | `""` | no |
| <a name="input_anf_subnet_nsg_name"></a> [anf\_subnet\_nsg\_name](#input\_anf\_subnet\_nsg\_name) | If provided, the name of the ANF subnet NSG | `string` | `""` | no |
| <a name="input_app_subnet_address_prefix"></a> [app\_subnet\_address\_prefix](#input\_app\_subnet\_address\_prefix) | The address prefix for the app subnet | `string` | `""` | no |
| <a name="input_app_subnet_arm_id"></a> [app\_subnet\_arm\_id](#input\_app\_subnet\_arm\_id) | If provided, Azure resource id for the app subnet | `string` | `""` | no |
| <a name="input_app_subnet_name"></a> [app\_subnet\_name](#input\_app\_subnet\_name) | If provided, the name of the app subnet | `string` | `""` | no |
| <a name="input_app_subnet_nsg_arm_id"></a> [app\_subnet\_nsg\_arm\_id](#input\_app\_subnet\_nsg\_arm\_id) | If provided, Azure resource id for the app subnet NSG | `string` | `""` | no |
| <a name="input_app_subnet_nsg_name"></a> [app\_subnet\_nsg\_name](#input\_app\_subnet\_nsg\_name) | If provided, the name of the app subnet NSG | `string` | `""` | no |
| <a name="input_authentication"></a> [authentication](#input\_authentication) | Details of ssh key pair | `map` | <pre>{<br/>  "path_to_private_key": "",<br/>  "path_to_public_key": "",<br/>  "username": "azureadm"<br/>}</pre> | no |
| <a name="input_automation_password"></a> [automation\_password](#input\_automation\_password) | If provided, the password for the automation account | `string` | `""` | no |
| <a name="input_automation_path_to_private_key"></a> [automation\_path\_to\_private\_key](#input\_automation\_path\_to\_private\_key) | If provided, the path to the existing private key for the automation account | `string` | `""` | no |
| <a name="input_automation_path_to_public_key"></a> [automation\_path\_to\_public\_key](#input\_automation\_path\_to\_public\_key) | If provided, the path to the existing public key for the automation account | `string` | `""` | no |
| <a name="input_automation_username"></a> [automation\_username](#input\_automation\_username) | The username for the automation account | `string` | `"azureadm"` | no |
| <a name="input_codename"></a> [codename](#input\_codename) | This is the code name name for the deployment | `string` | `""` | no |
| <a name="input_create_ams_instance"></a> [create\_ams\_instance](#input\_create\_ams\_instance) | If true, an AMS instance will be created | `bool` | `false` | no |
| <a name="input_create_transport_storage"></a> [create\_transport\_storage](#input\_create\_transport\_storage) | Boolean file indicating if storage should be created for SAP transport | `bool` | `true` | no |
| <a name="input_custom_random_id"></a> [custom\_random\_id](#input\_custom\_random\_id) | If provided, the value of the custom random id | `string` | `""` | no |
| <a name="input_data_plane_available"></a> [data\_plane\_available](#input\_data\_plane\_available) | Boolean value indicating if storage account access is via data plane | `bool` | `false` | no |
| <a name="input_db_subnet_address_prefix"></a> [db\_subnet\_address\_prefix](#input\_db\_subnet\_address\_prefix) | The address prefix for the db subnet | `string` | `""` | no |
| <a name="input_db_subnet_arm_id"></a> [db\_subnet\_arm\_id](#input\_db\_subnet\_arm\_id) | If provided, Azure resource id for the db subnet | `string` | `""` | no |
| <a name="input_db_subnet_name"></a> [db\_subnet\_name](#input\_db\_subnet\_name) | If provided, the name of the db subnet | `string` | `""` | no |
| <a name="input_db_subnet_nsg_arm_id"></a> [db\_subnet\_nsg\_arm\_id](#input\_db\_subnet\_nsg\_arm\_id) | If provided, Azure resource id for the db subnet NSG | `string` | `""` | no |
| <a name="input_db_subnet_nsg_name"></a> [db\_subnet\_nsg\_name](#input\_db\_subnet\_nsg\_name) | If provided, the name of the db subnet NSG | `string` | `""` | no |
| <a name="input_deploy_defender_extension"></a> [deploy\_defender\_extension](#input\_deploy\_defender\_extension) | If defined, will add the Microsoft.Azure.Security.Monitoring extension to the virtual machines | `bool` | `false` | no |
| <a name="input_deploy_monitoring_extension"></a> [deploy\_monitoring\_extension](#input\_deploy\_monitoring\_extension) | If defined, will add the Microsoft.Azure.Monitor.AzureMonitorLinuxAgent extension to the virtual machines | `bool` | `false` | no |
| <a name="input_deploy_nat_gateway"></a> [deploy\_nat\_gateway](#input\_deploy\_nat\_gateway) | If true, a NAT Gateway will be deployed | `bool` | `false` | no |
| <a name="input_deployer_tfstate_key"></a> [deployer\_tfstate\_key](#input\_deployer\_tfstate\_key) | The name of deployer's remote tfstate file | `string` | `""` | no |
| <a name="input_deployment"></a> [deployment](#input\_deployment) | The type of deployment | `string` | `"update"` | no |
| <a name="input_diagnostics_storage_account"></a> [diagnostics\_storage\_account](#input\_diagnostics\_storage\_account) | Storage account information for diagnostics account | `map` | <pre>{<br/>  "arm_id": ""<br/>}</pre> | no |
| <a name="input_diagnostics_storage_account_arm_id"></a> [diagnostics\_storage\_account\_arm\_id](#input\_diagnostics\_storage\_account\_arm\_id) | If provided, Azure resource id for the diagnostics storage account | `string` | `""` | no |
| <a name="input_dns_label"></a> [dns\_label](#input\_dns\_label) | DNS label | `string` | `""` | no |
| <a name="input_dns_server_list"></a> [dns\_server\_list](#input\_dns\_server\_list) | DNS server list | `list` | `[]` | no |
| <a name="input_dns_zone_names"></a> [dns\_zone\_names](#input\_dns\_zone\_names) | Private DNS zone names | `map(string)` | <pre>{<br/>  "blob_dns_zone_name": "privatelink.blob.core.windows.net",<br/>  "file_dns_zone_name": "privatelink.file.core.windows.net",<br/>  "table_dns_zone_name": "privatelink.table.core.windows.net",<br/>  "vault_dns_zone_name": "privatelink.vaultcore.azure.net"<br/>}</pre> | no |
| <a name="input_enable_firewall_for_keyvaults_and_storage"></a> [enable\_firewall\_for\_keyvaults\_and\_storage](#input\_enable\_firewall\_for\_keyvaults\_and\_storage) | Boolean value indicating if firewall should be enabled for key vaults and storage | `bool` | `false` | no |
| <a name="input_enable_purge_control_for_keyvaults"></a> [enable\_purge\_control\_for\_keyvaults](#input\_enable\_purge\_control\_for\_keyvaults) | Disables the purge protection for Azure keyvaults. | `bool` | `false` | no |
| <a name="input_enable_rbac_authorization_for_keyvault"></a> [enable\_rbac\_authorization\_for\_keyvault](#input\_enable\_rbac\_authorization\_for\_keyvault) | Enables RBAC authorization for Azure keyvault | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | This is the environment name for the deployment | `string` | `""` | no |
| <a name="input_export_install_path"></a> [export\_install\_path](#input\_export\_install\_path) | If provided, export mount path for the installation media | `bool` | `true` | no |
| <a name="input_export_transport_path"></a> [export\_transport\_path](#input\_export\_transport\_path) | If provided, export mount path for the transport media | `bool` | `true` | no |
| <a name="input_infrastructure"></a> [infrastructure](#input\_infrastructure) | Details of the Azure infrastructure to deploy the SAP landscape into | `map` | `{}` | no |
| <a name="input_install_always_create_fileshares"></a> [install\_always\_create\_fileshares](#input\_install\_always\_create\_fileshares) | Value indicating if file shares are created when using existing storage accounts | `bool` | `false` | no |
| <a name="input_install_create_smb_shares"></a> [install\_create\_smb\_shares](#input\_install\_create\_smb\_shares) | Value indicating if SMB shares should be created | `bool` | `true` | no |
| <a name="input_install_private_endpoint_id"></a> [install\_private\_endpoint\_id](#input\_install\_private\_endpoint\_id) | Azure Resource Identifier for an private endpoint connection | `string` | `""` | no |
| <a name="input_install_storage_account_id"></a> [install\_storage\_account\_id](#input\_install\_storage\_account\_id) | Azure Resource Identifier for the Installation media storage account | `string` | `""` | no |
| <a name="input_install_volume_size"></a> [install\_volume\_size](#input\_install\_volume\_size) | The volume size in GB for the transport share | `number` | `1024` | no |
| <a name="input_iscsi_authentication_type"></a> [iscsi\_authentication\_type](#input\_iscsi\_authentication\_type) | SCSI Virtual Machine authentication type | `string` | `"key"` | no |
| <a name="input_iscsi_authentication_username"></a> [iscsi\_authentication\_username](#input\_iscsi\_authentication\_username) | User name for iSCSI Virtual Machine | `string` | `"azureadm"` | no |
| <a name="input_iscsi_count"></a> [iscsi\_count](#input\_iscsi\_count) | The number of iSCSI Virtual Machines to create | `number` | `0` | no |
| <a name="input_iscsi_image"></a> [iscsi\_image](#input\_iscsi\_image) | The virtual machine image for the iSCSI Virtual Machine | `map` | <pre>{<br/>  "offer": "sles-sap-15-sp5",<br/>  "publisher": "SUSE",<br/>  "sku": "gen1",<br/>  "source_image_id": "",<br/>  "version": "latest"<br/>}</pre> | no |
| <a name="input_iscsi_nic_ips"></a> [iscsi\_nic\_ips](#input\_iscsi\_nic\_ips) | P addresses for the iSCSI Virtual Machine NICs | `list` | `[]` | no |
| <a name="input_iscsi_size"></a> [iscsi\_size](#input\_iscsi\_size) | The size of the iSCSI Virtual Machine | `string` | `""` | no |
| <a name="input_iscsi_subnet_address_prefix"></a> [iscsi\_subnet\_address\_prefix](#input\_iscsi\_subnet\_address\_prefix) | The address prefix for the iSCSI subnet | `string` | `""` | no |
| <a name="input_iscsi_subnet_arm_id"></a> [iscsi\_subnet\_arm\_id](#input\_iscsi\_subnet\_arm\_id) | If provided, Azure resource id for the iSCSI subnet | `string` | `""` | no |
| <a name="input_iscsi_subnet_name"></a> [iscsi\_subnet\_name](#input\_iscsi\_subnet\_name) | If provided, the name of the iSCSI subnet | `string` | `""` | no |
| <a name="input_iscsi_subnet_nsg_arm_id"></a> [iscsi\_subnet\_nsg\_arm\_id](#input\_iscsi\_subnet\_nsg\_arm\_id) | If provided, Azure resource id for the iSCSI subnet NSG | `string` | `""` | no |
| <a name="input_iscsi_subnet_nsg_name"></a> [iscsi\_subnet\_nsg\_name](#input\_iscsi\_subnet\_nsg\_name) | If provided, the name of the iSCSI subnet NSG | `string` | `""` | no |
| <a name="input_iscsi_useDHCP"></a> [iscsi\_useDHCP](#input\_iscsi\_useDHCP) | value indicating if iSCSI Virtual Machine should use DHCP | `bool` | `false` | no |
| <a name="input_iscsi_vm_zones"></a> [iscsi\_vm\_zones](#input\_iscsi\_vm\_zones) | If provided, the iSCSI will be deployed in the specified zones | `list` | `[]` | no |
| <a name="input_key_vault"></a> [key\_vault](#input\_key\_vault) | The user brings existing Azure Key Vaults | `map` | `{}` | no |
| <a name="input_keyvault_private_endpoint_id"></a> [keyvault\_private\_endpoint\_id](#input\_keyvault\_private\_endpoint\_id) | Existing private endpoint for key vault | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region for the resources | `string` | `""` | no |
| <a name="input_management_dns_resourcegroup_name"></a> [management\_dns\_resourcegroup\_name](#input\_management\_dns\_resourcegroup\_name) | String value giving the possibility to register custom dns a records in a separate resourcegroup | `string` | `""` | no |
| <a name="input_management_dns_subscription_id"></a> [management\_dns\_subscription\_id](#input\_management\_dns\_subscription\_id) | String value giving the possibility to register custom dns a records in a separate subscription | `string` | `""` | no |
| <a name="input_management_subscription"></a> [management\_subscription](#input\_management\_subscription) | This is the management subscription used by the deployment | `string` | `""` | no |
| <a name="input_name_override_file"></a> [name\_override\_file](#input\_name\_override\_file) | If provided, contains a json formatted file defining the name overrides | `string` | `""` | no |
| <a name="input_nat_gateway_arm_id"></a> [nat\_gateway\_arm\_id](#input\_nat\_gateway\_arm\_id) | If provided, Azure resource id for the NAT Gateway | `string` | `""` | no |
| <a name="input_nat_gateway_idle_timeout_in_minutes"></a> [nat\_gateway\_idle\_timeout\_in\_minutes](#input\_nat\_gateway\_idle\_timeout\_in\_minutes) | The idle timeout in minutes for the NAT Gateway | `number` | `4` | no |
| <a name="input_nat_gateway_name"></a> [nat\_gateway\_name](#input\_nat\_gateway\_name) | If provided, the name of the NAT Gateway | `string` | `""` | no |
| <a name="input_nat_gateway_public_ip_arm_id"></a> [nat\_gateway\_public\_ip\_arm\_id](#input\_nat\_gateway\_public\_ip\_arm\_id) | If provided, Azure resource id for the NAT Gateway public IP | `string` | `""` | no |
| <a name="input_nat_gateway_public_ip_tags"></a> [nat\_gateway\_public\_ip\_tags](#input\_nat\_gateway\_public\_ip\_tags) | Tags for the public\_ip resource | `map(string)` | `null` | no |
| <a name="input_nat_gateway_public_ip_zones"></a> [nat\_gateway\_public\_ip\_zones](#input\_nat\_gateway\_public\_ip\_zones) | If provided, the zones for the NAT Gateway public IP | `list(string)` | `[]` | no |
| <a name="input_network_address_space"></a> [network\_address\_space](#input\_network\_address\_space) | The address space of the virtual network | `string` | `""` | no |
| <a name="input_network_arm_id"></a> [network\_arm\_id](#input\_network\_arm\_id) | If provided, the Azure resource id of the virtual network | `string` | `""` | no |
| <a name="input_network_enable_route_propagation"></a> [network\_enable\_route\_propagation](#input\_network\_enable\_route\_propagation) | Enable network route table propagation | `bool` | `true` | no |
| <a name="input_network_flow_timeout_in_minutes"></a> [network\_flow\_timeout\_in\_minutes](#input\_network\_flow\_timeout\_in\_minutes) | The flow timeout in minutes of the virtual network | `number` | `null` | no |
| <a name="input_network_logical_name"></a> [network\_logical\_name](#input\_network\_logical\_name) | The logical name of the virtual network, used for resource naming | `string` | `""` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | If provided, the name of the Virtual network | `string` | `""` | no |
| <a name="input_options"></a> [options](#input\_options) | Configuration options | `map` | `{}` | no |
| <a name="input_patch_assessment_mode"></a> [patch\_assessment\_mode](#input\_patch\_assessment\_mode) | If defined, define the patch mode for the virtual machines | `string` | `"ImageDefault"` | no |
| <a name="input_patch_mode"></a> [patch\_mode](#input\_patch\_mode) | If defined, define the patch mode for the virtual machines | `string` | `"ImageDefault"` | no |
| <a name="input_peer_with_control_plane_vnet"></a> [peer\_with\_control\_plane\_vnet](#input\_peer\_with\_control\_plane\_vnet) | Defines in the SAP VNet will be peered with the controlplane VNet | `bool` | `true` | no |
| <a name="input_place_delete_lock_on_resources"></a> [place\_delete\_lock\_on\_resources](#input\_place\_delete\_lock\_on\_resources) | If defined, a delete lock will be placed on the key resources | `bool` | `false` | no |
| <a name="input_prevent_deletion_if_contains_resources"></a> [prevent\_deletion\_if\_contains\_resources](#input\_prevent\_deletion\_if\_contains\_resources) | Controls if resource groups are deleted even if they contain resources | `bool` | `true` | no |
| <a name="input_privatelink_dns_resourcegroup_name"></a> [privatelink\_dns\_resourcegroup\_name](#input\_privatelink\_dns\_resourcegroup\_name) | String value giving the possibility to register custom PrivateLink DNS A records in a separate resourcegroup | `string` | `""` | no |
| <a name="input_privatelink_dns_subscription_id"></a> [privatelink\_dns\_subscription\_id](#input\_privatelink\_dns\_subscription\_id) | String value giving the possibility to register custom PrivateLink DNS A records in a separate subscription | `string` | `""` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Defines if the public access should be enabled for keyvaults and storage accounts | `bool` | `true` | no |
| <a name="input_register_endpoints_with_dns"></a> [register\_endpoints\_with\_dns](#input\_register\_endpoints\_with\_dns) | Boolean value indicating if endpoints should be registered to the dns zone | `bool` | `true` | no |
| <a name="input_register_storage_accounts_keyvaults_with_dns"></a> [register\_storage\_accounts\_keyvaults\_with\_dns](#input\_register\_storage\_accounts\_keyvaults\_with\_dns) | Boolean value indicating if storage accounts and key vaults should be registered to the corresponding dns zones | `bool` | `true` | no |
| <a name="input_register_virtual_network_to_dns"></a> [register\_virtual\_network\_to\_dns](#input\_register\_virtual\_network\_to\_dns) | Boolean value indicating if the vnet should be registered to the dns zone | `bool` | `true` | no |
| <a name="input_resourcegroup_arm_id"></a> [resourcegroup\_arm\_id](#input\_resourcegroup\_arm\_id) | If provided, the Azure resource group id | `string` | `""` | no |
| <a name="input_resourcegroup_name"></a> [resourcegroup\_name](#input\_resourcegroup\_name) | If provided, the name of the resource group to be created | `string` | `""` | no |
| <a name="input_resourcegroup_tags"></a> [resourcegroup\_tags](#input\_resourcegroup\_tags) | Tags to be applied to the resource group | `map` | `{}` | no |
| <a name="input_set_secret_expiry"></a> [set\_secret\_expiry](#input\_set\_secret\_expiry) | Set expiry date for secrets | `bool` | `false` | no |
| <a name="input_shared_access_key_enabled"></a> [shared\_access\_key\_enabled](#input\_shared\_access\_key\_enabled) | Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. | `bool` | `false` | no |
| <a name="input_shared_access_key_enabled_nfs"></a> [shared\_access\_key\_enabled\_nfs](#input\_shared\_access\_key\_enabled\_nfs) | Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. | `bool` | `false` | no |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | The number of days that items should be retained in the soft delete period | `number` | `7` | no |
| <a name="input_spn_keyvault_id"></a> [spn\_keyvault\_id](#input\_spn\_keyvault\_id) | If provided, the Azure resource identifier of the deployment credential keyvault | `string` | `""` | no |
| <a name="input_storage_account_replication_type"></a> [storage\_account\_replication\_type](#input\_storage\_account\_replication\_type) | Storage account replication type | `string` | `"ZRS"` | no |
| <a name="input_storage_subnet_address_prefix"></a> [storage\_subnet\_address\_prefix](#input\_storage\_subnet\_address\_prefix) | The address prefix for the storage subnet | `string` | `""` | no |
| <a name="input_storage_subnet_arm_id"></a> [storage\_subnet\_arm\_id](#input\_storage\_subnet\_arm\_id) | If provided, Azure resource id for the storage subnet | `string` | `""` | no |
| <a name="input_storage_subnet_name"></a> [storage\_subnet\_name](#input\_storage\_subnet\_name) | If provided, the name of the stroage subnet | `string` | `""` | no |
| <a name="input_storage_subnet_nsg_arm_id"></a> [storage\_subnet\_nsg\_arm\_id](#input\_storage\_subnet\_nsg\_arm\_id) | If provided, Azure resource id for the storage subnet NSG | `string` | `""` | no |
| <a name="input_storage_subnet_nsg_name"></a> [storage\_subnet\_nsg\_name](#input\_storage\_subnet\_nsg\_name) | If provided, the name of the storage subnet NSG | `string` | `""` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | This is the target subscription for the deployment | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | If provided, tags for all resources | `map` | `{}` | no |
| <a name="input_terraform_template_version"></a> [terraform\_template\_version](#input\_terraform\_template\_version) | The version of Terraform templates that were identified in the state file | `string` | `""` | no |
| <a name="input_tfstate_resource_id"></a> [tfstate\_resource\_id](#input\_tfstate\_resource\_id) | Resource id of tfstate storage account | `any` | n/a | yes |
| <a name="input_transport_private_endpoint_id"></a> [transport\_private\_endpoint\_id](#input\_transport\_private\_endpoint\_id) | Azure Resource Identifier for an private endpoint connection | `string` | `""` | no |
| <a name="input_transport_storage_account_id"></a> [transport\_storage\_account\_id](#input\_transport\_storage\_account\_id) | Azure Resource Identifier for the Transport media storage account | `string` | `""` | no |
| <a name="input_transport_volume_size"></a> [transport\_volume\_size](#input\_transport\_volume\_size) | The volume size in GB for the transport share | `number` | `128` | no |
| <a name="input_use_AFS_for_shared_storage"></a> [use\_AFS\_for\_shared\_storage](#input\_use\_AFS\_for\_shared\_storage) | If true, will use AFS for all shared storage. | `bool` | `false` | no |
| <a name="input_use_custom_dns_a_registration"></a> [use\_custom\_dns\_a\_registration](#input\_use\_custom\_dns\_a\_registration) | Boolean value indicating if a custom dns a record should be created when using private endpoints | `bool` | `false` | no |
| <a name="input_use_private_endpoint"></a> [use\_private\_endpoint](#input\_use\_private\_endpoint) | Boolean value indicating if private endpoint should be used for the deployment | `bool` | `false` | no |
| <a name="input_use_service_endpoint"></a> [use\_service\_endpoint](#input\_use\_service\_endpoint) | Boolean value indicating if service endpoints should be used for the deployment | `bool` | `false` | no |
| <a name="input_use_spn"></a> [use\_spn](#input\_use\_spn) | Log in using a service principal when performing the deployment | `bool` | `false` | no |
| <a name="input_user_assigned_identity_id"></a> [user\_assigned\_identity\_id](#input\_user\_assigned\_identity\_id) | If provided defines the user assigned identity to assign to the virtual machines | `string` | `""` | no |
| <a name="input_user_keyvault_id"></a> [user\_keyvault\_id](#input\_user\_keyvault\_id) | If provided, the Azure resource identifier of the credentials keyvault | `string` | `""` | no |
| <a name="input_utility_vm_count"></a> [utility\_vm\_count](#input\_utility\_vm\_count) | The number of utility\_vmes to create | `number` | `0` | no |
| <a name="input_utility_vm_image"></a> [utility\_vm\_image](#input\_utility\_vm\_image) | The virtual machine image for the utility\_vm Virtual Machine | `map` | <pre>{<br/>  "offer": "WindowsServer",<br/>  "os_type": "WINDOWS",<br/>  "publisher": "MicrosoftWindowsServer",<br/>  "sku": "2022-Datacenter",<br/>  "source_image_id": "",<br/>  "version": "latest"<br/>}</pre> | no |
| <a name="input_utility_vm_nic_ips"></a> [utility\_vm\_nic\_ips](#input\_utility\_vm\_nic\_ips) | IP addresses for the utility\_vm Virtual Machine NICs | `list` | `[]` | no |
| <a name="input_utility_vm_os_disk_size"></a> [utility\_vm\_os\_disk\_size](#input\_utility\_vm\_os\_disk\_size) | The size of the OS disk for the Virtual Machine | `string` | `"128"` | no |
| <a name="input_utility_vm_os_disk_type"></a> [utility\_vm\_os\_disk\_type](#input\_utility\_vm\_os\_disk\_type) | The type of the OS disk for the Virtual Machine | `string` | `"Premium_LRS"` | no |
| <a name="input_utility_vm_size"></a> [utility\_vm\_size](#input\_utility\_vm\_size) | The size of the utility\_vm Virtual Machine | `string` | `"Standard_D4ds_v4"` | no |
| <a name="input_utility_vm_useDHCP"></a> [utility\_vm\_useDHCP](#input\_utility\_vm\_useDHCP) | value indicating if utility\_vm should use DHCP | `bool` | `true` | no |
| <a name="input_web_subnet_address_prefix"></a> [web\_subnet\_address\_prefix](#input\_web\_subnet\_address\_prefix) | The address prefix for the web subnet | `string` | `""` | no |
| <a name="input_web_subnet_arm_id"></a> [web\_subnet\_arm\_id](#input\_web\_subnet\_arm\_id) | If provided, Azure resource id for the web subnet | `string` | `""` | no |
| <a name="input_web_subnet_name"></a> [web\_subnet\_name](#input\_web\_subnet\_name) | If provided, the name of the web subnet | `string` | `""` | no |
| <a name="input_web_subnet_nsg_arm_id"></a> [web\_subnet\_nsg\_arm\_id](#input\_web\_subnet\_nsg\_arm\_id) | If provided, Azure resource id for the web subnet NSG | `string` | `""` | no |
| <a name="input_web_subnet_nsg_name"></a> [web\_subnet\_nsg\_name](#input\_web\_subnet\_nsg\_name) | If provided, the name of the web subnet NSG | `string` | `""` | no |
| <a name="input_witness_storage_account"></a> [witness\_storage\_account](#input\_witness\_storage\_account) | Storage account information for witness storage account | `map` | <pre>{<br/>  "arm_id": ""<br/>}</pre> | no |
| <a name="input_witness_storage_account_arm_id"></a> [witness\_storage\_account\_arm\_id](#input\_witness\_storage\_account\_arm\_id) | If provided, Azure resource id for the witness storage account | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ANF_pool_settings"></a> [ANF\_pool\_settings](#output\_ANF\_pool\_settings) | Dictionary with information pertinent to the ANF deployment |
| <a name="output_admin_nsg_id"></a> [admin\_nsg\_id](#output\_admin\_nsg\_id) | Azure resource identifier for the admin subnet network security group |
| <a name="output_admin_subnet_id"></a> [admin\_subnet\_id](#output\_admin\_subnet\_id) | Azure resource identifier for the admin subnet |
| <a name="output_ams_resource_id"></a> [ams\_resource\_id](#output\_ams\_resource\_id) | AMS resource ID |
| <a name="output_ams_subnet_id"></a> [ams\_subnet\_id](#output\_ams\_subnet\_id) | Azure resource identifier for the AMS subnet |
| <a name="output_app_nsg_id"></a> [app\_nsg\_id](#output\_app\_nsg\_id) | Azure resource identifier for the app subnet network security group |
| <a name="output_app_subnet_id"></a> [app\_subnet\_id](#output\_app\_subnet\_id) | Azure resource identifier for the app subnet |
| <a name="output_automation_version"></a> [automation\_version](#output\_automation\_version) | Returns the version of the automation templated used to deploy the landscape |
| <a name="output_controlplane_environment"></a> [controlplane\_environment](#output\_controlplane\_environment) | Control plane environment |
| <a name="output_created_resource_group_id"></a> [created\_resource\_group\_id](#output\_created\_resource\_group\_id) | Created resource group ID |
| <a name="output_created_resource_group_name"></a> [created\_resource\_group\_name](#output\_created\_resource\_group\_name) | Created resource group name |
| <a name="output_created_resource_group_subscription_id"></a> [created\_resource\_group\_subscription\_id](#output\_created\_resource\_group\_subscription\_id) | Created resource group' subscription ID |
| <a name="output_db_nsg_id"></a> [db\_nsg\_id](#output\_db\_nsg\_id) | Azure resource identifier for the database subnet network security group |
| <a name="output_db_subnet_id"></a> [db\_subnet\_id](#output\_db\_subnet\_id) | Azure resource identifier for the db subnet |
| <a name="output_dns_info_iscsi"></a> [dns\_info\_iscsi](#output\_dns\_info\_iscsi) | DNS information for the iSCSI devices |
| <a name="output_dns_label"></a> [dns\_label](#output\_dns\_label) | DNS suffix for the SAP Systems |
| <a name="output_dns_resource_group_name"></a> [dns\_resource\_group\_name](#output\_dns\_resource\_group\_name) | Resource group name for the resource group containing the local Private DNS Zone |
| <a name="output_iSCSI_server_ips"></a> [iSCSI\_server\_ips](#output\_iSCSI\_server\_ips) | IP addesses for the iSCSI Servers |
| <a name="output_iSCSI_server_names"></a> [iSCSI\_server\_names](#output\_iSCSI\_server\_names) | n/a |
| <a name="output_iSCSI_servers"></a> [iSCSI\_servers](#output\_iSCSI\_servers) | n/a |
| <a name="output_install_path"></a> [install\_path](#output\_install\_path) | Mount point for install volume |
| <a name="output_iscsi_authentication_type"></a> [iscsi\_authentication\_type](#output\_iscsi\_authentication\_type) | Authentication type for the iSCSI devices |
| <a name="output_iscsi_authentication_username"></a> [iscsi\_authentication\_username](#output\_iscsi\_authentication\_username) | User name for authentication to the iSCSI target |
| <a name="output_iscsi_private_ip"></a> [iscsi\_private\_ip](#output\_iscsi\_private\_ip) | IP addresses for the iSCSI devices |
| <a name="output_landscape_key_vault_private_arm_id"></a> [landscape\_key\_vault\_private\_arm\_id](#output\_landscape\_key\_vault\_private\_arm\_id) | Not used at this time |
| <a name="output_landscape_key_vault_spn_arm_id"></a> [landscape\_key\_vault\_spn\_arm\_id](#output\_landscape\_key\_vault\_spn\_arm\_id) | Azure resource identifier for the deployment credential keyvault |
| <a name="output_landscape_key_vault_user_arm_id"></a> [landscape\_key\_vault\_user\_arm\_id](#output\_landscape\_key\_vault\_user\_arm\_id) | Azure resource identifier for the user credential keyvault |
| <a name="output_management_dns_resourcegroup_name"></a> [management\_dns\_resourcegroup\_name](#output\_management\_dns\_resourcegroup\_name) | Resource group name for the resource group containing the public Private DNS Zone |
| <a name="output_management_dns_subscription_id"></a> [management\_dns\_subscription\_id](#output\_management\_dns\_subscription\_id) | Subscription ID for the public Private DNS Zone |
| <a name="output_ng_resource_id"></a> [ng\_resource\_id](#output\_ng\_resource\_id) | NAT Gateway resource ID |
| <a name="output_privatelink_dns_resourcegroup_name"></a> [privatelink\_dns\_resourcegroup\_name](#output\_privatelink\_dns\_resourcegroup\_name) | n/a |
| <a name="output_privatelink_dns_subscription_id"></a> [privatelink\_dns\_subscription\_id](#output\_privatelink\_dns\_subscription\_id) | Subscription ID for the PrivateLink Private DNS Zones |
| <a name="output_privatelink_file_id"></a> [privatelink\_file\_id](#output\_privatelink\_file\_id) | Azure resource identifier for the zone for the file resources |
| <a name="output_public_network_access_enabled"></a> [public\_network\_access\_enabled](#output\_public\_network\_access\_enabled) | Defines if the public access should be enabled for keyvaults and storage |
| <a name="output_random_id"></a> [random\_id](#output\_random\_id) | Random ID for workload zone |
| <a name="output_register_storage_accounts_keyvaults_with_dns"></a> [register\_storage\_accounts\_keyvaults\_with\_dns](#output\_register\_storage\_accounts\_keyvaults\_with\_dns) | Boolean flag to indicate if the stor4agte accounts and key vaults are registered to DNS |
| <a name="output_register_virtual_network_to_dns"></a> [register\_virtual\_network\_to\_dns](#output\_register\_virtual\_network\_to\_dns) | Boolean flag to indicate if the SAP virtual network are registered to DNS |
| <a name="output_route_table_id"></a> [route\_table\_id](#output\_route\_table\_id) | Azure resource identifier for the route table |
| <a name="output_saptransport_path"></a> [saptransport\_path](#output\_saptransport\_path) | Mount point for transport volume |
| <a name="output_sid_password_secret_name"></a> [sid\_password\_secret\_name](#output\_sid\_password\_secret\_name) | Name of key vault secret containing the password for the infrastructure |
| <a name="output_sid_public_key_secret_name"></a> [sid\_public\_key\_secret\_name](#output\_sid\_public\_key\_secret\_name) | Name of key vault secret containing the public ssh key for the infrastructure |
| <a name="output_sid_username_secret_name"></a> [sid\_username\_secret\_name](#output\_sid\_username\_secret\_name) | Name of key vault secret containing the user name for logging on to the infrastructure |
| <a name="output_spn_kv_id"></a> [spn\_kv\_id](#output\_spn\_kv\_id) | Name of key vault secret containing deployment credentials |
| <a name="output_storage_nsg_id"></a> [storage\_nsg\_id](#output\_storage\_nsg\_id) | Azure resource identifier for the storage subnet network security group |
| <a name="output_storage_subnet_id"></a> [storage\_subnet\_id](#output\_storage\_subnet\_id) | Azure resource identifier for the storage subnet |
| <a name="output_storageaccount_name"></a> [storageaccount\_name](#output\_storageaccount\_name) | Diagnostics storage account name |
| <a name="output_storageaccount_rg_name"></a> [storageaccount\_rg\_name](#output\_storageaccount\_rg\_name) | Diagnostics storage account resource group name |
| <a name="output_subnet_mgmt_id"></a> [subnet\_mgmt\_id](#output\_subnet\_mgmt\_id) | Azure resource identifier for the management subnet |
| <a name="output_transport_storage_account_id"></a> [transport\_storage\_account\_id](#output\_transport\_storage\_account\_id) | Transport storage account name |
| <a name="output_use_custom_dns_a_registration"></a> [use\_custom\_dns\_a\_registration](#output\_use\_custom\_dns\_a\_registration) | Defines if custom DNS is used |
| <a name="output_use_spn"></a> [use\_spn](#output\_use\_spn) | Perform deployments using a service principal |
| <a name="output_vnet_sap_arm_id"></a> [vnet\_sap\_arm\_id](#output\_vnet\_sap\_arm\_id) | Azure resource identifier for the Virtual Network |
| <a name="output_web_nsg_id"></a> [web\_nsg\_id](#output\_web\_nsg\_id) | Azure resource identifier for the web subnet network security group |
| <a name="output_web_subnet_id"></a> [web\_subnet\_id](#output\_web\_subnet\_id) | Azure resource identifier for the web subnet |
| <a name="output_witness_storage_account"></a> [witness\_storage\_account](#output\_witness\_storage\_account) | Witness storage account name |
| <a name="output_witness_storage_account_key"></a> [witness\_storage\_account\_key](#output\_witness\_storage\_account\_key) | Witness storage account account key |
| <a name="output_workload_zone_prefix"></a> [workload\_zone\_prefix](#output\_workload\_zone\_prefix) | Workload zone prefix |
| <a name="output_workloadzone_kv_name"></a> [workloadzone\_kv\_name](#output\_workloadzone\_kv\_name) | Workload zone keyvault name |
<!-- END_TF_DOCS -->