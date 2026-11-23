#!/usr/bin/python
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

from __future__ import absolute_import, division, print_function

__metaclass__ = type  # pylint: disable=invalid-name

DOCUMENTATION = r"""
---
module: nfs_mount
short_description: Mount a directory of an NFS share for SAP
version_added: "0.2.0"
description:
  - Mounts O(src), or the directory O(subdir) inside it, at O(path), the way
    SAP file systems on Azure NetApp Files and Azure Files NFS are laid out.
  - When O(subdir) is set and O(path) is not already mounted from it, the
    share is mounted at a private temporary directory, O(subdir) is created
    there if it is missing, and the temporary mount is removed again.
  - Several nodes may run the module for the same share at once; a
    subdirectory another node creates in the meantime is accepted.
  - Creates the mount point when it is missing and can make it immutable, so
    that nothing is written to the local directory while the share is not
    mounted.
  - Keeps an C(/etc/fstab) entry with O(persist=true). With O(persist=false)
    the file system is mounted but has no entry, for file systems that a
    Pacemaker C(Filesystem) resource mounts.
  - Never replaces a mount from another source and never remounts a mounted
    file system. A change of options is written to C(/etc/fstab) and
    reported in RV(remount_required).
options:
  path:
    description: Mount point.
    type: path
    required: true
  src:
    description: NFS export, as C(server:/export). Required unless O(state=absent) or O(state=unmounted).
    type: str
  subdir:
    description: Directory inside the export to mount instead of the export itself.
    type: str
  fstype:
    description: File system type, for example V(nfs4), V(nfs) or V(aznfs).
    type: str
    default: nfs4
  opts:
    description: Mount options.
    type: str
    default: defaults
  state:
    description:
      - V(mounted) mounts the file system.
      - V(unmounted) unmounts it and keeps its C(/etc/fstab) entry.
      - V(absent) unmounts it and removes its C(/etc/fstab) entry. Directories are kept.
    type: str
    choices: [mounted, unmounted, absent]
    default: mounted
  persist:
    description: Keep an C(/etc/fstab) entry for O(path). With V(false) any entry for O(path) is removed.
    type: bool
    default: true
  owner:
    description:
      - User name or ID given to O(subdir) and to the mount point when the
        module creates them. Existing directories are not changed.
    type: str
  group:
    description: Group name or ID, as for O(owner).
    type: str
  mode:
    description: Octal mode, as for O(owner).
    type: str
    default: "0755"
  immutable:
    description:
      - Set the immutable attribute on the local mount point directory while
        nothing is mounted on it.
    type: bool
    default: false
  retries:
    description: Further mount attempts after a failed one.
    type: int
    default: 1
  delay:
    description: Seconds between mount attempts.
    type: int
    default: 10
  fstab:
    description: File system table to manage.
    type: path
    default: /etc/fstab
attributes:
  check_mode:
    support: full
  diff_mode:
    support: full
notes:
  - In check mode the share is not mounted, so whether O(subdir) exists is
    not known; it is reported as missing unless O(path) is already mounted
    from it.
  - With O(fstype=aznfs) the mount table shows a local proxy address instead
    of the export, so the source of an existing mount is not compared.
author:
  - SAP Deployment Automation Framework contributors
"""

EXAMPLES = r"""
- name: Mount the HANA data volume, which a cluster resource will manage
  azure.sap_automation.nfs_mount:
    src: 10.0.2.4:/hanadb1-data-mnt00001
    subdir: hanadata
    path: /hana/data
    opts: rw,nfsvers=4.1,hard,timeo=600,rsize=262144,wsize=262144,noatime,lock,_netdev,sec=sys
    owner: "1001"
    group: sapsys
    persist: false
"""

RETURN = r"""
source:
  description: Mount source, O(src) followed by O(subdir).
  returned: when O(src) is set
  type: str
  sample: 10.0.2.4:/hanadb1-data-mnt00001/hanadata
mounted:
  description: Whether O(path) is mounted after the run, or would be in check mode.
  returned: always
  type: bool
subdir_created:
  description: Whether O(subdir) was, or in check mode may need to be, created.
  returned: always
  type: bool
fstab_changed:
  description: Whether the C(/etc/fstab) entry for O(path) changed.
  returned: always
  type: bool
remount_required:
  description: The entry changed while the file system stays mounted with its old options.
  returned: always
  type: bool
"""

import grp
import os
import pwd
import tempfile
import time

from ansible.module_utils.basic import AnsibleModule

MOUNTINFO = "/proc/self/mountinfo"
UNCOMPARABLE_SOURCES = ("aznfs",)


