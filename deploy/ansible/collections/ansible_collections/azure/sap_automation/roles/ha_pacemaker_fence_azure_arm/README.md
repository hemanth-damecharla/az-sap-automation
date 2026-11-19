# ha_pacemaker_fence_azure_arm

Fencing provider: creates the `fence_azure_arm` STONITH resource and enables
fencing. The agent authenticates to Azure with the managed identity of the
cluster virtual machines (the default) or with a service principal.

This role was called `ha_pacemaker_fence_azure_msi` in collection version
0.1.0, when it supported only the managed identity.

## Prerequisites

The identity the agent uses needs a role that permits
`Microsoft.Compute/virtualMachines/powerOff/action` and `start/action` on the
cluster VMs:

- **Managed identity** (`authentication: msi`): SDAF Terraform assigns the role
  when `use_msi_for_clusters` is set. No credential is written to the cluster
  configuration.
- **Service principal** (`authentication: spn`): the role assignment is made
  outside SDAF. The client secret is stored in the cluster configuration, as
  the tasks this role replaces stored it. The configuration task runs with
  `no_log`, so the secret does not appear in the Ansible output or diff.

## Inputs

See [`meta/argument_specs.yml`](meta/argument_specs.yml). Required:
`ha_pacemaker_fence_azure_arm_subscription_id` and
`ha_pacemaker_fence_azure_arm_resource_group`; node list and config node
default to the `ha_pacemaker` entry point values. Each node needs `vm_name`.

With `ha_pacemaker_fence_azure_arm_authentication: spn`, also set
`ha_pacemaker_fence_azure_arm_tenant_id`,
`ha_pacemaker_fence_azure_arm_client_id` and
`ha_pacemaker_fence_azure_arm_client_secret`. The role stops with an error
before changing the cluster if one is missing.

`ha_pacemaker_fence_azure_arm_parameters` merges additional agent parameters
over the platform defaults.

## Platform variables

| | RHEL | SLES |
| --- | --- | --- |
| `pcmk_monitor_timeout` | 120 | not set |
| `pcmk_delay_max` | not set | 15 |
| `failure-timeout` meta | not set | 120s |
| monitor operation | interval 3600 | interval 3600, timeout 120 |
| `priority-fencing-delay` | 15 | left to the resource agent role |
| service principal parameters | `username`, `password` | `login`, `passwd` |

## Idempotency and check mode

One `pacemaker_cib` task. It changes nothing when the resource and properties
match and supports check and diff mode; with a service principal the diff is
hidden. A change triggers one `crm_resource --cleanup` of the fence resource.

## Rollback

```yaml
- azure.sap_automation.pacemaker_cib:
    state: absent
    xml: <resources><primitive id="rsc_st_azure"/></resources>
```

Set `stonith-enabled` to `false` first if no other fencing device exists; a
cluster without fencing is not supported for SAP workloads.

## Status

Covers the managed identity and service principal branches of the legacy
Azure fence agent tasks for RHEL 8 and later and SLES 12 SP5 and later.

Linted, template-tested for RHEL 9 and 10 and SLES 12, 15 and 16, and run with
real Ansible against stand-ins for the cluster tools. Not yet executed against
a live cluster.
