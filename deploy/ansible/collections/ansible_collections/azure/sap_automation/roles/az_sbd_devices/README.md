# az_sbd_devices

Finds the SBD devices of a cluster node on Azure and returns their stable
`/dev/disk/by-id` names in the `az_sbd_devices` fact, for
[`ha_pacemaker_fence_sbd`](../ha_pacemaker_fence_sbd/README.md).

Kernel names such as `/dev/sdc` can change between boots. The by-id name of a
shared disk is derived from its WWN and is the same on every node.

## Sources

- **Azure shared disks** (`az_sbd_devices_source: shared_disk`): set
  `az_sbd_devices_luns`. Each LUN is resolved through the Azure udev link
  `/dev/disk/azure/scsi1/lun<N>` with the `disk_by_id` module. With
  `az_sbd_devices_nvme`, the NVMe link `/dev/disk/azure/data/by-lun/<N>` is
  stable already and is used as it is.
- **iSCSI** (`az_sbd_devices_source: iscsi`): set
  `az_sbd_devices_iscsi_targets` and `az_sbd_devices_iscsi_initiator_name`.
  The role installs the initiator, sets the initiator name (and restarts
  `iscsid` if it changed), logs in to every target with automatic login at
  boot, rescans new sessions, and resolves the devices of the sessions.

## Inputs

See [`meta/argument_specs.yml`](meta/argument_specs.yml).

## Output

`az_sbd_devices`: one to three device paths. The role fails if it finds none
or more than three.

## Idempotency and check mode

A second run changes nothing. In check mode a node that has not logged in to
its iSCSI targets yet has no devices to report, so the run stops at the
device check.

## Status

Covers the device discovery of the tasks this role replaces
(`1.17.1.1-iSCSI.yml`, `1.17.1.2-sbd.yaml`, `1.17.1.3-sbd-deviceUpdate.yaml`).
Linted; the `disk_by_id` module is unit-tested. The role needs real devices
and was not executed. Not yet executed against a live cluster.
