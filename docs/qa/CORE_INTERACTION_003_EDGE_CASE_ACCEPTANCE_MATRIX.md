# CORE INTERACTION 003 — Edge-Case Acceptance Matrix
**Status:** PROPOSED QA SPECIFICATION — NOT IMPLEMENTED OR EXECUTED  
**Scope:** Player controller, proximity sensor, interactable contract and touch-input lifecycle.

## 1. Invariants
- Only active, eligible interactables can be selected.
- One intentional press produces at most one interaction attempt.
- Nearest-target selection is deterministic, including ties.
- Leaving range, disabling/freeing a target or changing scenes clears stale selection.
- Keyboard and touch invoke the same gameplay action.
- UI focus/pause policy blocks unintended gameplay input.
- Failure is not presented as success; invalid targets cannot crash or softlock.

## 2. Acceptance matrix
| ID | Scenario | Expected | Priority |
|---|---|---|---|
| INT-001 | No target in range | No call; no error | P0 |
| INT-002 | One target enters | Becomes eligible | P0 |
| INT-003 | Target exits | Eligibility and stale selection cleared | P0 |
| INT-004 | Multiple targets | Nearest selected | P0 |
| INT-005 | Equal distance | Stable tie-break by authored ID | P1 |
| INT-006 | Target freed before press | Safe no-op | P0 |
| INT-007 | Target disabled in range | Immediately ineligible | P0 |
| INT-008 | Target reports unavailable | Failure propagated; no success feedback | P0 |
| INT-009 | Button held across frames | Edge-triggered; no repeat | P0 |
| INT-010 | Two quick presses | Separate attempts only under explicit repeat policy | P1 |
| INT-011 | Scene transition | Old references cleared | P0 |
| INT-012 | Re-enter scene | No duplicate signal subscriptions | P1 |
| INT-013 | Rapid enter/exit | No stale/duplicate target records | P1 |
| INT-014 | Multiple shapes, one interactable | One logical target | P1 |
| INT-015 | Player overlaps own sensor | Player never selected | P0 |
| INT-016 | UI text/menu focus | Explicit input-context policy enforced | P1 |
| INT-017 | Pause while target selected | Interaction blocked | P0 |
| INT-018 | Resume | Selection recalculated | P1 |
| INT-019 | Touch press/release | Same action path; no stuck state | P0 |
| INT-020 | Movement + interaction multitouch | No unintended cancellation/duplication | P1 |
| INT-021 | App loses focus mid-touch | Input released safely | P0 |
| INT-022 | Target moves while nearby | Selection uses current transform | P1 |
| INT-023 | Invalid node lacks contract | Excluded or safely rejected | P0 |
| INT-024 | Teardown during interaction | No freed-node access or invalid mutation | P0 |

## 3. Proposed selection policy
Eligibility uses active state, authored interaction group/layer and range. Select minimum squared distance from the player interaction origin. Resolve ties by stable authored interaction ID. Recalculate when the eligible set or relevant transforms change. Facing/line-of-sight weighting is optional and requires separate approval.

## 4. Input/lifecycle requirements
Use one `interact` gameplay action for keyboard and touch. Touch must release on button release, node exit, pause and application focus loss. Do not consume the same press in both input and physics loops. Scene teardown invalidates target references and disconnects signals safely.

## 5. Test plan
1. Minimal scene with player sensor and three test interactables.
2. Stable test IDs and enabled/disabled states.
3. Selection, invalidation, unavailable-target and one-press tests.
4. Scene teardown, pause/resume and re-entry tests.
5. Touch release, focus-loss and multitouch tests.
6. Headless automated checks where possible.
7. Manual editor/runtime verification for spatial behavior.
8. Android testing on a named device before DEVICE-VERIFIED status.

## 6. Evidence boundary
Current CI covers project import/parsing, NLI smoke tests and a ten-frame headless scene launch. It does not execute this matrix. No case is passed until its test is implemented and run.

Final prompt styling, camera-relative look, gamepad support, dialogue/inventory behavior, final character assets and Android performance certification are out of scope.
