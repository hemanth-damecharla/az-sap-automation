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
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.11.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_sap_deployer"></a> [sap\_deployer](#module\_sap\_deployer) | ../../terraform-units/modules/sap_deployer | n/a |
| <a name="module_sap_namegenerator"></a> [sap\_namegenerator](#module\_sap\_namegenerator) | ../../terraform-units/modules/sap_namegenerator | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.client_id](https://registry.terraform.io/providers/hashicorp/azurerm/4.11.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.client_secret](https://registry.terraform.io/providers/hashicorp/azurerm/4.11.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.subscription_id](https://registry.terraform.io/providers/hashicorp/azurerm/4.11.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.tenant_id](https://registry.terraform.io/providers/hashicorp/azurerm/4.11.0/docs/data-sources/key_vault_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_Agent_IP"></a> [Agent\_IP](#input\_Agent\_IP) | IP address of the agent | `string` | `""` | no |
| <a name="input_add_Agent_IP"></a> [add\_Agent\_IP](#input\_add\_Agent\_IP) | Boolean value indicating if the Agent IP should be added to the storage and key vault firewalls | `bool` | `true` | no |
| <a name="input_add_system_assigned_identity"></a> [add\_system\_assigned\_identity](#input\_add\_system\_assigned\_identity) | Boolean flag indicating if a system assigned identity should be added to the deployer | `bool` | `false` | no |
| <a name="input_additional_network_id"></a> [additional\_network\_id](#input\_additional\_network\_id) | Agent Network resource ID | `string` | `""` | no |
| <a name="input_additional_users_to_add_to_keyvault_policies"></a> [additional\_users\_to\_add\_to\_keyvault\_policies](#input\_additional\_users\_to\_add\_to\_keyvault\_policies) | List of object IDs to add to key vault policies | `list` | <pre>[<br/>  ""<br/>]</pre> | no |
| <a name="input_agent_ado_url"></a> [agent\_ado\_url](#input\_agent\_ado\_url) | If provided, contains the Url to the ADO repository | `string` | `""` | no |
| <a name="input_agent_pat"></a> [agent\_pat](#input\_agent\_pat) | If provided, contains the Personal Access Token to be used | `string` | `""` | no |
| <a name="input_agent_pool"></a> [agent\_pool](#input\_agent\_pool) | If provided, contains the name of the agent pool to be used | `string` | `""` | no |
| <a name="input_ansible_core_version"></a> [ansible\_core\_version](#input\_ansible\_core\_version) | If provided, the version of ansible core to be installed | `string` | `"2.16"` | no |
| <a name="input_app_registration_app_id"></a> [app\_registration\_app\_id](#input\_app\_registration\_app\_id) | The app registration id to be used for the webapp | `string` | `""` | no |
| <a name="input_app_service_SKU_name"></a> [app\_service\_SKU\_name](#input\_app\_service\_SKU\_name) | The SKU of the App Service Plan | `string` | `"S1"` | no |
| <a name="input_app_service_devops_authentication_type"></a> [app\_service\_devops\_authentication\_type](#input\_app\_service\_devops\_authentication\_type) | The Authentication to use when calling Azure DevOps, MSI/PAT | `string` | `"MSI"` | no |
| <a name="input_arm_client_id"></a> [arm\_client\_id](#input\_arm\_client\_id) | The client ID of the service principal used to authenticate to Azure | `string` | `""` | no |
| <a name="input_assign_subscription_permissions"></a> [assign\_subscription\_permissions](#input\_assign\_subscription\_permissions) | Assign permissions on the subscription | `bool` | `true` | no |
| <a name="input_authentication"></a> [authentication](#input\_authentication) | Authentication details | `map` | <pre>{<br/>  "path_to_private_key": "",<br/>  "path_to_public_key": "",<br/>  "username": "azureadm"<br/>}</pre> | no |
| <a name="input_auto_configure_deployer"></a> [auto\_configure\_deployer](#input\_auto\_configure\_deployer) | Value indicating if the deployer should be configured automatically | `bool` | `true` | no |
| <a name="input_bastion_deployment"></a> [bastion\_deployment](#input\_bastion\_deployment) | Boolean flag indicating if an Azure bastion should be deployed | `bool` | `false` | no |
| <a name="input_bastion_public_ip_tags"></a> [bastion\_public\_ip\_tags](#input\_bastion\_public\_ip\_tags) | Tags for the public\_ip resource attached to bastion | `map(string)` | `null` | no |
| <a name="input_bastion_sku"></a> [bastion\_sku](#input\_bastion\_sku) | The SKU of the Bastion Host. Accepted values are Basic or Standard | `string` | `"Basic"` | no |
| <a name="input_codename"></a> [codename](#input\_codename) | Additional component for naming the resources | `string` | `""` | no |
| <a name="input_custom_random_id"></a> [custom\_random\_id](#input\_custom\_random\_id) | If provided, the value of the custom random id | `string` | `""` | no |
| <a name="input_data_plane_available"></a> [data\_plane\_available](#input\_data\_plane\_available) | Boolean value indicating if storage account access is via data plane | `bool` | `false` | no |
| <a name="input_deploy_defender_extension"></a> [deploy\_defender\_extension](#input\_deploy\_defender\_extension) | If defined, will add the Microsoft.Azure.Security.Monitoring extension to the virtual machines | `bool` | `false` | no |
| <a name="input_deploy_monitoring_extension"></a> [deploy\_monitoring\_extension](#input\_deploy\_monitoring\_extension) | If defined, will add the Microsoft.Azure.Monitor.AzureMonitorLinuxAgent extension to the virtual machines | `bool` | `false` | no |
| <a name="input_deployer_assign_subscription_permissions"></a> [deployer\_assign\_subscription\_permissions](#input\_deployer\_assign\_subscription\_permissions) | Boolean flag indicating if the subscription permissions should be assigned | `bool` | `false` | no |
| <a name="input_deployer_authentication_password"></a> [deployer\_authentication\_password](#input\_deployer\_authentication\_password) | value to define the password for the deployer | `string` | `""` | no |
| <a name="input_deployer_authentication_path_to_private_key"></a> [deployer\_authentication\_path\_to\_private\_key](#input\_deployer\_authentication\_path\_to\_private\_key) | The path to an existing ssh private key, on the deployer | `string` | `""` | no |
| <a name="input_deployer_authentication_path_to_public_key"></a> [deployer\_authentication\_path\_to\_public\_key](#input\_deployer\_authentication\_path\_to\_public\_key) | The path to an existing ssh public key, on the deployer | `string` | `""` | no |
| <a name="input_deployer_authentication_type"></a> [deployer\_authentication\_type](#input\_deployer\_authentication\_type) | value to define the authentication type for the deployer | `string` | `"key"` | no |
| <a name="input_deployer_authentication_username"></a> [deployer\_authentication\_username](#input\_deployer\_authentication\_username) | value to define the username for the deployer | `string` | `"azureadm"` | no |
| <a name="input_deployer_count"></a> [deployer\_count](#input\_deployer\_count) | Number of deployer VMs to be created | `number` | `1` | no |
| <a name="input_deployer_diagnostics_account_arm_id"></a> [deployer\_diagnostics\_account\_arm\_id](#input\_deployer\_diagnostics\_account\_arm\_id) | Azure resource identifier for an existing storage accout that will be used for diagnostic logs | `string` | `""` | no |
| <a name="input_deployer_disk_type"></a> [deployer\_disk\_type](#input\_deployer\_disk\_type) | The type of the disk for the deployer VM | `string` | `"Premium_LRS"` | no |
| <a name="input_deployer_enable_public_ip"></a> [deployer\_enable\_public\_ip](#input\_deployer\_enable\_public\_ip) | value to enable/disable public ip | `bool` | `false` | no |
| <a name="input_deployer_image"></a> [deployer\_image](#input\_deployer\_image) | The image to be used for the deployer VM | `map` | <pre>{<br/>  "offer": "0001-com-ubuntu-server-jammy",<br/>  "os_type": "LINUX",<br/>  "publisher": "Canonical",<br/>  "sku": "22_04-lts-gen2",<br/>  "source_image_id": "",<br/>  "type": "marketplace",<br/>  "version": "latest"<br/>}</pre> | no |
| <a name="input_deployer_kv_user_arm_id"></a> [deployer\_kv\_user\_arm\_id](#input\_deployer\_kv\_user\_arm\_id) | Azure resource identifier for the deployer user Azure Key Vault | `string` | `""` | no |
| <a name="input_deployer_password_secret_name"></a> [deployer\_password\_secret\_name](#input\_deployer\_password\_secret\_name) | Defines the name of the secret in the Azure Key Vault that contains the password | `string` | `""` | no |
| <a name="input_deployer_private_ip_address"></a> [deployer\_private\_ip\_address](#input\_deployer\_private\_ip\_address) | If provides, the value of the deployer Virtual machine IPs | `list` | <pre>[<br/>  ""<br/>]</pre> | no |
| <a name="input_deployer_private_key_secret_name"></a> [deployer\_private\_key\_secret\_name](#input\_deployer\_private\_key\_secret\_name) | Defines the name of the secret in the Azure Key Vault that contains the private key | `string` | `""` | no |
| <a name="input_deployer_public_ip_tags"></a> [deployer\_public\_ip\_tags](#input\_deployer\_public\_ip\_tags) | Tags for the public\_ip resource attached to deployer | `map(string)` | `null` | no |
| <a name="input_deployer_public_key_secret_name"></a> [deployer\_public\_key\_secret\_name](#input\_deployer\_public\_key\_secret\_name) | Defines the name of the secret in the Azure Key Vault that contains the public key | `string` | `""` | no |
| <a name="input_deployer_size"></a> [deployer\_size](#input\_deployer\_size) | The size of the deployer VM | `string` | `"Standard_D4ds_v4"` | no |
| <a name="input_deployer_use_DHCP"></a> [deployer\_use\_DHCP](#input\_deployer\_use\_DHCP) | If true, the deployers will use Azure Provided IP addresses | `bool` | `false` | no |
| <a name="input_deployer_username_secret_name"></a> [deployer\_username\_secret\_name](#input\_deployer\_username\_secret\_name) | Defines the name of the secret in the Azure Key Vault that contains the user name | `string` | `""` | no |
| <a name="input_deployers"></a> [deployers](#input\_deployers) | Details of the list of deployer(s) | `list` | <pre>[<br/>  {}<br/>]</pre> | no |
| <a name="input_deployment"></a> [deployment](#input\_deployment) | The type of deployment | `string` | `"update"` | no |
| <a name="input_dns_zone_names"></a> [dns\_zone\_names](#input\_dns\_zone\_names) | Private DNS zone names | `map(string)` | <pre>{<br/>  "blob_dns_zone_name": "privatelink.blob.core.windows.net",<br/>  "file_dns_zone_name": "privatelink.file.core.windows.net",<br/>  "table_dns_zone_name": "privatelink.table.core.windows.net",<br/>  "vault_dns_zone_name": "privatelink.vaultcore.azure.net"<br/>}</pre> | no |
| <a name="input_enable_firewall_for_keyvaults_and_storage"></a> [enable\_firewall\_for\_keyvaults\_and\_storage](#input\_enable\_firewall\_for\_keyvaults\_and\_storage) | [OBSOLETE]Boolean value indicating if firewall should be enabled for key vaults and storage | `bool` | `false` | no |
| <a name="input_enable_purge_control_for_keyvaults"></a> [enable\_purge\_control\_for\_keyvaults](#input\_enable\_purge\_control\_for\_keyvaults) | Disables the purge protection for Azure keyvaults. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | This is the environment name of the deployer | `string` | `""` | no |
| <a name="input_firewall_allowed_ipaddresses"></a> [firewall\_allowed\_ipaddresses](#input\_firewall\_allowed\_ipaddresses) | List of allowed IP addresses to be part of the firewall rule | `list` | `[]` | no |
| <a name="input_firewall_deployment"></a> [firewall\_deployment](#input\_firewall\_deployment) | Boolean flag indicating if an Azure Firewall should be deployed | `bool` | `false` | no |
| <a name="input_firewall_public_ip_tags"></a> [firewall\_public\_ip\_tags](#input\_firewall\_public\_ip\_tags) | Tags for the public\_ip resource attached to firewall | `map(string)` | `null` | no |
| <a name="input_firewall_rule_subnets"></a> [firewall\_rule\_subnets](#input\_firewall\_rule\_subnets) | List of subnets that are part of the firewall rule | `list` | `[]` | no |
| <a name="input_infrastructure"></a> [infrastructure](#input\_infrastructure) | Details of the Azure infrastructure to deploy the deployer into | `map` | `{}` | no |
| <a name="input_key_vault"></a> [key\_vault](#input\_key\_vault) | Import existing Azure Key Vaults | `map` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Defines the Azure location where the resources will be deployed | `string` | n/a | yes |
| <a name="input_management_bastion_subnet_address_prefix"></a> [management\_bastion\_subnet\_address\_prefix](#input\_management\_bastion\_subnet\_address\_prefix) | Subnet adress range for the bastion subnet | `string` | `""` | no |
| <a name="input_management_bastion_subnet_arm_id"></a> [management\_bastion\_subnet\_arm\_id](#input\_management\_bastion\_subnet\_arm\_id) | Azure resource identifier Azure Bastion subnet | `string` | `""` | no |
| <a name="input_management_dns_resourcegroup_name"></a> [management\_dns\_resourcegroup\_name](#input\_management\_dns\_resourcegroup\_name) | String value giving the possibility to register custom dns a records in a separate resourcegroup | `string` | `""` | no |
| <a name="input_management_dns_subscription_id"></a> [management\_dns\_subscription\_id](#input\_management\_dns\_subscription\_id) | String value giving the possibility to register custom dns a records in a separate subscription | `string` | `""` | no |
| <a name="input_management_firewall_subnet_address_prefix"></a> [management\_firewall\_subnet\_address\_prefix](#input\_management\_firewall\_subnet\_address\_prefix) | value of the address prefix of the subnet into which the firewall will be deployed | `string` | `""` | no |
| <a name="input_management_firewall_subnet_arm_id"></a> [management\_firewall\_subnet\_arm\_id](#input\_management\_firewall\_subnet\_arm\_id) | Azure resource identifier for the existing subnet into which the firewall will be deployed | `string` | `""` | no |
| <a name="input_management_network_address_space"></a> [management\_network\_address\_space](#input\_management\_network\_address\_space) | The address space of the VNet into which the deployer will be deployed | `string` | `""` | no |
| <a name="input_management_network_arm_id"></a> [management\_network\_arm\_id](#input\_management\_network\_arm\_id) | Azure resource identifier for the existing VNet into which the deployer will be deployed | `string` | `""` | no |
| <a name="input_management_network_flow_timeout_in_minutes"></a> [management\_network\_flow\_timeout\_in\_minutes](#input\_management\_network\_flow\_timeout\_in\_minutes) | The flow timeout in minutes of the VNet into which the deployer will be deployed | `number` | `null` | no |
| <a name="input_management_network_logical_name"></a> [management\_network\_logical\_name](#input\_management\_network\_logical\_name) | The logical name of the VNet, used for naming purposes | `string` | `""` | no |
| <a name="input_management_network_name"></a> [management\_network\_name](#input\_management\_network\_name) | If provided, the name of the VNet into which the deployer will be deployed | `string` | `""` | no |
| <a name="input_management_subnet_address_prefix"></a> [management\_subnet\_address\_prefix](#input\_management\_subnet\_address\_prefix) | The address prefix of the subnet into which the deployer will be deployed | `string` | `""` | no |
| <a name="input_management_subnet_arm_id"></a> [management\_subnet\_arm\_id](#input\_management\_subnet\_arm\_id) | Azure resource identifier for the existing subnet into which the deployer will be deployed | `string` | `""` | no |
| <a name="input_management_subnet_name"></a> [management\_subnet\_name](#input\_management\_subnet\_name) | The name of the subnet into which the deployer will be deployed | `string` | `""` | no |
| <a name="input_management_subnet_nsg_allowed_ips"></a> [management\_subnet\_nsg\_allowed\_ips](#input\_management\_subnet\_nsg\_allowed\_ips) | IP allowed to access the deployer | `list` | `[]` | no |
| <a name="input_management_subnet_nsg_arm_id"></a> [management\_subnet\_nsg\_arm\_id](#input\_management\_subnet\_nsg\_arm\_id) | value of the Azure resource identifier for the network security group | `string` | `""` | no |
| <a name="input_management_subnet_nsg_name"></a> [management\_subnet\_nsg\_name](#input\_management\_subnet\_nsg\_name) | The name of the network security group | `string` | `""` | no |
| <a name="input_name_override_file"></a> [name\_override\_file](#input\_name\_override\_file) | If provided, contains a json formatted file defining the name overrides | `string` | `""` | no |
| <a name="input_options"></a> [options](#input\_options) | Configuration options | `map` | `{}` | no |
| <a name="input_place_delete_lock_on_resources"></a> [place\_delete\_lock\_on\_resources](#input\_place\_delete\_lock\_on\_resources) | If defined, a delete lock will be placed on the key resources | `bool` | `false` | no |
| <a name="input_prevent_deletion_if_contains_resources"></a> [prevent\_deletion\_if\_contains\_resources](#input\_prevent\_deletion\_if\_contains\_resources) | Controls if resource groups are deleted even if they contain resources | `bool` | `true` | no |
| <a name="input_privatelink_dns_resourcegroup_name"></a> [privatelink\_dns\_resourcegroup\_name](#input\_privatelink\_dns\_resourcegroup\_name) | String value giving the possibility to register custom PrivateLink DNS A records in a separate resourcegroup | `string` | `""` | no |
| <a name="input_privatelink_dns_subscription_id"></a> [privatelink\_dns\_subscription\_id](#input\_privatelink\_dns\_subscription\_id) | String value giving the possibility to register custom PrivateLink DNS A records in a separate subscription | `string` | `""` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Boolean value indicating if public access should be enabled for key vaults and storage | `bool` | `true` | no |
| <a name="input_recover"></a> [recover](#input\_recover) | Defines if in recovery mode | `bool` | `false` | no |
| <a name="input_resourcegroup_arm_id"></a> [resourcegroup\_arm\_id](#input\_resourcegroup\_arm\_id) | If provid, the Azure resource group id | `string` | `""` | no |
| <a name="input_resourcegroup_name"></a> [resourcegroup\_name](#input\_resourcegroup\_name) | If provided, the name of the resource group to be created | `string` | `""` | no |
| <a name="input_resourcegroup_tags"></a> [resourcegroup\_tags](#input\_resourcegroup\_tags) | Tags to be applied to the resource group | `map` | `{}` | no |
| <a name="input_sa_connection_string"></a> [sa\_connection\_string](#input\_sa\_connection\_string) | value to define the connection string for the Terraform state storage account | `string` | `""` | no |
| <a name="input_set_secret_expiry"></a> [set\_secret\_expiry](#input\_set\_secret\_expiry) | Set expiry date for secrets | `bool` | `false` | no |
| <a name="input_shared_access_key_enabled"></a> [shared\_access\_key\_enabled](#input\_shared\_access\_key\_enabled) | Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. | `bool` | `false` | no |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | The number of days that items should be retained in the soft delete period | `number` | `7` | no |
| <a name="input_spn_id"></a> [spn\_id](#input\_spn\_id) | SPN ID to be used for the deployment | `string` | `""` | no |
| <a name="input_ssh-timeout"></a> [ssh-timeout](#input\_ssh-timeout) | Timeout for connection that is used by provisioner | `string` | `"30s"` | no |
| <a name="input_subnets_to_add_to_firewall_for_keyvaults_and_storage"></a> [subnets\_to\_add\_to\_firewall\_for\_keyvaults\_and\_storage](#input\_subnets\_to\_add\_to\_firewall\_for\_keyvaults\_and\_storage) | List of subnets to add to storage account and keyvaults firewall | `list` | `[]` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Defines the Azure subscription\_id | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | If provided, tags for all resources | `map` | `{}` | no |
| <a name="input_terraform_template_version"></a> [terraform\_template\_version](#input\_terraform\_template\_version) | The version of Terraform templates that were identified in the state file | `string` | `""` | no |
| <a name="input_tf_version"></a> [tf\_version](#input\_tf\_version) | Terraform version to install on deployer | `string` | `"1.9.8"` | no |
| <a name="input_tfstate_resource_id"></a> [tfstate\_resource\_id](#input\_tfstate\_resource\_id) | Resource id of tfstate storage account | `any` | n/a | yes |
| <a name="input_use_custom_dns_a_registration"></a> [use\_custom\_dns\_a\_registration](#input\_use\_custom\_dns\_a\_registration) | Boolean value indicating if a custom dns a record should be created when using private endpoints | `bool` | `false` | no |
| <a name="input_use_private_endpoint"></a> [use\_private\_endpoint](#input\_use\_private\_endpoint) | Boolean value indicating if private endpoint should be used for the deployment | `bool` | `false` | no |
| <a name="input_use_service_endpoint"></a> [use\_service\_endpoint](#input\_use\_service\_endpoint) | Boolean value indicating if service endpoints should be used for the deployment | `bool` | `false` | no |
| <a name="input_use_spn"></a> [use\_spn](#input\_use\_spn) | Log in using a service principal when performing the deployment | `bool` | `false` | no |
| <a name="input_use_webapp"></a> [use\_webapp](#input\_use\_webapp) | Boolean value indicating if a webapp should be deployed | `bool` | `false` | no |
| <a name="input_user_assigned_identity_id"></a> [user\_assigned\_identity\_id](#input\_user\_assigned\_identity\_id) | User assigned Identity resource Id | `string` | `""` | no |
| <a name="input_user_keyvault_id"></a> [user\_keyvault\_id](#input\_user\_keyvault\_id) | Azure resource identifier for the Azure Key Vault containing the deployment credentials | `string` | `""` | no |
| <a name="input_webapp_client_secret"></a> [webapp\_client\_secret](#input\_webapp\_client\_secret) | value to define the client secret for the webapp | `string` | `""` | no |
| <a name="input_webapp_subnet_address_prefix"></a> [webapp\_subnet\_address\_prefix](#input\_webapp\_subnet\_address\_prefix) | Subnet address range for the Web App subnet | `string` | `""` | no |
| <a name="input_webapp_subnet_arm_id"></a> [webapp\_subnet\_arm\_id](#input\_webapp\_subnet\_arm\_id) | Azure resource identifier Web App subnet | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_Agent_IP"></a> [Agent\_IP](#output\_Agent\_IP) | The IP address of the agent |
| <a name="output_add_system_assigned_identity"></a> [add\_system\_assigned\_identity](#output\_add\_system\_assigned\_identity) | Define if a system assigned identity should be added to the deployer |
| <a name="output_automation_version"></a> [automation\_version](#output\_automation\_version) | Defines the version of the automation templates used |
| <a name="output_created_resource_group_id"></a> [created\_resource\_group\_id](#output\_created\_resource\_group\_id) | Created resource group ID |
| <a name="output_created_resource_group_location"></a> [created\_resource\_group\_location](#output\_created\_resource\_group\_location) | Created resource group's location |
| <a name="output_created_resource_group_name"></a> [created\_resource\_group\_name](#output\_created\_resource\_group\_name) | Created resource group name |
| <a name="output_created_resource_group_subscription_id"></a> [created\_resource\_group\_subscription\_id](#output\_created\_resource\_group\_subscription\_id) | Created resource group' subscription ID |
| <a name="output_deployer_extension_ids"></a> [deployer\_extension\_ids](#output\_deployer\_extension\_ids) | List of extension IDs |
| <a name="output_deployer_id"></a> [deployer\_id](#output\_deployer\_id) | Random ID for deployer |
| <a name="output_deployer_kv_user_arm_id"></a> [deployer\_kv\_user\_arm\_id](#output\_deployer\_kv\_user\_arm\_id) | Azure resource identifier for the key vault containing the deployment credentials |
| <a name="output_deployer_kv_user_name"></a> [deployer\_kv\_user\_name](#output\_deployer\_kv\_user\_name) | Name of the key vault containing the deployment credentials |
| <a name="output_deployer_msi_id"></a> [deployer\_msi\_id](#output\_deployer\_msi\_id) | The ID of the deployer MSI |
| <a name="output_deployer_public_ip_address"></a> [deployer\_public\_ip\_address](#output\_deployer\_public\_ip\_address) | Public IP address of the deployer |
| <a name="output_deployer_sshkey"></a> [deployer\_sshkey](#output\_deployer\_sshkey) | Name of the secreet containing the deployer ssh key |
| <a name="output_deployer_sshkey_secret_name"></a> [deployer\_sshkey\_secret\_name](#output\_deployer\_sshkey\_secret\_name) | Defines the name of the secret in the Azure Key Vault that contains the private key |
| <a name="output_deployer_system_assigned_identity"></a> [deployer\_system\_assigned\_identity](#output\_deployer\_system\_assigned\_identity) | value of the system assigned identity for the deployer |
| <a name="output_deployer_uai"></a> [deployer\_uai](#output\_deployer\_uai) | Information about the deployer user assigned identity |
| <a name="output_deployer_user_assigned_identity"></a> [deployer\_user\_assigned\_identity](#output\_deployer\_user\_assigned\_identity) | The Object ID of the deployer MSI |
| <a name="output_enable_firewall_for_keyvaults_and_storage"></a> [enable\_firewall\_for\_keyvaults\_and\_storage](#output\_enable\_firewall\_for\_keyvaults\_and\_storage) | Defines if the firewall should be enabled for keyvaults and storage |
| <a name="output_environment"></a> [environment](#output\_environment) | Deployer environment name |
| <a name="output_firewall_id"></a> [firewall\_id](#output\_firewall\_id) | The Azure resource ID of the firewall |
| <a name="output_firewall_ip"></a> [firewall\_ip](#output\_firewall\_ip) | The IP address of the firewall |
| <a name="output_public_network_access_enabled"></a> [public\_network\_access\_enabled](#output\_public\_network\_access\_enabled) | Defines if the public access should be enabled for keyvaults and storage |
| <a name="output_random_id"></a> [random\_id](#output\_random\_id) | Random ID for deployer |
| <a name="output_set_secret_expiry"></a> [set\_secret\_expiry](#output\_set\_secret\_expiry) | Defines if key vault secrets should be set to expire |
| <a name="output_subnet_bastion_address_prefixes"></a> [subnet\_bastion\_address\_prefixes](#output\_subnet\_bastion\_address\_prefixes) | The address prefices for the bastion subnet |
| <a name="output_subnet_mgmt_address_prefixes"></a> [subnet\_mgmt\_address\_prefixes](#output\_subnet\_mgmt\_address\_prefixes) | The address prefices for the management subnet |
| <a name="output_subnet_mgmt_id"></a> [subnet\_mgmt\_id](#output\_subnet\_mgmt\_id) | The resource ID for the management subnet |
| <a name="output_subnet_webapp_id"></a> [subnet\_webapp\_id](#output\_subnet\_webapp\_id) | The resource ID for the WebApp subnet |
| <a name="output_subnets_to_add_to_firewall_for_keyvaults_and_storage"></a> [subnets\_to\_add\_to\_firewall\_for\_keyvaults\_and\_storage](#output\_subnets\_to\_add\_to\_firewall\_for\_keyvaults\_and\_storage) | List of subnets to add to the firewall for keyvaults and storage |
| <a name="output_vnet_mgmt_id"></a> [vnet\_mgmt\_id](#output\_vnet\_mgmt\_id) | The resource ID for the management VNet |
| <a name="output_webapp_id"></a> [webapp\_id](#output\_webapp\_id) | The Azure resource ID of the configuration Web Application |
| <a name="output_webapp_identity"></a> [webapp\_identity](#output\_webapp\_identity) | The identity of the configuration Web Application |
| <a name="output_webapp_url_base"></a> [webapp\_url\_base](#output\_webapp\_url\_base) | The URL of the configuration Web Application |
<!-- END_TF_DOCS -->