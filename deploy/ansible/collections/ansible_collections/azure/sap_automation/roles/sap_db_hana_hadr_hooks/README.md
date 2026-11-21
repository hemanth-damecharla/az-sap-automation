# sap_db_hana_hadr_hooks

Configures the SAP HANA HA/DR provider hooks that tell Pacemaker about the
state of system replication (`SAPHanaSR`, `susHanaSR` or `HanaSR`) and react
to a lost index server (`susChkSrv` or `ChkSrv`). Run it on every HANA node
of a scale-up cluster, as root, after system replication is configured and
before the cluster resources are created.

The values follow the Microsoft Learn guides "High availability for SAP HANA
on Azure VMs on SLES" and "High availability of SAP HANA on Azure VMs on
RHEL", section "Set up SAP HANA HA/DR providers".

## What it does

| Component (`tasks/`) | Result |
| --- | --- |
| `configure` | Hook package installed; hook scripts present; provider sections and trace levels set in `global.ini`, those of the platform's other hooks removed; `/etc/sudoers.d/20-saphana` written and checked with `visudo` |
| `restart` | HANA stopped and started on a node whose `global.ini` changed, with `activation: restart` |
| `verify` | The name server trace reports each provider loaded from the configured directory (`hana_hadr_provider_info`) |

| | SLES classic | SLES angi | RHEL classic | RHEL angi |
| --- | --- | --- | --- | --- |
| Package | `SAPHanaSR` | `SAPHanaSR-angi` | `resource-agents-sap-hana` | `sap-hana-ha` |
| Replication hook | `SAPHanaSR` | `susHanaSR` | `SAPHanaSR` | `HanaSR` |
| Service hook | `susChkSrv` | `susChkSrv` | `ChkSrv` | `ChkSrv` |
| `action_on_lost` | `fence` | `fence` | `kill` | `fence` |
| sudoers | site rules and hook helper | site rules and hook helper | site rules | `crm_attribute -n hana_*` and hook helper |

## Inputs

See [`meta/argument_specs.yml`](meta/argument_specs.yml). Required:
`sap_db_hana_hadr_hooks_sid` and `sap_db_hana_hadr_hooks_instance_number`.

Set `sap_db_hana_hadr_hooks_flavor` to the flavor of the resource agents
(`ha_pacemaker_ra_hana_scaleup_flavor`), `sap_db_hana_hadr_hooks_site_names`
to the replication site names, and `sap_db_hana_hadr_hooks_host_name` when
HANA was installed with a virtual host name.

## Restarting HANA

HANA reads the providers only when it starts, and both vendor guides change
`global.ini` while HANA is stopped. The role does not use
`hdbnsutil -reloadHADRProviders`, which neither guide documents.

- `activation: restart` (default) stops and starts HANA on each node whose
  `global.ini` changed, then waits for the load. Use it before Pacemaker
  manages HANA; the cluster would treat a restart outside it as a failure.
- `activation: none` writes the configuration only and skips the check when
  the configuration changed. Restart HANA through the cluster afterwards.

## Idempotency and check mode

A second run changes nothing, restarts nothing, and only repeats the check.
Check mode reports the changes, writes no file and restarts nothing; the
check is skipped.

The check reads the name server traces, which keep old load lines until they
are rotated. It compares the directory of the most recent load of each
provider with the configured one, so it notices a hook that loaded from
another directory, but not a provider that HANA loaded at an earlier start
and has not loaded since.

## Rollback

Remove the provider sections from `global.ini` and `/etc/sudoers.d/20-saphana`,
and restart HANA. Do not do this while the cluster manages HANA: without the
replication hook the resource agent cannot tell whether the secondary is in
sync and refuses to take over.

## Differences from the tasks it replaces

`roles-sap/5.5-hanadb-pacemaker/tasks/5.5.3-SAPHanaSR.yml`:

- **RHEL angi** uses `action_on_lost = fence` and allows `SAPHanaSR-hookHelper`
  in sudoers, as documented; the earlier tasks set `stop` and had no hook
  helper rule.
- HANA is restarted only when `global.ini` changed, and not at all through
  the SDAF playbooks once the cluster is configured; the earlier tasks
  stopped and started HANA on every run.
- `global.ini` is changed option by option instead of as a marked block, and
  the sections of the other hook generation are removed.
- The hooks are not copied to `/hana/shared/myHooks`. The earlier tasks
  copied them there but loaded them from the package directory.
- The check is the documented provider load line, on every node. The earlier
  tasks waited for an `SOK` replication status in the trace, which is a
  cluster check rather than a hook check.

## Status

Linted and run with real Ansible against a HANA layout in files for SLES and
RHEL, both flavors (`tests/.../integration/test_hadr_hooks.py`): check mode,
apply, an unchanged second run, a change of flavor, and a failed check. The
package installation and the restart have not run; nothing has run against a
real HANA system.
