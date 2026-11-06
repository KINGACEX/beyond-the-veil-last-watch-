# BTV RESEARCH-TO-DESIGN TRACEABILITY MATRIX
**Date:** 6 November 2026  
**Branch:** `btv/test-first-contracts-001`  
**Status:** WORKING GOVERNANCE REGISTER — RESEARCH IS NOT APPROVED DESIGN  
**Purpose:** Connect external production evidence and repository findings to BTV-specific decisions, failure checks and acceptance evidence without silently converting research into canon.

## 1. Status rules

- **CONFIRMED:** source or repository fact directly evidenced.
- **PROPOSED:** BTV application or acceptance requirement suggested by evidence; not approved architecture/canon.
- **UNKNOWN:** insufficient evidence or decision not yet made.
- **BLOCKED:** cannot responsibly proceed until a dependency or decision exists.
- **COMPLETED:** a scoped artifact or test has actually been delivered and verified.

A row may have confirmed research evidence while its BTV application remains proposed.

## 2. Traceability matrix

| Domain | Evidence / repository source | BTV relevance | Failure / loophole check | Acceptance evidence | Current status |
|---|---|---|---|---|---|
| Source authority and canon | Recovered source-of-truth index and merged Vertical Slice v1.0 | Keep implementation traceable to approved source, preserve historical drafts and unresolved conflicts | Old drafts, generated assets or tool output silently override approved source | Source ID, version, authority/review state, conflict register and review record | CONFIRMED foundation; ongoing reconciliation |
| Asset publishing | `BTV_BLENDER_GODOT_ASSET_PIPELINE_RESEARCH_2026-11-05.md` | Blender working assets publish through a controlled Godot import boundary; begin with neutral test asset | Duplicate IDs, material identity collisions, import-order dependence, untracked metadata | One neutral asset export/import fixture; inspect hierarchy, materials, scale and metadata | PROPOSED; asset fixture not implemented |
| Character and animation | `BTV_CHARACTER_AND_ANIMATION_PIPELINE_RESEARCH_2026-11-05.md`; `BTV_CHARACTER_RIGGING_AND_GAME_ANIMATION_CASE_STUDY_2026-11-05.md` | Separate animator controls from runtime/gameplay needs; validate retargeting and interruption | Successful import mistaken for correct deformation, bone rest, accessory tracks or gameplay transitions | Rig/import test, representative locomotion, turn, stop, interruption and camera review | PROPOSED; approved production models unavailable |
| World and environment construction | `BTV_WORLD_CONSTRUCTION_AND_ENVIRONMENT_ART_RESEARCH_2026-11-05.md` | Build semi-open interconnected regions with readable landmarks and transitions | Wilderness becomes confusing, POIs lack readable approach, art pass invalidates navigation/readability | Region brief, macro layout, functional blockout, route/landmark review, art revalidation | PROPOSED; no production region implemented |
| Navigation and region boundaries | `BTV_GODOT_WORLD_NAVIGATION_AND_REGION_BOUNDARY_RESEARCH_2026-11-05.md` | Use explicit region/navmesh boundaries and simplified navigation geometry | Decorative meshes bloat nav bake; overlapping regions or frequent map updates cause path issues | Navmesh connectivity, agent reachability, boundary and runtime bake tests in representative region | PROPOSED; world partitioning undecided |
| Save/load and recovery | `BTV_SAVE_LOAD_AUTOMATED_TESTING_AND_QA_RESEARCH_2026-11-05.md` | Define explicit persistent state, versioning, migration and safe recovery | Arbitrary scene-tree serialization, duplicate entities, partial writes, invalid mission state | Schema contract, corruption/interrupted-write/migration tests and recovery review | BLOCKED; save architecture not approved |
| UI/accessibility/input | `BTV_UI_ACCESSIBILITY_INPUT_AND_PRESENTATION_RESEARCH_2026-11-06.md` | Separate UI and gameplay actions; plan focus, subtitles, text scaling, audio channels and localization | Modal input leaks into gameplay; focus order guessed; colour/audio-only information; text clipping | UI-001–UI-012 acceptance gates in the research document | PROPOSED; no production UI |
| Mission scripting and dialogue | `BTV_MISSION_SCRIPTING_AND_DIALOGUE_PIPELINE_RESEARCH_2026-11-06.md`; Godot Resources docs; GDC dialogue-tool case studies | Separate authored mission/dialogue definitions, authoritative runtime state, presentation and validation | Shared Resource mutation leaks state; dialogue creates evidence; missing/unreachable branches; custom editor built prematurely | Stable-ID/reference/reachability checks, Resource isolation test, evidence-ownership test, all slice approaches reach coherent report | PROPOSED; no mission scripting or dialogue system implemented |
| Core interaction | `CORE_INTERACTION_003_EDGE_CASE_ACCEPTANCE_MATRIX.md`; `tests/core_interaction_acceptance_test.gd` | Deterministic nearest eligible interaction using shared keyboard/touch action | Disabled target cannot re-enable; stale/freed target; duplicate IDs; focus/pause/multitouch gaps | Automated tests for implemented cases; manual/device evidence for spatial/touch cases | PARTIAL — 28 matrix cases; subset automated |
| NLI request lifecycle | `NLI_003_HANDOFF_AND_SOURCE_REGISTRY_CONTRACT.md`; `BTV_NLI_CONTRACT_GAP_AUDIT_2026-11-06.md` | Keep validation, handoff, actor acceptance and execution distinct | NLI claims actor acceptance; stale callback; duplicate or competing requests; indefinite pending state | Adapter/actor contract tests, canonical request ID, expiry, cancellation and recovery tests | PARTIAL foundation; actor lifecycle BLOCKED |
| Source integrity and NPC knowledge | `nli_knowledge_base.gd`; NLI gap audit | Only approved, in-scope source records authorize speaker-scoped knowledge; dialogue is not evidence | Asserted hash mistaken for verified digest; withdrawn source remains usable; response text overstates source | Hash verification tests, source version/withdrawal tests and editorial passage review | PARTIAL; cryptographic verification and registry lifecycle absent |
| Ridgeview mission | `BTV_RIDGEVIEW_DATA_CONTRACT_RECONCILIATION_V1_0_2026-11-05.md`; Vertical Slice v1.0 | Preserve evidence provenance, five response approaches, uncertainty and fail-forward outcomes | Reserved Devourer reveal; repairman fate resolved without authority; optional evidence softlocks case | Data contract tests, prohibited-string scan, all five approaches reach coherent report | DESIGN reconciliation only; mission content not implemented |
| Scripture and ancient languages | `BTV_BIBLICAL_LANGUAGE_AND_SCRIPTURE_RESEARCH_BASELINE_2026-11-05.md` | Optional contextual study of Biblical Hebrew, Koine Greek and Biblical Aramaic | Scripture treated as magic/password; translation snippet detached from context; prayer made transactional | Source/context review, translation comparison, theological review and optionality check | RESEARCH baseline; implementation not approved |
| Mobile/platform validation | `BOOTSTRAP_STATUS.md`; Godot 4.7.2 CI workflow | Android-first intent requires evidence on actual target hardware | Headless/desktop success mistaken for Android readiness | Named device/OS, export/install, touch/safe-area, performance, memory, thermal and stability record | BLOCKED — target device not identified |