def unescape(field):
    """Undo the octal escapes of /proc/self/mountinfo and /etc/fstab."""
    for code, char in (("\\040", " "), ("\\011", "\t"), ("\\012", "\n"), ("\\134", "\\")):
        field = field.replace(code, char)
    return field


def normalize(source):
    if ":" not in source:
        return source.rstrip("/") or "/"
    server, export = source.split(":", 1)
    export = "/" + "/".join(part for part in export.split("/") if part)
    return "%s:%s" % (server, export)


def join_source(src, subdir):
    if not subdir:
        return src
    return "%s/%s" % (src.rstrip("/"), subdir.strip("/"))


def mount_source(path):
    """Source of the topmost mount at path, or None when path is not a mount point."""
    found = None
    try:
        with open(MOUNTINFO) as handle:
            for line in handle:
                fields = line.split()
                separator = fields.index("-")
                if os.path.normpath(unescape(fields[4])) == path:
                    found = unescape(fields[separator + 2])
    except (OSError, ValueError, IndexError):
        return found
    return found


def fstab_entries(lines, path):
    """Indexes and fields of the lines that mount at path."""
    entries = []
    for index, line in enumerate(lines):
        fields = line.split()
        if fields and not fields[0].startswith("#") and len(fields) >= 2:
            if os.path.normpath(unescape(fields[1])) == path:
                entries.append((index, fields))
    return entries


def desired_fstab(lines, path, entry):
    """Lines of the table with exactly one entry for path, or none when entry is None."""
    entries = fstab_entries(lines, path)
    wanted = entry.split() if entry else None
    if wanted and len(entries) == 1:
        fields = entries[0][1] + ["0", "0"][len(entries[0][1]) - 4 :]
        if fields[:6] == wanted:
            return lines
    drop = {index for index, _fields in entries}
    result = []
    for index, line in enumerate(lines):
        if index in drop:
            if wanted and index == entries[0][0]:
                result.append(entry + "\n")
            continue
        result.append(line)
    if wanted and not entries:
        if result and not result[-1].endswith("\n"):
            result[-1] += "\n"
        result.append(entry + "\n")
    return result


def resolve_id(module, value, database):
    if value is None:
        return -1
    if value.isdigit():
        return int(value)
    try:
        if database is pwd:
            return pwd.getpwnam(value).pw_uid
        return grp.getgrnam(value).gr_gid
    except KeyError:
        module.fail_json(msg="unknown %s: %s" % ("user" if database is pwd else "group", value))


class Mounter:
    def __init__(self, module):
        self.module = module
        self.params = module.params
        self.path = os.path.normpath(self.params["path"])
        self.uid = resolve_id(module, self.params["owner"], pwd)
        self.gid = resolve_id(module, self.params["group"], grp)
        self.mode = int(self.params["mode"], 8)

    def run(self, command, check=True):
        rc, out, err = self.module.run_command(command)
        if check and rc != 0:
            self.module.fail_json(
                msg="%s failed: %s" % (" ".join(command), (err or out).strip()), rc=rc
            )
        return rc, out, err

    def make_directory(self, path, parents=False):
        if parents:
            os.makedirs(os.path.dirname(path) or "/", exist_ok=True)
        os.mkdir(path, self.mode)
        os.chmod(path, self.mode)
        if self.uid != -1 or self.gid != -1:
            os.chown(path, self.uid, self.gid)

    def mount(self, source, target):
        command = [
            self.module.get_bin_path("mount", required=True),
            "-t",
            self.params["fstype"],
            "-o",
            self.params["opts"],
            source,
            target,
        ]
        for attempt in range(self.params["retries"] + 1):
            rc, out, err = self.run(command, check=False)
            if rc == 0:
                return
            if attempt < self.params["retries"]:
                time.sleep(self.params["delay"])
        self.module.fail_json(
            msg="mounting %s at %s failed: %s" % (source, target, (err or out).strip()), rc=rc
        )

    def unmount(self, target):
        self.run([self.module.get_bin_path("umount", required=True), target])

    def ensure_subdir(self):
        """Create the subdirectory on the share; True when it was missing."""
        temporary = tempfile.mkdtemp(prefix=".nfs-mount-")
        try:
            self.mount(self.params["src"], temporary)
            try:
                target = os.path.join(temporary, self.params["subdir"].strip("/"))
                if os.path.isdir(target):
                    return False
                try:
                    self.make_directory(target)
                except FileExistsError:
                    # Another node created it at the same time.
                    return False
                return True
            finally:
                self.unmount(temporary)
        finally:
            os.rmdir(temporary)

    def is_immutable(self):
        _rc, out, _err = self.run(
            [self.module.get_bin_path("lsattr", required=True), "-d", self.path]
        )
        return "i" in out.split()[0] if out.split() else False

    def set_immutable(self):
        self.run([self.module.get_bin_path("chattr", required=True), "+i", self.path])


