# BTV SAVE/LOAD, AUTOMATED TESTING AND QA PRODUCTION RESEARCH
**Date:** 5 November 2026  
**Status:** OFFICIAL GODOT DOCUMENTATION + DEVELOPER CASE STUDIES  
**Project:** Beyond the Veil: The Last Watch  
**Scope:** Persistent game state, serialization, automated gameplay tests, regression testing and QA process.

## 1. Godot 4.7 save/load guidance

Official source: https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html

Godot's saving-games tutorial frames save systems as a problem of identifying persistent state across multiple objects and scenes. Its example uses a group to identify persistent objects, asks each object for the data it owns, serializes that data, and reconstructs the objects/state during load.

Important distinctions:
- Save-game state is different from user configuration. Godot recommends ConfigFile for configuration settings.
- A save system should explicitly identify which objects and data persist between sessions.
- Serialization should use a deliberate schema; objects should not simply dump arbitrary runtime state.
- Loading must restore a known game state and avoid accidentally duplicating persistent objects.
- Errors and missing/invalid save files need explicit handling.

Official related resources:
- Saving games: https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
- ConfigFile: https://docs.godotengine.org/en/stable/classes/class_configfile.html
- JSON: https://docs.godotengine.org/en/stable/classes/class_json.html
- FileAccess: https://docs.godotengine.org/en/stable/classes/class_fileaccess.html
- Saving and Loading (Serialization) demo: https://github.com/godotengine/godot-demo-projects/tree/master/loading/serialization

## 2. Save-system design lessons for BTV

The following is **PROPOSED** and not an approved implementation design.

### 2.1 Define persistent state before choosing a file format
Potential categories to evaluate against BTV's approved vertical slice:
- player position and region/scene identity;
- mission stage and objective completion;
- evidence records and their provenance;
- NPC/companion state that is explicitly allowed to persist;
- inventory/equipment only after those systems are canonically defined;
- settings and accessibility options (configuration, not narrative save state).

Do not add unapproved fields simply because the engine can serialize them.

### 2.2 Prefer explicit save contracts
Each persistent system should define:
- schema version;
- stable object/record identity;
- fields it owns;
- validation rules;
- defaults for missing optional fields;
- migration policy when the schema changes;
- failure behaviour when data is malformed or incomplete.

Do not serialize arbitrary NodePaths or depend on the current scene-tree layout remaining identical forever.

### 2.3 Save and load must be transactional from the player's perspective
A robust save flow should define:
- when saving is permitted;
- what happens if a save is interrupted;
- how corruption or partial writes are detected;
- whether the previous valid save is preserved;
- how load failure returns the player to a safe state;
- how scene/mission state is reconstructed without duplicating actors or evidence.

No BTV save format, save slots or auto-save policy is approved by this research.

## 3. Developer case study: automated gameplay testing in Sea of Thieves

**Primary developer talk:** Robert Masella, Rare, “Automated Testing of Gameplay Features in Sea of Thieves” (GDC 2019; public recording posted by GDC).  
https://www.youtube.com/watch?v=X673tOi8pU8

The talk describes why Rare adopted automated testing beyond conventional manual testing:
- Sea of Thieves was an open-world game with many interacting systems.
- The game was expected to evolve continuously, creating regression risk.
- The team wanted faster confidence in changes and a shorter release verification cycle.
- Manual testing alone was described as slow and unreliable for catching every interaction failure.
- The talk demonstrates testing gameplay features and the team's approach to building and improving a test framework.

The speaker describes a key failure pattern: a developer tested a change in a simple test environment that did not contain the conditions needed to expose a bug. A later test/play scenario with more relevant geometry revealed the issue. The lesson is that test fixtures must reproduce the conditions that matter; merely launching a feature in a simplified scene is not enough.

**BTV implication:** headless tests are valuable for contracts and regressions, but spatial behaviour also requires representative scenes and manual/editor/device checks. The current BTV interaction tests should be complemented by later visual and physical-device tests, not treated as substitutes for them.

## 4. QA as a production discipline

**Primary developer talk:** Michael Vork Larsen, RETO MOTO, “A QA Perspective on Live Game Production” (GDC 2019).  
https://www.youtube.com/watch?v=cMxNTsD-DaQ

