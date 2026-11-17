# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#######################################4#######################################8
#                                                                              #
#                          Resource group definitions                          #
#                                                                              #
#######################################4#######################################8

output "created_resource_group_id"               {
                                                   description = "Created resource group ID"
                                                   value       = module.sap_deployer.created_resource_group_id
                                                 }

output "created_resource_group_name"             {
                                                   description = "Created resource group name"
                                                   value       = module.sap_deployer.created_resource_group_name
                                                 }

output "created_resource_group_subscription_id"  {
                                                   description = "Created resource group' subscription ID"
                                                   value       = module.sap_deployer.created_resource_group_subscription_id
                                                 }

output "environment"                             {
                                                   description = "Deployer environment name"
                                                   value       = var.environment
                                                 }

output "location_short"                          {
                                                   description = "Deployer Location short name"
                                                   value       = module.sap_namegenerator.naming_new.location_short
                                                 }

output "network_logical_name"                    {
                                                   description = "Deployer Location short name"
                                                   value       = var.management_network_logical_name
                                                 }

output "created_resource_group_location"         {
                                                   description = "Created resource group's location"
                                                   value       = module.sap_deployer.created_resource_group_location
                                                 }

output "random_id"                               {
                                                   description = "Random ID for deployer"
                                                   value       = substr(coalesce(var.custom_random_id, module.sap_deployer.random_id), 0, 3)
                                                 }


output "diagnostics_account_id"                  {
                                                    description = "Diagnostics Storage Account ID"
                                                    value       = module.sap_deployer.diagnostics_account_id
                                                 }

###############################################################################
#                                                                             #
#                                 Deployer                                    #
#                                                                             #
###############################################################################

output "add_system_assigned_identity"            {
                                                   description = "Define if a system assigned identity should be added to the deployer"
                                                   value = var.add_system_assigned_identity
                                                 }

output "deployer_id"                             {
                                                   description = "Random ID for deployer"
                                                   sensitive = false
                                                   value     = module.sap_deployer.deployer_id
                                                 }

output "deployer_msi_id"                         {
                                                   description = "The ID of the deployer MSI"
                                                   value = module.sap_deployer.deployer_uai.principal_id
                                                 }

output "deployer_user_assigned_identity"         {
                                                   description = "The object id of the deployer User Assigned Identity"
                                                   value = module.sap_deployer.deployer_user_assigned_identity
                                                 }

output "deployer_client_id"                      {
                                                   description = "The client id of the deployer User Assigned Identity"
                                                   value = module.sap_deployer.deployer_client_id
                                                 }


output "deployer_public_ip_address"              {
                                                   description = "Public IP address of the deployer"
                                                   value = module.sap_deployer.deployer_public_ip_address
                                                 }

output "deployer_system_assigned_identity"       {
                                                   description = "value of the system assigned identity for the deployer"
                                                   value = module.sap_deployer.deployer_system_assigned_identity
                                                 }

output "deployer_uai"                            {
                                                   description = "Information about the deployer user assigned identity"
                                                   value = {
                                                             principal_id = module.sap_deployer.deployer_uai.principal_id
                                                             tenant_id    = module.sap_deployer.deployer_uai.tenant_id
                                                           }
                                                 }

output "deployer_sshkey"                         {
                                                   description = "Name of the secret containing the deployer ssh key"
                                                   value       = module.sap_deployer.ppk_secret_name
                                                 }

output "deployer_username"                      {
                                                   description = "Name of deployer username"
                                                   value       = var.deployer_authentication_username
                                                 }

###############################################################################
#                                                                             #
#                                  Network                                    #
#                                                                             #
###############################################################################

output "vnet_mgmt_id"                            {
                                                   description = "The resource ID for the management VNet"
                                                   value       = module.sap_deployer.vnet_mgmt_id
                                                 }

output "subnet_mgmt_id"                          {
                                                   description = "The resource ID for the management subnet"
                                                   value       = module.sap_deployer.subnet_mgmt_id
                                                 }