def update_fstab(module, path, entry, result):
    """Write the entry for path; return (changed, whether an entry existed before)."""
    name = module.params["fstab"]
    try:
        with open(name) as handle:
            before = handle.readlines()
    except FileNotFoundError:
        before = []
    existed = bool(fstab_entries(before, path))
    after = desired_fstab(before, path, entry)
    if after == before:
        return False, existed
    result["diff"] = {
        "before": "".join(before),
        "after": "".join(after),
        "before_header": name,
        "after_header": name,
    }
    if not module.check_mode:
        directory = os.path.dirname(name) or "."
        handle, temporary = tempfile.mkstemp(dir=directory, prefix=".fstab.")
        with os.fdopen(handle, "w") as stream:
            stream.writelines(after)
        if os.path.exists(name):
            os.chmod(temporary, os.stat(name).st_mode & 0o7777)
        else:
            os.chmod(temporary, 0o644)
        module.atomic_move(temporary, name)
    return True, existed


def main():
    module = AnsibleModule(
        argument_spec={
            "path": {"type": "path", "required": True},
            "src": {"type": "str"},
            "subdir": {"type": "str"},
            "fstype": {"type": "str", "default": "nfs4"},
            "opts": {"type": "str", "default": "defaults"},
            "state": {
                "type": "str",
                "choices": ["mounted", "unmounted", "absent"],
                "default": "mounted",
            },
            "persist": {"type": "bool", "default": True},
            "owner": {"type": "str"},
            "group": {"type": "str"},
            "mode": {"type": "str", "default": "0755"},
            "immutable": {"type": "bool", "default": False},
            "retries": {"type": "int", "default": 1},
            "delay": {"type": "int", "default": 10},
            "fstab": {"type": "path", "default": "/etc/fstab"},
        },
        required_if=[("state", "mounted", ["src"])],
        supports_check_mode=True,
    )
    params = module.params
    mounter = Mounter(module)
    path = mounter.path
    result = {
        "changed": False,
        "mounted": False,
        "subdir_created": False,
        "fstab_changed": False,
        "remount_required": False,
    }
    current = mount_source(path)

    if params["state"] != "mounted":
        if current is not None:
            if not module.check_mode:
                mounter.unmount(path)
            result["changed"] = True
        if params["state"] == "absent":
            result["fstab_changed"] = update_fstab(module, path, None, result)[0]
        result["changed"] = result["changed"] or result["fstab_changed"]
        module.exit_json(**result)

    source = join_source(params["src"], params["subdir"])
    result["source"] = source
    comparable = params["fstype"] not in UNCOMPARABLE_SOURCES
    if current is not None and comparable and normalize(current) != normalize(source):
        module.fail_json(
            msg="%s is mounted from %s, not from %s; unmount it first" % (path, current, source),
            **result,
        )
    if os.path.lexists(path) and not os.path.isdir(path):
        module.fail_json(msg="%s exists and is not a directory" % path, **result)

    if current is None:
        if params["subdir"]:
            if module.check_mode:
                result["subdir_created"] = True
            else:
                result["subdir_created"] = mounter.ensure_subdir()
        missing = not os.path.isdir(path)
        if missing and not module.check_mode:
            mounter.make_directory(path, parents=True)
        if params["immutable"]:
            # A directory that check mode did not create is not immutable yet.
            if (missing and module.check_mode) or not mounter.is_immutable():
                if not module.check_mode:
                    mounter.set_immutable()
        if not module.check_mode:
            mounter.mount(source, path)
        result["changed"] = True

    entry = None
    if params["persist"]:
        entry = "%s %s %s %s 0 0" % (
            source.replace(" ", "\\040"),
            path.replace(" ", "\\040"),
            params["fstype"],
            params["opts"],
        )
    result["fstab_changed"], existed = update_fstab(module, path, entry, result)
    # Only a rewritten entry says the mounted options may differ.
    result["remount_required"] = bool(
        current is not None and result["fstab_changed"] and params["persist"] and existed
    )
    if result["remount_required"]:
        module.warn(
            "the fstab entry of %s changed; the mounted file system keeps its options "
            "until it is mounted again" % path
        )
    result["mounted"] = True
    result["changed"] = result["changed"] or result["fstab_changed"] or result["subdir_created"]
    module.exit_json(**result)


if __name__ == "__main__":
    main()
