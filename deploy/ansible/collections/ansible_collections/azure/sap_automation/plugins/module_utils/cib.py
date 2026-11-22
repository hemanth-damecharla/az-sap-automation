# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

"""Pure-Python helpers to reconcile Pacemaker CIB sections declaratively.

Nothing in this file talks to a cluster: it parses a desired configuration,
fills in the element ids Pacemaker requires, and merges the result into the
XML of an existing CIB section. Keeping it free of side effects makes the
reconciliation logic unit-testable without a running cluster.
"""

from __future__ import absolute_import, division, print_function

__metaclass__ = type  # pylint: disable=invalid-name

import re
import xml.etree.ElementTree as ET

# Sections in the order they must be applied so that references resolve
# (constraints reference resources, fencing levels reference stonith devices).
SECTIONS = (
    "crm_config",
    "rsc_defaults",
    "op_defaults",
    "resources",
    "constraints",
    "fencing-topology",
    "alerts",
)

# Sections that hold name/value sets shared with other tools and with
# Pacemaker itself (dc-version, cluster-name, have-watchdog, ...). They are
# merged by nvpair name and never replaced wholesale.
MERGE_SECTIONS = ("crm_config", "rsc_defaults", "op_defaults")

DEFAULT_SET = {
    "crm_config": ("cluster_property_set", "cib-bootstrap-options"),
    "rsc_defaults": ("meta_attributes", "rsc-options"),
    "op_defaults": ("meta_attributes", "op-options"),
}

ATTRIBUTE_SETS = ("instance_attributes", "meta_attributes", "utilization", "cluster_property_set")

_ID_INVALID = re.compile(r"[^A-Za-z0-9_.-]")


class CibError(Exception):
    """Raised when the desired configuration cannot be reconciled safely."""


def _clean_id(value):
    cleaned = _ID_INVALID.sub("_", value)
    if not cleaned or not (cleaned[0].isalpha() or cleaned[0] == "_"):
        cleaned = "_" + cleaned
    return cleaned


def _strip_whitespace(element):
    """Drop the indentation that templates leave between elements."""
    for node in element.iter():
        if node.text is not None and not node.text.strip():
            node.text = None
        if node.tail is not None and not node.tail.strip():
            node.tail = None


def parse_desired(xml_text):
    """Return ``{section_name: Element}`` for a desired configuration.

    Accepts either a ``<configuration>`` document or a bare sequence of
    section elements such as ``<resources>...</resources><constraints>...``.
    """
    try:
        wrapper = ET.fromstring("<_wrapper>%s</_wrapper>" % xml_text)
    except ET.ParseError as exc:
        raise CibError("xml is not well-formed: %s" % exc) from exc

    _strip_whitespace(wrapper)
    children = list(wrapper)
    if len(children) == 1 and children[0].tag == "configuration":
        children = list(children[0])
    if not children:
        raise CibError("xml contains no CIB sections")

    sections = {}
    for child in children:
        if child.tag not in SECTIONS:
            raise CibError(
                "unsupported top-level element <%s>; expected one of: %s"
                % (child.tag, ", ".join(SECTIONS))
            )
        if child.tag in sections:
            raise CibError("section <%s> is given more than once" % child.tag)
        sections[child.tag] = child
    return sections


def assign_ids(element, parent_id, section):
    """Fill in missing ``id`` attributes below ``element``, in place.

    Pacemaker requires an id on nearly every element. Deriving them here keeps
    role templates readable and makes the generated ids stable between runs,
    which is what allows an unchanged template to compare equal.
    """
    expression_count = 0
    for child in element:
        tag = child.tag
        if tag == "nvpair":
            child.attrib.setdefault("id", _clean_id("%s-%s" % (parent_id, child.get("name", ""))))
        elif tag in ATTRIBUTE_SETS:
            child.attrib.setdefault("id", _clean_id("%s-%s" % (parent_id, tag)))
        elif tag == "op":
            child.attrib.setdefault("interval", "0")
            op_id = "%s-%s-%s" % (parent_id, child.get("name", ""), child.get("interval"))
            if child.get("role"):
                op_id = "%s-%s" % (op_id, child.get("role"))
            child.attrib.setdefault("id", _clean_id(op_id))
        elif tag == "rule":
            child.attrib.setdefault("id", _clean_id("%s-rule" % parent_id))
        elif tag in ("expression", "date_expression", "rsc_expression", "op_expression"):
            expression_count += 1
            child.attrib.setdefault("id", _clean_id("%s-expr-%d" % (parent_id, expression_count)))
        elif tag == "fencing-level":
            child.attrib.setdefault(
                "id",
                _clean_id(
                    "fl-%s-%s"
                    % (
                        child.get("target") or child.get("target-pattern", ""),
                        child.get("index", ""),
                    )
                ),
            )
        elif "id" not in child.attrib and tag not in ("operations", "resource_set"):
            if section in ("resources", "constraints"):
                raise CibError("<%s> under <%s> requires an explicit id" % (tag, section))
        assign_ids(child, child.get("id", parent_id), section)


