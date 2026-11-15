#!/usr/bin/python
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

from __future__ import absolute_import, division, print_function

__metaclass__ = type  # pylint: disable=invalid-name

DOCUMENTATION = r"""
---
module: hana_sql
short_description: Run an SQL statement against SAP HANA with hdbsql
version_added: "0.1.0"
description:
  - Runs one SQL statement through C(hdbsql) on the managed node and returns
    the result rows.
  - Queries are declared with O(read_only=true); they run in check mode and
    never report a change. Any other statement reports a change and is skipped
    in check mode.
options:
  sid:
    description: SAP HANA system ID.
    type: str
    required: true
  instance_number:
    description: Two-digit instance number.
    type: str
    required: true
  database:
    description: Database to connect to, for example V(SYSTEMDB).
    type: str
    default: SYSTEMDB
  query:
    description: The SQL statement.
    type: str
    required: true
  read_only:
    description: Whether the statement only reads data.
    type: bool
    default: false
  userstore_key:
    description:
      - Key in the secure user store (C(hdbuserstore)) of the user running the
        module. Preferred, because no password leaves the store.
    type: str
  user:
    description: Database user. Required together with O(password).
    type: str
  password:
    description:
      - Password of O(user). It is passed to C(hdbsql) as an argument and is
        therefore visible in the process list of the managed node while the
        statement runs; use O(userstore_key) where that matters.
    type: str
  host:
    description: Host hdbsql connects to.
    type: str
    default: localhost
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
- name: Read the log mode
  azure.sap_automation.hana_sql:
    sid: HDB
    instance_number: "00"
    user: SYSTEM
    password: "{{ system_password }}"
    read_only: true
    query: >-
      SELECT VALUE FROM M_INIFILE_CONTENTS WHERE FILE_NAME='global.ini'
      AND LAYER_NAME='DEFAULT' AND SECTION='persistence' AND KEY='log_mode'
  register: __log_mode
  become: true
  become_user: hdbadm
"""

RETURN = r"""
rows:
  description: Result rows, each a list of column values as strings.
  returned: when the statement was executed
  type: list
  elements: list
"""

from ansible.module_utils.basic import AnsibleModule

from ansible_collections.azure.sap_automation.plugins.module_utils.hana import (
    hana_environment,
    instance_dir,
    parse_sql_rows,
    validate_identity,
)


def main():
    module = AnsibleModule(
        argument_spec={
            "sid": {"type": "str", "required": True},
            "instance_number": {"type": "str", "required": True},
            "database": {"type": "str", "default": "SYSTEMDB"},
            "query": {"type": "str", "required": True},
            "read_only": {"type": "bool", "default": False},
            "userstore_key": {"type": "str", "no_log": False},
            "user": {"type": "str"},
            "password": {"type": "str", "no_log": True},
            "host": {"type": "str", "default": "localhost"},
        },
        mutually_exclusive=[("userstore_key", "user")],
        required_one_of=[("userstore_key", "user")],
        required_together=[("user", "password")],
        supports_check_mode=True,
    )
    params = module.params
    sid, number = params["sid"], params["instance_number"]
    error = validate_identity(sid, number)
    if error:
        module.fail_json(msg=error)

    changed = not params["read_only"]
    if changed and module.check_mode:
        module.exit_json(changed=True)

    command = ["%s/exe/hdbsql" % instance_dir(sid, number), "-x", "-a", "-j", "-C"]
    if params["userstore_key"]:
        command += ["-U", params["userstore_key"]]
    else:
        command += ["-n", params["host"], "-i", number, "-u", params["user"]]
        command += ["-p", params["password"]]
    command += ["-d", params["database"], params["query"]]

    rc, out, err = module.run_command(command, environ_update=hana_environment(sid, number))
    if rc != 0:
        module.fail_json(msg="hdbsql failed: %s" % (err.strip() or out.strip()), rc=rc)
    module.exit_json(changed=changed, rows=parse_sql_rows(out))


if __name__ == "__main__":
    main()
