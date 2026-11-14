# ha_pacemaker

Entry point for building a Pacemaker cluster. It runs, in order, the bootstrap
role, each fencing provider role and each resource agent provider role. The
roles are named by variables, so a different implementation can be plugged in
from another collection.

## Inputs

See [`meta/argument_specs.yml`](meta/argument_specs.yml) for types and defaults.

| Variable | Required | Purpose |
| --- | --- | --- |
| `ha_pacemaker_nodes` | yes | List of `name`, `address`, `vm_name` per node |
| `ha_pacemaker_config_node` | no | Node that applies cluster-wide configuration; defaults to the first node |
| `ha_pacemaker_core_role` | no | Bootstrap role |
| `ha_pacemaker_fence_roles` | no | Fencing provider roles |
| `ha_pacemaker_ra_roles` | no | Resource agent provider roles |

Inputs of the provider roles are set with their own prefixed variables.

## Example

```yaml
- name: Configure the HANA cluster
  hosts: "{{ hana_cluster_hosts }}"
  become: true
  roles:
    - role: azure.sap_automation.ha_pacemaker
      vars:
        ha_pacemaker_nodes:
          - {name: x00dhdb00l0, address: 10.1.1.10, vm_name: DEV-WEEU-SAP01-X00_x00dhdb00l0}
          - {name: x00dhdb00l1, address: 10.1.1.11, vm_name: DEV-WEEU-SAP01-X00_x00dhdb00l1}
        ha_pacemaker_ra_roles:
          - azure.sap_automation.ha_pacemaker_ra_hana_scaleup
        ha_pacemaker_core_cluster_name: hdb_X00
        ha_pacemaker_core_hacluster_password: "{{ lookup('azure.azcollection.azure_keyvault_secret', 'ha-cluster-password', vault_url=kv_url) }}"
        ha_pacemaker_fence_azure_msi_subscription_id: "{{ subscription_id }}"
        ha_pacemaker_fence_azure_msi_resource_group: "{{ resource_group_name }}"
        ha_pacemaker_ra_hana_scaleup_sid: X00
        ha_pacemaker_ra_hana_scaleup_instance_number: "00"
        ha_pacemaker_ra_hana_scaleup_virtual_ip: 10.1.1.4
```

## Idempotency and rollback

The role only includes other roles; see each provider for its behaviour.