## 3. Cross-cutting production gates

### Gate A — Authority and provenance
Every player-facing factual claim, mission record, Scripture quotation and character asset must have a traceable source and review status. Unresolved conflicts remain visible.

### Gate B — Deterministic system ownership
Every state-changing system must have one authoritative owner. NLI may parse and validate; it does not own companion acceptance, mission state, inventory or world mutation. UI presentation does not promote dialogue into evidence.

### Gate C — Representative acceptance evidence
A passing unit test proves only its tested contract. It does not prove spatial readability, animation quality, device usability, accessibility conformance or a complete mission loop.

### Gate D — Platform readiness
Android readiness requires physical-device export/install and reproducible runtime evidence. CI version checks and headless scene launch remain necessary but insufficient.

### Gate E — Scope and theological integrity
Research must not expand the project into a full open world or introduce spiritual scoring, transactional prayer, purchasable salvation/faith/divine favour/holiness, supernatural command shortcuts or coercive evangelism.

## 4. Immediate next actions

1. **P0:** Specify NLI actor-owned lifecycle and canonical request identity; write failing tests before implementing an adapter.
2. **P0:** Define source hashing/versioning/withdrawal contracts before any mutable or external source ingestion.
3. **P1:** Close interaction acceptance gaps that have stable seams, especially unavailable target, held input, pause/resume and scene lifecycle.
4. **P1:** Define UI input contexts before building dialogue or HUD screens.
5. **P1:** Define a minimal authored mission/dialogue data contract and tests before writing production dialogue.
6. **P1:** Create a neutral Blender-to-Godot asset acceptance contract; do not use Asher or Ember as the first test asset.
7. **P1:** Continue Ridgeview content only after mission data contracts and source authority are reconciled.
8. **P2:** Keep save/load architecture deferred until persistent gameplay state and recovery semantics are approved.
9. **BLOCKED:** Record target Android device details before renderer comparison and device QA.

