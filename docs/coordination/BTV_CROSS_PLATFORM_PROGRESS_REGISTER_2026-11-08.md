# BTV Cross-Platform Progress Register

**As of:** 2026-11-08  
**Branch:** `btv/project-history-and-lore-bridge-001`  
**Purpose:** Consolidate BTV work completed across repository development, ChatGPT coordination, external-agent planning, media production and the MiniMax Lore Bridge review.  
**Evidence rule:** A document, plan, rendered preview, static review or CI result must not be described as a connected agent, production-ready feature, playable game or user-approved canon unless the relevant evidence supports that claim.

## 1. Executive status

BTV has a substantial design and engineering foundation, but it is not a finished game and the cross-platform AI team is not yet operationally connected.

| Workstream | Current status | Evidence boundary |
|---|---|---|
| Canon and source-of-truth library | DOCUMENTED | The repository contains a 22-document recovered source library and an authority hierarchy. Older imported text is not automatically current canon. |
| Godot prototype | IMPLEMENTED FOUNDATION | Greybox project, player placeholder, interaction system, initial touch overlay, NLI contracts and tests exist on `btv/test-first-contracts-001`. |
| Automated validation | HEADLESS CI PASSED | Latest README-recorded successful validation: run 42189615410 on commit `c91094d99b5462d8b69f249ba579e8316dc09137`. This is not physical Android validation. |
| Full vertical slice | NOT IMPLEMENTED | Logos Rhema → Scout Report → Ridgeview remains a design target, not a completed playable slice. |
| Multi-agent framework | DOCUMENTED / NOT CONNECTED | Claude, MiniMax Code and ChatGPT charters and handoff rules are in this branch. External MCP connections and permissions remain unverified. |
| MiniMax Lore Bridge | EXTERNAL ZIP REVIEWED STATICALLY | Architecture and source were inspected; not installed, executed, registered or security-tested. |
| Trailer | DRAFT RENDER EXISTS | A 55-second 720p illustrative-stills render exists in Screel. It is not gameplay footage and is not published. |
| Descript trailer | INCOMPLETE / CREDIT-LIMITED | The project and media assets exist; AI edit attempt failed for insufficient credits. No completed timeline/export was verified. |
| YouTube release | NOT PUBLISHED | Channel content remains a draft. No upload or public release was performed. |

## 2. Repository and engineering work

### Current engineering base

The active engineering baseline is `btv/test-first-contracts-001`, originating from `btv/bootstrap-prototype-001`. This documentation branch was created from that baseline so the project record does not displace or rewrite the engineering branch.

The current prototype documentation records:
- Godot project entry point and greybox main scene.
- CharacterBody3D capsule placeholder with collision, third-person camera and proximity sensor.
- Keyboard movement and interaction actions.
- Initial touch overlay using shared InputMap actions.
- Reusable Area3D interactable contract and nearest-target selection.
- NLI phrase parsing, typed intent validation, authored knowledge records, provenance and per-NPC scope.
- NLI request gate and orchestration service.
- Neutral mission-data registry validator (Phase 1 only).
- Headless CI tests for project import, NLI contracts, core interactions and a short main-scene launch.

Read `docs/implementation/BOOTSTRAP_STATUS.md` and the README for the detailed implementation and verification boundaries. Do not infer full NLI lifecycle completion, mission content, combat, Ember behaviour, Veil rules or Android readiness from the existing foundation.

### CI evidence

The repository README identifies run **42189615410**, commit `c91094d99b5462d8b69f249ba579e8316dc09137`, as the latest successful code/test validation at the time of that README revision. It includes canonical NLI request-ID boundary tests, query/action lifecycle semantics, cancellation tests, neutral mission-registry validation, core interaction acceptance and a 10-frame main-scene launch.

CI does not establish physical Android export or installation, real-device touch usability, renderer suitability, sustained frame time, memory or thermal stability, visual quality, manual gameplay feel, save/load completeness or a playable vertical slice.

### NLI and source integrity

