# ha_pacemaker_ra_sap_ascs_ers

Resource agent provider for an SAP ASCS/SCS and ERS pair whose instance
directories are on NFS (Azure NetApp Files or Azure Files). The resources
follow the Microsoft Learn guides "High availability for SAP NetWeaver on
Azure VMs on SUSE Linux Enterprise Server with Azure NetApp Files" and "on Red
Hat Enterprise Linux with Azure NetApp Files", for ENSA1 and ENSA2.

## Entry points

SWPM installs each instance into the directory its cluster group mounts, so
the configuration has two stages:

| Entry point | When | Result |
| --- | --- | --- |
| `group.yml` | Before SWPM installs the instance in `ha_pacemaker_ra_sap_ascs_ers_group` (`ascs` or `ers`), on the node that is to run it | Group `g-<SID>_<type>` or `g-<SID>_ERS` with its `Filesystem`, `IPaddr2` and `azure-lb` resources; on RHEL the resource defaults |
| `main.yml` | After both installations, on the configuration node | Both groups with their `SAPInstance` resources, the constraints and the properties, applied under maintenance mode |

`group.yml` only adds what is missing (`pacemaker_cib` with
`replace: false`), so running it again after `main.yml` changes nothing.
Putting nodes on standby while an instance is installed is left to the
caller.

| | SLES | RHEL |
| --- | --- | --- |
| Group members | file system, probe, IP | file system, IP, probe |
| Order constraint | ASCS instance start before ERS instance stop | ASCS group start before ERS group stop |
| ENSA1 | `failure-timeout` equal to the monitor timeout, ERS `priority=1000`, `priority-fencing-delay` removed | `failure-timeout=60` |
| ENSA2 | ASCS `priority=100`, `priority-fencing-delay=30` | |
| Both | | resource defaults `resource-stickiness=1`, `migration-threshold=3`; with pacemaker 2.0.4 or later also `priority=1`, ASCS `priority=10` and `priority-fencing-delay=15s` |

With ENSA1 the ASCS instance prefers the node that runs ERS
(`runs_ers_<SID> eq 1`). With both, the groups never share a node by
preference (`-5000`).

## Simple mount

With `ha_pacemaker_ra_sap_ascs_ers_simple_mount: true` the layout follows the
Microsoft Learn guides "High-availability SAP NetWeaver with simple mount and
NFS" for SLES (15 and later) and RHEL (9 and later). The instance directories
are mounted outside the cluster, so the groups hold only the IP and probe
before the installation, and each group then gets a `SAPStartSrv` resource
before its `SAPInstance` resource, which uses `MINIMAL_PROBE=true`. The
resource defaults are `resource-stickiness=1` and `migration-threshold=3` on
both platforms.

| | SLES | RHEL |
| --- | --- | --- |
| Resource names | `rsc_sapstartsrv_*`, `rsc_sap_*` | `rsc_SAPStartSrv_*`, `rsc_SAPInstance_*` |
| SAPInstance parameters | `START_PROFILE`, `AUTOMATIC_RECOVER=false` as in the classic layout | `InstanceName` and `MINIMAL_PROBE` only |
| ASCS priority | 10 (ENSA1), 100 (ENSA2) | 100 |
| ENSA1 `failure-timeout` | 60 | not set |
| `priority-fencing-delay` | 30 (ENSA2), removed (ENSA1) | 15 |
| ENSA1 failover rule on | the ASCS instance | the ASCS group |

The SLES guide creates the primitives as `rsc_SAPStartSrv_*` and
`rsc_SAPInstance_*` but adds `rsc_sapstartsrv_*` and `rsc_sap_*` to the groups
and constraints; the role uses the names the groups need, which earlier SDAF
releases also used.

## Inputs

See [`meta/argument_specs.yml`](meta/argument_specs.yml). Set the monitor
timeouts and mount options to those of the storage: the guides use 40 and 60
seconds for NFSv3 and 105 for Azure NetApp Files NFSv4.1, with
`sec=sys,nfsvers=4.1`.

With `ha_pacemaker_ra_sap_ascs_ers_leave_maintenance: false` the cluster stays
in maintenance mode after `main.yml` changed something, for a caller that
restarts the nodes next.

## Idempotency and check mode

Both entry points compare first and change nothing on a second run. Check
and diff mode are supported.

## Status against `roles-sap/5.6-scsers-pacemaker`

Covers the resources of `5.6.4.0-cluster-*.yml` and `5.6.4.2-sap-resources-*.yml`,
including their `-SimpleMount` variants, for RHEL 8 and later (simple mount:
9 and later) and SLES. Not covered: RHEL 7, multi-SID, and everything outside the cluster configuration (node
standby, installation, profiles, systemd integration, restart, validation).

Template-tested for RHEL 9 and 10 and SLES 12, 15 and 16, and run with real
Ansible against stand-ins for the cluster tools for both platforms and both
enqueue generations. Not yet executed against a live cluster.
