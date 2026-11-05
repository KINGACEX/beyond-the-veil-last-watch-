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
4. [Core interaction acceptance matrix](docs/qa/CORE_INTERACTION_003_EDGE_CASE_ACCEPTANCE_MATRIX.md).
5. [Separated workstream execution board](docs/coordination/BTV_SEPARATED_WORKSTREAM_EXECUTION_BOARD_2026-11-05.md).

### Research
- [Game development practice — Phase 1](docs/research/BTV_GAME_DEVELOPMENT_PRACTICE_RESEARCH_PHASE_1_2026-11-05.md).
- [Cinematic and narrative environment research](docs/research/BTV_CINEMATIC_AND_NARRATIVE_ENVIRONMENT_RESEARCH_2026-11-05.md).
- [Godot 3D small-team postmortem](docs/research/BTV_GODOT_3D_SMALL_TEAM_POSTMORTEM_RESEARCH_2026-11-05.md).
- [Blender–Godot asset pipeline research](docs/research/BTV_BLENDER_GODOT_ASSET_PIPELINE_RESEARCH_2026-11-05.md).
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

**CONFIRMED — GitHub Actions run 42030200114** passed on commit `cf30a1259e013d8701ede04aef9d874ba7780990`. It ran Godot 4.7.2 installation/version check, headless editor import/project parsing, NLI smoke tests, NLI handoff/source-registry contract tests, core interaction acceptance tests and a 10-frame main-scene launch.

[View the validation run](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42030200114).

This is headless CI evidence only. It does not verify rendered appearance, manual interaction feel, physical touch behaviour, Android export/installation, device performance or thermal stability.

## Branch and release boundaries

- Active work remains on `btv/test-first-contracts-001`.
- No merge to `main` has been performed.
- No release has been published.
- Do not merge, force-push, delete branches, publish or deploy without explicit approval.
