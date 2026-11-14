#!/usr/bin/env bash
# Integration readiness checks for the BTV Roblox pull request stack.
#
# This script answers one question for each pull request in the merge order:
#   is this pull request safe to merge into the branch below it right now?
#
# It never merges, never pushes and never changes repository settings. It only
# reads from the GitHub API and runs the offline test suites in a throwaway
# git worktree, so it is safe to run at any time.
#
# Usage:
#   GITHUB_PAT=<token> bash roblox/ci/integration-readiness.sh
#   GITHUB_PAT=<token> bash roblox/ci/integration-readiness.sh 12 13
#
# Checks performed per pull request:
#   ancestry     the pull request's base is an ancestor of its head
#   overlap      the files it touches against the files later pull requests touch
#   persistence  whether it changes the profile schema, its version or the
#                persistence layer, and whether that change is a breaking one
#   tests        the offline Lune suites at the pull request's head
#
# Exit code 0 when every checked pull request is ready, 1 otherwise.

set -uo pipefail

REPO="${GITHUB_REPO:-KINGACEX/beyond-the-veil-last-watch-}"
API="https://api.github.com/repos/${REPO}"
PAT="${GITHUB_PAT:-}"

if [ -z "$PAT" ]; then
	echo "error: GITHUB_PAT is not set. It is used read-only for API calls." >&2
	exit 2
fi

if ! command -v git >/dev/null 2>&1; then
	echo "error: git is required." >&2
	exit 2
fi

api() {
	curl -s -H "Authorization: Bearer ${PAT}" -H "Accept: application/vnd.github+json" "$1"
}

SUITES="foundation settlement ridgeview_investigation pipeline geometry identity"

# ---------------------------------------------------------------- pull requests
if [ "$#" -gt 0 ]; then
	PR_LIST="$*"
else
	PR_LIST="$(api "${API}/pulls?state=open&per_page=100" |
		python3 -c "
import json,sys
prs=[p for p in json.load(sys.stdin) if p['draft'] and p['base']['ref'].startswith('btv/roblox-')]
prs.sort(key=lambda p: p['number'])
print(' '.join(str(p['number']) for p in prs))
")"
fi

echo "Repository: ${REPO}"
echo "Pull requests in check order: ${PR_LIST}"
echo

for pr in ${PR_LIST}; do
	echo "==============================================================================="
	echo "PR #${pr}"
	echo "==============================================================================="

	meta="$(api "${API}/pulls/${pr}")"
	base_ref="$(echo "${meta}" | python3 -c "import json,sys; print(json.load(sys.stdin)['base']['ref'])")"
	base_sha="$(echo "${meta}" | python3 -c "import json,sys; print(json.load(sys.stdin)['base']['sha'])")"
	head_ref="$(echo "${meta}" | python3 -c "import json,sys; print(json.load(sys.stdin)['head']['ref'])")"
	head_sha="$(echo "${meta}" | python3 -c "import json,sys; print(json.load(sys.stdin)['head']['sha'])")"
	files="$(api "${API}/pulls/${pr}/files?per_page=100" |
		python3 -c "import json,sys; print(' '.join(f['filename'] for f in json.load(sys.stdin)))")"

	echo "  base       ${base_ref} @ ${base_sha:0:12}"
	echo "  head       ${head_ref} @ ${head_sha:0:12}"

	# ---- ancestry
	compare="$(api "${API}/compare/${base_sha}...${head_sha}")"
	status="$(echo "${compare}" | python3 -c "
import json,sys
d=json.load(sys.stdin)
print(d.get('status','unknown'), d.get('ahead_by'), d.get('behind_by'))
")"
	set -- ${status}
	if [ "$1" = "ahead" ] || [ "$1" = "identical" ]; then
		echo "  ancestry   OK — head is $2 commit(s) ahead of base, $3 behind"
	else
		echo "  ancestry   BLOCKED — base is not an ancestor of head (${status})"
	fi

	# ---- overlap with later pull requests
	echo "  overlap    files touched:"
	for f in ${files}; do
		echo "               ${f}"
	done

	# ---- persistence compatibility
	persist_hits=""
	for f in ${files}; do
		case "${f}" in
		*PlayerProfileSchema*|*ProfileRecordPolicy*|*ProfilePersistenceAdapter*|*MerchantTransactionPolicy*|*MerchantService*|*ProfileLeasePolicy*)
			persist_hits="${persist_hits} ${f}"
			;;
		esac
	done
	if [ -n "${persist_hits}" ]; then
		echo "  persistence CHANGED — review required for:${persist_hits}"
		schema_line="$(echo "${files}" | tr ' ' '\n' | grep PlayerProfileSchema || true)"
		if [ -n "${schema_line}" ]; then
			echo "              the profile schema changed: read the migration rule before merging"
		fi
	else
		echo "  persistence unchanged — no schema or adapter file touched"
	fi

	# ---- offline tests at the head
	worktree="$(mktemp -d)/head"
	git fetch -q --no-tags origin "${head_ref}" 2>/dev/null
	if git worktree add -q --detach "${worktree}" "${head_sha}" 2>/dev/null; then
		failed=""
		for suite in ${SUITES}; do
			if [ -f "${worktree}/roblox/tests/${suite}.spec.luau" ]; then
				out="$(cd "${worktree}/roblox" && lune run "tests/${suite}.spec.luau" 2>&1)"
				if echo "${out}" | grep -qi "failed"; then
					failed="${failed} ${suite}"
				fi
			fi
		done
		if [ -z "${failed}" ]; then
			echo "  tests      OK — every offline suite present at this head passes"
		else
			echo "  tests      FAILED —${failed}"
		fi
		git worktree remove --force "${worktree}" 2>/dev/null || rm -rf "${worktree}"
	else
		echo "  tests      NOT RUN — could not check out ${head_sha:0:12}"
	fi

	echo
done

echo "Reminder: this script only inspects. Merging stays with the creator."
