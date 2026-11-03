# BTV Bootstrap 001 — One-Read Project Handoff

**Project:** Beyond the Veil: The Last Watch (BTV)  
**Report date:** 3 November 2026  
**Repository:** `KINGACEX/beyond-the-veil-last-watch-`  
**Working branch:** `btv/bootstrap-prototype-001`  
**Latest verified branch tree commit:** `993fa9e73ac8bb35a2494c8cd8d51d6028058493`  
**Implementation status:** Source scaffold committed; Godot engine validation remains outstanding.

> **Read this first:** Bootstrap 001 turns the previously documentation-only repository into a minimal Godot project scaffold. It is not yet a validated, complete, or Android-playable game. The files were committed and read back from the feature branch, but no Godot editor import, parser check, runtime test, automated test, export, or physical-device test has been completed.

---

## 1. What BTV is

BTV is a Christian action-adventure survival RPG about spiritual conflict, exploration, survival, and the Covenant's Last Watch. Its intended structure is a semi-open world made of interconnected regions, rather than an unrestricted full open world.

The creative direction is Christian in substance: Scripture, prayer, the Armor of God, evangelism, redemption, and the end-times/Veil premise should be handled accurately and without manipulation. It is not intended to be a retelling of the Bible.

Important design safeguards:
- Do not turn salvation, faith, prayer, holiness, or divine favour into purchasable items, XP, scores, or transactional rewards.
- Do not use spiritual scoring or imply that gameplay performance measures a character's standing with God.
- Keep the established character, Covenant, world, and spiritual-system canon authoritative. A technical bootstrap must not silently invent or overwrite narrative canon.

The current code does **not** implement these narrative or spiritual systems. They are included here as project context and guardrails, not as claims about completed features.

## 2. What existed before this change

The earlier repository inspection found a very small repository: a README and a tiny text file named `doc`. No Godot project configuration, scenes, GDScript source, assets, tests, or CI workflow were present in that inspected tree.

The first implementation was therefore deliberately limited to a small, reversible foundation on a separate branch. The default branch, `main`, was not changed or merged.

## 3. What was created

Bootstrap 001 added the following files on `btv/bootstrap-prototype-001`:

| Path | Purpose |
|---|---|
| `project.godot` | Godot project configuration, main-scene reference, window/viewport defaults, movement input actions, and default gravity. |
| `scenes/main.tscn` | Minimal 3D test scene with a directional light, a flat collision floor, and an instance of the player scene. |
| `scenes/player.tscn` | Temporary capsule player, collision shape, camera pivot, spring arm, and camera. |
| `scripts/player_controller.gd` | Basic `CharacterBody3D` movement controller. |
| `.gitignore` | Excludes generated Godot cache/import data, build/export folders, and common temporary operating-system files. |
| `docs/implementation/BOOTSTRAP_STATUS.md` | Concise status, scope, constraints, verification checklist, and next implementation task. |
| `README.md` | Repository introduction, current branch state, intended toolchain, and initial open/run instructions. |

### How the prototype is intended to behave

The main scene places a simple player capsule above a flat floor. A directional light makes the greybox scene visible. The player scene uses a `CharacterBody3D` root with a capsule collision shape and a third-person camera rig built from a pivot, `SpringArm3D`, and `Camera3D`.

The movement script:
- Reads the configured gravity value.
- Reads a two-dimensional movement vector from the project's input actions.
- Normalizes movement direction to avoid faster diagonal movement.
- Applies gravity while the character is airborne.
- Sets horizontal movement velocity.
- Rotates the character toward the movement direction.
- Uses `move_and_slide()` for character movement and collision handling.

The configured keyboard actions are W/A/S/D and the arrow keys. This is an initial desktop test path only; it is not an Android touch-control implementation.

## 4. Technical decisions and boundaries

- **Engine direction:** Godot 4.x. The current status document identifies Godot 4.7.2 as the intended validation gate. Confirm the exact installed editor and matching export templates before treating the project as validated.
- **Renderer:** No renderer has been selected in project settings. Compare suitable renderer options on the actual Android target before deciding.
- **Player representation:** A capsule is a temporary greybox placeholder. It is not Asher Vance's final model or a final character design.
- **Scope:** A small project scaffold and movement test only.
- **Dependencies and cost:** No paid assets, paid services, or external runtime dependencies were added in this bootstrap.
- **Version control:** Work is isolated on a feature branch. Do not merge to `main` until review and validation gates pass.

## 5. What is not implemented

The following are explicitly outside Bootstrap 001:

- Asher's final character model, animations, clothing, or identity presentation.
- Touch controls, mobile UI, Android export configuration, or device optimisation.
- Combat, weapons, enemies, enemy AI, or boss encounters.
- Veil rules, Ember abilities, Veil Sight, Guardian Instinct, Tracking Sense, or Spirit Guidance.
- Prayer, faith, Scripture interactions, church systems, or spiritual progression.
- Missions, dialogue, NPCs, region streaming, inventory, economy, or save/load.
- Final environment art, sound, music, visual effects, accessibility, or localisation.
- Automated tests, CI, profiling, and performance certification.

