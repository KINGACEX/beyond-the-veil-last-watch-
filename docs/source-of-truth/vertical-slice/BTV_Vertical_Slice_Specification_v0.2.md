# Beyond the Veil: The Last Watch
## Vertical Slice Specification v0.2 — Foundation Draft

**Status:** PROPOSED — implementation-planning draft; established facts below remain governed by the latest creator decisions  
**Date:** 2026-11-01  
**Authority:** Subordinate to the latest explicit creator decisions, BTV Master Canon, and the BTV Master Development Handoff. Where the sources conflict, stop and reconcile; do not silently choose.  
**Project state:** Treat the game repository as empty. Existing design bibles are in the ChatGPT Library. No playable build or implementation is verified.

---

## 1. Purpose

Define the smallest credible playable BTV experience that tests whether the game's central promise works in practice: ordinary Christian community life sits alongside a deeper spiritual conflict, and the player responds through discernment, investigation, service, and consequential choices—not combat alone.

This is a **vertical slice**, not the full game, not a complete open world, and not a commitment to final art quality. It must be small enough to build and test on Android first while keeping PC compatibility in view.

## 2. Source-of-truth rules

1. The latest explicit creator decisions supersede older documents.
2. Master Canon governs content canon; specialist bibles govern their domains; the Master Development Handoff governs workflow and canon protection.
3. The repository is considered empty. Do not imply that existing game code, scenes, assets, integrations, or tests exist.
4. The ChatGPT Library contains design references; a design document is not an implementation.
5. Do not turn UNKNOWN or PROPOSED details into canon merely to fill a gap.
6. Do not spend credits, make purchases, install paid tools, publish, deploy, or alter public repositories without explicit approval.
7. Preserve a record of asset provenance and licensing before integrating third-party or AI-generated content.

## 3. Established anchors relevant to this slice

- Title: **Beyond the Veil: The Last Watch**.
- Genre: original modern Christian action-adventure survival RPG.
- Primary protagonist: Asher Vance, age 18 in the current presentation; the selectable male/female Chosen system is retired and Asher is the sole primary playable protagonist/Chosen. The name “Kael” is an obsolete internal placeholder, not a canon character.
- The Covenant is a hidden service/protection organization, not a replacement for Christ, the Church, or government by default.
- Faith is not a currency, score, purchasable advantage, or grindable progression statistic. Prayer is not a transaction; the Holy Spirit is not a player-controlled combat resource.
- The in-game fictional church for the vertical slice is **Logos Rhema Temple**. Harvest Chapel International is real-world inspiration only and must not appear in-game under its real name.
- The planned service order is flexible: Arrival & Fellowship; Welcome; Praise & Worship; Prayer; Scripture Reading; KITFIT; Offering; Sermon; Response/Reflection; Communion when scheduled; Announcements; Closing Prayer; Fellowship & Service. The acronym KITFIT remains undefined and must not be expanded by assumption.
- A Scout Report leads toward an investigation at **Ridgeview Outpost**.
- The Devourers are an established enemy/group concept for this mission. Their scene should be disturbing through atmosphere and choices, not graphic depiction. The listed approaches are Speak/Preach, Investigate, Rescue, Defend, and Withdraw.
- Established Ember command set: Attack, Protect, Scout, Track, Retrieve, Hold, Regroup. “Stay” is legacy/informal wording for Hold; Follow and Guard are not official commands. Ember's species and origin remain unknown.
- Established Veil-stage framework: Normal, Disturbed, Influenced, Veil-Touched, Veil Breach, and Critical/Endgame-Level. The Veil’s origin, ultimate metaphysics, and limits remain unknown.
- BTV's world should show substantially more ordinary civilians than Covenant personnel in public spaces.

These anchors are drawn from the BTV Master Canon and the Library's BTV Canon Changelog & Reconciliation. Any conflict with a later explicit creator decision must be surfaced and reconciled.

## 4. Slice player journey

### Segment A — Arrival at Logos Rhema Temple
**Purpose:** Establish a believable ordinary community space before the mission escalation.

