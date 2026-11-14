#!/usr/bin/python
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

from __future__ import absolute_import, division, print_function

__metaclass__ = type  # pylint: disable=invalid-name

DOCUMENTATION = r"""
---
module: hana_system
short_description: Start or stop an SAP HANA instance or system
version_added: "0.1.0"
description:
  - Brings SAP HANA to the requested state through C(sapcontrol) and waits
    until that state is reached.
  - Does nothing when the instance or system is already in the requested state.
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
    description: Desired run state.
    type: str
    choices: [started, stopped]
    required: true
  scope:
    description:
      - V(instance) acts on the local instance only.
      - V(system) acts on every host of the system, as required for scale-out.
    type: str
    choices: [instance, system]
    default: instance
  timeout:
    description: Seconds to wait for the requested state.
    type: int
    default: 600
  delay:
    description: Seconds between status polls.
    type: int
    default: 10
attributes:
  check_mode:
    support: full
  diff_mode:
    support: none
notes:
  - Run as the C(<sid>adm) user. The module sets the environment the HANA
    tools need, so the login profile does not have to be sourced.
  - Do not use it on an instance managed by a cluster that is not in
    maintenance mode; Pacemaker would treat the stop as a failure.
author:
  - SAP Deployment Automation Framework contributors
"""

EXAMPLES = r"""
- name: Stop HANA before registering it as a secondary
  azure.sap_automation.hana_system:
    sid: HDB
    instance_number: "00"
    state: stopped
  become: true
  become_user: hdbadm
"""

RETURN = r"""
status:
  description: Run state observed before any change, one of C(started), C(stopped) or C(partial).
  returned: always
  type: str
"""

import time

from ansible.module_utils.basic import AnsibleModule

from ansible_collections.azure.sap_automation.plugins.module_utils.hana import (
    RC_ALL_RUNNING,
    RC_ALL_STOPPED,
    hana_environment,
    instance_dir,
    parse_instance_list,
    validate_identity,
)

ACTIONS = {
    ("instance", "started"): ["-function", "Start"],
    ("instance", "stopped"): ["-function", "Stop"],
    ("system", "started"): ["-function", "StartSystem", "HDB"],
    ("system", "stopped"): ["-function", "StopSystem", "HDB"],
}


def current_status(module, sapcontrol, env, scope):
    """Return ``started``, ``stopped`` or ``partial``."""
    if scope == "instance":
        rc, _out, _err = module.run_command(
            sapcontrol + ["-function", "GetProcessList"], environ_update=env
        )
        if rc == RC_ALL_RUNNING:
            return "started"
        if rc == RC_ALL_STOPPED:
            return "stopped"
        return "partial"

    _rc, out, _err = module.run_command(
        sapcontrol + ["-function", "GetSystemInstanceList"], environ_update=env
    )
    states = {instance["status"] for instance in parse_instance_list(out)}
    if states == {"GREEN"}:
        return "started"
    if states == {"GRAY"}:
        return "stopped"
    return "partial"


def main():
    module = AnsibleModule(
        argument_spec={
            "sid": {"type": "str", "required": True},
            "instance_number": {"type": "str", "required": True},
            "state": {"type": "str", "required": True, "choices": ["started", "stopped"]},
            "scope": {"type": "str", "choices": ["instance", "system"], "default": "instance"},
            "timeout": {"type": "int", "default": 600},
            "delay": {"type": "int", "default": 10},
        },
        supports_check_mode=True,
    )
    params = module.params
    sid, number = params["sid"], params["instance_number"]
    error = validate_identity(sid, number)
    if error:
        module.fail_json(msg=error)

    env = hana_environment(sid, number)
    sapcontrol = ["%s/exe/sapcontrol" % instance_dir(sid, number), "-nr", number]
    status = current_status(module, sapcontrol, env, params["scope"])
    if status == params["state"]:
        module.exit_json(changed=False, status=status)
    if module.check_mode:
        module.exit_json(changed=True, status=status)

    rc, out, err = module.run_command(
        sapcontrol + ACTIONS[(params["scope"], params["state"])], environ_update=env
    )
    if rc != 0:
        module.fail_json(msg="sapcontrol failed: %s" % (err.strip() or out.strip()), rc=rc)

    deadline = time.monotonic() + params["timeout"]
    while current_status(module, sapcontrol, env, params["scope"]) != params["state"]:
        if time.monotonic() >= deadline:
            module.fail_json(
                msg="HANA %s did not reach state '%s' within %d seconds"
                % (sid, params["state"], params["timeout"]),
                status=status,
            )
        time.sleep(params["delay"])

    module.exit_json(changed=True, status=status)


if __name__ == "__main__":
    main()
