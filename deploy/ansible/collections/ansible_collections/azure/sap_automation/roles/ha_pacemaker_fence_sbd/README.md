# ha_pacemaker_fence_sbd

Fencing provider: SBD (storage-based death) STONITH on one to three shared
block devices, such as Azure shared disks or iSCSI LUNs.

## What it does

On every node:

1. Installs `sbd` (and `fence-agents-sbd` on RHEL).
2. Loads the watchdog module (`softdog` by default) now and at boot.
3. Sets `SBD_PACEMAKER`, `SBD_STARTMODE` and `SBD_DEVICE` in
   `/etc/sysconfig/sbd`. Other settings keep the package values.
4. Adds a systemd drop-in that gives `sbd` time to start before Corosync, and
   enables the `sbd` service.

On the config node only:

5. Writes an SBD header to each device that has none, with the
   `sbd_device` module. A device that already has a header is not touched.
6. If step 3 or 4 changed anything on any node, restarts the cluster on every
   node and waits until all nodes are online. SBD only takes effect after a
   Pacemaker restart.
7. Creates the STONITH resource and sets `stonith-enabled` and
   `stonith-timeout`.

## Inputs

See [`meta/argument_specs.yml`](meta/argument_specs.yml). Required:
`ha_pacemaker_fence_sbd_devices`, the device paths on this node. The
[`az_sbd_devices`](../az_sbd_devices/README.md) role finds them for Azure
shared disks and iSCSI targets.

## Platform variables

| | RHEL | SLES |
| --- | --- | --- |
| packages | `sbd`, `fence-agents-sbd` | `sbd` |
| STONITH resource | `sbd`, `fence_sbd` with `devices` | `stonith-sbd`, `external/sbd` with `pcmk_delay_max=15` |
| service start timeout | 223 s | 259 s |
| restart | `pcs cluster stop --all`, `pcs cluster start --all` | `crm cluster restart --all` |

The values are those of the tasks this role replaces
(`roles-os/1.17-generic-pacemaker`). Unlike those tasks, the role does not
copy `sbd.service` to `/etc/systemd/system`: the drop-in applies to the unit
the package installs, and a copy would stop package updates of the unit from
taking effect.

## Idempotency and check mode

A second run changes nothing and does not restart the cluster. In check mode
the role reports what it would change and runs no restart.

## Rollback

Remove the STONITH resource with `pacemaker_cib` (`state: absent`), disable
the `sbd` service on every node and restart the cluster. Set
`stonith-enabled` to `false` first if no other fencing device exists; a
cluster without fencing is not supported for SAP workloads.

## Status

Linted and template-tested for RHEL 9 and 10 and SLES 12, 15 and 16; the CIB
step was run with real Ansible against stand-ins for the cluster tools. The
node preparation needs root and real devices and was not executed. Not yet
executed against a live cluster.
