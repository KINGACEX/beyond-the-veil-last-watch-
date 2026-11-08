# Beyond the Veil: The Last Watch

BTV is a Christian action-adventure survival RPG set in a modern world of spiritual conflict, exploration, survival, and the Covenant's Last Watch.

## Current repository state

The engineering reference branch is `btv/test-first-contracts-001`. The isolated feature branch `btv/camera-relative-mouselook-001` adds camera-relative movement and desktop mouse-look. The later branch `btv/mobile-touch-input-adapter-001` builds on it with an integrated analog joystick and touch-look surface; both have passed headless CI but remain unmerged. The Godot greybox foundation originated on `btv/bootstrap-prototype-001`.

The branch is not merged into `main`. Do not treat this branch as a finished game or a playable vertical slice.

The cross-platform project records and Lore Bridge static review are being consolidated on `btv/project-history-and-lore-bridge-001`, created from the active engineering branch. This is a documentation/review branch; it does not replace the engineering branch or imply that external agent connections are live.

### Project foundation
- `project.godot` — Godot project entry point and input actions.
- `scenes/main.tscn` — greybox test area.
- `scenes/player.tscn` — capsule placeholder, collision, third-person camera and proximity sensor.
- `scenes/touch_controls.tscn` / `scripts/touch_controls.gd` — analog joystick, right-side camera-look surface, shared InputMap actions and legacy directional-pad fallback.
- `scripts/player_controller.gd` — movement and nearest-interactable selection.
- `scripts/interactable.gd` — reusable Area3D interaction contract.
- `scripts/nli/` — deterministic NLI parser, validator, request gate, authored knowledge base and orchestration service.
- `scripts/mission/mission_data_validator.gd` — neutral typed-registry ID/reference validation utility (Phase 1 only).
- `tests/` — NLI smoke/contract tests, neutral mission-validator tests, core interaction acceptance tests and camera input tests.
- `.github/workflows/godot-validation.yml` — headless Godot validation workflow.

### Read these first
1. [BTV source-of-truth index](docs/source-of-truth/README.md).
2. [Current implementation status](docs/implementation/BOOTSTRAP_STATUS.md).
3. [M1 camera-relative movement and desktop mouse-look report](docs/implementation/BTV_M1_CAMERA_RELATIVE_MOUSE_LOOK_IMPLEMENTATION_2026-11-08.md).
4. [M2 independent touch input adapter report](docs/implementation/BTV_M2_TOUCH_INPUT_ADAPTER_2026-11-08.md).
5. [NLI handoff and source-registry contract](docs/implementation/NLI_003_HANDOFF_AND_SOURCE_REGISTRY_CONTRACT.md).
6. [NLI contract gap audit — 6 November 2026](docs/audits/BTV_NLI_CONTRACT_GAP_AUDIT_2026-11-06.md).
7. [Core interaction acceptance matrix](docs/qa/CORE_INTERACTION_003_EDGE_CASE_ACCEPTANCE_MATRIX.md).
8. [Research-to-design traceability matrix — 6 November 2026](docs/coordination/BTV_RESEARCH_TO_DESIGN_TRACEABILITY_MATRIX_2026-11-06.md).
9. [Separated workstream execution board](docs/coordination/BTV_SEPARATED_WORKSTREAM_EXECUTION_BOARD_2026-11-05.md).
10. [Cross-platform progress register — 8 November 2026](docs/coordination/BTV_CROSS_PLATFORM_PROGRESS_REGISTER_2026-11-08.md).
11. [Next execution plan — 8 November 2026](docs/coordination/BTV_NEXT_EXECUTION_PLAN_2026-11-08.md).
12. [MiniMax Lore Bridge static review — 8 November 2026](docs/audits/BTV_LORE_BRIDGE_STATIC_REVIEW_2026-11-08.md).
13. [Trailer production status — 8 November 2026](docs/media/BTV_TRAILER_PRODUCTION_STATUS_2026-11-08.md).

### Implementation contracts
- [Mission data validation contract](docs/implementation/MISSION_DATA_VALIDATION_CONTRACT_001.md) — Phase 1 neutral registry validator implemented; full mission/dialogue graph validation and Ridgeview content remain unimplemented.

### Multi-agent collaboration
- [Multi-agent development system](docs/agents/BTV_MULTI_AGENT_DEVELOPMENT_SYSTEM_v1.0.md).
- [Claude Visual Director charter](docs/agents/CLAUDE_VISUAL_DIRECTOR_CHARTER_v1.0.md).
- [MiniMax Code Implementation charter](docs/agents/MINIMAX_CODE_IMPLEMENTATION_CHARTER_v1.0.md).
- [ChatGPT Lead Coordinator charter](docs/agents/CHATGPT_LEAD_COORDINATOR_CHARTER_v1.0.md).
- [Task and handoff protocol](docs/agents/BTV_AGENT_TASK_AND_HANDOFF_PROTOCOL_v1.0.md).
- [Visual production quality standard](docs/visual/BTV_VISUAL_PRODUCTION_QUALITY_STANDARD_v1.0.md).
- [GitHub MCP and branch rules](docs/agents/BTV_GITHUB_MCP_AND_BRANCH_RULES_v1.0.md).
- [Story Development Agent charter](docs/agents/BTV_STORY_DEVELOPMENT_AGENT_CHARTER_v0.1.md).
- [Shared decision log](docs/agents/BTV_SHARED_DECISION_LOG.md).
- [Agent activity log](docs/agents/BTV_AGENT_ACTIVITY_LOG.md).

The multi-agent system is documented, not yet operationally connected. Claude/MiniMax MCP access and client compatibility require separate verification.

