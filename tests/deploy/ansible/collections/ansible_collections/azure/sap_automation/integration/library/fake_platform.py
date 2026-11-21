#!/usr/bin/python
"""Test-only module: report the operating system facts of a cluster node."""

from ansible.module_utils.basic import AnsibleModule


def main():
    module = AnsibleModule(
        argument_spec={
            "os_family": {"type": "str", "required": True},
            "distribution": {"type": "str", "required": True},
            "version": {"type": "str", "required": True},
        },
        supports_check_mode=True,
    )
    version = module.params["version"]
    module.exit_json(
        changed=False,
        ansible_facts={
            "os_family": module.params["os_family"],
            "distribution": module.params["distribution"],
            "distribution_version": version,
            "distribution_major_version": version.split(".")[0],
        },
    )


if __name__ == "__main__":
    main()