output "subnet_mgmt_address_prefixes"            {
                                                   description = "The address prefices for the management subnet"
                                                   value       = module.sap_deployer.subnet_mgmt_address_prefixes
                                                 }

output "subnet_bastion_address_prefixes"         {
                                                   description = "The address prefices for the bastion subnet"
                                                   value       = module.sap_deployer.subnet_bastion_address_prefixes
                                                 }


output "subnet_webapp_id"                        {
                                                   description = "The resource ID for the WebApp subnet"
                                                   value       = module.sap_deployer.subnet_webapp_id
                                                 }

output "subnets_to_add_to_firewall_for_keyvaults_and_storage" {
                                                                description = "List of subnets to add to the firewall for keyvaults and storage"
                                                                value       = compact(concat(var.subnets_to_add_to_firewall_for_keyvaults_and_storage, [module.sap_deployer.agent_subnet_id]))
                                                              }

output "additional_network_id"                     {
                                                       description = "Agent Network resource ID"
                                                       value       = length(var.additional_network_id) > 0 ? provider::azurerm::normalise_resource_id(split("/subnets/",var.additional_network_id)[0]) : ""
                                                     }

output "endpoint_subnet_id"                     {
                                                  description = "Azure resource identifier for the endpoint subnet"
                                                  value       = module.sap_deployer.endpoint_subnet_id
                                                }

###############################################################################
#                                                                             #
#                                 Key Vault                                   #
#                                                                             #
###############################################################################

output "deployer_kv_user_arm_id"                 {
                                                   description = "Azure resource identifier for the key vault containing the deployment credentials"
                                                   sensitive   = false
                                                   value       = module.sap_deployer.deployer_keyvault_user_arm_id
                                                 }

output "deployer_kv_user_name"                   {
                                                   description = "Name of the key vault containing the deployment credentials"
                                                   value       = module.sap_deployer.user_vault_name
                                                 }

output "set_secret_expiry"                       {
                                                   description = "Defines if key vault secrets should be set to expire"
                                                   value       = var.set_secret_expiry
                                                 }

output "deployer_sshkey_secret_name"             {
                                                   description = "Defines the name of the secret in the Azure Key Vault that contains the private key"
                                                   value       = module.sap_deployer.ppk_secret_name
                                                 }



###############################################################################
#                                                                             #
#                                 Firewall                                    #
#                                                                             #
###############################################################################


output "firewall_ip"                             {
                                                   description = "The IP address of the firewall"
                                                   value       = module.sap_deployer.firewall_ip
                                                 }

output "firewall_id"                             {
                                                   description = "The Azure resource ID of the firewall"
                                                   value       = module.sap_deployer.firewall_id
                                                 }

output "enable_firewall_for_keyvaults_and_storage" {
                                                     description = "Defines if the firewall should be enabled for keyvaults and storage"
                                                     value       = var.enable_firewall_for_keyvaults_and_storage
                                                   }

output "public_network_access_enabled"           {
                                                   description = "Defines if the public access should be enabled for keyvaults and storage"
                                                   value       = var.public_network_access_enabled
                                                 }


output "automation_version"                      {
                                                   description = "Defines the version of the automation templates used"
                                                   value       = local.version_label
                                                 }

###############################################################################
#                                                                             #
#                                App Service                                  #
#                                                                             #
###############################################################################


output "webapp_url_base"                         {
                                                   description = "The URL of the configuration Web Application"
                                                   value       = var.app_service_deployment ? module.sap_deployer.webapp_url_base : ""
                                                 }

output "webapp_identity"                         {
                                                   description = "The identity of the configuration Web Application"
                                                   value       = var.app_service_deployment ? module.sap_deployer.webapp_identity : ""
                                                 }

output "webapp_id"                               {
                                                   description = "The Azure resource ID of the configuration Web Application"
                                                   value       = var.app_service_deployment ? module.sap_deployer.webapp_id : ""
                                                 }