Minimum experience:
- Enter a small church/temple grounds or foyer with a few civilian NPCs.
- Move and look around using touch controls suitable for Android.
- Interact with at least one NPC through a short, authored dialogue exchange.
- Observe optional service/fellowship activity without forcing the player into a sermon or making participation a reward loop.
- If Communion is represented, it must be gated by an explicitly scheduled context and the `CommunionContextZone`; it must not be an always-available consumable or stat interaction. Communion can be omitted from the first build if that scope is not ready.

Boundaries:
- No faith meter, prayer reward, donation buff, salvation points, or spiritual ranking.
- Do not use real HCI names or real pastors as in-game organizations/characters.
- Do not invent the expansion of KITFIT.

### Segment B — Scout Report
**Purpose:** Bridge community life into Covenant responsibility without an exposition dump.

Minimum experience:
- The player receives or reviews a concise Scout Report describing a concern at Ridgeview Outpost.
- Report UI distinguishes confirmed observations, interpretation, and unknowns.
- Player can open a mission brief and review the known objective before leaving.
- The report gives a reason to investigate; it does not automatically prove a supernatural explanation or mark every unknown as hostile.

Boundaries:
- Covenant members can be mistaken; the organization is not omniscient or infallible.
- Do not introduce an unapproved named commander, city, faction history, or Veil rule to make the report sound complete.

### Segment C — Ridgeview Outpost investigation
**Purpose:** Test exploration, evidence gathering, uncertainty, player agency, and proportionate consequences.

Minimum experience:
- A compact outpost space with a clear navigation route and a few meaningful points of interest.
- At least three inspectable evidence items or environmental clues. Their content must be authored in a separate mission script and checked against the Veil & Enemy Encyclopedia before implementation.
- A readable objective log that updates when evidence is found.
- A decision point that supports the five established approaches: Speak/Preach, Investigate, Rescue, Defend, or Withdraw. These should be represented as player approaches, not as a morality score.
- Outcomes are acknowledged in dialogue or mission state. Avoid implementing permanent world-state complexity until the base loop is tested.

Boundaries:
- Keep the Devourers' depiction non-graphic and choice-driven.
- Do not make every approach a combat encounter.
- Do not establish the Devourers' full origin, the Veil's ultimate metaphysics, or a final antagonist identity in this slice unless already approved elsewhere.
- No universal morality meter or numeric spiritual score.

## 5. Minimum playable systems

### Required for the first prototype
1. **Player locomotion:** basic third-person movement, camera control, collision, and an interaction range.
2. **Interaction layer:** one reusable interact prompt and a small interaction interface for NPCs, report terminals/documents, and evidence.
3. **Dialogue:** authored dialogue nodes with explicit choices; no generative dialogue required.
4. **Mission state:** simple, explicit states such as `NotStarted`, `ReportRead`, `Investigating`, `EvidenceCollected`, `DecisionMade`, `Resolved`.
5. **Evidence journal:** tracks discovered clues and clearly labels uncertain interpretations.
6. **Scene flow:** Temple → report/transition → Ridgeview Outpost → outcome/return state.
7. **Touch-first UI:** readable text, comfortable buttons, safe-area handling, and control remapping or sensitivity options where feasible.
8. **Basic persistence:** save enough state to resume or restart the slice reliably. Exact save/retry policy for the full game remains open.
9. **Debug visibility:** a development-only way to inspect mission state and interaction events without shipping debug UI to players.

### Explicitly out of scope for v0.1
- Full open world or streaming architecture.
- Full combat, weapon inventory, or final enemy AI.
- Full Covenant hierarchy simulation, promotion rules, or strategic command system.
- Final Armor of God acquisition/progression or numerical combat statistics.
- Final Ember species, origin, or complete companion AI. Ember can be absent from the first playable slice unless a previously approved handoff requires it.
- Economy simulation, exact prices, crafting, durability, rarity tables, or XP curves.
- Multiplayer, live service, online accounts, analytics, or monetization.
- Final cinematic/voice acting, bespoke high-poly characters, or production-grade 3D assets.
- Paid asset generation or credit-consuming services.

## 6. Technical direction — proposed, pending project setup and device verification

