#!/usr/bin/python
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

from __future__ import absolute_import, division, print_function

__metaclass__ = type  # pylint: disable=invalid-name

DOCUMENTATION = r"""
---
module: sbd_device
short_description: Initialize SBD devices that have no SBD header
version_added: "0.2.0"
description:
  - Reads the SBD header of each device with C(sbd dump) and writes a header
    with C(sbd create) only to the devices that have none.
  - A device that already carries a header is never written to, so running
    the module against a device in use by a cluster is safe. Its timeouts are
    left as they are.
options:
  devices:
    description:
      - Block devices to use for SBD, as stable paths such as
        C(/dev/disk/by-id/scsi-3...). Every path must exist.
    type: list
    elements: str
    required: true
  watchdog_timeout:
    description: Watchdog timeout written to a new header, in seconds (C(sbd -1)).
    type: int
    default: 60
  msgwait_timeout:
    description: Message wait timeout written to a new header, in seconds (C(sbd -4)).
    type: int
    default: 120
attributes:
  check_mode:
    support: full
  diff_mode:
    support: none
notes:
  - Run on one cluster node only; the devices are shared.
author:
  - SAP Deployment Automation Framework contributors
"""

EXAMPLES = r"""
- name: Initialize the SBD devices
  azure.sap_automation.sbd_device:
    devices:
      - /dev/disk/by-id/scsi-36001405a1b2c3d4e5f60718293a4b5c6
  run_once: true
"""

RETURN = r"""
created:
  description: Devices that had no SBD header and were, or in check mode would be, initialized.
  returned: always
  type: list
  elements: str
initialized:
  description: Devices that already carried an SBD header.
  returned: always
  type: list
  elements: str
"""

import os

from ansible.module_utils.basic import AnsibleModule


def main():
    module = AnsibleModule(
        argument_spec={
            "devices": {"type": "list", "elements": "str", "required": True},
            "watchdog_timeout": {"type": "int", "default": 60},
            "msgwait_timeout": {"type": "int", "default": 120},
        },
        supports_check_mode=True,
    )
    devices = module.params["devices"]
    if not devices:
        module.fail_json(msg="at least one SBD device is required")
    missing = [device for device in devices if not os.path.exists(device)]
    if missing:
        module.fail_json(msg="SBD device does not exist: %s" % ", ".join(missing))

    sbd = module.get_bin_path("sbd", required=True)
    initialized = []
    created = []
    for device in devices:
        rc, _out, _err = module.run_command([sbd, "-d", device, "dump"])
        (initialized if rc == 0 else created).append(device)

    if created and not module.check_mode:
        command = [sbd]
        for device in created:
            command += ["-d", device]
        command += [
            "-1",
            str(module.params["watchdog_timeout"]),
            "-4",
            str(module.params["msgwait_timeout"]),
            "create",
        ]
        rc, _out, err = module.run_command(command)
        if rc != 0:
            module.fail_json(msg="sbd create failed: %s" % err.strip(), rc=rc, created=[])

    module.exit_json(changed=bool(created), created=created, initialized=initialized)


if __name__ == "__main__":
    main()