Prior implementation work added a deterministic NLI parser/validator/request gate, source provenance and registry integrity mechanisms. A SHA-256 digest establishes byte-level integrity only; it does not establish source authority, creator approval, truth, freshness or permission to use a fact in a particular scene. The NLI must not claim an actor accepted or executed an action until the actor-owned acknowledgement and lifecycle exist.

## 3. Multi-agent development framework

The nine multi-agent governance documents originally created on `btv/multi-agent-system-v1` have been ported into this branch. They define the creator-led roles for Claude (Visual Director), MiniMax Code (Implementation Agent) and ChatGPT (Lead Coordinator), with task handoffs, visual standards, repository boundaries, decision logging and activity logging.

The nine paths are indexed in the root README and source-of-truth index. These are documented roles, not proof of active MCP connectivity. Each external client still needs a separately verified, least-privilege connection and a successful handoff test.

## 4. Story, character and world-design records ported

The following existing records have also been ported from the earlier design branch into this branch:

- `docs/characters/KAY_FAMILY_CHARACTER_BIBLE_v1.0.md`
- `docs/characters/KAY_FAMILY_NAMING_ADDENDUM_v1.1.md`
- `docs/design/BTV_GLOBAL_CHARACTER_NAMING_AND_CULTURAL_REPRESENTATION_FRAMEWORK_v0.1.md`
- `docs/design/BTV_ANNUAL_COMMUNITY_CALENDAR_FRAMEWORK_PROPOSAL_v0.1.md`
- `docs/design/CHURCH_FESTIVAL_AND_COMMUNITY_EVENT_FRAMEWORK_PROPOSAL_v0.1.md`
- `docs/design/BTV_NEW_GAME_NPC_GENERATION_AND_CHRISTIAN_NAME_LEXICON_PROPOSAL_v0.1.md`
- `docs/agents/BTV_STORY_DEVELOPMENT_AGENT_CHARTER_v0.1.md`
- `docs/story/BTV_STORY_GAP_REGISTER_INITIAL_TRIAGE_v0.1.md`
- `docs/story/BTV_VERTICAL_SLICE_OPENING_TO_RIDGEVIEW_NARRATIVE_FLOW_v0.1.md`

The calendar, festival and NPC-generation records are proposals, not approved canon. The story charter defines review workflow, not authority to invent unresolved lore. The controlling source-of-truth hierarchy and creator decisions remain higher authority.

## 5. MiniMax BTV Lore Bridge — external artifact review

The creator supplied `btv-lore-bridge.zip` for review. SHA-256 of the reviewed ZIP:

`3c045fb5148b96caa7c71697ebff5bbed191b316e6094e7de0e191374245bb71`

The project is a local Node.js/MCP knowledge bridge intended to make a curated BTV knowledge corpus available to coding assistants. Its visible components include corpus/index building, search, an MCP server, repository file access, gap analysis, registration scripts, a Claude-oriented shell pipeline and a smoke-test fixture.

The review was static only. No installation, dependency execution, MCP registration, network exposure or live test was performed.

Key risks identified: destructive corpus rebuild scope; registration scripts that may remove existing configuration; unsafe invalid-config recovery; keyword-only gap analysis; incomplete conversation-branch coverage; generated code not validated by Godot; privacy risks from broad ChatGPT exports; and unverified Claude mobile compatibility. See `docs/audits/BTV_LORE_BRIDGE_STATIC_REVIEW_2026-11-08.md` for required remediations and acceptance gates.

## 6. Trailer and channel production

A separate Screel project produced a 55-second, 720p draft render using five generated still images, subtle motion, five Charon narration clips and captions. It is illustrative material, not gameplay footage; it does not establish canonical Asher or Ember designs. The render requires human playback review. Screel had zero remaining credits at the last audit.

The original Descript project remains incomplete. A Mike narration asset was imported to its media bin only; the AI edit attempt failed for insufficient free credits. No final Descript export was verified.

The official YouTube channel has draft concepts and release metadata only. No public upload or publication was performed. Full references and review gates are in `docs/media/BTV_TRAILER_PRODUCTION_STATUS_2026-11-08.md`.

