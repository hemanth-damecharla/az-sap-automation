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
| <a name="provider_azurerm.deployer"></a> [azurerm.deployer](#provider\_azurerm.deployer) | 4.11.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_sap_library"></a> [sap\_library](#module\_sap\_library) | ../../terraform-units/modules/sap_library | n/a |
| <a name="module_sap_namegenerator"></a> [sap\_namegenerator](#module\_sap\_namegenerator) | ../../terraform-units/modules/sap_namegenerator | n/a |

## Resources

| Name | Type |
|------|------|
| [azuread_service_principal.sp](https://registry.terraform.io/providers/hashicorp/azuread/3.0.2/docs/data-sources/service_principal) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/4.11.0/docs/data-sources/client_config) | data source |
| [azurerm_key_vault_secret.client_id](https://registry.terraform.io/providers/hashicorp/azurerm/4.11.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.client_secret](https://registry.terraform.io/providers/hashicorp/azurerm/4.11.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.subscription_id](https://registry.terraform.io/providers/hashicorp/azurerm/4.11.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.tenant_id](https://registry.terraform.io/providers/hashicorp/azurerm/4.11.0/docs/data-sources/key_vault_secret) | data source |
| [terraform_remote_state.deployer](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_Agent_IP"></a> [Agent\_IP](#input\_Agent\_IP) | IP address of the agent | `string` | `""` | no |
| <a name="input_add_Agent_IP"></a> [add\_Agent\_IP](#input\_add\_Agent\_IP) | Boolean value indicating if the Agent IP should be added to the storage and key vault firewalls | `bool` | `true` | no |
| <a name="input_additional_network_id"></a> [additional\_network\_id](#input\_additional\_network\_id) | Agent Network resource ID | `string` | `""` | no |
| <a name="input_codename"></a> [codename](#input\_codename) | Additional component for naming the resources | `string` | `""` | no |
| <a name="input_create_privatelink_dns_zones"></a> [create\_privatelink\_dns\_zones](#input\_create\_privatelink\_dns\_zones) | Boolean value indicating if PrivateLink DNS Zones should be created | `bool` | `true` | no |
| <a name="input_custom_random_id"></a> [custom\_random\_id](#input\_custom\_random\_id) | If provided, the value of the custom random id | `string` | `""` | no |
| <a name="input_data_plane_available"></a> [data\_plane\_available](#input\_data\_plane\_available) | Boolean value indicating if storage account access is via data plane | `bool` | `false` | no |
| <a name="input_deployer"></a> [deployer](#input\_deployer) | Details of deployer | `map` | `{}` | no |
| <a name="input_deployer_statefile_foldername"></a> [deployer\_statefile\_foldername](#input\_deployer\_statefile\_foldername) | Folder name of folder containing the terraform state file | `string` | `""` | no |
| <a name="input_deployer_tfstate_key"></a> [deployer\_tfstate\_key](#input\_deployer\_tfstate\_key) | The key of deployer's remote tfstate file | `string` | `""` | no |
| <a name="input_deployment"></a> [deployment](#input\_deployment) | The type of deployment | `string` | `"update"` | no |
| <a name="input_dns_label"></a> [dns\_label](#input\_dns\_label) | DNS label | `string` | `""` | no |
| <a name="input_dns_zone_names"></a> [dns\_zone\_names](#input\_dns\_zone\_names) | Private DNS zone names | `map(string)` | <pre>{<br/>  "blob_dns_zone_name": "privatelink.blob.core.windows.net",<br/>  "file_dns_zone_name": "privatelink.file.core.windows.net",<br/>  "table_dns_zone_name": "privatelink.table.core.windows.net",<br/>  "vault_dns_zone_name": "privatelink.vaultcore.azure.net"<br/>}</pre> | no |
| <a name="input_enable_firewall_for_keyvaults_and_storage"></a> [enable\_firewall\_for\_keyvaults\_and\_storage](#input\_enable\_firewall\_for\_keyvaults\_and\_storage) | Boolean value indicating if firewall should be enabled for key vaults and storage | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | This is the environment name of the deployer | `string` | `""` | no |
| <a name="input_infrastructure"></a> [infrastructure](#input\_infrastructure) | Details of the Azure infrastructure to deploy the SAP library into | `map` | `{}` | no |
| <a name="input_key_vault"></a> [key\_vault](#input\_key\_vault) | Import existing Azure Key Vaults | `map` | `{}` | no |
| <a name="input_library_ansible_blob_container_is_existing"></a> [library\_ansible\_blob\_container\_is\_existing](#input\_library\_ansible\_blob\_container\_is\_existing) | If defined use an existing blob container | `bool` | `false` | no |
| <a name="input_library_ansible_blob_container_name"></a> [library\_ansible\_blob\_container\_name](#input\_library\_ansible\_blob\_container\_name) | If defined, the blob container name to create | `string` | `"ansible"` | no |
| <a name="input_library_sapmedia_account_kind"></a> [library\_sapmedia\_account\_kind](#input\_library\_sapmedia\_account\_kind) | The storage account kind | `string` | `"StorageV2"` | no |
| <a name="input_library_sapmedia_account_replication_type"></a> [library\_sapmedia\_account\_replication\_type](#input\_library\_sapmedia\_account\_replication\_type) | The replication type for the storage account | `string` | `"LRS"` | no |
| <a name="input_library_sapmedia_account_tier"></a> [library\_sapmedia\_account\_tier](#input\_library\_sapmedia\_account\_tier) | The storage account tier | `string` | `"Standard"` | no |
| <a name="input_library_sapmedia_arm_id"></a> [library\_sapmedia\_arm\_id](#input\_library\_sapmedia\_arm\_id) | Optional Azure resource identifier for the storage account where the SAP bits will be stored | `string` | `""` | no |
| <a name="input_library_sapmedia_blob_container_enable_deployment"></a> [library\_sapmedia\_blob\_container\_enable\_deployment](#input\_library\_sapmedia\_blob\_container\_enable\_deployment) | If true, the blob container will be created | `bool` | `true` | no |
| <a name="input_library_sapmedia_blob_container_is_existing"></a> [library\_sapmedia\_blob\_container\_is\_existing](#input\_library\_sapmedia\_blob\_container\_is\_existing) | If defined use an existing blob container | `bool` | `false` | no |
| <a name="input_library_sapmedia_blob_container_name"></a> [library\_sapmedia\_blob\_container\_name](#input\_library\_sapmedia\_blob\_container\_name) | If defined, the name of the blob container | `string` | `"sapbits"` | no |
| <a name="input_library_sapmedia_file_share_enable_deployment"></a> [library\_sapmedia\_file\_share\_enable\_deployment](#input\_library\_sapmedia\_file\_share\_enable\_deployment) | If true, the file share will be created | `bool` | `true` | no |
| <a name="input_library_sapmedia_file_share_is_existing"></a> [library\_sapmedia\_file\_share\_is\_existing](#input\_library\_sapmedia\_file\_share\_is\_existing) | If defined use an existing file share | `bool` | `false` | no |
| <a name="input_library_sapmedia_file_share_name"></a> [library\_sapmedia\_file\_share\_name](#input\_library\_sapmedia\_file\_share\_name) | If defined, the name of the file share | `string` | `"sapbits"` | no |
| <a name="input_library_sapmedia_name"></a> [library\_sapmedia\_name](#input\_library\_sapmedia\_name) | If defined, the name of the storage account where the SAP bits will be stored | `string` | `""` | no |
| <a name="input_library_terraform_state_account_kind"></a> [library\_terraform\_state\_account\_kind](#input\_library\_terraform\_state\_account\_kind) | The storage account kind | `string` | `"StorageV2"` | no |
| <a name="input_library_terraform_state_account_replication_type"></a> [library\_terraform\_state\_account\_replication\_type](#input\_library\_terraform\_state\_account\_replication\_type) | The replication type for the storage account | `string` | `"LRS"` | no |
| <a name="input_library_terraform_state_account_tier"></a> [library\_terraform\_state\_account\_tier](#input\_library\_terraform\_state\_account\_tier) | The storage account tier | `string` | `"Standard"` | no |
| <a name="input_library_terraform_state_arm_id"></a> [library\_terraform\_state\_arm\_id](#input\_library\_terraform\_state\_arm\_id) | Optional Azure resource identifier for the storage account where the terraform state will be stored | `string` | `""` | no |
| <a name="input_library_terraform_state_blob_container_is_existing"></a> [library\_terraform\_state\_blob\_container\_is\_existing](#input\_library\_terraform\_state\_blob\_container\_is\_existing) | If defined use an existing blob container | `bool` | `false` | no |
| <a name="input_library_terraform_state_blob_container_name"></a> [library\_terraform\_state\_blob\_container\_name](#input\_library\_terraform\_state\_blob\_container\_name) | If defined, the blob container name to create | `string` | `"tfstate"` | no |
| <a name="input_library_terraform_state_name"></a> [library\_terraform\_state\_name](#input\_library\_terraform\_state\_name) | Optional name for the storage account where the terraform state will be stored | `string` | `""` | no |
| <a name="input_library_terraform_vars_blob_container_is_existing"></a> [library\_terraform\_vars\_blob\_container\_is\_existing](#input\_library\_terraform\_vars\_blob\_container\_is\_existing) | If defined use an existing blob container for terraform vars | `bool` | `false` | no |
| <a name="input_library_terraform_vars_blob_container_name"></a> [library\_terraform\_vars\_blob\_container\_name](#input\_library\_terraform\_vars\_blob\_container\_name) | If defined, the blob container name to create | `string` | `"tfvars"` | no |
| <a name="input_location"></a> [location](#input\_location) | Defines the Azure location where the resources will be deployed | `string` | n/a | yes |
| <a name="input_management_dns_resourcegroup_name"></a> [management\_dns\_resourcegroup\_name](#input\_management\_dns\_resourcegroup\_name) | String value giving the possibility to register custom dns a records in a separate resourcegroup | `string` | `""` | no |
| <a name="input_management_dns_subscription_id"></a> [management\_dns\_subscription\_id](#input\_management\_dns\_subscription\_id) | String value giving the possibility to register custom dns a records in a separate subscription | `string` | `""` | no |
| <a name="input_name_override_file"></a> [name\_override\_file](#input\_name\_override\_file) | If provided, contains a json formatted file defining the name overrides | `string` | `""` | no |
| <a name="input_place_delete_lock_on_resources"></a> [place\_delete\_lock\_on\_resources](#input\_place\_delete\_lock\_on\_resources) | If defined, a delete lock will be placed on the key resources | `bool` | `false` | no |
| <a name="input_prevent_deletion_if_contains_resources"></a> [prevent\_deletion\_if\_contains\_resources](#input\_prevent\_deletion\_if\_contains\_resources) | Controls if resource groups are deleted even if they contain resources | `bool` | `true` | no |
| <a name="input_privatelink_dns_resourcegroup_name"></a> [privatelink\_dns\_resourcegroup\_name](#input\_privatelink\_dns\_resourcegroup\_name) | String value giving the possibility to register custom PrivateLink DNS A records in a separate resourcegroup | `string` | `""` | no |
| <a name="input_privatelink_dns_subscription_id"></a> [privatelink\_dns\_subscription\_id](#input\_privatelink\_dns\_subscription\_id) | String value giving the possibility to register custom PrivateLink DNS A records in a separate subscription | `string` | `""` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Boolean value indicating if public access should be enabled for key vaults and storage | `bool` | `true` | no |
| <a name="input_register_endpoints_with_dns"></a> [register\_endpoints\_with\_dns](#input\_register\_endpoints\_with\_dns) | Boolean value indicating if endpoints should be registered to the dns zone | `bool` | `true` | no |
| <a name="input_register_storage_accounts_keyvaults_with_dns"></a> [register\_storage\_accounts\_keyvaults\_with\_dns](#input\_register\_storage\_accounts\_keyvaults\_with\_dns) | Boolean value indicating if storage accounts and key vaults should be registered to the corresponding dns zones | `bool` | `true` | no |
| <a name="input_resourcegroup_arm_id"></a> [resourcegroup\_arm\_id](#input\_resourcegroup\_arm\_id) | If provided, the Azure resource group id | `string` | `""` | no |
| <a name="input_resourcegroup_name"></a> [resourcegroup\_name](#input\_resourcegroup\_name) | If provided, the name of the resource group to be created | `string` | `""` | no |
| <a name="input_resourcegroup_tags"></a> [resourcegroup\_tags](#input\_resourcegroup\_tags) | Tags to be applied to the resource group | `map` | `{}` | no |
| <a name="input_shared_access_key_enabled"></a> [shared\_access\_key\_enabled](#input\_shared\_access\_key\_enabled) | Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. | `bool` | `false` | no |
| <a name="input_short_named_endpoints_nics"></a> [short\_named\_endpoints\_nics](#input\_short\_named\_endpoints\_nics) | If defined, uses short names for private endpoints nics | `bool` | `false` | no |
| <a name="input_spn_keyvault_id"></a> [spn\_keyvault\_id](#input\_spn\_keyvault\_id) | Azure resource identifier for the keyvault where the spn will be stored | `string` | `""` | no |
| <a name="input_storage_account_sapbits"></a> [storage\_account\_sapbits](#input\_storage\_account\_sapbits) | Details of the Storage account for storing sap bits | `map` | `{}` | no |
| <a name="input_storage_account_tfstate"></a> [storage\_account\_tfstate](#input\_storage\_account\_tfstate) | Details of the Storage account for storing tfstate | `map` | `{}` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Defines the Azure subscription\_id | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | If provided, tags for all resources | `map` | `{}` | no |
| <a name="input_terraform_template_version"></a> [terraform\_template\_version](#input\_terraform\_template\_version) | The version of Terraform templates that were identified in the state file | `string` | `""` | no |
| <a name="input_tfstate_resource_id"></a> [tfstate\_resource\_id](#input\_tfstate\_resource\_id) | Resource id of tfstate storage account | `any` | n/a | yes |
| <a name="input_use_custom_dns_a_registration"></a> [use\_custom\_dns\_a\_registration](#input\_use\_custom\_dns\_a\_registration) | Boolean value indicating if a custom dns a record should be created when using private endpoints | `bool` | `false` | no |
| <a name="input_use_deployer"></a> [use\_deployer](#input\_use\_deployer) | Use deployer to deploy the resources | `bool` | `true` | no |
| <a name="input_use_private_endpoint"></a> [use\_private\_endpoint](#input\_use\_private\_endpoint) | Boolean value indicating if private endpoint should be used for the deployment | `bool` | `false` | no |
| <a name="input_use_spn"></a> [use\_spn](#input\_use\_spn) | Log in using a service principal when performing the deployment | `bool` | `false` | no |
| <a name="input_use_webapp"></a> [use\_webapp](#input\_use\_webapp) | Boolean value indicating if a webapp should be created | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_automation_version"></a> [automation\_version](#output\_automation\_version) | Version of automation |
| <a name="output_created_resource_group_id"></a> [created\_resource\_group\_id](#output\_created\_resource\_group\_id) | Created resource group ID |
| <a name="output_created_resource_group_name"></a> [created\_resource\_group\_name](#output\_created\_resource\_group\_name) | Created resource group name |
| <a name="output_created_resource_group_subscription_id"></a> [created\_resource\_group\_subscription\_id](#output\_created\_resource\_group\_subscription\_id) | Created resource group' subscription ID |
| <a name="output_random_id"></a> [random\_id](#output\_random\_id) | Random ID for library |
| <a name="output_remote_state_storage_account_name"></a> [remote\_state\_storage\_account\_name](#output\_remote\_state\_storage\_account\_name) | Storage account name for Terraform remote state |
| <a name="output_sa_connection_string"></a> [sa\_connection\_string](#output\_sa\_connection\_string) | Connection string to storage account |
| <a name="output_sapbits_sa_resource_group_name"></a> [sapbits\_sa\_resource\_group\_name](#output\_sapbits\_sa\_resource\_group\_name) | Resource group name for SAP Binaries |
| <a name="output_sapbits_storage_account_name"></a> [sapbits\_storage\_account\_name](#output\_sapbits\_storage\_account\_name) | Storage account name for SAP Binaries |
| <a name="output_saplibrary_environment"></a> [saplibrary\_environment](#output\_saplibrary\_environment) | Name of enfironment |
| <a name="output_saplibrary_subscription_id"></a> [saplibrary\_subscription\_id](#output\_saplibrary\_subscription\_id) | Subscription Id for SAP Binaries |
| <a name="output_tfstate_resource_id"></a> [tfstate\_resource\_id](#output\_tfstate\_resource\_id) | Azure Resource identifier for Terraform remote state |
<!-- END_TF_DOCS -->