#!/usr/bin/env python3
"""Widen the BTV Roblox validation workflow triggers to every Roblox branch.

Why this exists
---------------
`.github/workflows/roblox-validation.yml` enumerated its trigger branches by
hand. Two Roblox pull requests (the Ridgeview journal PR and the runtime
testing pipeline PR) target branches that were not in the `pull_request` list,
so those pull requests received no CI at all. Every new `btv/roblox-*` branch
had the same problem until the list was updated again.

The fix is to trigger on the `btv/roblox-**` glob instead of an enumerated
list, so every current and future Roblox branch is covered.

Why a script
------------
The implementation token used for this work does not carry the `workflow`
scope, so the workflow file itself cannot be pushed from the agent. This
script performs the same edit the agent would have made, and it is shipped
with the branch so the change can be reviewed and applied by someone with
workflow write access:

    python3 roblox/ci/widen-workflow-triggers.py            # apply in place
    python3 roblox/ci/widen-workflow-triggers.py --check    # verify only

The script refuses to touch anything other than the trigger branch lists and
verifies the result before writing.
"""

from __future__ import annotations

import argparse
import difflib
import re
import sys
from pathlib import Path

WORKFLOW_RELATIVE = Path(".github/workflows/roblox-validation.yml")
GLOB = '"btv/roblox-**"'


def find_workflow(start: Path) -> Path:
    candidate = start / WORKFLOW_RELATIVE
    if candidate.is_file():
        return candidate
    for parent in [start, *start.parents]:
        candidate = parent / WORKFLOW_RELATIVE
        if candidate.is_file():
            return candidate
    raise SystemExit(f"error: {WORKFLOW_RELATIVE} not found from {start}")


def widen(text: str) -> str:
    """Replace the enumerated trigger branch lists with the Roblox glob."""
    lines = text.splitlines(keepends=True)
    out: list[str] = []
    index = 0
    replaced = 0
    while index < len(lines):
        line = lines[index]
        if re.match(r"^\s*branches:\s*$", line) and index + 1 < len(lines):
            branch_lines = []
            cursor = index + 1
            while cursor < len(lines) and re.match(r"^\s*-\s+\S", lines[cursor]):
                branch_lines.append(lines[cursor])
                cursor += 1
            if branch_lines and all("btv/roblox-" in entry for entry in branch_lines):
                indent = re.match(r"^(\s*)", branch_lines[0]).group(1)
                out.append(line)
                out.append(f"{indent}- {GLOB}\n")
                index = cursor
                replaced += 1
                continue
        out.append(line)
        index += 1
    if replaced == 0:
        raise SystemExit("error: no enumerated Roblox branch list found; inspect the workflow manually")
    return "".join(out)


def verify(text: str) -> None:
    if GLOB not in text:
        raise SystemExit("error: the glob trigger is missing after the edit")
    if "btv/roblox-foundation-001\n" in text:
        raise SystemExit("error: an enumerated branch list survived the edit")
    for marker in ("push:", "pull_request:", "workflow_dispatch:"):
        if marker not in text:
            raise SystemExit(f"error: {marker} is missing after the edit")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="verify only; do not write")
    parser.add_argument("--path", default=".", help="repository root to search from")
    args = parser.parse_args()

    workflow = find_workflow(Path(args.path).resolve())
    original = workflow.read_text(encoding="utf-8")
    updated = widen(original)
    verify(updated)

    if updated == original:
        print(f"[BTV] workflow triggers are already widened: {workflow}")
        return 0

    diff = difflib.unified_diff(
        original.splitlines(keepends=True),
        updated.splitlines(keepends=True),
        fromfile=f"a/{WORKFLOW_RELATIVE}",
        tofile=f"b/{WORKFLOW_RELATIVE}",
    )
    sys.stdout.writelines(diff)

    if args.check:
        print("[BTV] --check: the workflow still needs the change above.")
        return 1

    workflow.write_text(updated, encoding="utf-8")
    print(f"[BTV] widened workflow triggers in {workflow}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
