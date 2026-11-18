<!-- BEGIN_TF_DOCS -->


## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.81.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azurerm.dnsmanagement"></a> [azurerm.dnsmanagement](#provider\_azurerm.dnsmanagement) | 4.81.0 |
| <a name="provider_azurerm.main"></a> [azurerm.main](#provider\_azurerm.main) | 4.81.0 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_availability_set.anydb](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/availability_set) | resource |
| [azurerm_lb.anydb](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/lb) | resource |
| [azurerm_lb_backend_address_pool.anydb](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/lb_backend_address_pool) | resource |
| [azurerm_lb_probe.anydb](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/lb_probe) | resource |
| [azurerm_lb_rule.anydb](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/lb_rule) | resource |
| [azurerm_linux_virtual_machine.dbserver](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/linux_virtual_machine) | resource |
| [azurerm_linux_virtual_machine.observer](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/linux_virtual_machine) | resource |
| [azurerm_managed_disk.cluster](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/managed_disk) | resource |
| [azurerm_managed_disk.disks](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/managed_disk) | resource |
| [azurerm_managed_disk.kdump](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/managed_disk) | resource |
| [azurerm_network_interface.anydb_admin](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/network_interface) | resource |
| [azurerm_network_interface.anydb_db](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/network_interface) | resource |
| [azurerm_network_interface.observer](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/network_interface) | resource |
| [azurerm_network_interface_application_security_group_association.db](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/network_interface_application_security_group_association) | resource |
| [azurerm_network_interface_backend_address_pool_association.anydb](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_private_dns_a_record.db](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/private_dns_a_record) | resource |
| [azurerm_role_assignment.role_assignment_msi](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.role_assignment_msi_ha](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/role_assignment) | resource |
| [azurerm_virtual_machine_data_disk_attachment.cluster](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_data_disk_attachment.kdump](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_data_disk_attachment.vm_disks](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_extension.configure_ansible](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.monitoring_defender_db_lnx](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.monitoring_defender_db_win](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.monitoring_extension_db_lnx](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.monitoring_extension_db_win](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/virtual_machine_extension) | resource |
| [azurerm_windows_virtual_machine.dbserver](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/windows_virtual_machine) | resource |
| [azurerm_windows_virtual_machine.observer](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/windows_virtual_machine) | resource |
| [time_sleep.wait_30_secs](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [azurerm_availability_set.anydb](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/data-sources/availability_set) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_admin_subnet"></a> [admin\_subnet](#input\_admin\_subnet) | The admin subnet, as returned by the common\_infrastructure module (a resource or data source object, or null) | `any` | n/a | yes |
| <a name="input_anchor_vm"></a> [anchor\_vm](#input\_anchor\_vm) | The anchor virtual machine of the common\_infrastructure module; passed only to order deployment after it | `any` | n/a | yes |
| <a name="input_cloudinit_growpart_config"></a> [cloudinit\_growpart\_config](#input\_cloudinit\_growpart\_config) | Rendered cloud-init configuration passed to virtual machines on first deployment, or null | `any` | n/a | yes |
| <a name="input_custom_disk_sizes_filename"></a> [custom\_disk\_sizes\_filename](#input\_custom\_disk\_sizes\_filename) | Custom disk sizing file | `string` | n/a | yes |
| <a name="input_database"></a> [database](#input\_database) | Database tier settings. use\_avset and use\_ppg are null when the caller leaves the placement decision open. Only the attributes this module reads are declared; Terraform discards the rest. | <pre>object({<br/>                                                                          platform                   = string<br/>                                                                          db_sizing_key              = optional(string, "Default")<br/>                                                                          database_vm_sku            = optional(string, "")<br/>                                                                          high_availability          = optional(bool, false)<br/>                                                                          dual_network_interfaces    = optional(bool, false)<br/>                                                                          instance                   = optional(object({<br/>                                                                                                         sid = optional(string)<br/>                                                                                                       }), {})<br/>                                                                          authentication             = optional(object({<br/>                                                                                                         type = optional(string, "key")<br/>                                                                                                       }), {})<br/>                                                                          os                         = optional(object({<br/>                                                                                                         os_type         = optional(string, "LINUX")<br/>                                                                                                         type            = optional(string, "marketplace")<br/>                                                                                                         source_image_id = optional(string, "")<br/>                                                                                                         publisher       = optional(string, "SUSE")<br/>                                                                                                         offer           = optional(string, "sles-sap-15-sp5")<br/>                                                                                                         sku             = optional(string, "gen2")<br/>                                                                                                         version         = optional(string, "latest")<br/>                                                                                                       }), {})<br/>                                                                          loadbalancer               = optional(object({<br/>                                                                                                         frontend_ips = optional(list(string), [])<br/>                                                                                                       }), {})<br/>                                                                          database_cluster_type      = optional(string, "AFA")<br/>                                                                          database_cluster_disk_lun  = optional(number, 8)<br/>                                                                          database_cluster_disk_size = optional(number, 128)<br/>                                                                          database_cluster_disk_type = optional(string, "Premium_ZRS")<br/>                                                                          fence_kdump_disk_size      = optional(number, 128)<br/>                                                                          fence_kdump_lun_number     = optional(number, -1)<br/>                                                                          use_DHCP                   = optional(bool, false)<br/>                                                                          use_avset                  = optional(bool)<br/>                                                                          use_ppg                    = optional(bool)<br/>                                                                          avset_arm_ids              = optional(list(string), [])<br/>                                                                          zones                      = optional(list(string), [])<br/>                                                                          user_assigned_identity_id  = optional(string, "")<br/>                                                                          tags                       = optional(map(string), {})<br/>                                                                        })</pre> | n/a | yes |
| <a name="input_database_vm_admin_nic_ips"></a> [database\_vm\_admin\_nic\_ips](#input\_database\_vm\_admin\_nic\_ips) | If provided, the database tier virtual machines will be configured with the specified IPs (admin subnet) | `list(string)` | n/a | yes |
| <a name="input_database_vm_db_nic_ips"></a> [database\_vm\_db\_nic\_ips](#input\_database\_vm\_db\_nic\_ips) | If provided, the database tier virtual machines will be configured using the specified IPs | `list(string)` | n/a | yes |
| <a name="input_database_vm_db_nic_secondary_ips"></a> [database\_vm\_db\_nic\_secondary\_ips](#input\_database\_vm\_db\_nic\_secondary\_ips) | If provided, the database tier virtual machines will be configured using the specified IPs as secondary IPs | `list(string)` | n/a | yes |
| <a name="input_db_asg_id"></a> [db\_asg\_id](#input\_db\_asg\_id) | Azure resource ID of the database application security group, or empty | `string` | n/a | yes |
| <a name="input_db_subnet"></a> [db\_subnet](#input\_db\_subnet) | The database subnet, as returned by the common\_infrastructure module (a resource or data source object) | `any` | n/a | yes |
| <a name="input_deploy_application_security_groups"></a> [deploy\_application\_security\_groups](#input\_deploy\_application\_security\_groups) | Defines if application security groups should be deployed | `bool` | n/a | yes |
| <a name="input_deployment"></a> [deployment](#input\_deployment) | The type of deployment: new or update | `string` | n/a | yes |
| <a name="input_dns_settings"></a> [dns\_settings](#input\_dns\_settings) | DNS settings. Only the attributes this module reads are declared; Terraform discards the rest. | <pre>object({<br/>                                                                          management_dns_resourcegroup_name = optional(string, "")<br/>                                                                          register_virtual_network_to_dns   = optional(bool, false)<br/>                                                                        })</pre> | n/a | yes |
| <a name="input_fencing_role_name"></a> [fencing\_role\_name](#input\_fencing\_role\_name) | If specified the role name to use for the fencing agent | `string` | n/a | yes |
| <a name="input_infrastructure"></a> [infrastructure](#input\_infrastructure) | Infrastructure settings of the SAP system. Only the attributes this module reads are declared; Terraform discards the rest. | <pre>object({<br/>                                                                          region                             = string<br/>                                                                          patch_mode                         = optional(string, "ImageDefault")<br/>                                                                          patch_assessment_mode              = optional(string, "ImageDefault")<br/>                                                                          encryption_at_host_enabled         = optional(bool, false)<br/>                                                                          deploy_monitoring_extension        = optional(bool, false)<br/>                                                                          deploy_defender_extension          = optional(bool, false)<br/>                                                                          disk_controller_type_database_tier = optional(string, "SCSI")<br/>                                                                          configuration_settings             = optional(any, {})<br/>                                                                        })</pre> | n/a | yes |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | Specifies the license type for the OS | `string` | n/a | yes |
| <a name="input_naming"></a> [naming](#input\_naming) | Defines the names for the resources: the 'naming' output of the sap\_namegenerator module, or a custom names file with the same structure. Only the groups this module reads are declared; Terraform discards the rest. The groups are maps and lists, so a custom names file may leave out entries the deployment does not use. | <pre>object({<br/>                                                                          separator             = string<br/>                                                                          prefix                = optional(map(string), {})<br/>                                                                          resource_prefixes     = optional(map(string), {})<br/>                                                                          resource_suffixes     = optional(map(string), {})<br/>                                                                          virtualmachine_names  = optional(map(list(string)), {})<br/>                                                                          availabilityset_names = optional(map(list(string)), {})<br/>                                                                          storageaccount_names  = optional(object({<br/>                                                                                                    SDU = optional(string)<br/>                                                                                                  }), {})<br/>                                                                        })</pre> | n/a | yes |
| <a name="input_observer_vm_size"></a> [observer\_vm\_size](#input\_observer\_vm\_size) | The VM size to use for the observer | `string` | n/a | yes |
| <a name="input_observer_vm_tags"></a> [observer\_vm\_tags](#input\_observer\_vm\_tags) | Tags to use specifically for the observer VM | `map(string)` | n/a | yes |
| <a name="input_observer_vm_zones"></a> [observer\_vm\_zones](#input\_observer\_vm\_zones) | The zone to deploy the observer in | `list(string)` | n/a | yes |
| <a name="input_options"></a> [options](#input\_options) | Miscellaneous deployment options. disk\_encryption\_set\_id is null unless a disk encryption set is used. Only the attributes this module reads are declared; Terraform discards the rest. | <pre>object({<br/>                                                                          legacy_nic_order       = optional(bool, false)<br/>                                                                          resource_offset        = optional(number, 0)<br/>                                                                          disk_encryption_set_id = optional(string)<br/>                                                                        })</pre> | n/a | yes |
| <a name="input_order_deployment"></a> [order\_deployment](#input\_order\_deployment) | Value used only to order this module after another one; its content is not read | `any` | n/a | yes |
| <a name="input_ppg"></a> [ppg](#input\_ppg) | Proximity placement groups, as returned by the common\_infrastructure module | `any` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | The resource group of the SAP system, as returned by the common\_infrastructure module | `any` | n/a | yes |
| <a name="input_sap_sid"></a> [sap\_sid](#input\_sap\_sid) | The SAP system ID | `string` | n/a | yes |
| <a name="input_scale_set_id"></a> [scale\_set\_id](#input\_scale\_set\_id) | Azure resource ID of the flexible virtual machine scale set, or empty | `string` | n/a | yes |
| <a name="input_sdu_public_key"></a> [sdu\_public\_key](#input\_sdu\_public\_key) | Public SSH key of the SAP system administrator | `string` | n/a | yes |
| <a name="input_sid_keyvault_user_id"></a> [sid\_keyvault\_user\_id](#input\_sid\_keyvault\_user\_id) | Azure resource ID of the key vault holding the SAP system credentials | `string` | n/a | yes |
| <a name="input_sid_password"></a> [sid\_password](#input\_sid\_password) | Password of the SAP system administrator | `string` | n/a | yes |
| <a name="input_sid_username"></a> [sid\_username](#input\_sid\_username) | User name of the SAP system administrator | `string` | n/a | yes |
| <a name="input_storage_bootdiag_endpoint"></a> [storage\_bootdiag\_endpoint](#input\_storage\_bootdiag\_endpoint) | Blob endpoint of the boot diagnostics storage account | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | If provided, tags for all resources | `map(string)` | n/a | yes |
| <a name="input_terraform_template_version"></a> [terraform\_template\_version](#input\_terraform\_template\_version) | The version of Terraform templates that were identified in the state file | `string` | n/a | yes |
| <a name="input_use_admin_nic_for_asg"></a> [use\_admin\_nic\_for\_asg](#input\_use\_admin\_nic\_for\_asg) | If true, the admin nic will be assigned to the ASG instead of the second nic | `bool` | n/a | yes |
| <a name="input_use_admin_nic_suffix_for_observer"></a> [use\_admin\_nic\_suffix\_for\_observer](#input\_use\_admin\_nic\_suffix\_for\_observer) | If true, the admin nic suffix will be used for the observer | `bool` | n/a | yes |
| <a name="input_use_loadbalancers_for_standalone_deployments"></a> [use\_loadbalancers\_for\_standalone\_deployments](#input\_use\_loadbalancers\_for\_standalone\_deployments) | If defined, will use load balancers for standalone deployments | `bool` | n/a | yes |
| <a name="input_use_msi_for_clusters"></a> [use\_msi\_for\_clusters](#input\_use\_msi\_for\_clusters) | If true, the Pacemaker cluser will use a managed identity | `bool` | n/a | yes |
| <a name="input_use_observer"></a> [use\_observer](#input\_use\_observer) | If true, an observer virtual machine will be used | `bool` | n/a | yes |
| <a name="input_use_scalesets_for_deployment"></a> [use\_scalesets\_for\_deployment](#input\_use\_scalesets\_for\_deployment) | Use Flexible Virtual Machine Scale Sets for the deployment | `bool` | n/a | yes |
| <a name="input_database_server_count"></a> [database\_server\_count](#input\_database\_server\_count) | The number of database servers | `number` | `1` | no |
| <a name="input_landscape_tfstate"></a> [landscape\_tfstate](#input\_landscape\_tfstate) | Outputs of the workload zone state, as returned by the sap\_capabilities module. Only the attributes this module reads are declared; Terraform discards the rest. An attribute missing from an older state takes its default | <pre>object({<br/>                                                                          dns_label               = optional(string, "")<br/>                                                                          dns_resource_group_name = optional(string, "")<br/>                                                                        })</pre> | `{}` | no |
| <a name="input_use_secondary_ips"></a> [use\_secondary\_ips](#input\_use\_secondary\_ips) | Use secondary IPs for the SAP System | `bool` | `false` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_database_cluster_ip"></a> [database\_cluster\_ip](#output\_database\_cluster\_ip) | AnyDB load balancer cluster IPs |
| <a name="output_database_disks"></a> [database\_disks](#output\_database\_disks) | AnyDB Virtual machine disks |
| <a name="output_database_kdump_disks"></a> [database\_kdump\_disks](#output\_database\_kdump\_disks) | List of Azure kdump disks |
| <a name="output_database_loadbalancer_id"></a> [database\_loadbalancer\_id](#output\_database\_loadbalancer\_id) | AnyDB load balancer Id |
| <a name="output_database_loadbalancer_ip"></a> [database\_loadbalancer\_ip](#output\_database\_loadbalancer\_ip) | AnyDB load balancer IPs |
| <a name="output_database_server_admin_ips"></a> [database\_server\_admin\_ips](#output\_database\_server\_admin\_ips) | AnyDB Virtual machine Admin interface IPs |
| <a name="output_database_server_ips"></a> [database\_server\_ips](#output\_database\_server\_ips) | AnyDB Virtual machine db interface IPs |
| <a name="output_database_server_secondary_ips"></a> [database\_server\_secondary\_ips](#output\_database\_server\_secondary\_ips) | AnyDB Virtual machine db interface IPs |
| <a name="output_database_server_vm_ids"></a> [database\_server\_vm\_ids](#output\_database\_server\_vm\_ids) | AnyDB Virtual machine resource IDs |
| <a name="output_database_server_vm_names"></a> [database\_server\_vm\_names](#output\_database\_server\_vm\_names) | AnyDB Virtual machine names |
| <a name="output_database_shared_disks"></a> [database\_shared\_disks](#output\_database\_shared\_disks) | List of Azure shared disks |
| <a name="output_dns_info_loadbalancers"></a> [dns\_info\_loadbalancers](#output\_dns\_info\_loadbalancers) | DNS Information for the virtual machines |
| <a name="output_dns_info_vms"></a> [dns\_info\_vms](#output\_dns\_info\_vms) | DNS Information for the virtual machines |
| <a name="output_observer_ips"></a> [observer\_ips](#output\_observer\_ips) | IP adresses for observer nodes |
| <a name="output_observer_vms"></a> [observer\_vms](#output\_observer\_vms) | Resource IDs for observer nodes |

<!-- END_TF_DOCS -->