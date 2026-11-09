# BTV Development Checkpoint 03 — XH-003 Specification — 2026-11-09

**Status:** COMPLETED — ISOLATED ENGINEERING SPECIFICATION VERIFIED; IMPLEMENTATION NOT STARTED  
**Evidence branch:** `btv/agent-minimax-xh-002-evidence`  
**Implementation-spec branch:** `btv/xh-003-input-source-composition-spec-001`  
**XH-002 base SHA:** `34c5af7089efa83a151fbaa79e44a070d1bf21c5`  
**Spec commit SHA:** `96407a42b46eb8fe16b558f1549c888c49833206`

## 1. Current repository state rechecked

- PR #4 remains open and draft; it has not been merged.
- PR #4 head remains XH-002 commit `34c5af7089efa83a151fbaa79e44a070d1bf21c5`.
- XH-002 implementation files confirm touch controls still write into the same `move_*` / `interact` actions used by keyboard input.
- Player movement still reads one shared keyboard-facing InputMap vector.
- XH-002's ownership-strength heuristic does not provide additive composition for simultaneous independent sources.
- The earlier evidence discrepancy is now explained: PR #4 describes the earlier 12-suite state, while a later evidence commit adds a reconciliation suite and reports 13 suites / 251 assertions. This assistant has not run those tests; GitHub Actions still has no run evidence in the checked status.

## 2. New work completed

Created an isolated branch from the exact XH-002 SHA, without changing the XH-002 branch or MiniMax's private workspace:

`btv/xh-003-input-source-composition-spec-001`

Added:
`docs/engineering/BTV_XH-003_INPUT_SOURCE_COMPOSITION_SPEC_2026-11-09.md`

The specification defines:
- a dedicated `touch_move_*` and `touch_interact` action namespace;
- a single composition method that sums keyboard and touchscreen vectors and caps magnitude at 1.0;
- preservation of one-shot Interact semantics;
- explicit regression tests for both input-release orders, simultaneous sources, pause/focus cleanup, teardown, and player lifecycle;
- the Godot 4.7.2 parse, test-suite, main-scene, and clean-working-tree verification protocol;
- strict boundaries against unrelated HUD, camera, gamepad, export, workflow, credentials, canon, and release changes.

The branch comparison confirms exactly one commit ahead of XH-002, with one added specification file (113 lines; no source-code changes).

## 3. Source reconciliation gate — still open

The GitHub proposal branch is a fresh isolated branch based on a known public commit. It is not proof that the private MiniMax `/workspace/btv` is at the same commit or clean. Before implementing or transferring code into that workspace, capture:

```bash
git rev-parse HEAD
git status --short --branch
git remote -v
```

Inspect any uncommitted changes and compare the reported HEAD and remote against the XH-002 base above. Do not reset, clean, overwrite, or cherry-pick until divergence is understood. If the private workspace cannot be inspected, keep all implementation isolated to a fresh checkout and do not claim it reconciles with that private workspace.

## 4. Verification and limits

- **CONFIRMED:** specification file exists on the isolated branch and was fetched back successfully.
- **CONFIRMED:** branch comparison is one commit ahead of XH-002, one file added, no deletions.
- **CONFIRMED:** PR #4 is still draft and unmerged.
- **NOT RUN:** Godot import, test suites, main-scene launch, Android export, physical-device tests.
- **NOT DONE:** XH-003 source implementation, independent code review, PR creation, merge, release.
- No credentials, token permissions, CI workflows, export settings, package identifiers, or signing configuration were changed.

## 5. Next checkpoint

Checkpoint 04 is implementation and test execution, but only after the source identity gate is satisfied. Required outputs: exact base SHA, clean/dirty status, bounded source diff, complete Godot 4.7.2 logs and exit codes, test inventory, main-scene result, and independent review. Keep any resulting PR draft pending creator review.
