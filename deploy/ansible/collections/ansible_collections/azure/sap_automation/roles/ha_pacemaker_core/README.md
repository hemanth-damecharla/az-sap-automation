# ha_pacemaker_core

Bootstraps a two-node Pacemaker and Corosync cluster on Azure virtual machines
and applies the configuration that does not depend on the fencing mechanism or
on the SAP workload.

## What it does

| Component (`tasks/`) | Result |
| --- | --- |
| `prerequisites` | `hacluster` password, systemd task limit, firewalld service (RHEL), cloud-netconfig exclusion (SLES before 16) |
| `bootstrap_RedHat` | `pcs host auth` and `pcs cluster setup`, once; services started |
| `bootstrap_Suse` | root SSH trust including each node's own key, `crm cluster init` / `join`, once; `corosync.conf` (SLES before 16) |
| `configuration` | waits for both nodes, sets `concurrent-fencing` |
| `azure_events` | `azure-events-az` clone, node health strategy and constraint |
| `start_delay` | `pacemaker.timer`, with direct start of the services disabled |

## Inputs

See [`meta/argument_specs.yml`](meta/argument_specs.yml). Required:
`ha_pacemaker_core_nodes`, `ha_pacemaker_core_config_node` (both default to
the `ha_pacemaker` entry point values), `ha_pacemaker_core_cluster_name` and
`ha_pacemaker_core_hacluster_password` (secret, no default, never logged).

## Platform variables

`vars/main.yml` holds the common values. `vars/Suse.yml`, `vars/RedHat.yml`
and `vars/SLES_SAP_16.yml` (linked as `SLES_16.yml`) hold only differences.

## Idempotency and check mode

- Cluster creation uses `pcs` and `crm` because it generates and distributes
  the Corosync key; no declarative interface exists. Each command is guarded by
  `creates: /etc/corosync/corosync.conf` and therefore runs once.
- All other changes use modules and report `changed` only on a difference.
- In check mode against hosts without a cluster, the creation commands are
  skipped and the CIB tasks report `changed`.

## Rollback

The role does not destroy a cluster. To remove what it configured: delete the
`health-azure-events` clone and `loc_azure_health` with
`pacemaker_cib state=absent`, disable `pacemaker.timer`, and re-enable the
`pacemaker` and `corosync` units. Destroying the cluster itself is done with
`pcs cluster destroy --all` or `crm cluster remove`.

## Status against `roles-os/1.17-generic-pacemaker`

Not yet migrated, and still served by the legacy role: package version
pre-checks, SBD and iSCSI fencing, `fence_kdump`, service principal fencing,
and RHEL 7. Instance metadata is no longer queried by the role; node addresses
and VM names are inputs. Two legacy steps are intentionally dropped:
`pcs quorum expected-votes` (a two-node `pcs cluster setup` already writes
`two_node: 1`) and toggling maintenance mode around the scheduled events
agent (the configuration is applied per CIB section in one call each).

The role has been linted and its templates are rendered in the test suite for
every platform. It has not been executed against a live cluster.
