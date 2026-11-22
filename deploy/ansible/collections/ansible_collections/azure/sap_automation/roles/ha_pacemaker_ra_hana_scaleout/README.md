# ha_pacemaker_ra_hana_scaleout

Resource agent provider for SAP HANA scale-out with system replication between
two sites and a majority maker node. The resources follow the Microsoft Learn
guides "SAP HANA scale-out with HSR and Pacemaker on SLES" and "High
availability of SAP HANA scale-out system on Red Hat Enterprise Linux", for
both resource agent generations.

## Prerequisites

A running cluster of all HANA nodes and the majority maker, with fencing;
HANA System Replication; and the scale-out HA/DR provider hooks. Those are
configured outside this role.

## What it creates

| | SLES classic | SLES angi | RHEL classic | RHEL angi |
| --- | --- | --- | --- | --- |
| Topology and controller | `cln_SAPHanaTopology`, `msl_SAPHana` | `cln_SAPHanaTopology`, `mst_SAPHanaController` | `SAPHanaTopology_*-clone`, `SAPHana_*-clone` | `cln_SAPHanaTopology`, `cln_SAPHanaController` |
| /hana/shared | Cloned bind-mount check of `/hana/shared/<SID>/check` | `SAPHanaFilesystem` | Per site a cloned `Filesystem` of `/hana/shared`, placed by the node attribute `NFS_<SID>_SITE`, and an `attribute` clone `hana_nfs_s<n>_active` | `SAPHanaFilesystem` |
| Majority maker | `-INFINITY` locations for each HANA clone | same | HANA runs only where a site's `/hana/shared` is mounted | one `rsc-pattern=".*SAPHana.*"` location |
| Fencing alert | | `SAPHanaSR-alert-fencing` (`fencing-1`) | | `SAPHanaSR-alert-fencing` (`alert-hana-1`) |
| Resource defaults | stickiness 1000, migration threshold 50 | same | stickiness 1000, migration threshold 5000 | same |

The virtual IP and the Azure load balancer probe form a group that runs with
the promoted controller.

On RHEL with classic, set `ha_pacemaker_ra_hana_scaleout_shared_devices`,
`_site1_nodes` and `_site2_nodes`; `/hana/shared` must not be in
`/etc/fstab`, because the cluster mounts it. With angi it stays in
`/etc/fstab`.

## Inputs

See [`meta/argument_specs.yml`](meta/argument_specs.yml). Required: SID,
instance number, virtual IP and `ha_pacemaker_ra_hana_scaleout_majority_maker`,
which must be one of `ha_pacemaker_ra_hana_scaleout_nodes`.

## Idempotency and check mode

The desired configuration is compared first; only a difference puts the
cluster into maintenance mode while resources and constraints are applied. A
second run reports no change. Check and diff mode are supported.

## Status against `roles-sap/5.8-hanadb-scaleout-pacemaker`

Covers the resources of `5.8.4.0-clusterPrep-ScaleOut-*.yml` and
`5.8.4.1-cluster-ScaleOut-*.yml` for RHEL 8 and later and SLES 15 and later.
Not covered: the active/read-enabled secondary virtual IP, RHEL 7 and
SLES 12, and everything outside the cluster resources (system replication,
hooks, systemd integration, post-provision report).

Template-tested for RHEL 9 and 10 and SLES 15 and 16, and run with real
Ansible against stand-ins for the cluster tools (RHEL classic, SLES angi).
Not yet executed against a live cluster.
