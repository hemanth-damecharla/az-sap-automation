# ha_pacemaker_fence_kdump

Fencing provider for RHEL that adds `fence_kdump` as the first fencing level.
A node that is writing a kernel crash dump tells its peer, which then waits
for the dump instead of power-cycling the node. If no notification arrives
within the timeout, the second level fences the node as usual.

## What it does

- Installs `fence-agents-kdump`, opens `7410/udp`, enables kdump.
- Sets `fence_kdump_nodes` (the peer) and `path` in `/etc/kdump.conf`.
- Creates the `fence_kdump` STONITH resource and, per node, fencing level 1
  (`fence_kdump`) and level 2 (`ha_pacemaker_fence_kdump_fallback_devices`).
- Fails if the rebuilt kdump initramfs lacks `fence_kdump_send`.

## Inputs

See [`meta/argument_specs.yml`](meta/argument_specs.yml). Nothing is required
beyond the node list and config node, which default to the `ha_pacemaker`
entry point values.

## Usage

List it after the role that creates the fallback device:

```yaml
ha_pacemaker_fence_roles:
  - azure.sap_automation.ha_pacemaker_fence_azure_arm
  - azure.sap_automation.ha_pacemaker_fence_kdump
```

## Idempotency and check mode

All changes use modules; kdump is restarted only when `/etc/kdump.conf`
changed. `lsinitrd` is run read-only because no module inspects an initramfs.
In check mode the initramfs assertion is skipped, since nothing was rebuilt.

## Rollback

```yaml
- azure.sap_automation.pacemaker_cib:
    state: absent
    xml: |
      <fencing-topology>
        <fencing-level id="fl-node1-1"/><fencing-level id="fl-node1-2"/>
        <fencing-level id="fl-node2-1"/><fencing-level id="fl-node2-2"/>
      </fencing-topology>
      <resources><primitive id="rsc_st_kdump"/></resources>
```

The fallback device keeps fencing the nodes once the topology is removed.
`/etc/kdump.conf` backups are written next to the file.

## Status against `roles-os/1.17-generic-pacemaker`

Covers the `use_fence_kdump` tasks in `1.17.1-pre_checks.yml` and
`1.17.2.0-cluster-RedHat.yml`. Linted and template-tested; not yet executed
against a live cluster.
