# BTV Development Checkpoint 01 — 2026-11-09

Status: CHECKPOINT RECORDED — READ-ONLY AUDIT
Scope: GitHub branch topology, XH-002 input implementation, test evidence, Android readiness, and blockers.
No game source was changed. No branch was merged. No release, CI workflow, credential, permission, or signing change was made.

## 1. Repository topology

Confirmed branches include:
- `btv/bootstrap-prototype-001`
- `btv/mobile-touch-input-adapter-001`
- `btv/agent-minimax-xh-002`
- `btv/agent-minimax-xh-002-evidence`
- `btv/camera-relative-mouselook-001`
- `btv/nli-lifecycle-guard-001`
- `btv/test-first-contracts-001`
- `btv/multi-agent-system-v1`
- `btv/project-history-and-lore-bridge-001`
- `btv/mission-validator-strict-types-001`
- `btv/kay-family-character-bible-001`
- `btv/claude-review-temp-001` (branch listed; expected project.godot fetch returned 404)

The bootstrap and mobile-touch adapter branches return the same project.godot blob SHA:
`25df7548a03efebcb2a3256835315a9a63f49616`.

The XH-002 implementation branch returns project.godot SHA:
`bb6da4bd58aadcc8d70d5f927305663e066fa57c`.

Therefore these branches are not interchangeable. The evidence branch's project.godot matches the bootstrap baseline, not the XH-002 implementation file. The canonical local workspace at MiniMax's `/workspace/btv` was not accessible for comparison during this checkpoint.

## 2. Confirmed XH-003 defect

Inspected on `btv/agent-minimax-xh-002`:
- `project.godot` — SHA `bb6da4bd58aadcc8d70d5f927305663e066fa57c`
- `scripts/touch_controls.gd` — SHA `b72a88e6bc4ba5cb6da0c804f3c2632daec1a321`
- `scripts/player_controller.gd` — SHA `895019395d502899448d967cc15b64ec29451800`
- `tests/touch_controls_composition_test.gd` — SHA `68e5fa299c5d068aaa38bd03881f58908cdcee8c`

The touch overlay writes into the same InputMap actions used by keyboard controls. The player reads only those shared actions. The ownership/strength heuristic cannot reliably distinguish independent input sources. The current composition suite checks analog action strength and diagonal clamping, but does not establish correct keyboard-plus-touch coexistence in both release orders.

Approved implementation direction remains Option A:
1. Preserve keyboard `move_*` actions.
2. Add independent `touch_move_*` actions and `touch_interact`.
3. Compose keyboard and touch vectors once in the player controller and clamp to unit length.
4. Accept keyboard Interact or touch Interact.
5. Remove the shared-action ownership heuristic after all touch controls migrate.
6. Test both release orders, both sources released, simultaneous Interact sources, pause/focus cleanup, and respawn.

## 3. Evidence gaps and inconsistencies

- PR #4 describes 12/12 passing headless suites.
- PR #5 evidence-pack description reports 13/13 suites.
- These claims are not reconciled here; the underlying run logs have not been independently executed or inspected in this environment.
- The reported 10-frame main-scene launch is agent-reported, not independently reproduced.
- No verified physical Android device test, emulator test, Android export, package identifier, export preset, or signing configuration.
- PR #4 explicitly defers safe-area insets and resolution-dependent look sensitivity.
- CI workflow updates remain blocked by the current token permission boundary. Do not widen permissions as part of this task.

## 4. Execution environment limitation

This assistant environment has no checked-out BTV working tree, no accessible MiniMax private `/workspace/btv`, and no Godot executable detected. GitHub source inspection is available, but this is not a substitute for running Godot 4.7.2 tests against the reconciled working tree.

## 5. Required gates before source implementation

- Obtain a verifiable source identity for MiniMax's working tree (commit SHA and clean/dirty status) and compare it with the GitHub XH-002 branch.
- Resolve whether the GitHub XH-002 branch or another branch is the agreed implementation base.
- Preserve unrelated local work; do not overwrite or reset the MiniMax workspace.
- Implement XH-003 only on a new isolated branch from the agreed base.
- Run the complete headless suite on Godot 4.7.2 and retain raw output; reconcile the 12/12 versus 13/13 count.
- Run a headless main-scene smoke test.
- Obtain a separate review score of at least 27/30 before requesting creator review.
- Keep any resulting PR in draft. No merge or release is authorized by this checkpoint.

## 6. Next checkpoint

Checkpoint 02: source reconciliation and XH-003 implementation readiness.
Expected evidence: source commit identity, clean/dirty state, branch/base decision, exact patch, test output, and independent review score.

---
This checkpoint records inspected facts and explicit unknowns. It does not claim that XH-003 has been implemented or tested.
