# BTV Prototype — Implementation Status

**Branch:** `btv/bootstrap-prototype-001`  
**Latest source milestones:** Bootstrap 001/002, NLI 001, knowledge-profile isolation, explicit question routing and initial Android touch overlay  
**Status:** GODOT 4.7.2 HEADLESS CI PASSED — ANDROID DEVICE VALIDATION PENDING

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
- Initial Android touch overlay with directional movement buttons and an INTERACT button, mapped to the same InputMap actions as keyboard controls.
- Compact repository engineering rules in `AGENTS.md`.

## Deliberate constraints
- No renderer is selected; compare supported options on the target Android device before deciding.
- The capsule is a temporary placeholder, not Asher's final model.
- Keyboard input remains available for desktop smoke testing. The touch overlay is source-implemented, but its layout and usability remain unverified on the Android target.
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

## Verification evidence

**CONFIRMED — GitHub Actions run 41671365779** on commit `f990811bd387a34a2df1fb77329ae81a99008078`:
- Godot 4.7.2 installation and version check passed.
- Headless editor import and project parsing passed.
- NLI smoke-test harness passed all 49 assertions.
- Main scene launched for 10 headless frames.
- Workflow: [BTV Godot Validation](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/41671365779).

This verifies the project import, tested scripts and headless scene startup on the Ubuntu CI runner. It does not verify rendered appearance, interactive movement, touch input, Android export, APK installation, physical-device performance or actual phone behaviour.

## Verification still required
1. Open with the intended Godot 4.7.2 editor on a desktop and inspect the rendered scene.
2. Run the main scene and verify floor collision, movement, gravity, camera and rotation interactively.
3. Confirm the test marker appears ahead of the player.
4. Approach the marker and press E; confirm the diagnostic response appears in Output.
5. Leave sensor range and confirm E no longer invokes the target.
6. Move between targets and verify nearest-target selection.
7. Compare renderer options on the actual Android target before selecting one.
8. Validate touch overlay layout, safe areas, scaling, multi-touch and interaction on-device.
9. Produce a debug APK with free tooling, install it, and record device/OS and test evidence.
10. Record performance, memory, thermal behaviour and stability.

## Next implementation gate

The headless CI gate has passed. Next, perform a visual/interactivity review of the current prototype, then isolate and test the Ridgeview NPC knowledge-contract scenarios. Do not add mission facts until canon review is complete. Android export and device testing remain a separate gate.

## Automated validation
- Workflow: `.github/workflows/godot-validation.yml`.
- Uses the free standard Ubuntu runner and installs Godot 4.7.2; no paid API key or external game-hosting account is required.
- The workflow runs on pushes to this development branch and can also be manually dispatched from GitHub Actions.
- Latest verified run: [41671365779](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/41671365779).