- **Engine/version:** The Library’s Canon Changelog records Godot 4.7.2 stable with GDScript as the approved direction. Before bootstrapping, verify the official release and export-template availability; do not silently upgrade the project version. Record the chosen exact version in the README and project settings.
- **Language:** GDScript, as recorded in the Library’s Canon Changelog.
- **Renderer:** Do not lock this based only on theory. Godot documents Compatibility as the broadest option for older/low-end devices, while Mobile targets newer Vulkan-capable devices. Begin with a small renderer test on the actual target Android phone before choosing. See official documentation links below.
- **Scene architecture:** separate scenes for Temple, Scout Report/mission briefing, Ridgeview Outpost, and shared UI; use reusable components for interaction, dialogue, evidence, and mission state.
- **Data:** keep authored dialogue, clue descriptions, mission objectives, and outcome mappings separate from presentation code where practical.
- **Assets:** use simple placeholders first. Establish scale, naming, collision, material budgets, licensing, and performance limits before any expensive/high-detail asset work.
- **Version control:** Git with small, meaningful commits once the project is initialized. Never overwrite the empty repository's history or claim commits without a verified write.

## 7. Proposed project structure

```text
BeyondTheVeil/
  project.godot
  README.md
  CHANGELOG.md
  docs/
    BTV_Vertical_Slice_Specification_v0.1.md
    BTV_Asset_Registry.csv
    BTV_Test_Plan.md
    canon/
      canon_index.md
  scenes/
    temple/
    mission_briefing/
    ridgeview_outpost/
    ui/
  scripts/
    player/
    interaction/
    dialogue/
    mission/
    evidence/
    save/
  data/
    dialogue/
    missions/
    evidence/
  assets/
    placeholder/
    environment/
    characters/
    ui/
  tests/
```

This is a proposed target layout, not a description of existing files.

## 8. Acceptance criteria

The slice is not accepted because it launches once or looks convincing in a screenshot. It passes only when evidence exists for each applicable criterion.

### Functional
- The player can enter the Temple, move, interact, read the Scout Report, transition to Ridgeview, inspect evidence, choose an approach, and reach a clearly acknowledged outcome.
- Mission-state transitions are deterministic and cannot accidentally skip required steps through repeated interactions.
- Dialogue and evidence UI can be closed/reopened without losing the correct mission state.
- Save/restart behavior is repeatable and documented.

### Canon and narrative
- No contradiction with the Master Canon or latest creator decisions.
- Faith, prayer, Scripture, Communion, and giving are not represented as transactional buffs or spiritual scores.
- The Church and Covenant remain distinct.
- Unknowns are presented as unknowns rather than hidden facts.
- Devourers content remains non-graphic and permits meaningful non-combat responses.

### Android usability and performance
- Core controls are usable on the actual target device; target device model and OS must be recorded before acceptance.
- Text is readable at normal phone viewing distance; interactive controls do not overlap critical text or each other.
- No reproducible crash or softlock in the defined test route.
- Performance, memory, battery/thermal behavior, and load times are measured on-device rather than guessed. Numerical targets are to be set after baseline measurement on the target device.

### Production quality
- Every non-placeholder asset has source/provenance and license status recorded.
- No paid or credit-consuming dependency is required to complete the minimum slice.
- Project opens from a clean checkout and the documented test route can be reproduced.

## 9. Test plan outline

1. **Clean-open test:** clone/open the project from a clean state; confirm Godot version and project import.
2. **Navigation test:** Temple to report to Ridgeview and back/outcome path.
3. **Interaction test:** repeated, cancelled, out-of-range, and conflicting interactions.
4. **Mission-state test:** verify every state transition and reject invalid transitions.
5. **Evidence test:** each clue updates the journal once; repeated inspection does not duplicate it.
6. **Choice-path test:** run each of the five approaches and verify an acknowledged result without spiritual scoring.
7. **Save/restart test:** save at defined checkpoints, close/reopen, and verify state integrity.
8. **Touch/UI test:** different aspect ratios if available, safe areas, text scale/readability, and touch target usability.
9. **Android performance test:** record device, renderer, resolution, frame-time observations, memory, load times, and any thermal degradation.
10. **Canon audit:** check narrative, dialogue, UI labels, rewards, and outcomes against all relevant bibles.

No tests have been run; this is the proposed test plan.

## 10. Work sequence and gates

### Gate 0 — Design source reconciliation
- Identify latest approved creator decisions in the handoff and changelog.
- Mark cross-document conflicts and reserved areas.
- Create a short canon index linking the authoritative bibles.
- Exit only when the slice's named content and scope are consistent.

