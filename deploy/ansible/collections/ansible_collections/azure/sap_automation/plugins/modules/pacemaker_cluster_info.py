#!/usr/bin/python
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

from __future__ import absolute_import, division, print_function

__metaclass__ = type  # pylint: disable=invalid-name

DOCUMENTATION = r"""
---
module: pacemaker_cluster_info
short_description: Report Pacemaker cluster, node and resource state
version_added: "0.1.0"
description:
  - Reads the cluster state from C(crm_mon) XML output and returns it as
    structured data, replacing text scraping of C(pcs status) or
    C(crm status).
  - Never fails because the cluster is down; RV(running) reports that instead,
    so the module can be used to decide whether a cluster must be created.
options: {}
attributes:
  check_mode:
    support: full
  diff_mode:
    support: none
notes:
  - Must run as root.
author:
  - SAP Deployment Automation Framework contributors
"""

EXAMPLES = r"""
- name: Wait until both nodes are online
  azure.sap_automation.pacemaker_cluster_info:
  register: __ha_pacemaker_core_state
  until: __ha_pacemaker_core_state.online_nodes | length == 2
  retries: 12
  delay: 10
"""

RETURN = r"""
running:
  description: Whether a cluster is running on this node.
  returned: always
  type: bool
maintenance_mode:
  description: Whether the cluster is in maintenance mode.
  returned: always
  type: bool
with_quorum:
  description: Whether the partition this node belongs to has quorum.
  returned: always
  type: bool
nodes:
  description: Cluster nodes with C(name), C(online), C(standby), C(maintenance) and C(unclean).
  returned: always
  type: list
  elements: dict
online_nodes:
  description: Names of the nodes that are online.
  returned: always
  type: list
  elements: str
resources:
  description:
    - Resource instances with C(id), C(agent), C(role), C(active), C(failed),
      C(managed) and the C(nodes) they run on.
  returned: always
  type: list
  elements: dict
"""

import xml.etree.ElementTree as ET

from ansible.module_utils.basic import AnsibleModule


def _flag(element, name):
    return element.get(name, "false") == "true"


def parse_status(xml_text):
    """Convert ``crm_mon`` XML into the module's return structure."""
    root = ET.fromstring(xml_text)
    options = root.find("summary/cluster_options")
    current_dc = root.find("summary/current_dc")
    nodes = [
        {
            "name": node.get("name"),
            "online": _flag(node, "online"),
            "standby": _flag(node, "standby"),
            "maintenance": _flag(node, "maintenance"),
            "unclean": _flag(node, "unclean"),
        }
        for node in root.findall("nodes/node")
    ]
    resources = [
        {
            "id": resource.get("id"),
            "agent": resource.get("resource_agent"),
            "role": resource.get("role"),
            "active": _flag(resource, "active"),
            "failed": _flag(resource, "failed"),
            "managed": _flag(resource, "managed"),
            "nodes": [node.get("name") for node in resource.findall("node")],
        }
        for resource in root.findall("resources//resource")
    ]
    return {
        "running": True,
        "maintenance_mode": options is not None and _flag(options, "maintenance-mode"),
        "with_quorum": current_dc is not None and _flag(current_dc, "with_quorum"),
        "nodes": nodes,
        "online_nodes": [node["name"] for node in nodes if node["online"]],
        "resources": resources,
    }


def main():
    module = AnsibleModule(argument_spec={}, supports_check_mode=True)
    crm_mon = module.get_bin_path("crm_mon")
    result = {
        "changed": False,
        "running": False,
        "maintenance_mode": False,
        "with_quorum": False,
        "nodes": [],
        "online_nodes": [],
        "resources": [],
    }
    if crm_mon is None:
        module.exit_json(**result)

    # --output-as=xml needs Pacemaker 2.0.3; --as-xml covers older releases.
    for option in ("--output-as=xml", "--as-xml"):
        rc, out, _err = module.run_command([crm_mon, "--one-shot", option])
        if rc == 0:
            try:
                result.update(parse_status(out))
            except ET.ParseError as exc:
                module.fail_json(msg="cannot parse crm_mon output: %s" % exc)
            break
    module.exit_json(**result)


if __name__ == "__main__":
    main()
