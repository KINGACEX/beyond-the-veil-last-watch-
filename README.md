# Beyond the Veil: The Last Watch

BTV is a Christian action-adventure survival RPG set in a modern world of spiritual conflict, exploration, survival, and the Covenant's Last Watch.

## Current repository state

The active isolated engineering/research branch is `btv/controls-hardening-prototype-layout-plan-001`. It contains the Godot greybox foundation, hardened keyboard/touch input, neutral movement and traversal tests, optics, wind, wildlife and weather primitives, recovered source-of-truth documents, audits and research. See [the 10 November repository state audit](docs/audits/BTV_REPOSITORY_STATE_AND_WORKSTREAM_RECONCILIATION_AUDIT_2026-11-10.md).

The branch is not merged into `main`. Do not treat this branch as a finished game or a playable vertical slice.

### Project foundation
- `project.godot` — Godot project entry point and input actions.
- `scenes/main.tscn` — greybox test area.
- `scenes/player.tscn` — capsule placeholder, collision, third-person camera and proximity sensor.
- `scenes/touch_controls.tscn` / `scripts/touch_controls.gd` — initial touch overlay mapped to shared InputMap actions.
- `scripts/player_controller.gd` — movement and nearest-interactable selection.
- `scripts/interactable.gd` — reusable Area3D interaction contract.
- `scripts/nli/` — deterministic NLI parser, validator, request gate, authored knowledge base and orchestration service.
- `scripts/mission/mission_data_validator.gd` — neutral typed-registry ID/reference validation utility (Phase 1 only).
- `tests/` — NLI smoke/contract tests, neutral mission-validator tests and core interaction acceptance tests.
- `.github/workflows/godot-validation.yml` — headless Godot validation workflow.

### Read these first
1. [BTV source-of-truth index](docs/source-of-truth/README.md).
2. [Current implementation status](docs/implementation/BOOTSTRAP_STATUS.md).
3. [NLI handoff and source-registry contract](docs/implementation/NLI_003_HANDOFF_AND_SOURCE_REGISTRY_CONTRACT.md).
4. [NLI contract gap audit — 6 November 2026](docs/audits/BTV_NLI_CONTRACT_GAP_AUDIT_2026-11-06.md).
5. [Core interaction acceptance matrix](docs/qa/CORE_INTERACTION_003_EDGE_CASE_ACCEPTANCE_MATRIX.md).
6. [Research-to-design traceability matrix — 6 November 2026](docs/coordination/BTV_RESEARCH_TO_DESIGN_TRACEABILITY_MATRIX_2026-11-06.md).
7. [Separated workstream execution board](docs/coordination/BTV_SEPARATED_WORKSTREAM_EXECUTION_BOARD_2026-11-05.md).

### Implementation contracts
- [Mission data validation contract](docs/implementation/MISSION_DATA_VALIDATION_CONTRACT_001.md) — Phase 1 neutral registry validator implemented; full mission/dialogue graph validation and Ridgeview content remain unimplemented.

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
- [Mission scripting and dialogue pipeline](docs/research/BTV_MISSION_SCRIPTING_AND_DIALOGUE_PIPELINE_RESEARCH_2026-11-06.md).
- [AI coding-agent alternatives — 6 November 2026](docs/research/BTV_AI_CODING_AGENT_ALTERNATIVES_2026-11-06.md) — research only; no installations or paid services.
- [Consensus academic synthesis](docs/research/academic/CONSENSUS_GAME_PRODUCTION_RESEARCH_2026-11-05.md).

Research findings are not approved BTV canon or architecture until explicitly reviewed.

## Toolchain and platform status

The GitHub Actions workflow currently installs Godot 4.7.2 for headless validation. This is the CI toolchain, not proof of the editor version installed on a developer's device. The renderer remains deliberately undecided pending comparison on the actual target Android device.

Android export, installation, touch usability, sustained performance, memory and thermal behaviour remain unverified on a physical target device.

## Open and run

1. Check out `btv/controls-hardening-prototype-layout-plan-001` for the current isolated branch.
2. Open the project folder in Godot 4.7.2 (matching the CI version).
3. Allow the project to import and inspect the Output/debugger panels.
4. Run the project (F5 / Run Project).
5. Use W/A/S/D or arrow keys to move the capsule.
6. Approach the neutral test marker and press E; inspect the diagnostic response in Output.

## Verification

**CONFIRMED — latest audited validation run 42783455949** passed on commit `8bce9a4ce497f6ca36a3aa0344e16b49d72b0d68`. It ran Godot 4.7.2 import/parsing, NLI and mission contracts, camera and touch input suites, movement/collision/traversal tests, optics, wind, wildlife, weather and a 10-frame neutral movement lab launch (35 workflow steps).

[View latest audited validation run 42783455949](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42783455949).

**CONFIRMED — code/test validation run 42031646069** passed on commit `67b799558b4a7690275dfb383b3a23e7cb8599cc`. It ran Godot 4.7.2 installation/version check, headless editor import/project parsing, NLI smoke tests, NLI handoff/source-registry contract tests (including normalized request-state lookup), core interaction acceptance tests (including INT-025–INT-028), and a 10-frame main-scene launch.

[View code/test validation run 42031646069](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42031646069).

**CONFIRMED — research documentation run 42180281566** passed on commit `a19666107f24a61029fb39717938d76aa5197ad3`.

[View research documentation validation run 42180281566](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42180281566).

**CONFIRMED — NLI audit documentation run 42180351027** passed on commit `2bb40fd5c14e03fd721b9a262b84396ae982b243`.

[View NLI audit documentation validation run 42180351027](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42180351027).

These are headless CI/documentation checks only. They do not verify rendered appearance, manual interaction feel, physical touch behaviour, Android export/installation, device performance or thermal stability. Check the branch Actions page for the current result on the latest commit.

## Branch and release boundaries

- Active work remains on `btv/controls-hardening-prototype-layout-plan-001`.
- No merge to `main` has been performed.
- No release has been published.
- Do not merge, force-push, delete branches, publish or deploy without explicit approval.


## Approved visual direction and graphics production

- [BTV Visual Art Bible v1.0](docs/art/BTV_VISUAL_ART_BIBLE_v1.0.md) — approved cinematic semi-realism direction, reference-game study matrix, character/environment art rules, originality, lighting, animation and art review gates.
- [BTV Technical Graphics Specification v1.0](docs/technical/BTV_TECHNICAL_GRAPHICS_SPECIFICATION_v1.0.md) — renderer decision gate, Android/PC quality tiers, provisional frame-time objectives, asset acceptance and device-validation plan.
- [Android Graphics and Device Benchmark Research](docs/research/BTV_ANDROID_GRAPHICS_AND_DEVICE_BENCHMARK_RESEARCH_2026-11-06.md) — Godot 4.7 renderer trade-offs, Android sustained performance and device-tier methodology.
- [Neutral Graphics Benchmark Scene Acceptance Contract](docs/qa/BTV_NEUTRAL_GRAPHICS_BENCHMARK_SCENE_ACCEPTANCE_CONTRACT_v1.0.md) — canon-neutral scene composition, telemetry, test protocol and acceptance gates.

These documents record approved visual intent and proposed production standards. The renderer, target Android hardware, fixed asset budgets and physical-device performance remain unresolved until measured. Neither document claims the production art or Android build is implemented.
