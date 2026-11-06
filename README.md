# Beyond the Veil: The Last Watch

BTV is a Christian action-adventure survival RPG set in a modern world of spiritual conflict, exploration, survival, and the Covenant's Last Watch.

## Current repository state

The active isolated engineering/research branch is `btv/test-first-contracts-001`. It contains the Godot greybox foundation originally developed on `btv/bootstrap-prototype-001`, additional interaction and NLI contract tests, recovered source-of-truth design documents, audits and research.

The branch is not merged into `main`. Do not treat this branch as a finished game or a playable vertical slice.

### Project foundation
- `project.godot` — Godot project entry point and input actions.
- `scenes/main.tscn` — greybox test area.
- `scenes/player.tscn` — capsule placeholder, collision, third-person camera and proximity sensor.
- `scenes/touch_controls.tscn` / `scripts/touch_controls.gd` — initial touch overlay mapped to shared InputMap actions.
- `scripts/player_controller.gd` — movement and nearest-interactable selection.
- `scripts/interactable.gd` — reusable Area3D interaction contract.
- `scripts/nli/` — deterministic NLI parser, validator, request gate, authored knowledge base and orchestration service.
- `tests/` — NLI smoke/contract tests and core interaction acceptance tests.
- `.github/workflows/godot-validation.yml` — headless Godot validation workflow.

### Read these first
1. [BTV source-of-truth index](docs/source-of-truth/README.md).
2. [Current implementation status](docs/implementation/BOOTSTRAP_STATUS.md).
3. [NLI handoff and source-registry contract](docs/implementation/NLI_003_HANDOFF_AND_SOURCE_REGISTRY_CONTRACT.md).
4. [NLI contract gap audit — 6 November 2026](docs/audits/BTV_NLI_CONTRACT_GAP_AUDIT_2026-11-06.md).
5. [Core interaction acceptance matrix](docs/qa/CORE_INTERACTION_003_EDGE_CASE_ACCEPTANCE_MATRIX.md).
6. [Research-to-design traceability matrix — 6 November 2026](docs/coordination/BTV_RESEARCH_TO_DESIGN_TRACEABILITY_MATRIX_2026-11-06.md).
7. [Separated workstream execution board](docs/coordination/BTV_SEPARATED_WORKSTREAM_EXECUTION_BOARD_2026-11-05.md).

### Research
- [Game development practice — Phase 1](docs/research/BTV_GAME_DEVELOPMENT_PRACTICE_RESEARCH_PHASE_1_2026-11-05.md).
- [Cinematic and narrative environment research](docs/research/BTV_CINEMATIC_AND_NARRATIVE_ENVIRONMENT_RESEARCH_2026-11-05.md).
- [Godot 3D small-team postmortem](docs/research/BTV_GODOT_3D_SMALL_TEAM_POSTMORTEM_RESEARCH_2026-11-05.md).
- [Blender–Godot asset pipeline](docs/research/BTV_BLENDER_GODOT_ASSET_PIPELINE_RESEARCH_2026-11-05.md).
- [Character and animation pipeline](docs/research/BTV_CHARACTER_AND_ANIMATION_PIPELINE_RESEARCH_2026-11-05.md).
- [Character rigging and game-animation case study](docs/research/BTV_CHARACTER_RIGGING_AND_GAME_ANIMATION_CASE_STUDY_2026-11-05.md).
- [World construction and environment art](docs/research/BTV_WORLD_CONSTRUCTION_AND_ENVIRONMENT_ART_RESEARCH_2026-11-05.md).
- [Godot world navigation and region boundaries](docs/research/BTV_GODOT_WORLD_NAVIGATION_AND_REGION_BOUNDARY_RESEARCH_2026-11-05.md).
- [Save/load, automated testing and QA](docs/research/BTV_SAVE_LOAD_AUTOMATED_TESTING_AND_QA_RESEARCH_2026-11-05.md).
- [UI accessibility, input and presentation](docs/research/BTV_UI_ACCESSIBILITY_INPUT_AND_PRESENTATION_RESEARCH_2026-11-06.md).
- [Consensus academic synthesis](docs/research/academic/CONSENSUS_GAME_PRODUCTION_RESEARCH_2026-11-05.md).

Research findings are not approved BTV canon or architecture until explicitly reviewed.

## Toolchain and platform status

The GitHub Actions workflow currently installs Godot 4.7.2 for headless validation. This is the CI toolchain, not proof of the editor version installed on a developer's device. The renderer remains deliberately undecided pending comparison on the actual target Android device.

Android export, installation, touch usability, sustained performance, memory and thermal behaviour remain unverified on a physical target device.

## Open and run

1. Check out `btv/test-first-contracts-001` for the current isolated branch.
2. Open the project folder in Godot 4.7.2 (matching the CI version).
3. Allow the project to import and inspect the Output/debugger panels.
4. Run the project (F5 / Run Project).
5. Use W/A/S/D or arrow keys to move the capsule.
6. Approach the neutral test marker and press E; inspect the diagnostic response in Output.

## Verification

**CONFIRMED — code/test validation run 42031646069** passed on commit `67b799558b4a7690275dfb383b3a23e7cb8599cc`. It ran Godot 4.7.2 installation/version check, headless editor import/project parsing, NLI smoke tests, NLI handoff/source-registry contract tests (including normalized request-state lookup), core interaction acceptance tests (including INT-025–INT-028), and a 10-frame main-scene launch.

[View code/test validation run 42031646069](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42031646069).

**CONFIRMED — research documentation run 42180281566** passed on commit `a19666107f24a61029fb39717938d76aa5197ad3`.

[View research documentation validation run 42180281566](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42180281566).

**CONFIRMED — NLI audit documentation run 42180351027** passed on commit `2bb40fd5c14e03fd721b9a262b84396ae982b243`.

[View NLI audit documentation validation run 42180351027](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42180351027).

These are headless CI/documentation checks only. They do not verify rendered appearance, manual interaction feel, physical touch behaviour, Android export/installation, device performance or thermal stability. Check the branch Actions page for the current result on the latest commit.

## Branch and release boundaries

- Active work remains on `btv/test-first-contracts-001`.
- No merge to `main` has been performed.
- No release has been published.
- Do not merge, force-push, delete branches, publish or deploy without explicit approval.
