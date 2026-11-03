# Beyond the Veil: The Last Watch

BTV is a Christian action-adventure survival RPG set in a modern world of spiritual conflict, exploration, survival, and the Covenant's Last Watch.

## Current repository state

The `btv/bootstrap-prototype-001` branch contains a Godot 4 3D greybox prototype foundation and the first reusable interaction test:

- `project.godot` — project entry point, movement actions and E interaction action.
- `scenes/main.tscn` — greybox test area with a neutral interactable marker.
- `scenes/player.tscn` — capsule placeholder, collision, third-person camera and proximity sensor.
- `scripts/player_controller.gd` — movement and nearest-interactable input handling.
- `scripts/interactable.gd` — reusable Area3D interaction contract.
- `scripts/test_interactable.gd` — neutral test implementation.
- `AGENTS.md` — concise repository engineering rules.
- `scripts/nli/` — deterministic NLI parser, validator, request gate, authored knowledge base and orchestration service.
- `tests/nli_smoke_test.gd` — headless NLI acceptance smoke-test harness.

## Read these first

1. [Bootstrap 001 — One-Read Project Handoff](docs/implementation/BOOTSTRAP_001_ONE_READ.md) — original scaffold, decisions, boundaries and verification status.
2. [Bootstrap 002 — Reusable Interaction](docs/implementation/BOOTSTRAP_002_INTERACTION.md) — current interaction architecture and acceptance checks.
3. [NLI 001 — Natural Language Interaction](docs/implementation/NLI_001_FOUNDATION.md) — deterministic NPC questions, validated companion requests and knowledge boundaries.
4. [Current Implementation Status](docs/implementation/BOOTSTRAP_STATUS.md) — concise scope, limitations and next gate.

## Intended toolchain

The current development gate identifies Godot 4.7.2 as the intended version. Confirm the installed editor and export templates before treating this as a validated project. The renderer is deliberately not selected yet; compare supported renderers on the actual target Android device before deciding.

## Open and run

1. Download or check out the `btv/bootstrap-prototype-001` branch.
2. Open the project folder in Godot 4.7.x.
3. Allow the project to import and inspect the Output/debugger panels.
4. Run the project (F5 / Run Project).
5. Use W/A/S/D or arrow keys to move the capsule.
6. Approach the test marker ahead of the player and press E. The diagnostic interaction response should appear in the Output panel.

This is a greybox prototype, not a playable vertical slice or finished game. Touch controls, on-screen prompts, saving, Android export, and performance validation are not implemented. No Godot editor import, parser check, runtime test, Android export, or physical-device test has yet been recorded as passed.

## Status

**Bootstrap 001 and 002 plus NLI 001 source changes committed; engine and test-harness validation pending.** Work remains on `btv/bootstrap-prototype-001`; it has not been merged into `main`.