### Gate 1 — Empty-project bootstrap
- Create a clean Godot project, README, folder structure, and version record.
- Choose renderer only after a target-device test.
- Add a simple start scene and verify launch.

### Gate 2 — Graybox traversal and interaction
- Build placeholder Temple and Outpost spaces.
- Implement movement, camera, interaction, and scene transitions.
- Verify touch controls on device.

### Gate 3 — Mission loop
- Add Scout Report, evidence journal, mission state, five approach choices, and outcome acknowledgment.
- Test state transitions and save/restart behavior.

### Gate 4 — Canon, usability, and performance pass
- Reconcile content against the bibles.
- Test on the target phone and record actual results.
- Fix blockers before adding high-cost visuals.

### Gate 5 — Visual target and asset pipeline
- Establish visual target with concept references and approved placeholder swaps.
- Test one small environmental asset end-to-end before scaling up asset production.
- Hyper3D/Rodin remains optional and conditional; no credits are to be spent without explicit approval.

## 11. Risks and mitigations

- **Scope expansion:** enforce the three-segment slice and keep full-world systems out of v0.1.
- **Canon drift:** use a canon index and review every narrative/system addition against authoritative bibles.
- **Premature high-detail art:** graybox first; validate gameplay and target-device performance before detailed assets.
- **Unknown hardware capability:** record the actual target device and test renderers instead of guessing.
- **Asset licensing/provenance gaps:** maintain an asset registry; do not integrate unclear-license assets into a release candidate.
- **AI-generated overconfidence:** treat all generated content as a proposal until canon-reviewed and tested.
- **Tool/credit lock-in:** keep a free/manual fallback and avoid paid dependencies in the minimum slice.

## 12. Open questions intentionally not resolved here

- Exact target Android phone and minimum supported hardware.
- Confirmation that the recorded Godot 4.7.2 release and export templates are available in the intended development environment; do not change version without evidence and a documented decision.
- Final renderer.
- Detailed Temple layout, exact service scene dialogue, and which service moments appear in the first build.
- Specific Scout Report wording and evidence details.
- Exact Devourers encounter behavior and outcome content.
- Whether Ember appears in v0.1.
- Final combat design, Armor of God mechanics, and exact Veil rules.
- Save/retry policy beyond the minimum repeatable prototype.
- Visual style guide, asset budgets, final character model specifications, and animation targets.

These remain OPEN/UNKNOWN or PROPOSED; no silent canon decisions are made here.

## 13. Official technical references

- Godot Android export guide: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html
- Godot renderer overview: https://docs.godotengine.org/en/stable/tutorials/rendering/renderers.html
- Godot system requirements: https://docs.godotengine.org/en/stable/about/system_requirements.html

These references explain current engine capabilities and setup considerations; they do not prove BTV has been configured or tested.

---

## Current status ledger

| Work item | Status | Evidence / next action |
|---|---|---|
| Existing BTV design references | CONFIRMED | Relevant Master Canon, Story & Lore, Mission/Progression/Economy, Veil/Enemy, Covenant, Faith/Prayer, and Changelog files found in ChatGPT Library. |
| Game repository implementation | BLOCKED / EMPTY BY CREATOR DIRECTION | Treat as empty; no code or runnable project assumed. |
| Vertical slice definition | PROPOSED | This document is the first implementation-planning draft; requires canon reconciliation before coding. |
| Godot project bootstrap | BLOCKED | No verified project workspace/build environment is connected; bootstrap requires an authorized workspace and version check. |
| Android testing | BLOCKED | Requires a real build and target device; no tests have been run. |
| 3D asset generation | BLOCKED / DEFERRED | No credits or paid services used; first validate a small asset pipeline and licensing. |


## Status vocabulary used in current project tracking

- **CONFIRMED:** directly supported by a creator decision or authoritative source.
- **PROPOSED:** a recommended design or implementation choice awaiting approval where approval is required.
- **UNKNOWN:** not established; do not invent.
- **BLOCKED:** cannot proceed until a named dependency or permission is available.
- **COMPLETED:** finished with evidence recorded.

This operational vocabulary follows the current BTV working preference. Older bibles may use CANON, APPROVED DESIGN, CANON DIRECTION, RESERVED, CONFLICT, or related labels; preserve their meaning when reading older documents and reconcile status changes explicitly.