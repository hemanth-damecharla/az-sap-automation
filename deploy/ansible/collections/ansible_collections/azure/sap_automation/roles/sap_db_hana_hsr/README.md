# sap_db_hana_hsr

Configures SAP HANA System Replication between a primary and one or more
secondary sites of a scale-up system. All HANA operations go through the
collection's modules (`hana_system`, `hana_sql`, `hana_hsr`, `hana_hsr_info`),
so each step compares the current state first.

## What it does

| Component (`tasks/`) | Host | Result |
| --- | --- | --- |
| `preflight` | all | HANA running; replication state read; on a primary without replication: SYSTEMDB present and `log_mode` is `normal` |
| `ssfs` | secondary | Secure store files (`SSFS_<SID>.DAT`/`.KEY`, and the XSA pair if present) identical to the primary |
| `global_ini` | all | `[inifile_checker]` section in `global.ini` |
| `backup` | primary | Initial data backup of SYSTEMDB and the tenant, unless the backup catalog already has one |
| `primary` | primary | `hdbnsutil -sr_enable`; HANA restarted only if replication or `global.ini` changed |
| `secondary` | secondary | HANA stopped, `hdbnsutil -sr_register`, HANA started; only when not already registered as required |
| `validate` | primary | Overall replication status polled and reported |

## Inputs

See [`meta/argument_specs.yml`](meta/argument_specs.yml). Required:
`sap_db_hana_hsr_sid`, `sap_db_hana_hsr_instance_number`,
`sap_db_hana_hsr_primary` (an inventory host name; the role contains no group
names) and `sap_db_hana_hsr_system_password`.

Set `sap_db_hana_hsr_primary_host` and `sap_db_hana_hsr_host_name` when HANA
was installed with virtual host names.

## Secrets

`sap_db_hana_hsr_system_password` has no default and is never logged. It is
passed to `hdbsql` as an argument on the managed node, as the existing
automation does, and is therefore visible in that node's process list while a
statement runs. `hana_sql` also accepts a secure user store key; switching
the role to one is the intended follow-up.

The secure store files are staged in a private temporary directory on the
controller (mode 0700) and removed even when the play fails.

## Example

```yaml
- name: Configure HANA system replication
  hosts: "{{ hana_hosts }}"
  roles:
    - role: azure.sap_automation.sap_db_hana_hsr
      vars:
        sap_db_hana_hsr_sid: X00
        sap_db_hana_hsr_instance_number: "00"
        sap_db_hana_hsr_primary: "{{ ansible_play_hosts_all | first }}"
        sap_db_hana_hsr_system_password: "{{ lookup('azure.azcollection.azure_keyvault_secret', 'x00-system-password', vault_url=kv_url) }}"
```

## Idempotency and check mode

A second run changes nothing. Check mode reports what would change and stops,
starts or registers nothing; read-only queries still run so that the report
is accurate. The status poll is skipped in check mode.

## Rollback

On the secondary: stop HANA, run `hana_hsr` with `state: disabled`, start
HANA. On the primary: `hana_hsr` with `state: disabled`. The initial backups
and the `inifile_checker` section are left in place.

## Status against `roles-db/4.0.1-hdb-hsr`

Not carried over: SAP HANA 1.0 (replication user and user store entry), which
is out of maintenance. Sudoers for `<sid>adm` stays with the accounts role.
The status check is stricter in what it reads (the exit code of
`systemReplicationStatus.py`) and, like before, does not fail the play unless
`sap_db_hana_hsr_require_active` is set.

Linted, unit-tested through its modules, and run with real Ansible against
stand-ins for the HANA tools (check mode, primary, secondary, unchanged
second run). Not yet executed against a real HANA system.
