# BTV Prototype — Implementation Status

**Branch:** `btv/bootstrap-prototype-001`  
**Latest source milestone:** NLI knowledge-profile isolation and explicit question routing  
**Status:** SOURCE IMPLEMENTED — NOT ENGINE-VERIFIED

## Implemented in source

### Bootstrap 001 — 3D greybox foundation
- Godot project configuration and main scene.
- W/A/S/D and arrow-key movement actions.
- Flat collision floor and directional light.
- Capsule placeholder using CharacterBody3D.
- SpringArm3D and Camera3D rig.
- Basic GDScript movement controller.
- Generated Godot cache and export folders excluded from Git.

### Bootstrap 002 — interaction foundation
- `BTVInteractable` base Area3D contract with an overridable `interact(actor)` method.
- Neutral test interactable that returns a diagnostic result without changing game state.
- Player-owned forward proximity sensor configured to detect interactables on collision layer 2.
- E keyboard action invokes the nearest nearby interactable.
- Main test scene places the neutral interactable in front of the player.
- Compact repository engineering rules in `AGENTS.md`.

## Deliberate constraints
- No renderer is selected; compare supported options on the target Android device before deciding.
- The capsule is a temporary placeholder, not Asher's final model.
- Keyboard input is only a desktop smoke-test path. Touch-first controls remain required.
- No combat, enemies, Veil rules, Ember behaviour, faith systems, missions, economy, or narrative content has been introduced.
- No paid assets, paid services, or external runtime dependencies have been added.

### NLI 001 — Natural Language Interaction
- Deterministic phrase parser for initial question and companion-command vocabulary.
- Typed intent envelope and validation rules.
- Structured NPC knowledge records with provenance metadata, registered per-NPC scopes and authorized source allowlists.
- Explicit unknown-answer and conflicting-knowledge ambiguity behaviour.
- Evidence-marked dialogue rejection and duplicate statement protection.
- Exact question aliases; unsupported questions return clarification instead of guessed topics.
- In-memory request lifecycle guard for duplicate, completion and cancellation handling.
- NLI orchestration service that returns structured handoffs without directly mutating authoritative game state.
- Expanded headless smoke-test harness covering parser routing, source authorization, profile isolation, provenance, evidence rejection, ambiguity, request lifecycle and bounded handoff.
- Attack command is recognised but deferred pending its gameplay-system design gate.

## Verification still required
1. Open with the intended Godot 4.7.2 editor and confirm project import.
2. Check all scripts and scene resources for parse/load errors.
3. Run the main scene and verify floor collision, movement, gravity, camera and rotation.
4. Confirm the test marker appears ahead of the player.
5. Approach the marker and press E; confirm the diagnostic response appears in Output.
6. Leave sensor range and confirm E no longer invokes the target.
7. Compare renderer options on the actual Android target before selecting one.
8. Run `godot --headless --path . --script res://tests/nli_smoke_test.gd` and resolve any parser/test failures.
9. Add touch controls and test on-device.
10. Record actual device, frame time, memory, thermal behaviour and stability.

**No Godot editor run, parser check, NLI smoke-test run, runtime test, Android export, or device test has yet been recorded as passed for this branch.**

## Next implementation task
Run the expanded NLI smoke-test harness in Godot 4.7.2. After it passes, add isolated NPC test profiles and the ten Ridgeview knowledge-contract acceptance scenarios. In parallel, keep the touch-first interaction affordance as the next player-facing prototype task; do not add mission facts until canon review is complete.
