# BTV Development Checkpoint 07 — XH-003 Engineering Review

**Date:** 2026-11-09  
**PR:** [#6 — XH-003 independent input-source composition](https://github.com/KINGACEX/beyond-the-veil-last-watch-/pull/6)  
**PR state:** OPEN · DRAFT · UNMERGED  
**Current PR head:** `ba6b32b937d274acfcc8565284ed9dfa20e9bdcd`  
**Verified CI:** [Run #42651172481](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42651172481) — SUCCESS

## Review result

**Internal engineering review: 28/30** for the isolated implementation and headless verification scope.

This is not a release-readiness score or an external peer review. Two points are withheld because:
1. Physical Android QA has not been performed.
2. A final local clean-working-tree audit and external peer review remain outstanding. A read-only scan of the current GitHub commit tree found no tracked `.godot/`, `.import/`, or `.uid` generated artifacts; this does not reveal local untracked files.

## Review matrix

| Area | Result | Evidence |
|---|---:|---|
| Input namespace separation | 5/5 | Dedicated touch-only actions; no physical events; touch writers migrated |
| Movement composition | 5/5 | Separate keyboard/touch vectors; combined magnitude capped at 1.0; player uses the composed vector |
| Interact edge semantics | 5/5 | Combined latch; staggered source join, simultaneous press, held state, and release/re-arm tests |
| Lifecycle and coexistence | 5/5 | Touch release, focus loss, Android pause, teardown, keyboard preservation, and player re-resolution tests |
| Automated tests and CI | 4/5 | All 14 suites and main-scene launch pass on Godot 4.7.2; physical Android QA and clean-tree audit remain |
| Scope, documentation, and review governance | 4/5 | Isolated draft PR, least-privilege workflow, checkpoints, and accurate verification notes; external peer review remains |

**Total: 28/30.**

## Confirmed technical results

- Touchscreen controls use `touch_move_forward`, `touch_move_back`, `touch_move_left`, `touch_move_right`, and `touch_interact`.
- The player reads keyboard and touch movement independently, combines the vectors, and caps the final length at 1.0.
- Interact is treated as one logical control. A second input source joining an already-held press does not produce a second edge. The latch re-arms after both sources are released.
- Touch cleanup only releases actions owned by the touch overlay.
- The Android pause notification and focus-loss path clear touch state.
- The lifecycle tests verify the touch HUD can resolve a player created later and follow a replacement player for camera look.
- The CI workflow installs Godot 4.7.2, imports the project, runs 14 suites, and launches the main scene for 10 frames.
- Latest successful code validation is run #42653466596 on implementation commit `2ab0b87fcf4791905d2c338fdc459547fd6bc6ec`. Subsequent documentation-only commits updated verification references and added `docs/engineering/BTV_GODOT_CI_RUNBOOK.md`; the current PR head is `96cb5f87aa1a102f12779820b5157fb9fa44fbfb`. No source, test, or workflow files changed after the tested implementation. No separate run has been recorded for the documentation-only head.

## Remaining gates

1. Reconcile the GitHub branch against MiniMax's private workspace using `git rev-parse HEAD`, `git status --short --branch`, and `git remote -v`. Do not reset, clean, overwrite, or cherry-pick before reviewing differences and uncommitted work.
2. Perform physical Android QA: simultaneous multitouch, button interaction, orientation, safe areas, pause/resume, touch ergonomics, performance, and export readiness.
3. Obtain an external peer review and inspect the final working-tree state after tests.
4. Keep PR #6 in draft and unmerged until these gates are satisfied.

## Governance

No merge, release, Android export, signing, package identifier, secret change, permission expansion, destructive operation, or MiniMax private-workspace modification occurred.
