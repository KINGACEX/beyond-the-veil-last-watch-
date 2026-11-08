# CORE INTERACTION 003 — Edge-Case Acceptance Matrix
**Status:** PROPOSED QA SPECIFICATION — PARTIALLY AUTOMATED; MANUAL/DEVICE EXECUTION PENDING  
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
The matrix is only partially automated. Per-case status is recorded below; a general project-launch smoke test does not pass an unimplemented matrix case. Headless test evidence does not establish editor/runtime feel or Android device behaviour.

Final prompt styling, camera-relative look, gamepad support, dialogue/inventory behavior, final character assets and Android performance certification are out of scope.


## 7. Automated coverage status — 5 November 2026

**CONFIRMED:** The first headless automated acceptance suite is at `tests/core_interaction_acceptance_test.gd`. It currently exercises these matrix cases or direct contract equivalents:

| Matrix ID | Automated evidence | Status |
|---|---|---|
| INT-001 | No-target safe no-op | AUTOMATED |
| INT-002 | One target registered and invoked | AUTOMATED |
| INT-003 | Exit removes target | AUTOMATED |
| INT-004 | Nearest target wins | AUTOMATED |
| INT-005 | Equal-distance stable authored-ID tie-break | AUTOMATED |
| INT-006 | Freed target safely ignored | AUTOMATED |
| INT-007 | Disabled target excluded | AUTOMATED |
| INT-013 | Duplicate target-enter notification is idempotent | PARTIAL — duplicate enter tested; rapid enter/exit still needed |
| INT-019 | Touch press/release uses shared InputMap action | AUTOMATED |
| INT-021 | Application focus loss releases held touch actions | AUTOMATED |
| INT-022 | Moving target changes current nearest selection | AUTOMATED |
| INT-023 | Non-interactable Area3D is ignored | AUTOMATED |
| INT-024 | Touch teardown releases actions; freed target is ignored | PARTIAL — both teardown paths covered, interaction-in-progress teardown still needed |

**Not yet automated:** INT-008, INT-009, INT-010, INT-011, INT-012, INT-014, INT-015, INT-016, INT-017, INT-018, INT-020 and the remaining portions of INT-013/024. Some require explicit input-context, pause policy or scene-lifecycle seams before reliable headless testing. Do not mark them passed from the general scene-launch smoke test.

**CI evidence:** Godot 4.7.2 headless run `42027258305` passed the then-current NLI contract suite and initial interaction acceptance suite. The expanded touch/lifecycle tests passed in run `42027583419` on commit `2021388bb7a337f8dd5c740b9d5c4c3df7a443a5`; they are now counted as passed only for the cases listed above.

**Important:** Passing headless tests does not replace editor/runtime visual checks or Android device testing.


## 8. Additional edge cases — 5 November 2026

The test-first review identified two defects in the selector: temporarily disabled targets were removed from the nearby set, preventing re-enablement while still in range; and IDs were counted after trimming but looked up without trimming, causing valid padded IDs to be excluded.

| ID | Scenario | Expected | Priority |
|---|---|---|---|
| INT-025 | Target disabled during selection, then re-enabled without leaving sensor range | Target becomes eligible again without requiring exit/re-entry | P1 |
| INT-026 | Authored interaction ID contains leading/trailing whitespace | ID is normalized consistently; target remains eligible | P1 |
| INT-027 | Two IDs differ only by surrounding whitespace | Normalized duplicate IDs are both excluded | P1 |

**Automated test names:**
- `_test_disabled_target_can_be_reenabled_in_range`
- `_test_whitespace_padded_interaction_id_is_normalized`
- `_test_ids_equal_after_whitespace_normalization_are_duplicates`

**Historical verification note:** the initial regression run failed on INT-025 and INT-026 as expected; the selector correction followed. Current verification is recorded in Section 10.


## 9. Case-insensitive comparison tie-break — 5 November 2026

| ID | Scenario | Expected | Priority |
|---|---|---|---|
| INT-028 | Two unique IDs differ only by letter case and are at equal distance | Case-insensitive comparison is followed by deterministic exact-string ordering | P1 |

**Automated test:** `_test_case_only_ids_have_deterministic_tie_break`.

**Historical verification note:** test-first regression was added after the earlier baseline. Current verification is recorded in Section 10.



## 10. Current CI verification — 8 November 2026

**CONFIRMED:** GitHub Actions run [42497741908](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42497741908) completed successfully on Godot 4.7.2. The run used code commit `81570c095f90b0b9c1d4e3ab38ebb40c7c3a9efd` on `btv/mission-validator-strict-types-001`. Its core interaction step passed with `CORE_INTERACTION_ACCEPTANCE_TESTS: PASS`. The strict-type documentation-only follow-up commit does not change the interaction test or controller code.

**Direct automated coverage in the test file at that commit:**

- **AUTOMATED (15 matrix cases):** INT-001 through INT-007; INT-019; INT-021 through INT-023; INT-025 through INT-028.
- **PARTIAL (2 matrix cases):** INT-013 (duplicate enter is idempotent; rapid enter/exit is not covered); INT-024 (freed-target and touch-overlay teardown paths are covered separately; teardown during an active interaction is not covered).
- **NOT AUTOMATED (11 matrix cases):** INT-008, INT-009, INT-010, INT-011, INT-012, INT-014, INT-015, INT-016, INT-017, INT-018 and INT-020.

The automated suite contains direct tests for disabled-target re-enablement, whitespace-normalized IDs, normalized duplicate IDs, and case-only deterministic tie-breaking. These four cases are now verified by the successful run; the earlier pending notes in Sections 8 and 9 are historical.

**Source-inspection gaps (not claims of runtime failure):**

- No explicit unavailable-target result contract/test exists yet.
- No scene-transition/re-entry lifecycle test exists.
- No explicit pause/UI input-context policy or tests exist.
- No multitouch test exists.
- Multiple collision shapes per logical interactable and player/self-sensor exclusion are not tested.
- Camera look and camera-relative movement are outside this interaction matrix and remain unimplemented in the inspected controller.

**Verification boundary:** This run proves the listed headless automated checks only. It does not prove manual editor behaviour, camera feel, visual layout, Android export/install, physical multitouch, safe-area layout or device performance.
