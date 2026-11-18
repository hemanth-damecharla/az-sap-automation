# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

output "deployer"                                {
                                                   description = "Outputs of the deployer state under the names of its individual outputs, taken from the capability contract when the state publishes one"
                                                   value       = local.deployer

                                                   precondition {
                                                     condition     = local.deployer_contract_version == "" || startswith(local.deployer_contract_version, "1.")
                                                     error_message = "The deployer state publishes capability contract version ${local.deployer_contract_version}, but this release reads version 1. Deploy the deployer and this stage from the same release."
                                                   }
                                                 }

output "deployer_contract_version"               {
                                                   description = "Version of the capability contract published by the deployer state, or empty when the state predates the contract"
                                                   value       = local.deployer_contract_version
                                                 }

output "landscape"                               {
                                                   description = "Outputs of the workload zone state under the names of its individual outputs, taken from the capability contract when the state publishes one"
                                                   value       = local.landscape

                                                   precondition {
                                                     condition     = local.landscape_contract_version == "" || startswith(local.landscape_contract_version, "1.")
                                                     error_message = "The workload zone state publishes capability contract version ${local.landscape_contract_version}, but this release reads version 1. Deploy the workload zone and this stage from the same release."
                                                   }
                                                 }

output "landscape_contract_version"              {
                                                   description = "Version of the capability contract published by the workload zone state, or empty when the state predates the contract"
                                                   value       = local.landscape_contract_version
                                                 }
