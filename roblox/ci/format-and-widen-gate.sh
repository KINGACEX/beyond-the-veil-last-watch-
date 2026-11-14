#!/usr/bin/env bash
# One-command remedy for the CI format-gate problem.
#
# Problem: .github/workflows/roblox-validation.yml checks StyLua against an explicit
# list of files. New files are added to that list; files that were already failing
# are never fixed. On 2026-11-14, 20 of 43 Luau files failed `stylua --check` while
# CI stayed green, because none of those 20 was in the list.
#
# Root cause: the gate is an allowlist instead of a directory.
#
# This script:
#   1. formats the whole tree with the pinned StyLua (no behaviour change);
#   2. replaces the per-file `stylua --check` lines with a single
#      `stylua --check src tests`;
#   3. shows the diff so it can be reviewed before committing.
#
# Run it AFTER the integration stack has landed, so the formatting pass does not
# collide with branches that are still being edited.
#
#   bash roblox/ci/format-and-widen-gate.sh
#
set -euo pipefail
cd "$(dirname "$0")/../.."

if ! command -v stylua >/dev/null 2>&1; then
	echo "error: stylua is not on PATH. Install the pinned 2.5.2 from roblox/rokit.toml." >&2
	exit 1
fi

WORKFLOW=".github/workflows/roblox-validation.yml"
if [ ! -f "$WORKFLOW" ]; then
	echo "error: $WORKFLOW not found" >&2
	exit 1
fi

echo "==> Formatting the tree with stylua $(stylua --version)"
(cd roblox && stylua src tests)

echo "==> Widening the format gate to the whole tree"
python3 - "$WORKFLOW" <<'PY'
import re
import sys

path = sys.argv[1]
with open(path, "r", encoding="utf-8") as handle:
    text = handle.read()

lines = text.split("\n")
out = []
replaced = 0
for line in lines:
    if "stylua --check" in line:
        indent = line[: len(line) - len(line.lstrip())]
        out.append(f"{indent}stylua --check src tests")
        replaced += 1
        continue
    if "stylua src/server" in line or "stylua src/shared" in line or "stylua src/client" in line or "stylua tests/" in line:
        out.append(f"{line[: len(line) - len(line.lstrip())]}# stylua src tests")
        replaced += 1
        continue
    out.append(line)

with open(path, "w", encoding="utf-8") as handle:
    handle.write("\n".join(out))
print(f"  rewrote {replaced} stylua step(s) in {path}")
PY

echo
echo "==> Review the changes before committing:"
echo "    git diff --stat"
echo "    git diff $WORKFLOW"
echo
echo "Then:"
echo "    git add roblox $WORKFLOW"
echo "    git commit -m 'style(roblox): format the whole tree and widen the format gate'"