### Story, character and world-design records
- [Kay family character bible](docs/characters/KAY_FAMILY_CHARACTER_BIBLE_v1.0.md).
- [Kay family naming addendum](docs/characters/KAY_FAMILY_NAMING_ADDENDUM_v1.1.md).
- [Global character naming and cultural representation framework](docs/design/BTV_GLOBAL_CHARACTER_NAMING_AND_CULTURAL_REPRESENTATION_FRAMEWORK_v0.1.md).
- [Annual community calendar framework proposal](docs/design/BTV_ANNUAL_COMMUNITY_CALENDAR_FRAMEWORK_PROPOSAL_v0.1.md).
- [Church festival and community event framework proposal](docs/design/CHURCH_FESTIVAL_AND_COMMUNITY_EVENT_FRAMEWORK_PROPOSAL_v0.1.md).
- [New-game NPC generation and Christian name lexicon proposal](docs/design/BTV_NEW_GAME_NPC_GENERATION_AND_CHRISTIAN_NAME_LEXICON_PROPOSAL_v0.1.md).
- [Story gap register — initial triage](docs/story/BTV_STORY_GAP_REGISTER_INITIAL_TRIAGE_v0.1.md).
- [Opening-to-Ridgeview narrative flow](docs/story/BTV_VERTICAL_SLICE_OPENING_TO_RIDGEVIEW_NARRATIVE_FLOW_v0.1.md).

These are supporting character/design records and proposals. They do not supersede the controlling Master Canon, creator decisions or merged Vertical Slice Specification. Calendar, festival and NPC-generation documents remain proposals unless separately approved.

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

1. Check out `btv/test-first-contracts-001` for the current isolated engineering branch.
2. Open the project folder in Godot 4.7.2 (matching the CI version).
3. Allow the project to import and inspect the Output/debugger panels.
4. Run the project (F5 / Run Project).
5. Use W/A/S/D or arrow keys to move the capsule.
6. Approach the neutral test marker and press E; inspect the diagnostic response in Output.

## Verification

**CONFIRMED — latest code/test validation run 42189615410** passed on commit `c91094d99b5462d8b69f249ba579e8316dc09137`. It includes the canonical NLI request-ID boundary tests, query/action lifecycle semantics, cancellation tests, neutral mission-registry validation tests, core interaction acceptance tests and a 10-frame main-scene launch.

[View latest code/test validation run 42189615410](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42189615410).

**CONFIRMED — code/test validation run 42031646069** passed on commit `67b799558b4a7690275dfb383b3a23e7cb8599cc`. It ran Godot 4.7.2 installation/version check, headless editor import/project parsing, NLI smoke tests, NLI handoff/source-registry contract tests (including normalized request-state lookup), core interaction acceptance tests (including INT-025–INT-028), and a 10-frame main-scene launch.

[View code/test validation run 42031646069](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42031646069).

**CONFIRMED — research documentation run 42180281566** passed on commit `a19666107f24a61029fb39717938d76aa5197ad3`.

[View research documentation validation run 42180281566](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42180281566).

**CONFIRMED — NLI audit documentation run 42180351027** passed on commit `2bb40fd5c14e03fd721b9a262b84396ae982b243`.

[View NLI audit documentation validation run 42180351027](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42180351027).

These are headless CI/documentation checks only. They do not verify rendered appearance, manual interaction feel, physical touch behaviour, Android export/installation, device performance or thermal stability. Check the branch Actions page for the current result on the latest commit.

## Branch and release boundaries

- Active engineering work remains on `btv/test-first-contracts-001`.
- Cross-platform documentation and Lore Bridge review are on `btv/project-history-and-lore-bridge-001`.
- The earlier `btv/multi-agent-system-v1` branch is retained as historical work; its nine documents have been ported into the current documentation branch.
- No merge to `main` has been performed.
- No release has been published.
- Do not merge, force-push, delete branches, publish or deploy without explicit approval.

## Approved visual direction and graphics production

- [BTV Visual Art Bible v1.0](docs/art/BTV_VISUAL_ART_BIBLE_v1.0.md) — approved cinematic semi-realism direction, reference-game study matrix, character/environment art rules, originality, lighting, animation and art review gates.
- [BTV Technical Graphics Specification v1.0](docs/technical/BTV_TECHNICAL_GRAPHICS_SPECIFICATION_v1.0.md) — renderer decision gate, Android/PC quality tiers, provisional frame-time objectives, asset acceptance and device-validation plan.
- [Android Graphics and Device Benchmark Research](docs/research/BTV_ANDROID_GRAPHICS_AND_DEVICE_BENCHMARK_RESEARCH_2026-11-06.md) — Godot 4.7 renderer trade-offs, Android sustained performance and device-tier methodology.
- [Neutral Graphics Benchmark Scene Acceptance Contract](docs/qa/BTV_NEUTRAL_GRAPHICS_BENCHMARK_SCENE_ACCEPTANCE_CONTRACT_v1.0.md) — canon-neutral scene composition, telemetry, test protocol and acceptance gates.

These documents record approved visual intent and proposed production standards. The renderer, target Android hardware, fixed asset budgets and physical-device performance remain unresolved until measured. Neither document claims the production art or Android build is implemented.


### Lore Bridge remediation
- [Lore Bridge v1.1 remediation and acceptance specification](docs/implementation/BTV_LORE_BRIDGE_V1_1_REMEDIATION_SPEC.md) — proposed safety, privacy, provenance, evidence-tier and test requirements; no source-code changes have been made.


### Ridgeview investigation design
- [Ridgeview Revelation & Evidence Matrix v0.1](docs/story/BTV_RIDGEVIEW_REVELATION_AND_EVIDENCE_MATRIX_v0.1.md) — source-traced claim/evidence relationships, uncertainty limits, outcome mapping and QA acceptance scenarios. Proposed analytical aid only; it does not add canon or final dialogue.