## 5. Change control

This matrix is a working register, not a canon document. Updating a row to APPROVED/LOCKED requires explicit creator review where the change affects canon, story, theology, character identity, progression, platform commitments or major architecture. A row may be marked COMPLETED only with a committed artifact and matching test/review evidence. No research result alone authorizes implementation.

## 6. Source register

- Godot 4.7 official documentation and release notes are linked in the individual research reports.
- Developer case studies and talks are linked in their corresponding research reports, with access limitations recorded there.
- Repository source paths and test files are linked by exact path in the table.
- No external claims in this matrix are intended to exceed the cited research documents.


## 7. Visual identity and technical graphics specification

| Domain | Evidence / repository source | BTV relevance | Failure / loophole check | Acceptance evidence | Current status |
|---|---|---|---|---|---|
| Visual art direction | Creator-approved visual identity decision, `docs/art/BTV_VISUAL_ART_BIBLE_v1.0.md` | Establish cinematic semi-realism, original character/environment language, art review and reference-game study rules | Reference games mistaken for assets to copy; unresolved Asher/Ember details invented; decorative detail obscures gameplay; visual effects contradict canon | Approved character references; region visual keys; provenance/licence records; concept/model/rig/import/gameplay review gates | APPROVED DESIGN direction; art bible committed; production assets not implemented |
| Technical graphics | `docs/technical/BTV_TECHNICAL_GRAPHICS_SPECIFICATION_v1.0.md`; `BOOTSTRAP_STATUS.md`; official Godot documentation | Translate Android-first quality ambition into renderer comparison, scalable tiers, asset acceptance and measurable device tests | Renderer selected without target device; frame-rate targets presented as achieved; fixed budgets invented before profiling; desktop/headless success mistaken for Android readiness | Named device matrix; neutral Blender-to-glTF-to-Godot test assets; renderer comparison; representative scene profile; sustained frame-time/memory/thermal and Android export/install record | Specification committed; renderer and device remain BLOCKED; 30/60 FPS are PROPOSED objectives only |

### Visual production gates added
1. Identify minimum supported Android hardware before renderer selection.
2. Validate a neutral asset pipeline before using production Asher or Ember assets.
3. Compare renderer options on representative scenes and actual hardware.
4. Establish asset budgets from measured representative assets/scenes, not guesses.
5. Preserve canon and asset provenance throughout concept, modelling, rigging, import and gameplay review.