## 7. Story and canon direction

The intended opening slice remains Sunday/community at Logos Rhema Temple → Covenant Scout Report → travel and investigation at Ridgeview → evidence-based response → final report grounded in what the player actually observed and verified.

Preserve distinctions between observed, reported, inferred and unconfirmed information. A meaningful local conclusion must not prematurely resolve the wider Veil mystery. Do not treat generated mockups, old handoffs or proposals as canon.

## 8. Safety, privacy and creator-control constraints

- Do not commit API keys, OAuth secrets, access tokens, passwords or private exports.
- Treat any credential pasted into chat as compromised and revoke it at its issuer; never copy it into this repository.
- Do not ingest a full personal ChatGPT export into a shared corpus without BTV-only filtering and privacy review.
- Do not delete repository content, rewrite history, change GitHub security settings, merge, publish, deploy, purchase or spend paid credits without explicit creator approval.
- Prefer feature branches, small reversible changes, evidence-linked commits and append-only logs.
- Keep canon, approved design, proposal, implementation and test evidence as distinct states.

## 9. Immediate next actions

See `docs/coordination/BTV_NEXT_EXECUTION_PLAN_2026-11-08.md`. The priority is to make the Lore Bridge safe to evaluate, prove a minimal end-to-end agent handoff, and continue the engineering branch's existing test-first work. No new gameplay system should be invented merely to make the project appear more complete.


## 10. Lore Bridge v1.1 remediation specification

A follow-on engineering specification has been added at `docs/implementation/BTV_LORE_BRIDGE_V1_1_REMEDIATION_SPEC.md`. It defines the non-destructive corpus layout, provenance/status schema, privacy-first ingestion, safe configuration registration, evidence-tier gap reporting, client compatibility tests and staged acceptance gates. It is a proposed specification only; the external ZIP source code remains unchanged and unexecuted.


## 11. Ridgeview revelation and evidence matrix

Created `docs/story/BTV_RIDGEVIEW_REVELATION_AND_EVIDENCE_MATRIX_v0.1.md` from the merged Vertical Slice Specification v1.0 and the existing opening-to-Ridgeview narrative flow. It separates Scout historical labels from Asher's field status, distinguishes the trader's contradicted closure claim from the still-open missed-delivery claim, preserves the visitor-relative connection as Unverified until supported, and keeps the repairman's fate unresolved. It includes source traceability, response/flag mapping and 16 acceptance scenarios. This is a proposed analytical aid, not new canon, final dialogue or implemented gameplay.


## 12. Engineering validator hardening — draft PR #2

A bounded engineering change is under review on `btv/mission-validator-strict-types-001`. The neutral mission registry validator previously converted arbitrary Variant values to Strings before checking them, allowing wrong-type IDs or reference fields to be silently coerced. Test-first cases now require actual String values and the implementation emits stable type diagnostics. The contract document was updated. Draft PR #2 targets `btv/test-first-contracts-001`: https://github.com/KINGACEX/beyond-the-veil-last-watch-/pull/2.

**Historical verification note:** At the time of the original register entry, run `42497741908` was still in progress. The subsequent completion is recorded immediately below. The PR remains draft and unmerged pending creator review.


### Strict-type PR verification update

**CONFIRMED — GitHub Actions run 42497741908 passed** on the PR #2 merge ref using Godot 4.7.2. The log explicitly reports `MISSION_DATA_VALIDATOR_TESTS: PASS`; NLI smoke, NLI contract and core interaction acceptance suites also report PASS, and the main scene completed its 10-frame headless launch. The PR contains four changed files, five commits ahead of the engineering base, and remains draft/unmerged. This is headless CI evidence only, not editor visual review, manual play testing or Android-device verification.



## 13. Core interaction acceptance review — 8 November 2026

Inspected the current controller, touch overlay, main scene, automated test file, interaction matrix and cross-platform input brief on `btv/test-first-contracts-001`.

