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
| `hana_hsr` | Enable, register or disable HANA System Replication |
| `hana_hsr_info` | Replication state for validation |

| Roles | Layer | Replaces |
| --- | --- | --- |
| [`ha_pacemaker`](roles/ha_pacemaker/README.md) | Entry point | Role ordering in `playbook_04_00_01_db_ha.yaml` |
| [`ha_pacemaker_core`](roles/ha_pacemaker_core/README.md) | Cluster bootstrap | `roles-os/1.17-generic-pacemaker` (bootstrap, scheduled events, start delay) |
| [`ha_pacemaker_fence_azure_msi`](roles/ha_pacemaker_fence_azure_msi/README.md) | Fencing provider | Azure fence agent tasks in `1.17.2.0-cluster-*.yml` |
| [`az_instance_metadata`](roles/az_instance_metadata/README.md) | Azure facts | Instance metadata queries repeated in playbooks and roles |
| [`ha_pacemaker_ra_hana_scaleup`](roles/ha_pacemaker_ra_hana_scaleup/README.md) | Resource agent provider | `roles-sap/5.5-hanadb-pacemaker/tasks/5.5.4.1-cluster-*.yml` |

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
| Cluster bootstrap and fencing (`roles-os/1.17-generic-pacemaker`) | HANA scale-up, `database_cluster_type` is `AFA`, `use_msi_for_clusters` is true, kdump fencing is off, RHEL 8 or later or SLES | Existing tasks |
| HANA cluster resources (`roles-sap/5.5-hanadb-pacemaker`, step 5.5.4.1) | No active/read-enabled secondary, `NFS_provider` is not `ANF`, RHEL 8 or later or SLES | Existing tasks |

As before, both steps act only on a node where the cluster has not been
configured yet, so a cluster built by the existing tasks is not rewritten.
The two files that translate the framework's variables into role inputs are
`1.17.9-collection.yml` and `5.5.4.2-cluster-collection.yml`.

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
`ha_pacemaker_fence_azure_msi` needs no credential: the fence agent uses the
managed identity of the virtual machines.

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

No role has been run against a live cluster yet, and `ha_pacemaker_core` has
only been linted and template-tested; see the status section of each role.
