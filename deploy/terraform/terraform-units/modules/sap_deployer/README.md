<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_azurerm.main"></a> [azurerm.main](#provider\_azurerm.main) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_app_service_virtual_network_swift_connection.webapp_vnet_connection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_virtual_network_swift_connection) | resource |
| [azurerm_bastion_host.bastion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host) | resource |
| [azurerm_firewall.firewall](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) | resource |
| [azurerm_firewall_network_rule_collection.firewall-azure](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_network_rule_collection) | resource |
| [azurerm_key_vault.kv_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_access_policy.kv_user_additional_users](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.kv_user_msi](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.kv_user_pre_deployer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.kv_user_systemidentity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_secret.pat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.pk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.ppk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.pwd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.subscription](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_virtual_machine.deployer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_management_lock.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_network_interface.deployer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_security_group.nsg_mgmt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.nsr_rdp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.nsr_ssh](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.nsr_winrm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_public_ip.bastion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.deployer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.firewall](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.deployer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.deployer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.resource_group_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.resource_group_contributor_contributor_msi](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.subscription_contributor_system_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_route.admin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route_table.rt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_service_plan.appserviceplan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |
| [azurerm_storage_account.deployer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_subnet.bastion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.firewall](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.subnet_mgmt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.webapp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.associate_nsg_mgmt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_user_assigned_identity.deployer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_virtual_machine_extension.configure](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.monitoring_defender_deployer_lnx](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.monitoring_extension_deployer_lnx](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_network.vnet_mgmt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_peering.peering_agent_management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_virtual_network_peering.peering_management_agent](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_windows_web_app.webapp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_web_app) | resource |
| [local_file.configure_deployer](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.prepare-deployer](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_id.deployer](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_integer.priority](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [random_password.deployer](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [time_offset.secret_expiry_date](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/offset) | resource |
| [time_sleep.wait_for_VM](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_for_keyvault](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [tls_private_key.deployer](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_client_config.deployer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.kv_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.pk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.ppk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.pwd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_network_security_group.nsg_mgmt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_security_group) | data source |
| [azurerm_resource_group.deployer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_storage_account.deployer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [azurerm_subnet.bastion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subnet.firewall](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subnet.subnet_mgmt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subnet.webapp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subscription.primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_user_assigned_identity.deployer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) | data source |
| [azurerm_virtual_network.agent_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |
| [azurerm_virtual_network.vnet_mgmt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_Agent_IP"></a> [Agent\_IP](#input\_Agent\_IP) | If provided, contains the IP address of the agent | `any` | n/a | yes |
| <a name="input_additional_network_id"></a> [additional\_network\_id](#input\_additional\_network\_id) | Additional network ID | `any` | n/a | yes |
| <a name="input_additional_users_to_add_to_keyvault_policies"></a> [additional\_users\_to\_add\_to\_keyvault\_policies](#input\_additional\_users\_to\_add\_to\_keyvault\_policies) | List of object IDs to add to key vault policies | `any` | n/a | yes |
| <a name="input_agent_ado_url"></a> [agent\_ado\_url](#input\_agent\_ado\_url) | If provided, contains the Url to the ADO repository | `any` | n/a | yes |
| <a name="input_agent_pat"></a> [agent\_pat](#input\_agent\_pat) | If provided, contains the Personal Access Token to be used | `any` | n/a | yes |
| <a name="input_agent_pool"></a> [agent\_pool](#input\_agent\_pool) | If provided, contains the name of the agent pool to be used | `any` | n/a | yes |
| <a name="input_ansible_core_version"></a> [ansible\_core\_version](#input\_ansible\_core\_version) | If provided, the version of ansible core to be installed | `any` | n/a | yes |
| <a name="input_app_registration_app_id"></a> [app\_registration\_app\_id](#input\_app\_registration\_app\_id) | App registration app id | `any` | n/a | yes |
| <a name="input_app_service"></a> [app\_service](#input\_app\_service) | Details of the Application Service | `any` | n/a | yes |
| <a name="input_arm_client_id"></a> [arm\_client\_id](#input\_arm\_client\_id) | ARM client id | `any` | n/a | yes |
| <a name="input_assign_subscription_permissions"></a> [assign\_subscription\_permissions](#input\_assign\_subscription\_permissions) | Assign permissions on the subscription | `any` | n/a | yes |
| <a name="input_authentication"></a> [authentication](#input\_authentication) | Dictionary of authentication information | `any` | n/a | yes |
| <a name="input_auto_configure_deployer"></a> [auto\_configure\_deployer](#input\_auto\_configure\_deployer) | Value indicating if the deployer should be configured automatically | `any` | n/a | yes |
| <a name="input_bastion_deployment"></a> [bastion\_deployment](#input\_bastion\_deployment) | Value indicating if Azure Bastion should be deployed | `any` | n/a | yes |
| <a name="input_bastion_sku"></a> [bastion\_sku](#input\_bastion\_sku) | The SKU of the Bastion Host. Accepted values are Basic or Standard | `any` | n/a | yes |
| <a name="input_bootstrap"></a> [bootstrap](#input\_bootstrap) | Defines the phase of deployment | `any` | n/a | yes |
| <a name="input_configure"></a> [configure](#input\_configure) | Value indicating if deployer should be configured | `any` | n/a | yes |
| <a name="input_deployer"></a> [deployer](#input\_deployer) | Dictionary of information about the deployer | `any` | n/a | yes |
| <a name="input_deployer_vm_count"></a> [deployer\_vm\_count](#input\_deployer\_vm\_count) | Number of deployer VMs to create | `number` | `1` | no |
| <a name="input_dns_settings"></a> [dns\_settings](#input\_dns\_settings) | DNS details for the deployment | `map` | `{}` | no |
| <a name="input_enable_firewall_for_keyvaults_and_storage"></a> [enable\_firewall\_for\_keyvaults\_and\_storage](#input\_enable\_firewall\_for\_keyvaults\_and\_storage) | Boolean value indicating if firewall should be enabled for key vaults and storage | `bool` | `false` | no |
| <a name="input_enable_purge_control_for_keyvaults"></a> [enable\_purge\_control\_for\_keyvaults](#input\_enable\_purge\_control\_for\_keyvaults) | Disables the purge protection for Azure keyvaults. | `any` | n/a | yes |
| <a name="input_firewall"></a> [firewall](#input\_firewall) | Dictionary of Firewall settings | `any` | n/a | yes |
| <a name="input_infrastructure"></a> [infrastructure](#input\_infrastructure) | Dictionary of information about the common infrastructure | `any` | n/a | yes |
| <a name="input_key_vault"></a> [key\_vault](#input\_key\_vault) | The user brings existing Azure Key Vaults | `any` | n/a | yes |
| <a name="input_naming"></a> [naming](#input\_naming) | Defines the names for the resources | `any` | n/a | yes |
| <a name="input_options"></a> [options](#input\_options) | Dictionary of miscallaneous parameters | `any` | n/a | yes |
| <a name="input_place_delete_lock_on_resources"></a> [place\_delete\_lock\_on\_resources](#input\_place\_delete\_lock\_on\_resources) | If defined, a delete lock will be placed on the key resources | `any` | n/a | yes |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Defines if the public access should be enabled for keyvaults and storage accounts | `any` | n/a | yes |
| <a name="input_sa_connection_string"></a> [sa\_connection\_string](#input\_sa\_connection\_string) | Storage account connection string | `any` | n/a | yes |
| <a name="input_set_secret_expiry"></a> [set\_secret\_expiry](#input\_set\_secret\_expiry) | Set expiry date for secrets | `any` | n/a | yes |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | The number of days that items should be retained in the soft delete period | `any` | n/a | yes |
| <a name="input_spn_id"></a> [spn\_id](#input\_spn\_id) | SPN ID to be used for the deployment | `any` | n/a | yes |
| <a name="input_ssh-timeout"></a> [ssh-timeout](#input\_ssh-timeout) | SSH timeout | `any` | n/a | yes |
| <a name="input_subnets_to_add"></a> [subnets\_to\_add](#input\_subnets\_to\_add) | List of subnets to add to storage account and keyvaults firewall | `list` | `[]` | no |
| <a name="input_tf_version"></a> [tf\_version](#input\_tf\_version) | Terraform version to install on deployer | `any` | n/a | yes |
| <a name="input_use_private_endpoint"></a> [use\_private\_endpoint](#input\_use\_private\_endpoint) | Boolean value indicating if private endpoint should be used for the deployment | `any` | n/a | yes |
| <a name="input_use_service_endpoint"></a> [use\_service\_endpoint](#input\_use\_service\_endpoint) | Boolean value indicating if service endpoints should be used for the deployment | `any` | n/a | yes |
| <a name="input_use_webapp"></a> [use\_webapp](#input\_use\_webapp) | value indicating if webapp should be deployed | `bool` | `false` | no |
| <a name="input_webapp_client_secret"></a> [webapp\_client\_secret](#input\_webapp\_client\_secret) | App registration client secret | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_created_resource_group_id"></a> [created\_resource\_group\_id](#output\_created\_resource\_group\_id) | Created resource group ID |
| <a name="output_created_resource_group_location"></a> [created\_resource\_group\_location](#output\_created\_resource\_group\_location) | Created resource group's location |
| <a name="output_created_resource_group_name"></a> [created\_resource\_group\_name](#output\_created\_resource\_group\_name) | Created resource group name |
| <a name="output_created_resource_group_subscription_id"></a> [created\_resource\_group\_subscription\_id](#output\_created\_resource\_group\_subscription\_id) | Created resource group' subscription ID |
| <a name="output_deployer_id"></a> [deployer\_id](#output\_deployer\_id) | Random ID for deployer |
| <a name="output_deployer_keyvault_user_arm_id"></a> [deployer\_keyvault\_user\_arm\_id](#output\_deployer\_keyvault\_user\_arm\_id) | Azure resource ID of the deployer key vault |
| <a name="output_deployer_private_ip_address"></a> [deployer\_private\_ip\_address](#output\_deployer\_private\_ip\_address) | Deployer private IP Addresses |
| <a name="output_deployer_public_ip_address"></a> [deployer\_public\_ip\_address](#output\_deployer\_public\_ip\_address) | Deployer Public IP Address |
| <a name="output_deployer_system_assigned_identity"></a> [deployer\_system\_assigned\_identity](#output\_deployer\_system\_assigned\_identity) | Deployer System Assigned Identity |
| <a name="output_deployer_uai"></a> [deployer\_uai](#output\_deployer\_uai) | Deployer User Assigned Identity |
| <a name="output_deployer_user_assigned_identity"></a> [deployer\_user\_assigned\_identity](#output\_deployer\_user\_assigned\_identity) | Deployer System Assigned Identity |
| <a name="output_extension_ids"></a> [extension\_ids](#output\_extension\_ids) | Virtual machine extension id |
| <a name="output_firewall_id"></a> [firewall\_id](#output\_firewall\_id) | Firewall ID |
| <a name="output_firewall_ip"></a> [firewall\_ip](#output\_firewall\_ip) | Firewall private IP address |
| <a name="output_nsg_mgmt"></a> [nsg\_mgmt](#output\_nsg\_mgmt) | Management VNet NSG |
| <a name="output_pk_secret_name"></a> [pk\_secret\_name](#output\_pk\_secret\_name) | Public Key Secret Name |
| <a name="output_ppk_secret_name"></a> [ppk\_secret\_name](#output\_ppk\_secret\_name) | Private Key Secret Name |
| <a name="output_pwd_secret_name"></a> [pwd\_secret\_name](#output\_pwd\_secret\_name) | Password Secret Name |
| <a name="output_random_id"></a> [random\_id](#output\_random\_id) | Random ID for deployer |
| <a name="output_subnet_bastion_address_prefixes"></a> [subnet\_bastion\_address\_prefixes](#output\_subnet\_bastion\_address\_prefixes) | Bastion Subnet Address Prefixes |
| <a name="output_subnet_mgmt_address_prefixes"></a> [subnet\_mgmt\_address\_prefixes](#output\_subnet\_mgmt\_address\_prefixes) | Management Subnet Address Prefixes |
| <a name="output_subnet_mgmt_id"></a> [subnet\_mgmt\_id](#output\_subnet\_mgmt\_id) | Management Subnet ID |
| <a name="output_subnet_webapp_id"></a> [subnet\_webapp\_id](#output\_subnet\_webapp\_id) | Webapp Subnet ID |
| <a name="output_user_vault_name"></a> [user\_vault\_name](#output\_user\_vault\_name) | Key Vault Name |
| <a name="output_username_secret_name"></a> [username\_secret\_name](#output\_username\_secret\_name) | Username Secret Name |
| <a name="output_vnet_mgmt_id"></a> [vnet\_mgmt\_id](#output\_vnet\_mgmt\_id) | Management VNet ID |
| <a name="output_webapp_id"></a> [webapp\_id](#output\_webapp\_id) | Webapp ID |
| <a name="output_webapp_identity"></a> [webapp\_identity](#output\_webapp\_identity) | Webapp Identity |
| <a name="output_webapp_url_base"></a> [webapp\_url\_base](#output\_webapp\_url\_base) | Webapp URL Base |
<!-- END_TF_DOCS -->