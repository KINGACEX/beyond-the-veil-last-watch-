## Summary
- Close the XH-001 findings that were mechanical to fix: player lookup on late spawn/respawn, the double-applied analog deadzone, touch cleanup cancelling another input source's action, Android backgrounding, and a hidden overlay still driving the player.
- Add five headless suites (37 assertions) covering player lifecycle, analog composition, keyboard coexistence, viewport resize and the real input path.
- Add `apply_look_delta` as the public look entry point shared by the mouse path and the touch HUD.

## Scope and boundaries
- Fixes **HIGH-1**, **MEDIUM-1**, **MEDIUM-2**, **MEDIUM-3**, **MEDIUM-4** and **LOW-1** from the XH-001 review.
- **HIGH-2 (fixed-pixel HUD, no safe-area insets) and HIGH-3 (resolution-dependent look sensitivity) are deliberately NOT fixed here.** Both are visual/layout decisions that need the Visual Director's brief and a creator device/renderer decision. They are recorded as deferred in the implementation report.
- No canon, art, assets, audio or narrative content was added.
- No dependency was added, no project security setting was changed, and no files were deleted.
- The application identifier was not chosen. No export preset or signing configuration was created.
- This PR remains draft and must not be merged without creator review.

## Verification
- **PASS — 12/12 suites on Godot 4.7.2 headless** (`4.7.2.stable.official.ed1daf0bf`), run locally: the 7 existing CI suites plus the 5 new suites in this branch.
- **PASS — 10-frame headless main-scene launch.**
- Measured analog curve after the fix: raw 0.25 / 0.50 / 0.75 now produce action strength 0.1477 / 0.4318 / 0.7159, and the player input magnitude equals the action strength (no second deadzone).

## Test-suite change worth reviewing
`tests/touch_controls_integration_test.gd` now makes the overlay visible. It previously drove the HUD **while it was hidden** — an artefact of headless CI reporting no touchscreen, and the exact state in which the hidden-overlay defect was invisible. No assertion was weakened or removed.

## Known limitations
- Action ownership is a heuristic: Godot keeps one state per action, so two sources driving the *same* action still conflict. A dedicated summed input source is the architectural fix.
- HIGH-2 and HIGH-3 remain open.
- The Android export pipeline is still unconfigured: no `export_presets.cfg`, no application identifier, no signing, and CI installs no export templates.
- `.uid` files remain untracked in the repository (Godot 4.7 generates one per script).

This is headless CI evidence only. It does not establish physical Android multitouch, latency, thumb reach, safe-area insets, orientation change, camera sensitivity, frame pacing, device performance or Android export readiness.

## ACTION REQUIRED — CI workflow step could not be pushed
`.github/workflows/godot-validation.yml` is **not** included in this branch. The token used for this push is refused by GitHub for workflow files ("refusing to allow a Personal Access Token to create or update workflow `.github/workflows/godot-validation.yml` without `workflow` scope"). Two options:

1. **Creator applies it in the GitHub web editor** (recommended). The required change is: add `btv/agent-minimax-xh-002` to the `push.branches` list, and add five steps after "Run touch controls integration tests":
   ```yaml
      - name: Run touch controls lifecycle tests
        run: godot --headless --path . --script res://tests/touch_controls_lifecycle_test.gd
      - name: Run touch controls composition tests
        run: godot --headless --path . --script res://tests/touch_controls_composition_test.gd
      - name: Run touch controls coexistence tests
        run: godot --headless --path . --script res://tests/touch_controls_coexistence_test.gd
      - name: Run touch controls resize tests
        run: godot --headless --path . --script res://tests/touch_controls_resize_test.gd
      - name: Run touch controls input path tests
        run: godot --headless --path . --script res://tests/touch_controls_input_path_test.gd
   ```
2. **Grant the token the `workflow` scope**, then the workflow change can be pushed as-is.

Until one of these is done, CI will not run the five new suites on this branch. The suites were all executed locally and pass.

## Review focus
- Confirm the `project.godot` movement-action deadzone change is intended, and that keyboard movement is unaffected.
- Confirm the modified integration suite still proves the same behaviours.
- Confirm HIGH-2 and HIGH-3 should stay deferred to the Visual Director's brief.
