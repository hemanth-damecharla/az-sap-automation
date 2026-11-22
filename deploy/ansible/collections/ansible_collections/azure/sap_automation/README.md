# azure.sap_automation

Ansible collection of the SAP Deployment Automation Framework (SDAF). It is
being built incrementally: each release moves one area of
`deploy/ansible/roles-*` into roles that follow the Red Hat CoP good practices
(prefixed variables, `argument_specs`, sparse platform variables) and that
select their implementation through provider roles.

The existing numbered playbooks use this collection only when
`use_sap_automation_collection` is set, and only for the scenarios listed
under [Using it from the SDAF playbooks](#using-it-from-the-sdaf-playbooks).
The default behaviour of every playbook is unchanged.

## Content

| Modules | Purpose |
| --- | --- |
| `pacemaker_cib` | Reconcile resources, constraints, fencing topology, properties and defaults from CIB XML |
| `pacemaker_cluster_info` | Cluster, node and resource state as structured data |
| `pacemaker_attribute` | Node attributes |
| `hana_system` | Start or stop a HANA instance or system |
| `hana_sql` | Run an SQL statement through `hdbsql` |
| `hana_hsr` | Enable, register or disable HANA System Replication |
| `hana_hsr_info` | Replication state for validation |
| `sbd_device` | Write an SBD header to devices that have none |
| `disk_by_id` | Stable `/dev/disk/by-id` name of a block device |
| `hana_hadr_provider_info` | HA/DR providers the HANA name server loaded |
| `nfs_mount` | Mount a directory of an NFS share, creating it on the share first |

| Roles | Layer | Replaces |
| --- | --- | --- |
| [`ha_pacemaker`](roles/ha_pacemaker/README.md) | Entry point | Role ordering in `playbook_04_00_01_db_ha.yaml` |
| [`ha_pacemaker_core`](roles/ha_pacemaker_core/README.md) | Cluster bootstrap | `roles-os/1.17-generic-pacemaker` (bootstrap, scheduled events, start delay) |
| [`ha_pacemaker_fence_azure_arm`](roles/ha_pacemaker_fence_azure_arm/README.md) | Fencing provider | Azure fence agent tasks in `1.17.2.0-cluster-*.yml` |
| [`ha_pacemaker_fence_sbd`](roles/ha_pacemaker_fence_sbd/README.md) | Fencing provider | SBD tasks in `1.17.1.2-sbd.yaml` and `1.17.2.0-cluster-*.yml` |
| [`az_sbd_devices`](roles/az_sbd_devices/README.md) | Azure facts | Device discovery in `1.17.1.1-iSCSI.yml` and `1.17.1.3-sbd-deviceUpdate.yaml` |
| [`ha_pacemaker_fence_kdump`](roles/ha_pacemaker_fence_kdump/README.md) | Fencing provider | `use_fence_kdump` tasks in `1.17.1-pre_checks.yml` and `1.17.2.0-cluster-RedHat.yml` |
| [`sap_db_hana_hsr`](roles/sap_db_hana_hsr/README.md) | Database function | `roles-db/4.0.1-hdb-hsr` |
| [`sap_db_hana_hadr_hooks`](roles/sap_db_hana_hadr_hooks/README.md) | Database function | `roles-sap/5.5-hanadb-pacemaker/tasks/5.5.3-SAPHanaSR.yml` |
| [`az_instance_metadata`](roles/az_instance_metadata/README.md) | Azure facts | Instance metadata queries repeated in playbooks and roles |
| [`ha_pacemaker_ra_hana_scaleup`](roles/ha_pacemaker_ra_hana_scaleup/README.md) | Resource agent provider | `roles-sap/5.5-hanadb-pacemaker/tasks/5.5.4.1-cluster-*.yml` |
| [`ha_pacemaker_ra_sap_ascs_ers`](roles/ha_pacemaker_ra_sap_ascs_ers/README.md) | Resource agent provider | Cluster resources in `roles-sap/5.6-scsers-pacemaker/tasks/5.6.4.0-cluster-*.yml` and `5.6.4.2-sap-resources-*.yml` |

## Using it from the SDAF playbooks

Set the switch in the SAP system configuration, through
`configuration_settings` so that it reaches the generated
`sap-parameters.yaml`:

```hcl
configuration_settings = {
  use_sap_automation_collection = true
}
```

Ansible finds the collection without further configuration because it sits in
`collections/` next to the playbooks.

| Step | Collection is used when | Otherwise |
| --- | --- | --- |
| Cluster bootstrap and fencing (`roles-os/1.17-generic-pacemaker`) | HANA scale-up on RHEL 8 or later or SLES other than SLES 12 SP4, with `database_cluster_type` `AFA`; or `ASD` on RHEL 8.8 or SLES 15 SP1 and later; or `ISCSI` on RHEL 8.8 or SLES 12 SP5 and later | Existing tasks |
| System replication (`roles-db/4.0.1-hdb-hsr`) | HANA scale-up | Existing tasks |
| HANA data, log and shared volumes on Azure NetApp Files (`roles-sap-os/2.6-sap-mounts`, step 2.6.1) | HANA scale-up with `NFS_provider` `ANF` | Existing tasks |
| ASCS/ERS cluster resources (`roles-sap/5.6-scsers-pacemaker`, steps 5.6.4.0 and 5.6.4.2); the node sequence, installations and restarts stay in the existing tasks | Not the simple mount architecture, RHEL 8 or later or SLES | Existing tasks |
| HANA HA/DR provider hooks (`roles-sap/5.5-hanadb-pacemaker`, step 5.5.3) | HANA scale-up on RHEL 8 or later or SLES | Existing tasks |
| HANA cluster resources (`roles-sap/5.5-hanadb-pacemaker`, steps 5.5.4.0 and 5.5.4.1), including the Azure NetApp Files file system resources | No active/read-enabled secondary, RHEL 8 or later or SLES | Existing tasks |

As before, the two cluster steps act only on a node where the cluster has not
been configured yet, so a cluster built by the existing tasks is not
rewritten. The hook step runs every time, but once the cluster is configured
it only writes the configuration and does not restart HANA. The files that
translate the framework's variables into role inputs are
`1.17.9-collection.yml`, `2.6.1.9-anf-mounts-hana-collection.yaml`,
`4.0.1.9-collection.yml`, `5.5.3.1-SAPHanaSR-collection.yml`, `5.6.4.9-cluster-collection.yml` and `5.5.4.2-cluster-collection.yml`.

## Extending without changing the collection

Fencing mechanisms and resource agents are separate roles, chosen by name:

```yaml
ha_pacemaker_fence_roles:
  - contoso.cluster.fence_vendor_x        # your own role
ha_pacemaker_ra_roles:
  - azure.sap_automation.ha_pacemaker_ra_hana_scaleup
```

A provider role reads `ha_pacemaker_nodes` and `ha_pacemaker_config_node`,
takes every other input through variables prefixed with its own name, and
applies its configuration with `azure.sap_automation.pacemaker_cib`.

## Secrets

No role stores or defaults a secret. `ha_pacemaker_core_hacluster_password`
must be supplied from Azure Key Vault or Ansible Vault and is never logged.
`ha_pacemaker_fence_azure_arm` needs no credential with the managed identity
of the virtual machines (`use_msi_for_clusters`). With a service principal the
client secret comes from the framework's fencing variables, is written to the
cluster configuration as the existing tasks wrote it, and is kept out of the
Ansible output: the fencing task runs with `no_log`, and `pacemaker_cib` masks
password and secret parameters in every diff it reports.

## Validation

```bash
yamllint .
ansible-lint                       # production profile, see .ansible-lint
python -m pytest                   # from the repository root
```

The Python tests cover the modules, render every CIB template for RHEL 9 and
10 and SLES 12, 15 and 16, and run the fencing and resource agent roles with
real Ansible against stand-ins for `cibadmin`, `crm_mon` and the instance
metadata service (check mode, apply, and an unchanged second run).

No role has been run against a live cluster or a real HANA system yet, and
`ha_pacemaker_core` has only been linted and template-tested; see the status section of each role.
