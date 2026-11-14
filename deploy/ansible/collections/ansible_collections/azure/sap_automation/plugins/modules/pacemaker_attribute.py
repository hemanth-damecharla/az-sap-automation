#!/usr/bin/python
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

from __future__ import absolute_import, division, print_function

__metaclass__ = type  # pylint: disable=invalid-name

DOCUMENTATION = r"""
---
module: pacemaker_attribute
short_description: Manage a Pacemaker node attribute
version_added: "0.1.0"
description:
  - Sets or removes a node attribute through C(crm_attribute), only when the
    current value differs.
  - Cluster properties are managed with M(azure.sap_automation.pacemaker_cib).
options:
  name:
    description: Attribute name, for example C(#health-azure).
    type: str
    required: true
  node:
    description: Cluster node the attribute belongs to.
    type: str
    required: true
  value:
    description: Attribute value. Required when O(state=present).
    type: str
  lifetime:
    description: V(forever) survives a cluster restart, V(reboot) does not.
    type: str
    choices: [forever, reboot]
    default: forever
  state:
    description: Whether the attribute must be set or removed.
    type: str
    choices: [present, absent]
    default: present
attributes:
  check_mode:
    support: full
  diff_mode:
    support: none
author:
  - SAP Deployment Automation Framework contributors
"""

EXAMPLES = r"""
- name: Initialise the Azure health attribute
  azure.sap_automation.pacemaker_attribute:
    name: "#health-azure"
    node: "{{ item }}"
    value: "0"
  loop: "{{ ha_pacemaker_core_nodes | map(attribute='name') }}"
"""

RETURN = r"""
previous_value:
  description: Value before the module ran; empty when the attribute was unset.
  returned: always
  type: str
"""

from ansible.module_utils.basic import AnsibleModule


def main():
    module = AnsibleModule(
        argument_spec={
            "name": {"type": "str", "required": True},
            "node": {"type": "str", "required": True},
            "value": {"type": "str"},
            "lifetime": {"type": "str", "choices": ["forever", "reboot"], "default": "forever"},
            "state": {"type": "str", "choices": ["present", "absent"], "default": "present"},
        },
        required_if=[("state", "present", ("value",))],
        supports_check_mode=True,
    )
    params = module.params
    base = [
        module.get_bin_path("crm_attribute", required=True),
        "--node",
        params["node"],
        "--name",
        params["name"],
        "--lifetime",
        params["lifetime"],
    ]

    rc, out, _err = module.run_command(base + ["--query", "--quiet"])
    current = out.strip() if rc == 0 else None

    if params["state"] == "present":
        changed = current != params["value"]
        action = ["--update", params["value"]]
    else:
        changed = current is not None
        action = ["--delete"]

    if changed and not module.check_mode:
        rc, _out, err = module.run_command(base + action)
        if rc != 0:
            module.fail_json(msg="crm_attribute failed: %s" % err.strip(), rc=rc)

    module.exit_json(changed=changed, previous_value=current or "")


if __name__ == "__main__":
    main()
