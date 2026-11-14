#!/usr/bin/env bash
# Install the Roblox Studio runtime workflow into .github/workflows/.
#
# GitHub refuses workflow-file changes made with a personal access token that
# lacks the "workflow" scope, so an agent cannot self-install this file. A
# maintainer with a normal token (or the GitHub web editor) runs this once.
#
#   bash roblox/ci/install-studio-workflow.sh
#
set -euo pipefail
cd "$(dirname "$0")/../.."

SOURCE="roblox/ci/roblox-studio-validation.yml"
TARGET=".github/workflows/roblox-studio-validation.yml"

if [ ! -f "$SOURCE" ]; then
	echo "error: $SOURCE not found" >&2
	exit 1
fi

mkdir -p "$(dirname "$TARGET")"
cp "$SOURCE" "$TARGET"
echo "Installed $TARGET"
echo
echo "Next:"
echo "  1. git add .github/workflows/roblox-studio-validation.yml"
echo "  2. git commit -m 'ci(roblox): add Roblox Studio runtime validation workflow'"
echo "  3. git push"
echo
echo "The workflow also needs to be enabled once for the branch if the repository"
echo "has workflow restrictions. It runs on every pull request that touches roblox/**."
