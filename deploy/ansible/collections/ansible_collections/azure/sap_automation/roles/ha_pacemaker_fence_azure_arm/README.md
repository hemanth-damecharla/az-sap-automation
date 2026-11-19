# ha_pacemaker_fence_azure_msi

Fencing provider: creates the `fence_azure_arm` STONITH resource, authenticated
by the managed identity of the cluster virtual machines, and enables fencing.
No credential is written to the cluster configuration.

## Prerequisites

The virtual machines need a managed identity with a role that permits
`Microsoft.Compute/virtualMachines/powerOff/action` and `start/action` on the
cluster VMs. SDAF Terraform assigns this when `use_msi_for_clusters` is set.

## Inputs

See [`meta/argument_specs.yml`](meta/argument_specs.yml). Required:
`ha_pacemaker_fence_azure_msi_subscription_id` and
`ha_pacemaker_fence_azure_msi_resource_group`; node list and config node
default to the `ha_pacemaker` entry point values. Each node needs `vm_name`.

`ha_pacemaker_fence_azure_msi_parameters` merges additional agent parameters
over the platform defaults.

## Platform variables

| | RHEL | SLES |
| --- | --- | --- |
| `pcmk_monitor_timeout` | 120 | not set |
| `pcmk_delay_max` | not set | 15 |
| `failure-timeout` meta | not set | 120s |
| monitor operation | interval 3600 | interval 3600, timeout 120 |
| `priority-fencing-delay` | 15 | left to the resource agent role |

## Idempotency and check mode

One `pacemaker_cib` task. It changes nothing when the resource and properties
match and supports check and diff mode. A change triggers one
`crm_resource --cleanup` of the fence resource.

## Rollback

```yaml
- azure.sap_automation.pacemaker_cib:
    state: absent
    xml: <resources><primitive id="rsc_st_azure"/></resources>
```

Set `stonith-enabled` to `false` first if no other fencing device exists; a
cluster without fencing is not supported for SAP workloads.

## Status

Covers the managed identity branch of the legacy Azure fence agent tasks for
RHEL 8 and later and SLES 12 SP5 and later.

Linted, template-tested for RHEL 9 and 10 and SLES 12, 15 and 16, and run with
real Ansible against stand-ins for the cluster tools. Not yet executed against
a live cluster.
