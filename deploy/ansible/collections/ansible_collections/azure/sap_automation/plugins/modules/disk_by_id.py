#!/usr/bin/python
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

from __future__ import absolute_import, division, print_function

__metaclass__ = type  # pylint: disable=invalid-name

DOCUMENTATION = r"""
---
module: disk_by_id
short_description: Find the stable /dev/disk/by-id name of a block device
version_added: "0.2.0"
description:
  - Resolves a device path, which may be a symbolic link such as
    C(/dev/disk/azure/scsi1/lun0), to the block device it points to, and
    returns the C(/dev/disk/by-id) links of that device.
  - Kernel names such as C(/dev/sdc) can change between boots; the by-id name
    of a shared disk is the same on every node, which SBD and multipath
    configuration rely on.
  - Reads only; never changes the system.
options:
  path:
    description: Device path to resolve.
    type: path
    required: true
  prefer:
    description:
      - Link name prefixes in order of preference; the first matching link is
        returned as RV(by_id).
    type: list
    elements: str
    default: [scsi-3, wwn-, nvme-eui., nvme-]
  by_id_dir:
    description: Directory that holds the by-id links.
    type: path
    default: /dev/disk/by-id
attributes:
  check_mode:
    support: full
  diff_mode:
    support: none
author:
  - SAP Deployment Automation Framework contributors
"""

EXAMPLES = r"""
- name: Find the by-id name of the shared disk at LUN 0
  azure.sap_automation.disk_by_id:
    path: /dev/disk/azure/scsi1/lun0
  register: sbd_disk
"""

RETURN = r"""
device:
  description: Block device the path resolves to.
  returned: always
  type: str
  sample: /dev/sdc
by_id:
  description: Preferred by-id link of the device.
  returned: always
  type: str
  sample: /dev/disk/by-id/scsi-36001405a1b2c3d4e5f60718293a4b5c6
links:
  description: Every by-id link of the device, sorted.
  returned: always
  type: list
  elements: str
"""

import os

from ansible.module_utils.basic import AnsibleModule


def find_links(device, by_id_dir):
    """Return the names in by_id_dir whose link resolves to device, sorted."""
    try:
        names = sorted(os.listdir(by_id_dir))
    except OSError:
        return []
    return [name for name in names if os.path.realpath(os.path.join(by_id_dir, name)) == device]


def choose(names, prefer):
    """Return the first name matching the preferred prefixes, else the first name."""
    for prefix in prefer:
        for name in names:
            if name.startswith(prefix):
                return name
    return names[0]


def main():
    module = AnsibleModule(
        argument_spec={
            "path": {"type": "path", "required": True},
            "prefer": {
                "type": "list",
                "elements": "str",
                "default": ["scsi-3", "wwn-", "nvme-eui.", "nvme-"],
            },
            "by_id_dir": {"type": "path", "default": "/dev/disk/by-id"},
        },
        supports_check_mode=True,
    )
    path = module.params["path"]
    if not os.path.exists(path):
        module.fail_json(msg="device path does not exist: %s" % path)
    device = os.path.realpath(path)
    by_id_dir = module.params["by_id_dir"]
    names = find_links(device, by_id_dir)
    if not names:
        module.fail_json(msg="no link in %s points to %s" % (by_id_dir, device), device=device)
    links = [os.path.join(by_id_dir, name) for name in names]
    by_id = os.path.join(by_id_dir, choose(names, module.params["prefer"]))
    module.exit_json(changed=False, device=device, by_id=by_id, links=links)


if __name__ == "__main__":
    main()