output "app_service_deployment"                  {
                                                   description = "Is the App Service deployed"
                                                   value       = var.app_service_deployment
                                                 }

###############################################################################
#                                                                             #
#                                VM Extension                                 #
#                                                                             #
###############################################################################

output "deployer_extension_ids"                  {
                                                   description = "List of extension IDs"
                                                   value       = module.sap_deployer.extension_ids
                                                 }


output "Agent_IP"                                {
                                                    description = "The IP address of the agent"
                                                    value       = var.Agent_IP
                                                 }

###############################################################################
#                                                                             #
#                                App Config                                   #
#                                                                             #
###############################################################################


output "application_configuration_name"                {
                                                    description = "Application Configuration Name"
                                                    value       = module.sap_deployer.application_configuration_name
                                                 }
output "application_configuration_id"                  {
                                                    description = "Application Configuration Azure Resource Id"
                                                    value       = module.sap_deployer.application_configuration_id
                                                 }

output "control_plane_name"                      {
                                                    description = "Control plane name"
                                                    value       = module.sap_namegenerator.naming.prefix.DEPLOYER
                                                 }

output "app_config_deployment"                 {
                                                   description = "Is the App Configuration deployed"
                                                   value       = var.application_configuration_deployment
                                                 }


###############################################################################
#                                                                             #
#                                Dev Center                                   #
#                                                                             #
###############################################################################

output "DevOpsInfrastructureObjectId"            {
                                                   description = "DevOps Infrastructure Object ID"
                                                   value       = var.DevOpsInfrastructure_object_id
                                                 }


#######################################4#######################################8
#                                                                              #
#                          Network Security Perimeter outputs                  #
#                                                                              #
#######################################4#######################################8

output "network_security_perimeter_deployment"  {
                                                    description = "Is the Network Security Perimeter deployed"
                                                    value       = var.network_security_perimeter_deployment
                                                }

output "network_security_perimeter_id"          {
                                                  description = "The Azure network security perimeter id"
                                                  value       = var.network_security_perimeter_deployment ? module.sap_deployer.network_security_perimeter_id : ""
                                                }


output "network_security_access_mode"          {
                                                  description = "The access mode for the network security perimeter association. Possible values are Audit, Enforced, and Learning."
                                                  value       = var.network_security_access_mode
                                                }

#######################################4#######################################8
#                                                                              #
#                            Capability contract                               #
#                                                                              #
#######################################4#######################################8


