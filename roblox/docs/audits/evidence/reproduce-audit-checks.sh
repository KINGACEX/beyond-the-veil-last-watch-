#!/usr/bin/env bash
# Reproduce the tool-verified parts of the BTV Roblox independent technical audit.
# READ-ONLY: this script inspects the working tree and never writes to it.
#
# Requires the pinned toolchain from roblox/rokit.toml:
#   rojo 7.7.0 · selene 0.31.0 · stylua 2.5.2 · lune 0.10.5
#
# Usage:  bash roblox/docs/audits/evidence/reproduce-audit-checks.sh
set -u
cd "$(dirname "$0")/../../.." || exit 1

echo "=== 1. Headless regression suite (lune 0.10.5) ==="
lune run tests/foundation.spec.luau && echo "PASS" || echo "FAIL"

echo
echo "=== 2. Format check on the six files the CI workflow gates ==="
stylua --check \
  src/server/Services/MissionService.luau \
  src/server/Services/CompanionActorService.luau \
  src/server/Bootstrap.server.luau \
  src/server/World/OpeningMission.server.luau \
  src/client/Controllers/MobileHUDController.luau \
  tests/foundation.spec.luau \
  && echo "PASS — the gated files are formatted" \
  || echo "FAIL"

echo
echo "=== 3. Format check across every source file (the wider gate) ==="
echo "--- files that would fail if the CI gate were widened to 'src tests' ---"
stylua --check src tests 2>&1 | grep '^Diff in' || echo "(none)"

echo
echo "=== 4. Lint across every source file (CI already covers this) ==="
selene src tests && echo "PASS — 0 errors, 0 warnings" || echo "FAIL"

echo
echo "Note: geometry counts, Studio behaviour, multiplayer and Android performance are"
echo "NOT reproducible here. They are marked BLOCKED in the audit and require Roblox Studio."
