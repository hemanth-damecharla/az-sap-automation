# sap_capabilities

Reads the outputs of an upstream Terraform state (deployer or workload zone) for a
later deployment stage.

States written since the capability contract was introduced publish a versioned
`capabilities` output. When it is present this module takes its values from that
contract and returns them under the names of the individual outputs, which is what
the child modules read. States written before the contract existed are passed
through unchanged, so a stage can be upgraded before the stage it depends on.

A contract with a major version this release does not know is rejected.
