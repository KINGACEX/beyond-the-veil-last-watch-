#!/usr/bin/env bash
# Adds the original GLB to branch btv/chapel-visual-integration-001.
# Usage (from a local clone): bash tools/transfer_chapel_glb.sh /path/to/downloaded.glb [--push]
# Uses YOUR git credentials; nothing is embedded here.
set -euo pipefail
GLB="$1"; PUSH="${2:-}"
BR=btv/chapel-visual-integration-001
D=assets/environment/chapel/logos_rhema_chapel_interior_study_001
echo "fd1014f2ed1c6d65d74cc632af113ebc811dff6f699c47684cf0fa03493b67be  $GLB" | sha256sum -c -
git fetch origin
git checkout "$BR" 2>/dev/null || git checkout -b "$BR" "origin/$BR"
git pull --ff-only origin "$BR"
mkdir -p "$D"
cp -n "$GLB" "$D/logos_rhema_chapel_interior_study_001.glb"
git add "$D/logos_rhema_chapel_interior_study_001.glb"
git commit -m "Add original Logos Rhema chapel interior study 001 GLB (unmodified)"
godot --headless --editor --path . --quit
godot --headless --path . --script res://tests/chapel_study_001_load_test.gd
[ "$PUSH" = "--push" ] && git push origin "$BR" || echo "Not pushed. Re-run with --push after reviewing the Godot output."
