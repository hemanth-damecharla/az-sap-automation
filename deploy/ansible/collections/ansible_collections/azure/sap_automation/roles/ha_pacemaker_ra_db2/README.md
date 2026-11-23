# ha_pacemaker_ra_db2

Resource agent provider for IBM Db2 LUW with HADR between two nodes. The
resources follow the Microsoft Learn guides "High availability of IBM Db2 LUW
on Azure VMs on SUSE Linux Enterprise Server with Pacemaker" and "on Red Hat
Enterprise Linux Server".

## Prerequisites

A running cluster with fencing, Db2 HADR between the nodes, both instances
stopped with `db2stop`, and the instance owner `db2<sid>` using `/bin/ksh`.
Those are done outside this role.

## What it creates

| | SLES | RHEL |
| --- | --- | --- |
| Db2 | `rsc_Db2_db2<sid>_<SID>` in the promotable clone `msl_Db2_db2<sid>_<SID>` (`notify`, `target-role=Started`) | `Db2_HADR_<SID>` in `Db2_HADR_<SID>-clone` (`notify`, `resource-stickiness=5000`) |
| IP and probe | group `g_ip_db2<sid>_<SID>` | group `g_ipnc_db2<sid>_<SID>` |
| Constraints | IP group with the promoted instance, started after promotion | same |
| Defaults | `resource-stickiness=1000`, `migration-threshold=5000` | with pacemaker later than 2.0.4: `priority=1`, Db2 `priority=10`, `priority-fencing-delay=15s` |

The db2 agent operations are those of the SLES guide on both platforms. The
RHEL guide creates the resources with `pcs`, which adds the agent's default
operations; a CIB written directly has none, so the role states them. For the
same reason the RHEL IP and probe get the monitor operations the other Azure
guides use. The RHEL priorities are not in the Db2 guide; they are what
earlier SDAF releases set, and `ha_pacemaker_ra_db2_priority_fencing: false`
leaves them out.

## Idempotency and check mode

The desired configuration is compared first; only a difference puts the
cluster into maintenance mode while it is applied. A second run reports no
change. Check and diff mode are supported.

## Status against `roles-sap/5.7-db2-pacemaker`

Covers the cluster resources of `5.7.3.0-cluster-*.yml` for RHEL 8 and later
and SLES. The preparation (stopping Db2, changing the shell) stays with the
existing tasks. Template-tested for RHEL 9 and 10 and SLES 15 and 16, and run
with real Ansible against stand-ins for the cluster tools. Not yet executed
against a live cluster.
