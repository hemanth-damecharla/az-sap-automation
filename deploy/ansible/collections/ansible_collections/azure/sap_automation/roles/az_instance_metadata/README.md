# az_instance_metadata

Reads the Azure Instance Metadata Service on each managed node and publishes
two facts:

| Fact | Content |
| --- | --- |
| `az_instance_metadata_compute` | `vm_name`, `subscription_id`, `resource_group`, `cloud` (`public` or `usgov`) |
| `az_instance_metadata_cluster_node` | `name`, `address`, `vm_name`: one entry of `ha_pacemaker_nodes` |

It replaces the metadata queries that were repeated inside the legacy
Pacemaker roles and playbooks, so that the cluster roles take their node list
as an input.

## Inputs

`az_instance_metadata_url` and `az_instance_metadata_api_version`; see
[`meta/argument_specs.yml`](meta/argument_specs.yml).

## Example

```yaml
- name: Collect node data
  ansible.builtin.include_role:
    name: azure.sap_automation.az_instance_metadata
    public: true

- name: Build the cluster
  ansible.builtin.include_role:
    name: azure.sap_automation.ha_pacemaker
  vars:
    ha_pacemaker_nodes: "{{ ansible_play_hosts_all | map('extract', hostvars, 'az_instance_metadata_cluster_node') | list }}"
```

## Idempotency, check mode and rollback

Read-only. It never reports a change, runs in check mode, and has nothing to
roll back.
