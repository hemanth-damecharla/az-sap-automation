<!-- BEGIN_TF_DOCS -->
# sap\_capabilities

Reads the outputs of an upstream Terraform state (deployer or workload zone) for a
later deployment stage.

States written since the capability contract was introduced publish a versioned
`capabilities` output. When it is present this module takes its values from that
contract and returns them under the names of the individual outputs, which is what
the child modules read. States written before the contract existed are passed
through unchanged, so a stage can be upgraded before the stage it depends on.

A contract with a major version this release does not know is rejected.

## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_deployer_outputs"></a> [deployer\_outputs](#input\_deployer\_outputs) | Outputs of the deployer Terraform state, or an empty object when no deployer state is used | `any` | `{}` | no |
| <a name="input_landscape_outputs"></a> [landscape\_outputs](#input\_landscape\_outputs) | Outputs of the workload zone Terraform state, or an empty object when no workload zone state is used | `any` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_deployer"></a> [deployer](#output\_deployer) | Outputs of the deployer state under the names of its individual outputs, taken from the capability contract when the state publishes one |
| <a name="output_deployer_contract_version"></a> [deployer\_contract\_version](#output\_deployer\_contract\_version) | Version of the capability contract published by the deployer state, or empty when the state predates the contract |
| <a name="output_landscape"></a> [landscape](#output\_landscape) | Outputs of the workload zone state under the names of its individual outputs, taken from the capability contract when the state publishes one |
| <a name="output_landscape_contract_version"></a> [landscape\_contract\_version](#output\_landscape\_contract\_version) | Version of the capability contract published by the workload zone state, or empty when the state predates the contract |

<!-- END_TF_DOCS -->