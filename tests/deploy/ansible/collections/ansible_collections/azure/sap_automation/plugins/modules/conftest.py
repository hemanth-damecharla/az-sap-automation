"""Shared harness for running collection modules in-process."""

import json

import pytest
from ansible.module_utils import basic
from ansible.module_utils.common.text.converters import to_bytes


class ModuleExit(Exception):
    """Raised in place of ``exit_json``/``fail_json`` so tests can inspect results."""

    def __init__(self, result):
        super().__init__(result.get("msg", ""))
        self.result = result


class Commands:
    """Scripted replacement for ``AnsibleModule.run_command``."""

    def __init__(self):
        self.calls = []
        self.responses = []

    def add(self, rc=0, out="", err=""):
        self.responses.append((rc, out, err))
        return self

    def run(self, args, **kwargs):
        self.calls.append((list(args), kwargs))
        if not self.responses:
            raise AssertionError("unexpected command: %s" % args)
        return self.responses.pop(0)

    @property
    def argv(self):
        return [call[0] for call in self.calls]


@pytest.fixture
def run_module(monkeypatch):
    """Return ``run(main, args, check_mode=False)`` plus the command script."""
    commands = Commands()

    def exit_json(_module, **kwargs):
        raise ModuleExit(dict(kwargs, failed=False))

    def fail_json(_module, **kwargs):
        raise ModuleExit(dict(kwargs, failed=True))

    monkeypatch.setattr(basic.AnsibleModule, "exit_json", exit_json)
    monkeypatch.setattr(basic.AnsibleModule, "fail_json", fail_json)
    monkeypatch.setattr(
        basic.AnsibleModule,
        "run_command",
        lambda _module, args, **kwargs: commands.run(args, **kwargs),
    )
    monkeypatch.setattr(
        basic.AnsibleModule,
        "get_bin_path",
        lambda _module, name, required=False, opt_dirs=None: "/usr/sbin/" + name,
    )

    def run(main, args, check_mode=False):
        payload = dict(args, _ansible_check_mode=check_mode)
        monkeypatch.setattr(
            basic, "_ANSIBLE_ARGS", to_bytes(json.dumps({"ANSIBLE_MODULE_ARGS": payload}))
        )
        with pytest.raises(ModuleExit) as caught:
            main()
        return caught.value.result

    run.commands = commands
    return run