Do not describe the current scaffold as a playable vertical slice or finished game.

## 6. Verification: what is known and what remains unknown

### Confirmed from repository operations

- The feature branch `btv/bootstrap-prototype-001` was created from the existing repository history.
- The listed source/configuration files were committed to that branch.
- The branch tree was read back after the final scene-file correction; its latest verified tree commit is `993fa9e73ac8bb35a2494c8cd8d51d6028058493`.
- The relevant files were fetched back from the branch for inspection.
- The main branch was not merged or intentionally modified by this work.

### Not verified

No Godot executable/editor validation was available during this implementation. Therefore, all of the following remain **UNKNOWN / NOT TESTED**:

1. Whether Godot 4.7.2 imports the project without errors.
2. Whether every scene resource and serialized input event is accepted by the editor.
3. Whether the GDScript parses and runs as intended.
4. Whether floor collision, gravity, movement, camera placement, and rotation behave correctly at runtime.
5. Whether any renderer performs acceptably on the intended Android device.
6. Whether the project can be exported and launched on Android.
7. Whether performance, memory use, thermal behaviour, and stability meet any target.

The README's open/run instructions describe the intended smoke test; they are not evidence that the test has passed.

## 7. Required next steps

### Gate A — Editor smoke test

1. Check out `btv/bootstrap-prototype-001`.
2. Open the project folder in the agreed Godot 4.7.2 editor (or first confirm the actual compatible version in use).
3. Allow the editor to import the project.
4. Inspect the Output and debugger panels for parse, resource, and configuration errors.
5. Run the main scene.
6. Verify floor collision, gravity, directional movement, diagonal speed, player rotation, and camera follow.
7. Record exact errors and fixes. Do not mark this gate complete based only on files existing in GitHub.

### Gate B — Android feasibility

1. Identify the actual target Android device and its OS/GPU constraints.
2. Install matching Godot export templates.
3. Compare renderer options on that device before locking the renderer.
4. Implement touch controls and mobile-friendly input/UI.
5. Export and run a development build on the device.
6. Measure frame time/FPS, memory, thermal behaviour, stability, and visual quality over a repeatable test.
7. Record results and limitations in the status document.

### Gate C — Bootstrap 002

Only after Gate A passes, implement a small reusable interaction contract and one neutral test interactable. Keep it separate from combat, mission logic, spiritual systems, and narrative content. Define acceptance criteria and a test plan before expanding the feature.

## 8. Suggested engineering workflow

Use a small, testable, modular approach:
1. Inspect the existing project and canon before changing files.
2. State the task boundary and acceptance criteria.
3. Implement one coherent feature at a time.
4. Run the relevant editor checks and tests.
5. Review the diff and update documentation.
6. Commit to a feature branch.
7. Merge only after review and the required checks pass.

Use scenes for reusable gameplay entities, scripts for behaviour, and Resources for reusable configuration/data where appropriate. Avoid both monolithic scripts and unnecessary abstraction. Keep the Android target in view when choosing rendering, input, asset sizes, and scene complexity.

For multi-agent work, assign one clear owner per feature, define file ownership, use separate branches or worktrees where practical, and require integration review. Do not assume another collaborator or agent has repository access until that access is independently confirmed.

## 9. Handoff summary

**Current state:** A minimal Godot project scaffold and desktop-oriented greybox movement path are committed on `btv/bootstrap-prototype-001`.

**Safe claim:** The source files exist on the feature branch and were read back from GitHub.

**Unsafe claim:** The project has been run successfully, tested, exported, or proven playable on Android. None of those validations has occurred.

**Immediate priority:** Run Gate A in the Godot editor, report the exact editor version and any errors, and only then proceed to Bootstrap 002.

## 10. Repository links

- [Feature branch](https://github.com/KINGACEX/beyond-the-veil-last-watch-/tree/btv/bootstrap-prototype-001)
- [Project configuration](https://github.com/KINGACEX/beyond-the-veil-last-watch-/blob/btv/bootstrap-prototype-001/project.godot)
- [Main scene](https://github.com/KINGACEX/beyond-the-veil-last-watch-/blob/btv/bootstrap-prototype-001/scenes/main.tscn)
- [Player scene](https://github.com/KINGACEX/beyond-the-veil-last-watch-/blob/btv/bootstrap-prototype-001/scenes/player.tscn)
- [Movement controller](https://github.com/KINGACEX/beyond-the-veil-last-watch-/blob/btv/bootstrap-prototype-001/scripts/player_controller.gd)
- [Bootstrap status](https://github.com/KINGACEX/beyond-the-veil-last-watch-/blob/btv/bootstrap-prototype-001/docs/implementation/BOOTSTRAP_STATUS.md)
- [Repository README](https://github.com/KINGACEX/beyond-the-veil-last-watch-/blob/btv/bootstrap-prototype-001/README.md)

---

**Document purpose:** This is the single-read handoff for the Bootstrap 001 implementation. Update it when verified project facts change; do not silently convert proposed work or untested behaviour into completed status.
