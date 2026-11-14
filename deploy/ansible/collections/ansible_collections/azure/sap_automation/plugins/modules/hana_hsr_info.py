#!/usr/bin/python
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

from __future__ import absolute_import, division, print_function

__metaclass__ = type  # pylint: disable=invalid-name

DOCUMENTATION = r"""
---
module: hana_hsr_info
short_description: Report SAP HANA System Replication state of one site
version_added: "0.1.0"
description:
  - Returns the output of C(hdbnsutil -sr_state) as structured data so that
    replication can be validated with M(ansible.builtin.assert) instead of
    text matching.
options:
  sid:
    description: SAP HANA system ID.
    type: str
    required: true
  instance_number:
    description: Two-digit instance number.
    type: str
    required: true
attributes:
  check_mode:
    support: full
  diff_mode:
    support: none
notes:
  - Run as the C(<sid>adm) user.
author:
  - SAP Deployment Automation Framework contributors
"""

EXAMPLES = r"""
- name: Read replication state
  azure.sap_automation.hana_hsr_info:
    sid: HDB
    instance_number: "00"
  register: __sap_db_hana_hsr_state
  become: true
  become_user: hdbadm

- name: Validate that this site is the primary
  ansible.builtin.assert:
    that: __sap_db_hana_hsr_state.replication.is_primary
"""

RETURN = r"""
replication:
  description:
    - Replication state with C(mode), C(enabled), C(is_primary),
      C(is_secondary), C(online), C(site_name), C(site_id),
      C(operation_mode) and C(primary_masters).
  returned: always
  type: dict
raw:
  description: Every key and value reported by C(hdbnsutil -sr_state --sapcontrol=1).
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


def main():
    module = AnsibleModule(
        argument_spec={
            "sid": {"type": "str", "required": True},
            "instance_number": {"type": "str", "required": True},
        },
        supports_check_mode=True,
    )
    sid, number = module.params["sid"], module.params["instance_number"]
    error = validate_identity(sid, number)
    if error:
        module.fail_json(msg=error)

    rc, out, err = module.run_command(
        ["%s/exe/hdbnsutil" % instance_dir(sid, number), "-sr_state", "--sapcontrol=1"],
        environ_update=hana_environment(sid, number),
    )
    if rc != 0:
        module.fail_json(msg="hdbnsutil -sr_state failed: %s" % (err.strip() or out.strip()))
    raw = parse_key_values(out)
    module.exit_json(changed=False, replication=summarize_sr_state(raw), raw=raw)


if __name__ == "__main__":
    main()
