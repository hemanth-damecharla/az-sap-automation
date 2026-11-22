#!/usr/bin/python
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

from __future__ import absolute_import, division, print_function

__metaclass__ = type  # pylint: disable=invalid-name

DOCUMENTATION = r"""
---
module: pacemaker_cib
short_description: Declaratively manage Pacemaker CIB configuration from XML
version_added: "0.1.0"
description:
  - Reconciles resources, constraints, fencing topology, cluster properties and
    resource/operation defaults against a desired CIB XML document.
  - Works identically on RHEL and SLES because it only uses C(cibadmin), which
    ships with Pacemaker itself; neither C(pcs) nor C(crmsh) is required.
  - Elements in C(resources), C(constraints) and C(fencing-topology) are
    matched by C(id) and replaced when they differ. Elements not mentioned are
    left untouched.
  - C(crm_config), C(rsc_defaults) and C(op_defaults) are merged by nvpair
    name, so values owned by Pacemaker or other tools are preserved.
  - Missing C(id) attributes on nvpairs, attribute sets, operations, rules and
    expressions are derived deterministically from their parent.
options:
  xml:
    description:
      - Desired configuration. Either a C(<configuration>) document or a
        sequence of section elements (C(<crm_config>), C(<rsc_defaults>),
        C(<op_defaults>), C(<resources>), C(<constraints>),
        C(<fencing-topology>)).
      - With O(state=absent) only the C(id) of each top-level element (or the
        C(name) of each nvpair in merged sections) is significant.
    type: str
    required: true
  state:
    description: Whether the described elements must exist or be removed.
    type: str
    choices: [present, absent]
    default: present
  replace:
    description:
      - With V(false), elements and properties that already exist are kept as
        they are, even when they differ from O(xml); only missing ones are
        added. Use it for a configuration step that must not undo a later one.
      - Only used with O(state=present).
    type: bool
    default: true
    version_added: "0.2.0"
attributes:
  check_mode:
    support: full
  diff_mode:
    support: full
notes:
  - Must run as root on a node where the cluster is running.
  - In check mode on a node without a running cluster the module reports
    C(changed=true), because nothing can be compared.
  - Each changed section is pushed with one C(cibadmin --replace) call, so a
    section is updated atomically and Pacemaker validates it against the
    active schema before accepting it.
  - The diff masks the value of every C(nvpair) named C(passwd) or
    C(password), or with C(secret) in its name, wherever it is in a changed
    section. The XML passed in O(xml) is not masked; use C(no_log) on a task
    whose O(xml) carries a secret.
author:
  - SAP Deployment Automation Framework contributors
"""

EXAMPLES = r"""
- name: Ensure fencing is enabled and the Azure fence agent exists
  azure.sap_automation.pacemaker_cib:
    xml: |
      <crm_config>
        <cluster_property_set>
          <nvpair name="stonith-enabled" value="true"/>
          <nvpair name="stonith-timeout" value="900"/>
        </cluster_property_set>
      </crm_config>
      <resources>
        <primitive id="rsc_st_azure" class="stonith" type="fence_azure_arm">
          <instance_attributes>
            <nvpair name="msi" value="true"/>
          </instance_attributes>
          <operations>
            <op name="monitor" interval="3600" timeout="120"/>
          </operations>
        </primitive>
      </resources>

- name: Render resources from a role template
  azure.sap_automation.pacemaker_cib:
    xml: "{{ lookup('ansible.builtin.template', 'cib/resources.xml.j2') }}"

- name: Remove a resource
  azure.sap_automation.pacemaker_cib:
    state: absent
    xml: <resources><primitive id="rsc_st_azure"/></resources>
"""

RETURN = r"""
sections:
  description: Names of the CIB sections that were (or would be) modified.
  returned: always
  type: list
  elements: str
  sample: [crm_config, resources]
"""

from ansible.module_utils.basic import AnsibleModule

from ansible_collections.azure.sap_automation.plugins.module_utils.cib import (
    SECTIONS,
    CibError,
    parse_desired,
    reconcile,
    redact,
)

# cibadmin exits with ENXIO when the requested scope is not in the CIB yet.
RC_NO_SUCH_SECTION = 105


def read_section(module, cibadmin, name):
    """Return the XML of a live section, or None when it does not exist."""
    rc, out, err = module.run_command([cibadmin, "--query", "--scope", name])
    if rc == 0:
        return out
    if rc == RC_NO_SUCH_SECTION:
        return None
    if module.check_mode:
        module.exit_json(
            changed=True,
            sections=[],
            msg="cluster is not reachable, so the CIB cannot be compared: %s" % err.strip(),
        )
    module.fail_json(msg="cibadmin could not read <%s>: %s" % (name, err.strip()), rc=rc)


def write_section(module, cibadmin, name, xml, existed):
    """Push one section. A section missing from the CIB is created."""
    if existed:
        command = [cibadmin, "--replace", "--scope", name, "--xml-pipe"]
    else:
        command = [cibadmin, "--create", "--scope", "configuration", "--xml-pipe"]
    rc, _out, err = module.run_command(command, data=xml)
    if rc != 0:
        module.fail_json(msg="cibadmin rejected the <%s> section: %s" % (name, err.strip()), rc=rc)


def main():
    module = AnsibleModule(
        argument_spec={
            "xml": {"type": "str", "required": True},
            "state": {"type": "str", "choices": ["present", "absent"], "default": "present"},
            "replace": {"type": "bool", "default": True},
        },
        supports_check_mode=True,
    )
    cibadmin = module.get_bin_path("cibadmin", required=True)
    state = module.params["state"]

    try:
        desired = parse_desired(module.params["xml"])
    except CibError as exc:
        module.fail_json(msg=str(exc))

    order = SECTIONS if state == "present" else tuple(reversed(SECTIONS))
    changed_sections = []
    before = []
    after = []
    for name in order:
        if name not in desired:
            continue
        current = read_section(module, cibadmin, name)
        try:
            new_xml, changed = reconcile(current, desired[name], state, module.params["replace"])
        except CibError as exc:
            module.fail_json(msg=str(exc))
        if not changed:
            continue
        changed_sections.append(name)
        # The diff shows whole sections, so a secret in an unrelated element
        # of the same section would otherwise appear in the output.
        before.append(redact(current or ""))
        after.append(redact(new_xml))
        if not module.check_mode:
            write_section(module, cibadmin, name, new_xml, current is not None)

    module.exit_json(
        changed=bool(changed_sections),
        sections=changed_sections,
        diff={"before": "\n".join(before) + "\n", "after": "\n".join(after) + "\n"},
    )


if __name__ == "__main__":
    main()
