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

**Verification at register update:** GitHub Actions run `42497741908` was in progress at the Godot 4.7.2 installation step. No test pass is claimed. The PR remains draft and unmerged pending CI and review.
