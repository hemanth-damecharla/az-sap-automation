# Changelog

## 0.2.0

Breaking:

- `ha_pacemaker_fence_azure_msi` is renamed `ha_pacemaker_fence_azure_arm`,
  and its variables from `ha_pacemaker_fence_azure_msi_*` to
  `ha_pacemaker_fence_azure_arm_*`. The role now covers both ways the
  `fence_azure_arm` agent authenticates.

Added:

- `ha_pacemaker_fence_azure_arm_authentication`: `msi` (default) or `spn`,
  with `ha_pacemaker_fence_azure_arm_tenant_id`, `_client_id` and
  `_client_secret` for a service principal.
- `pacemaker_cib` masks the value of `passwd`, `password` and `*secret*`
  parameters in the diff it reports.
- The SDAF playbooks use the collection for service principal fencing too.
- `ha_pacemaker_fence_sbd`: SBD fencing provider, with the `sbd_device`
  module that never rewrites an existing SBD header.
- `az_sbd_devices`: stable device names of Azure shared disks (SCSI and
  NVMe) and iSCSI targets, with the `disk_by_id` module.
- The SDAF playbooks use the collection for HANA scale-up clusters with
  `database_cluster_type` `ASD` or `ISCSI`.
- `sap_db_hana_hadr_hooks`: the HANA HA/DR provider hooks for both
  generations on SLES and RHEL, with the `hana_hadr_provider_info` module.
  The SDAF playbooks use it for HANA scale-up with the switch on. On RHEL with
  `sap-hana-ha`, `action_on_lost` is now `fence`, as documented.
- `nfs_mount`: mounts a directory of an NFS share and creates it on the share
  first, keeps or removes the fstab entry, never replaces a mount from
  another source and never remounts. The SDAF playbooks use it for the HANA
  scale-up volumes on Azure NetApp Files with the switch on.
- `ha_pacemaker_ra_hana_scaleup_nfs`: cluster resources for HANA file
  systems on NFS (Filesystem groups and attribute resources on RHEL classic,
  the `/hana/shared` check clone on SLES classic). The SDAF playbooks now use
  the collection for HANA clusters on Azure NetApp Files too. On RHEL with
  angi the HANA volumes stay in `/etc/fstab` and the cluster no longer
  creates Filesystem resources for them, as documented.

## 0.1.0

- Collection skeleton.
- Modules: `pacemaker_cib`, `pacemaker_cluster_info`, `pacemaker_attribute`,
  `hana_system`, `hana_sql`, `hana_hsr`, `hana_hsr_info`.
- Roles: `ha_pacemaker`, `ha_pacemaker_core`, `ha_pacemaker_fence_azure_msi`,
  `ha_pacemaker_ra_hana_scaleup`, `az_instance_metadata`, `ha_pacemaker_fence_kdump`,
  `sap_db_hana_hsr`.
- Opt-in use from the SDAF playbooks through `use_sap_automation_collection`.