output "capabilities"                            {
                                                   description = "Versioned contract of the control plane deployer for later deployment stages and add-ons. The attributes repeat the individual outputs above in a stable, grouped form; secrets are never included. contract_version changes only when an attribute is removed or changes meaning"
                                                   value       = {
                                                                   contract_version           = "1.0"
                                                                   stage                      = "deployer"
                                                                   automation_version         = local.version_label
                                                                   naming                     = {
                                                                                                  environment          = var.environment
                                                                                                  location_short       = module.sap_namegenerator.naming_new.location_short
                                                                                                  network_logical_name = var.management_network_logical_name
                                                                                                  control_plane_name   = module.sap_namegenerator.naming.prefix.DEPLOYER
                                                                                                  random_id            = substr(coalesce(var.custom_random_id, module.sap_deployer.random_id), 0, 3)
                                                                                                }
                                                                   resource_group             = {
                                                                                                  id              = module.sap_deployer.created_resource_group_id
                                                                                                  name            = module.sap_deployer.created_resource_group_name
                                                                                                  subscription_id = module.sap_deployer.created_resource_group_subscription_id
                                                                                                  location        = module.sap_deployer.created_resource_group_location
                                                                                                }
                                                                   network                    = {
                                                                                                  vnet_id                                    = module.sap_deployer.vnet_mgmt_id
                                                                                                  management_subnet_id                       = module.sap_deployer.subnet_mgmt_id
                                                                                                  management_subnet_address_prefixes         = module.sap_deployer.subnet_mgmt_address_prefixes
                                                                                                  bastion_subnet_address_prefixes            = module.sap_deployer.subnet_bastion_address_prefixes
                                                                                                  webapp_subnet_id                           = module.sap_deployer.subnet_webapp_id
                                                                                                  endpoint_subnet_id                         = module.sap_deployer.endpoint_subnet_id
                                                                                                  additional_network_id                      = length(var.additional_network_id) > 0 ? provider::azurerm::normalise_resource_id(split("/subnets/",var.additional_network_id)[0]) : ""
                                                                                                  firewall_allowed_subnet_ids                = compact(concat(var.subnets_to_add_to_firewall_for_keyvaults_and_storage, [module.sap_deployer.agent_subnet_id]))
                                                                                                  agent_ip                                   = var.Agent_IP
                                                                                                  public_network_access_enabled              = var.public_network_access_enabled
                                                                                                  firewall_for_keyvaults_and_storage_enabled = var.enable_firewall_for_keyvaults_and_storage
                                                                                                  firewall_id                                = module.sap_deployer.firewall_id
                                                                                                  firewall_ip                                = module.sap_deployer.firewall_ip
                                                                                                }
                                                                   network_security_perimeter = {
                                                                                                  deployed    = var.network_security_perimeter_deployment
                                                                                                  id          = var.network_security_perimeter_deployment ? module.sap_deployer.network_security_perimeter_id : ""
                                                                                                  access_mode = var.network_security_access_mode
                                                                                                }
                                                                   identity                   = {
                                                                                                  principal_id                    = module.sap_deployer.deployer_uai.principal_id
                                                                                                  user_assigned                   = {
                                                                                                                                      principal_id = module.sap_deployer.deployer_uai.principal_id
                                                                                                                                      tenant_id    = module.sap_deployer.deployer_uai.tenant_id
                                                                                                                                    }
                                                                                                  user_assigned_identity_id       = module.sap_deployer.deployer_user_assigned_identity
                                                                                                  client_id                       = module.sap_deployer.deployer_client_id
                                                                                                  system_assigned                 = module.sap_deployer.deployer_system_assigned_identity
                                                                                                  system_assigned_enabled         = var.add_system_assigned_identity
                                                                                                  devops_infrastructure_object_id = var.DevOpsInfrastructure_object_id
                                                                                                }
                                                                   key_vault                  = {
                                                                                                  id                  = module.sap_deployer.deployer_keyvault_user_arm_id
                                                                                                  name                = module.sap_deployer.user_vault_name
                                                                                                  ssh_key_secret_name = module.sap_deployer.ppk_secret_name
                                                                                                  set_secret_expiry   = var.set_secret_expiry
                                                                                                }
                                                                   virtual_machines           = {
                                                                                                  ids                 = module.sap_deployer.deployer_id
                                                                                                  public_ip_addresses = module.sap_deployer.deployer_public_ip_address
                                                                                                  username            = var.deployer_authentication_username
                                                                                                  extension_ids       = module.sap_deployer.extension_ids
                                                                                                }
                                                                   application_configuration  = {
                                                                                                  deployed = var.application_configuration_deployment
                                                                                                  id       = module.sap_deployer.application_configuration_id
                                                                                                  name     = module.sap_deployer.application_configuration_name
                                                                                                }
                                                                   web_app                    = {
                                                                                                  deployed = var.app_service_deployment
                                                                                                  id       = var.app_service_deployment ? module.sap_deployer.webapp_id : ""
                                                                                                  url_base = var.app_service_deployment ? module.sap_deployer.webapp_url_base : ""
                                                                                                  identity = var.app_service_deployment ? module.sap_deployer.webapp_identity : ""
                                                                                                }
                                                                   diagnostics                = {
                                                                                                  storage_account_id = module.sap_deployer.diagnostics_account_id
                                                                                                }
                                                                 }
                                                 }