The talk presents QA from the perspective of a game that moved through closed beta, open beta, release and ongoing updates. The speaker describes the need to adapt testing as player populations and update cadence changed, and the value of structured feedback from dedicated players during earlier testing stages.

For BTV, the transferable lesson is not live-service operation. It is that QA needs to evolve with the project's stage:
- early prototype: validate the core loop and technical assumptions;
- vertical slice: validate the end-to-end production pipeline and player experience;
- content production: regression-test shared systems as more content is added;
- release preparation: test full platform, save/load, performance, accessibility and recovery paths.

## 5. Vertical slice as a production gate

**GDC session:** Greg Donovan, Volition, “The Vertical Slice Challenge” (GDC 2015).  
https://gdcvault.com/play/1022328/The-Vertical-Slice

The session description defines the vertical slice as a gate for determining whether the team is ready to move from pre-production into production. It should demonstrate that the team understands both what it is making and how to make it, and must serve internal and external goals.

This supports BTV's existing separation between:
- the narrative/experience target described in the recovered Vertical Slice v1.0 design document; and
- the engineering/production proof that BTV can build and validate the experience using a repeatable pipeline.

A written mission flow is not itself proof that the full playable pipeline works.

## 6. Proposed BTV QA matrix

| Test layer | Purpose | Example evidence |
|---|---|---|
| Unit/contract tests | Validate a small rule or API invariant | NLI request state and source resolution tests |
| Integration tests | Validate communication across systems | NLI-to-companion adapter acknowledgement |
| Scene tests | Validate scene composition and node contracts | Scene import, actor availability and teardown |
| Gameplay acceptance | Validate player-visible behaviour | Interaction selection, target invalidation and mission flow |
| Regression tests | Ensure fixes do not break earlier behaviour | Run established suites after every relevant change |
| Visual/manual QA | Validate spatial readability and presentation | Camera, lighting, route and animation review |
| Platform QA | Validate actual device constraints | Android input, memory, performance and thermal tests |
| Recovery tests | Validate failure paths | Save interruption, reload, missing asset and corrupted data handling |

## 7. Loophole and failure checks

| Risk | Required contract/test |
|---|---|
| Save includes unapproved or transient state | Explicit allowlist of persistent data |
| Duplicate entities after loading | Stable IDs and load-time deduplication |
| Old save schema breaks after update | Versioned schema and migration tests |
| Partial save overwrites last good save | Atomic/backup strategy and interrupted-write test |
| Invalid data creates impossible mission state | Validate before applying; recover safely |
| Headless test passes but spatial issue remains | Representative scene and manual visual QA |
| Test fixture omits the trigger condition | Fixture coverage review against real gameplay context |
| Shared feature regresses when content grows | Regression suite in CI |
| QA only checks happy paths | Failure, cancellation, teardown, pause/resume and reload tests |
| Release gate is confused with one successful launch | Separate criteria for code, content, visual, platform and recovery readiness |

## 8. BTV-specific safeguards
- Save data must not create spiritual scoring, prayer transactions, salvation/faith/holiness purchases or divine-favour tracking.
- Communion context and church/Covenant separation must remain correct after reload.
- Mission/evidence persistence must preserve provenance and must not silently promote dialogue into evidence.
- Companion state must not imply omniscience or guaranteed supernatural guidance.
- Do not implement a save system before persistent gameplay data and mission-state ownership are defined.
- No Android readiness claim from desktop or headless tests.

## 9. Sources and limitations
- Godot 4.7 official documentation is authoritative for the engine's save/load examples and APIs, but the tutorial is a starting point rather than a complete production save architecture.
- Sea of Thieves and Heroes & Generals are different products from BTV. Their QA practices are examples, not direct staffing or release-process prescriptions.
- The GDC Vertical Slice session is available as an official session description; full session access was not available during this review.
- No save/load system or new QA automation was implemented in BTV as a result of this research.

## 10. Next research
- Godot resource-based save data versus JSON/ConfigFile trade-offs, with explicit schema/version and recovery design.
- Mission-state and evidence persistence contracts aligned with the recovered BTV vertical slice.
- UI/UX and accessibility testing, especially Android touch input.
- Audio and cinematic interruption/recovery QA.
- A complete BTV production acceptance gate and research-to-implementation traceability matrix.
