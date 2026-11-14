#!/usr/bin/python
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

from __future__ import absolute_import, division, print_function

__metaclass__ = type  # pylint: disable=invalid-name

DOCUMENTATION = r"""
---
module: hana_hsr
short_description: Configure SAP HANA System Replication on one site
version_added: "0.1.0"
description:
  - Enables a site as replication primary, registers it as a secondary, or
    removes it from replication, using C(hdbnsutil).
  - The current replication state is read first; nothing is executed when it
    already matches.
options:
  sid:
    description: SAP HANA system ID.
    type: str
    required: true
  instance_number:
    description: Two-digit instance number.
    type: str
    required: true
  state:
    description:
      - V(primary) enables system replication on this site.
      - V(secondary) registers this site against O(remote_host).
      - V(disabled) unregisters a secondary or disables a primary.
    type: str
    choices: [primary, secondary, disabled]
    required: true
  site_name:
    description: Replication site name. Required unless O(state=disabled).
    type: str
  remote_host:
    description: Host name of the primary. Required when O(state=secondary).
    type: str
  remote_instance_number:
    description: Instance number of the primary; defaults to O(instance_number).
    type: str
  replication_mode:
    description: Replication mode for a secondary.
    type: str
    choices: [sync, syncmem, async]
    default: sync
  operation_mode:
    description: Operation mode for a secondary.
    type: str
    choices: [logreplay, logreplay_readaccess, delta_datashipping]
    default: logreplay
attributes:
  check_mode:
    support: full
  diff_mode:
    support: none
notes:
  - Run as the C(<sid>adm) user.
  - Registering a secondary requires HANA to be stopped on that site. The
    module fails instead of stopping it; use M(azure.sap_automation.hana_system)
    first so that the outage is explicit in the play.
author:
  - SAP Deployment Automation Framework contributors
"""

EXAMPLES = r"""
- name: Enable replication on the primary
  azure.sap_automation.hana_hsr:
    sid: HDB
    instance_number: "00"
    state: primary
    site_name: SITEA
  become: true
  become_user: hdbadm

- name: Register the secondary
  azure.sap_automation.hana_hsr:
    sid: HDB
    instance_number: "00"
    state: secondary
    site_name: SITEB
    remote_host: hdb-primary
  become: true
  become_user: hdbadm
"""

RETURN = r"""
replication:
  description:
    - Replication state before any change, with C(mode), C(enabled),
      C(is_primary), C(is_secondary), C(online), C(site_name), C(site_id),
      C(operation_mode) and C(primary_masters).
  returned: always
  type: dict
"""

from ansible.module_utils.basic import AnsibleModule

from ansible_collections.azure.sap_automation.plugins.module_utils.hana import (
    hana_environment,
    instance_dir,
    parse_key_values,
    summarize_sr_state,
    validate_identity,
)


def planned_command(params, current):
    """Return the hdbnsutil arguments needed, or None when already compliant."""
    state = params["state"]
    if state == "primary":
        if current["is_primary"] and current["site_name"] == params["site_name"]:
            return None
        return ["-sr_enable", "--name=%s" % params["site_name"]]

    if state == "secondary":
        compliant = (
            current["mode"] == params["replication_mode"]
            and current["site_name"] == params["site_name"]
            and current["operation_mode"] == params["operation_mode"]
            and params["remote_host"] in current["primary_masters"].split()
        )
        if compliant:
            return None
        return [
            "-sr_register",
            "--remoteHost=%s" % params["remote_host"],
            "--remoteInstance=%s" % (params["remote_instance_number"] or params["instance_number"]),
            "--replicationMode=%s" % params["replication_mode"],
            "--operationMode=%s" % params["operation_mode"],
            "--name=%s" % params["site_name"],
        ]

    if current["is_secondary"]:
        return ["-sr_unregister"]
    if current["is_primary"]:
        return ["-sr_disable"]
    return None


def main():
    module = AnsibleModule(
        argument_spec={
            "sid": {"type": "str", "required": True},
            "instance_number": {"type": "str", "required": True},
            "state": {
                "type": "str",
                "required": True,
                "choices": ["primary", "secondary", "disabled"],
            },
            "site_name": {"type": "str"},
            "remote_host": {"type": "str"},
            "remote_instance_number": {"type": "str"},
            "replication_mode": {
                "type": "str",
                "choices": ["sync", "syncmem", "async"],
                "default": "sync",
            },
            "operation_mode": {
                "type": "str",
                "choices": ["logreplay", "logreplay_readaccess", "delta_datashipping"],
                "default": "logreplay",
            },
        },
        required_if=[
            ("state", "primary", ("site_name",)),
            ("state", "secondary", ("site_name", "remote_host")),
        ],
        supports_check_mode=True,
    )
    params = module.params
    sid, number = params["sid"], params["instance_number"]
    error = validate_identity(sid, number)
    if error:
        module.fail_json(msg=error)

    env = hana_environment(sid, number)
    hdbnsutil = "%s/exe/hdbnsutil" % instance_dir(sid, number)

    rc, out, err = module.run_command(
        [hdbnsutil, "-sr_state", "--sapcontrol=1"], environ_update=env
    )
    if rc != 0:
        module.fail_json(msg="hdbnsutil -sr_state failed: %s" % (err.strip() or out.strip()))
    current = summarize_sr_state(parse_key_values(out))

    command = planned_command(params, current)
    if command is None:
        module.exit_json(changed=False, replication=current)
    if params["state"] == "secondary" and current["online"]:
        module.fail_json(
            msg="HANA must be stopped on this site before it can be registered as a secondary",
            replication=current,
        )
    if module.check_mode:
        module.exit_json(changed=True, replication=current)

    rc, out, err = module.run_command([hdbnsutil] + command, environ_update=env)
    if rc != 0:
        module.fail_json(
            msg="hdbnsutil %s failed: %s" % (command[0], err.strip() or out.strip()),
            rc=rc,
            replication=current,
        )
    module.exit_json(changed=True, replication=current)


if __name__ == "__main__":
    main()
