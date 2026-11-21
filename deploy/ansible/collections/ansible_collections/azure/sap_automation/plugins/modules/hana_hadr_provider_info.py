#!/usr/bin/python
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

from __future__ import absolute_import, division, print_function

__metaclass__ = type  # pylint: disable=invalid-name

DOCUMENTATION = r"""
---
module: hana_hadr_provider_info
short_description: Report the HA/DR providers an SAP HANA name server loaded
version_added: "0.2.0"
description:
  - Reads the name server trace files of an SAP HANA instance and reports, for
    each HA/DR provider, the directory it was last loaded from.
  - The name server writes a line of the form
    C(loading HA/DR Provider 'susHanaSR' from /usr/share/SAPHanaSR-angi) each
    time it loads a provider. The trace files are read oldest first, so a
    later load wins.
  - Reads only; never changes the system.
options:
  sid:
    description: SAP HANA system ID.
    type: str
    required: true
  instance_number:
    description: Two-digit instance number.
    type: str
    required: true
  host_name:
    description:
      - Host name the instance was installed with, which names its trace
        directory. Defaults to the short operating system host name.
    type: str
  trace_dir:
    description:
      - Trace directory to read instead of
        C(/usr/sap/<SID>/HDB<nr>/<host_name>/trace).
    type: path
  providers:
    description:
      - Providers that must be loaded. Each one that is not is listed in
        RV(missing).
    type: list
    elements: str
    default: []
  path:
    description:
      - Directory the providers in O(providers) must have been loaded from.
        A provider last loaded from another directory is listed in
        RV(missing). Trailing slashes are ignored.
    type: str
attributes:
  check_mode:
    support: full
  diff_mode:
    support: none
notes:
  - A load line stays in the trace files after the provider is removed from
    C(global.ini), until the files are rotated. Compare RV(loaded) with the
    configuration rather than treating any entry as current.
author:
  - SAP Deployment Automation Framework contributors
"""

EXAMPLES = r"""
- name: Wait until HANA has loaded the replication and service hooks
  azure.sap_automation.hana_hadr_provider_info:
    sid: HDB
    instance_number: "00"
    providers: [susHanaSR, susChkSrv]
    path: /usr/share/SAPHanaSR-angi
  register: hooks
  until: hooks.missing | length == 0
  retries: 30
  delay: 10
"""

RETURN = r"""
loaded:
  description: Directory each provider was last loaded from, without a trailing slash.
  returned: always
  type: dict
  sample: {susHanaSR: /usr/share/SAPHanaSR-angi, susChkSrv: /usr/share/SAPHanaSR-angi}
missing:
  description: Providers of O(providers) that are not loaded, or not from O(path).
  returned: always
  type: list
  elements: str
trace_dir:
  description: Directory that was read.
  returned: always
  type: str
"""

import glob
import os
import re
import socket

from ansible.module_utils.basic import AnsibleModule

from ansible_collections.azure.sap_automation.plugins.module_utils.hana import (
    instance_dir,
    validate_identity,
)

LOAD_LINE = re.compile(r"loading HA/DR Provider '([^']+)' from (\S+)")


def normalize(path):
    return path.rstrip("/") or "/"


def trace_files(trace_dir):
    """Name server trace files, oldest first."""
    files = glob.glob(os.path.join(trace_dir, "nameserver_*.trc"))
    return sorted(files, key=lambda name: (os.path.getmtime(name), name))


def loaded_providers(files):
    loaded = {}
    for name in files:
        with open(name, errors="replace") as handle:
            for line in handle:
                match = LOAD_LINE.search(line)
                if match:
                    loaded[match.group(1)] = normalize(match.group(2))
    return loaded


def main():
    module = AnsibleModule(
        argument_spec={
            "sid": {"type": "str", "required": True},
            "instance_number": {"type": "str", "required": True},
            "host_name": {"type": "str"},
            "trace_dir": {"type": "path"},
            "providers": {"type": "list", "elements": "str", "default": []},
            "path": {"type": "str"},
        },
        supports_check_mode=True,
    )
    sid = module.params["sid"]
    instance_number = module.params["instance_number"]
    error = validate_identity(sid, instance_number)
    if error:
        module.fail_json(msg=error)

    trace_dir = module.params["trace_dir"] or os.path.join(
        instance_dir(sid, instance_number),
        module.params["host_name"] or socket.gethostname().split(".")[0],
        "trace",
    )
    if not os.path.isdir(trace_dir):
        module.fail_json(msg="trace directory does not exist: %s" % trace_dir, trace_dir=trace_dir)

    loaded = loaded_providers(trace_files(trace_dir))
    path = module.params["path"]
    missing = [
        provider
        for provider in module.params["providers"]
        if provider not in loaded or (path is not None and loaded[provider] != normalize(path))
    ]
    module.exit_json(changed=False, loaded=loaded, missing=missing, trace_dir=trace_dir)


if __name__ == "__main__":
    main()
