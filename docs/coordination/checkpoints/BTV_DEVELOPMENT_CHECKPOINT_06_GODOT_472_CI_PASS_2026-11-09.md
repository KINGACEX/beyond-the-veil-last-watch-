# BTV Development Checkpoint 06 — Godot 4.7.2 CI Pass

**Date:** 2026-11-09  
**Status:** GODOT 4.7.2 HEADLESS CI PASSED — INDEPENDENT REVIEW AND DEVICE QA PENDING  
**PR:** #6 (open, draft, unmerged)  
**PR head branch:** `btv/xh-003-input-source-composition-spec-001`  
**Verified PR head SHA:** `226bcf6ac8610d800fe6f8e921112f60d49a7958`  
**GitHub Actions run:** [#42649951014](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42649951014)

## CI restoration

The existing `BTV Godot Validation` workflow was present but its push branch filter did not include the XH-003 branch. The workflow was updated on the XH-003 branch to include that branch and run the full test inventory. Its permission remains `contents: read`; no token scopes, credentials, repository permissions, or secrets were changed.

Workflow update commit: `9448f905e880e932bcbdddae22ac70577daadfc5`.

## Verified execution

GitHub Actions run #42649951014 completed with conclusion **success** for the current PR head SHA above.

- Godot version: `4.7.2.stable.official.ed1daf0bf`
- Ubuntu cloud runner installed the Godot 4.7.2 stable Linux executable.
- Editor import and script parsing: success.
- All 14 test suites: success.
- Main scene headless launch for 10 frames: success.
- Job conclusion: success.

The 14 suites were:
1. NLI smoke
2. NLI contract
3. Mission data validator
4. Core interaction acceptance
5. Player camera input
6. Touch input adapter
7. Touch controls integration
8. Touch controls coexistence
9. Touch controls composition
10. Touch controls input path
11. Touch controls lifecycle
12. Touch controls reconciliation
13. Touch controls resize
14. Touch input source composition

## Additional defect caught during post-pass review

Reviewing the successful first CI logs and test source exposed stale assertions in `tests/core_interaction_acceptance_test.gd`: its touch acceptance cases manually wrote to keyboard-facing `interact` and `move_forward` actions, even though XH-003 migrated touch controls to a dedicated `touch_*` namespace.

Those assertions were corrected to use `touch_interact` and `touch_move_forward`, including teardown cleanup. The updated commit `226bcf6ac8610d800fe6f8e921112f60d49a7958` triggered a fresh CI run. Run #42649951014 then passed all 14 suites and the main-scene launch on that corrected commit.

An earlier superseded run (#42649919332) was cancelled when the subsequent commit arrived; it is not counted as a failure of the final verified head.

## Non-blocking warning

The runner reported that `actions/checkout@v4` uses a Node.js 20 runtime that GitHub is deprecating. It was a warning only; the job and all test steps passed. Do not change action versions without checking compatibility and making a separate reviewed update.

## Remaining gates

- Independent review of all 11 changed files and XH-003 semantics.
- Reconcile the public GitHub branch with MiniMax's private workspace before any transfer; preserve divergent or uncommitted changes.
- Physical Android QA for real multitouch, focus/pause behaviour, safe areas, touch ergonomics, performance, and export readiness.
- Keep PR #6 in draft and unmerged until these gates are completed.

## Governance

No merge, release, Android export, signing, package identifier, secret change, permission expansion, destructive operation, or private MiniMax workspace modification occurred.
