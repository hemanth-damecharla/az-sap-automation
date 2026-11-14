# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

"""Shared helpers for the SAP HANA administration modules."""

from __future__ import absolute_import, division, print_function

__metaclass__ = type  # pylint: disable=invalid-name

import re

SID_PATTERN = re.compile(r"^[A-Z][A-Z0-9]{2}$")
INSTANCE_PATTERN = re.compile(r"^[0-9]{2}$")

# sapcontrol GetProcessList exit codes (see "sapcontrol EXITCODES").
RC_ALL_RUNNING = 3
RC_ALL_STOPPED = 4

REPLICATION_MODES = ("sync", "syncmem", "async")


def validate_identity(sid, instance_number):
    """Return an error string for a malformed SID or instance number, else None."""
    if not SID_PATTERN.match(sid):
        return "sid must be three characters, upper case, starting with a letter"
    if not INSTANCE_PATTERN.match(instance_number):
        return "instance_number must be exactly two digits"
    return None


def instance_dir(sid, instance_number):
    return "/usr/sap/%s/HDB%s" % (sid, instance_number)


def hana_environment(sid, instance_number):
    """Minimal environment the HANA command line tools need.

    The <sid>adm login shell is frequently csh and is not sourced by Ansible
    privilege escalation, so the required variables are passed explicitly.
    """
    base = instance_dir(sid, instance_number)
    exe = "%s/exe" % base
    return {
        "PATH": "/usr/bin:/bin:%s:%s" % (base, exe),
        "HOME": "/usr/sap/%s/home" % sid,
        "DIR_LIBRARY": exe,
        "LD_LIBRARY_PATH": exe,
        "SAPSYSTEMNAME": sid,
    }


def parse_key_values(text):
    """Parse ``key=value`` lines as printed by ``hdbnsutil --sapcontrol=1``."""
    result = {}
    for line in text.splitlines():
        line = line.strip()
        if "=" not in line or line.startswith("SAPCONTROL-OK"):
            continue
        key, value = line.split("=", 1)
        result[key.strip()] = value.strip()
    return result


def summarize_sr_state(raw):
    """Reduce the raw ``-sr_state`` keys to the fields roles act on."""
    mode = raw.get("mode", "none")
    return {
        "mode": mode,
        "enabled": mode not in ("none", ""),
        "is_primary": mode == "primary",
        "is_secondary": mode in REPLICATION_MODES,
        "online": raw.get("online", "false") == "true",
        "site_name": raw.get("site name", ""),
        "site_id": raw.get("site id", ""),
        "operation_mode": raw.get("operation mode", ""),
        "primary_masters": raw.get("primary masters", ""),
    }


def parse_instance_list(text):
    """Parse ``sapcontrol -function GetSystemInstanceList`` output."""
    instances = []
    for line in text.splitlines():
        parts = [part.strip() for part in line.split(",")]
        if len(parts) == 7 and parts[1].isdigit():
            instances.append(
                {
                    "hostname": parts[0],
                    "instance_number": parts[1].zfill(2),
                    "features": parts[5],
                    "status": parts[6],
                }
            )
    return instances
