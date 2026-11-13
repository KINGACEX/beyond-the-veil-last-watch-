# BTV Prototype — Implementation Status

**Current pre-trailer working baseline:** `btv/chapel-visual-integration-001`  
**Prototype origin:** `btv/bootstrap-prototype-001`  
**Status:** HEADLESS CI PASSED; visual/runtime and Android device validation remain pending.  
**Latest completed full validation:** [43410957023](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/43410957023), commit `9e7d9c3fd84d10aaaff6c1c8b54a50043fa4bfd1`; 15 test scripts and a 10-frame main-scene launch passed on Godot 4.7.2.

## 1. Implemented source

### Bootstrap / interaction foundation
- Godot project configuration and main greybox scene.
- CharacterBody3D capsule placeholder, collision, third-person camera and proximity sensor.
- Keyboard movement actions and E interaction action.
- Reusable BTVInteractable Area3D contract.
- Initial Android touch overlay feeding the same InputMap actions as keyboard.
- Nearest eligible interactable selection, stable authored-ID tie-break, disabled/freed/duplicate-ID exclusion.
- Touch release on button-up, application focus loss and overlay teardown.

### NLI
- Deterministic phrase parser and typed intent validation.
- Authored NPC knowledge records with source provenance and per-NPC scope.
- Unknown-answer, conflict and evidence-marked dialogue handling.
- Request gate and structured orchestration service.
- Service reports validation; it does not claim companion actor acceptance or execution.
- Source records include identity, type, title, location, hash/version field, authority/review status and permitted scopes.
- Unresolved, unapproved and out-of-scope sources are rejected.

## 2. Automated test coverage

The current CI workflow runs:
1. Godot 4.7.2 version check.
2. Headless editor import and project parsing.
3. NLI smoke tests.
4. NLI handoff/source-registry contract tests.
5. Core interaction acceptance tests.
6. Ten-frame main-scene launch.

The interaction test file is `tests/core_interaction_acceptance_test.gd`. The acceptance matrix is `docs/qa/CORE_INTERACTION_003_EDGE_CASE_ACCEPTANCE_MATRIX.md`. The latest regression additions cover temporary disable/re-enable and normalized ID handling.

The automated suite currently covers:
- no-target safe no-op;
- one eligible target invoked once;
- nearest target selection;
- target exit;
- freed target;
- disabled target;
- duplicate authored IDs excluded;
- stable tie-break;
- duplicate enter notification idempotence;
- moving-target selection recalculation;
- non-interactable Area3D exclusion;
- touch press/release through shared actions;
- focus-loss release;
- touch teardown release;
- disabled target can be re-enabled while still in sensor range;
- whitespace-padded interaction IDs are normalized;
- IDs equal after whitespace normalization are rejected as duplicates;
- case-only ID tie uses deterministic secondary lexical ordering.

The acceptance matrix now has 28 cases. Some are covered only partially; the remaining cases are not passed merely because the overall CI workflow passes. Consult the matrix for per-case status.

## 3. NLI lifecycle still incomplete

**Implemented:** validation and source resolution; NLI does not claim actor acceptance.

**Still open:**
- real companion adapter and actor-owned handoff acknowledgement;
- actor-owned accepted/rejected/executing/executed/cancelled/expired/failed transitions;
- expiry/timeout and stale callback handling;
- pause/quit/reload persistence;
- cancellation after execution starts;
- persistent source-registry lifecycle;
- cryptographic hash verification and source-version invalidation.

Do not mark NLI lifecycle complete.

## 4. Deliberate constraints

- No renderer selected; compare options on the actual target Android device.
- Capsule is a placeholder, not Asher's final model.
- Touch overlay source exists, but layout, safe areas, scaling and multitouch remain unverified on a physical device.
- No combat, enemies, Veil rules, Ember behaviour, faith systems, mission content or narrative content has been introduced into the prototype.
- No paid assets, paid services or external runtime dependencies have been added.
- The recovered vertical slice specification remains a design target; the playable vertical slice is not implemented.

## 5. Verification boundary

**CONFIRMED — run 43411504832:** the expanded feature-branch workflow passed on Ubuntu with Godot 4.7.2, including all 16 test scripts, chapel scene loading, HQ blockout structure/collision validation and main-scene startup.

Not verified:
1. Editor visual inspection.
2. Manual movement, camera and interaction feel.
3. Physical touch input and multitouch.
4. Android export and APK installation.
5. Renderer comparison on target device.
6. Frame time, memory, thermal behaviour and sustained stability.
7. Save/load and full vertical-slice behaviour.

A successful headless run is not Android readiness.

## 6. Next engineering gate

1. Complete remaining interaction acceptance cases where a stable test seam exists.
2. Design and test the NLI companion adapter/lifecycle without claiming actor state prematurely.
3. Keep Ridgeview data contracts aligned with the recovered Vertical Slice v1.0.
4. Prototype a neutral Blender-to-Godot test asset only after writing its acceptance contract; do not use Asher or Ember as the test asset.
5. Defer renderer selection and Android export until the target device is identified and tested.

All changes remain on the isolated engineering branch. Do not merge to main, change canon or introduce paid dependencies without explicit approval.