**CONFIRMED:** GitHub Actions run [42497741908](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42497741908) passed the core interaction acceptance suite on code commit `81570c095f90b0b9c1d4e3ab38ebb40c7c3a9efd`. The matrix was updated to record 15 directly automated cases, 2 partial cases and 11 not-yet-automated cases. This is per-case test accounting, not a claim that all 28 cases pass.

**Source-inspection findings:** the main scene instantiates the touch overlay; touch buttons feed shared InputMap actions and release on button-up, focus loss and teardown. At the time of this inspection, before the subsequent M1 implementation, the player controller had no camera-look input or camera-relative movement. M1 is recorded in Section 14. Explicit pause/UI input-context policy, touch multitouch coverage, scene-transition/re-entry tests, unavailable-target result handling, multiple-shape deduplication and player/self-sensor exclusion remain open.

**Historical next-task note:** camera-relative movement and mouse-look were the next bounded task at the time of this review; it was completed on `btv/camera-relative-mouselook-001`. M2 mobile controls are now integrated on `btv/mobile-touch-input-adapter-001` as recorded in Section 15. Physical Android acceptance remains pending.

**Changed documentation:** `docs/qa/CORE_INTERACTION_003_EDGE_CASE_ACCEPTANCE_MATRIX.md` and `docs/implementation/BOOTSTRAP_STATUS.md` were refreshed on this documentation branch. No gameplay code, scene files, canon or mission content changed during this review.



## 14. M1 camera-relative movement and desktop mouse-look — 8 November 2026

**COMPLETED ON ISOLATED FEATURE BRANCH:** `btv/camera-relative-mouselook-001`, head `de2cb1d29f81a011ddb5319e6c32d95ac3418e45`.

Implemented camera-relative horizontal movement, diagonal normalization, pitch limits, desktop mouse-look logic, click-to-capture, Escape release and focus-loss pointer release. Camera yaw is tracked independently from player-body facing rotation because the camera pivot is parented to the player. Added `tests/player_camera_input_test.gd` and a dedicated CI step.

**CONFIRMED:** Godot 4.7.2 run [42499393434](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42499393434) passed editor import/parsing, NLI smoke and contract tests, mission validator tests, core interaction acceptance tests, camera input tests and the 10-frame main-scene launch.

A prior test attempt failed because a headless display server cannot capture a real desktop pointer. The OS pointer-capture assertions are now explicitly skipped in headless CI. Actual desktop capture/focus behaviour still needs a windowed runtime test. Android touch-look, virtual joystick, multitouch and physical-device testing remain open. No scene, story/canon, mission content or paid dependency was added. No merge or release was performed.

Implementation report: `docs/implementation/BTV_M1_CAMERA_RELATIVE_MOUSE_LOOK_IMPLEMENTATION_2026-11-08.md`.



## 15. M2 touch input adapter — 8 November 2026

**COMPLETED — independent touch adapter and HUD integration:** Branch `btv/mobile-touch-input-adapter-001`, head `3484672809ad95e4e36591e7ca7d49d5f61dfd5e`, based on the M1 camera branch. Added the independent movement/look finger adapter, analog joystick UI, right-side camera-look region, shared InputMap action-strength routing, Interact-area exclusion, viewport-sized overlay layout and cleanup on focus loss/scene teardown. The legacy directional pad remains available through the exported fallback switch.

**CONFIRMED:** Godot 4.7.2 run [42500466981](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42500466981) passed editor parsing, all existing NLI/mission/interaction/camera suites, touch adapter tests, touch HUD integration tests and the 10-frame main-scene launch. The integration suite reports `TOUCH_CONTROLS_INTEGRATION_TESTS: PASS`.

**NOT VERIFIED:** physical Android touch behaviour, thumb reach, safe-area insets, orientation changes, sensitivity, frame pacing and device performance. Headless synthetic input is not device acceptance. The inspected branch has no export_presets.cfg or Android export job, and no package identifier has been selected; an installable debug APK is therefore a prerequisite to device review.

Implementation report: `docs/implementation/BTV_M2_TOUCH_INPUT_ADAPTER_2026-11-08.md`.