def normalize(element):
    """Return a hashable, order-insensitive-where-safe form of ``element``.

    nvpairs inside attribute sets are compared by name regardless of order;
    every other child keeps its position because order is meaningful for
    group members, resource sets and rule expressions.
    """
    children = [normalize(child) for child in element]
    if element.tag in ATTRIBUTE_SETS:
        children.sort()
    return (element.tag, tuple(sorted(element.attrib.items())), tuple(children))


def _ids(element):
    return {node.get("id") for node in element.iter() if node.get("id")}


def _find_top(section, element_id):
    for index, child in enumerate(section):
        if child.get("id") == element_id:
            return index, child
    return None, None


def _reconcile_replace(current, desired, state, replace=True):
    changed = False
    for want in desired:
        want_id = want.get("id")
        if not want_id:
            raise CibError("<%s> under <%s> requires an explicit id" % (want.tag, desired.tag))
        index, have = _find_top(current, want_id)
        if state == "absent":
            if have is not None:
                current.remove(have)
                changed = True
            continue
        if have is None:
            others = set()
            for child in current:
                others |= _ids(child)
            clash = sorted(_ids(want) & others)
            if clash:
                raise CibError(
                    "ids %s already exist in <%s> under a different parent; "
                    "remove them first (state=absent) or rename" % (", ".join(clash), desired.tag)
                )
            current.append(want)
            changed = True
        elif replace and normalize(have) != normalize(want):
            current.remove(have)
            current.insert(index, want)
            changed = True
    return changed


def _target_set(current, want, section_name):
    set_tag, default_id = DEFAULT_SET[section_name]
    if want.tag != set_tag:
        raise CibError("<%s> only accepts <%s> children" % (section_name, set_tag))
    if want.get("id"):
        _unused, have = _find_top(current, want.get("id"))
    else:
        have = current.find(set_tag)
    return have, want.get("id") or default_id


def _reconcile_merge(current, desired, state, section_name, replace=True):
    changed = False
    for want in desired:
        have, set_id = _target_set(current, want, section_name)
        if have is None:
            if state == "absent":
                continue
            have = ET.SubElement(current, want.tag, {"id": set_id})
            changed = True
        existing = {pair.get("name"): pair for pair in have.findall("nvpair")}
        for pair in want.findall("nvpair"):
            name = pair.get("name")
            found = existing.get(name)
            if state == "absent":
                if found is not None:
                    have.remove(found)
                    changed = True
            elif found is None:
                ET.SubElement(
                    have,
                    "nvpair",
                    {
                        "id": _clean_id("%s-%s" % (have.get("id"), name)),
                        "name": name,
                        "value": pair.get("value", ""),
                    },
                )
                changed = True
            elif replace and found.get("value") != pair.get("value", ""):
                found.set("value", pair.get("value", ""))
                changed = True
    return changed


def reconcile(current_xml, desired, state="present", replace=True):
    """Merge a desired section into the current one.

    ``current_xml`` is the XML text of the live section, or ``None`` when the
    section does not exist yet. With ``replace`` false, elements and
    properties that already exist are kept as they are and only missing ones
    are added. Returns ``(new_xml_text, changed)``.
    """
    name = desired.tag
    if current_xml:
        try:
            current = ET.fromstring(current_xml)
        except ET.ParseError as exc:
            raise CibError("cannot parse current <%s> section: %s" % (name, exc)) from exc
        if current.tag != name:
            raise CibError("expected <%s> from the cluster, got <%s>" % (name, current.tag))
    else:
        current = ET.Element(name)

    if name in MERGE_SECTIONS:
        changed = _reconcile_merge(current, desired, state, name, replace)
    else:
        if state == "present":
            assign_ids(desired, name, name)
        changed = _reconcile_replace(current, desired, state, replace)
    return ET.tostring(current, encoding="unicode"), changed


# Replacement shown instead of a secret, the marker Ansible itself uses.
REDACTED = "********"


def is_sensitive(name):
    """True for an nvpair that carries a secret, such as a fence agent password."""
    name = (name or "").lower()
    return name in ("passwd", "password") or "secret" in name


def redact(xml_text):
    """Return the XML with the value of every sensitive nvpair masked.

    Used only for what a module reports. Text that is not well-formed XML is
    returned unchanged; it carries no parsed nvpair to mask.
    """
    if not xml_text:
        return xml_text
    try:
        root = ET.fromstring(xml_text)
    except ET.ParseError:
        return xml_text
    masked = False
    for pair in root.iter("nvpair"):
        if is_sensitive(pair.get("name")) and pair.get("value"):
            pair.set("value", REDACTED)
            masked = True
    return ET.tostring(root, encoding="unicode") if masked else xml_text
