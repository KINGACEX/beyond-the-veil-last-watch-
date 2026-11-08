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

CI does not establish:
- physical Android export or installation;
- touch usability or multitouch on a real device;
- renderer suitability, sustained frame time, memory or thermal stability;
- visual quality or manual gameplay feel;
- save/load completeness or a playable vertical slice.

### NLI and source integrity

Prior implementation work added a deterministic NLI parser/validator/request gate, source provenance and registry integrity mechanisms. A SHA-256 digest establishes byte-level integrity only; it does not establish source authority, creator approval, truth, freshness or permission to use a fact in a particular scene. The NLI must not claim an actor accepted or executed an action until the actor-owned acknowledgement and lifecycle exist.

## 3. Multi-agent development framework

The nine multi-agent documents originally created on `btv/multi-agent-system-v1` have been ported into this branch:

1. `docs/agents/BTV_MULTI_AGENT_DEVELOPMENT_SYSTEM_v1.0.md`
2. `docs/agents/CLAUDE_VISUAL_DIRECTOR_CHARTER_v1.0.md`
3. `docs/agents/MINIMAX_CODE_IMPLEMENTATION_CHARTER_v1.0.md`
4. `docs/agents/CHATGPT_LEAD_COORDINATOR_CHARTER_v1.0.md`
5. `docs/agents/BTV_AGENT_TASK_AND_HANDOFF_PROTOCOL_v1.0.md`
6. `docs/visual/BTV_VISUAL_PRODUCTION_QUALITY_STANDARD_v1.0.md`
7. `docs/agents/BTV_GITHUB_MCP_AND_BRANCH_RULES_v1.0.md`
8. `docs/agents/BTV_SHARED_DECISION_LOG.md`
9. `docs/agents/BTV_AGENT_ACTIVITY_LOG.md`

The intended division is:
- **Creator:** final authority over canon, approvals, scope and consequential actions.
- **Claude:** Visual Director — visual concepts, storyboards, cinematography and visual critique.
- **MiniMax Code:** Implementation Agent — approved Godot implementation and test evidence.
- **ChatGPT:** Lead Coordinator — source hierarchy, task coordination, independent review and status reporting.

These are documented roles, not proof of active MCP connectivity. Each external client still needs a separately verified, least-privilege connection and a successful handoff test.

## 4. MiniMax BTV Lore Bridge — external artifact review

The creator supplied `btv-lore-bridge.zip` for review. SHA-256 of the reviewed ZIP:

`3c045fb5148b96caa7c71697ebff5bbed191b316e6094e7de0e191374245bb71`

The project is a local Node.js/MCP knowledge bridge intended to make a curated BTV knowledge corpus available to coding assistants. Its visible components include corpus/index building, search, an MCP server, repository file access, gap analysis, registration scripts, a Claude-oriented shell pipeline and a smoke-test fixture.

The review was static only. No installation, dependency execution, MCP registration, network exposure or live test was performed.

Key review findings:
1. The rebuild path appears capable of deleting the whole Markdown corpus directory, including manually maintained material. Rebuild must become non-destructive or require an explicit, narrowly scoped generated-output directory.
2. Registration scripts can remove an existing MCP registration before adding the new one. They need backup, merge-preserving edits, idempotence and rollback.
3. MiniMax configuration error handling may replace an invalid configuration with a minimal file, risking unrelated settings. It should fail closed and preserve the original.
4. `lore_gap` uses keyword-oriented matching. A matching code word is not proof that a feature is implemented or tested.
5. The ChatGPT export parser may follow only the active conversation branch and omit alternate branches.
6. The Claude pipeline drafts code but does not apply it automatically or prove Godot validation.
7. Full ChatGPT exports may contain unrelated private conversations. The corpus builder needs BTV-only selection, sensitive-data exclusion and a strict no-private-export-to-Git rule.
8. The Claude pipeline targets Claude Code; compatibility with Claude mobile is not established. A local Node MCP server may require an execution environment unavailable in the mobile app.

Recommended direction: keep the Lore Bridge as a promising external prototype, but do not install or trust it until the risks are addressed and its behavior is tested in a disposable environment. See `docs/audits/BTV_LORE_BRIDGE_STATIC_REVIEW_2026-11-08.md`.

## 5. Story, canon and design work

The repository's recovered source-of-truth library contains the controlling Master Canon, reconciliation document, domain bibles and merged Vertical Slice Specification. Its authority hierarchy must be followed; imported historical documents, generated mockups and agent suggestions do not automatically become canon.

The intended opening slice remains:
1. Sunday/community sequence at Logos Rhema Temple.
2. Covenant Scout Report.
3. Travel and investigation at Ridgeview.
4. Evidence gathering and a meaningful response.
5. A final report grounded in what the player actually observed and verified.

The story must preserve distinctions between observed, reported, inferred and unconfirmed information. The player should not be rewarded for overclaiming certainty. The local Ridgeview case should reach a meaningful conclusion without prematurely resolving the wider Veil mystery.

A separate character/naming and NPC-generation proposal has been documented on the earlier multi-agent branch; it must remain labelled as a proposal until reconciled with the current source-of-truth hierarchy and explicitly accepted. Do not procedurally generate fixed canon characters or critical story secrets.

## 6. Trailer and channel production

### Screel visual cut

A separate Screel project was created so the original Descript project remained untouched.

- Project: **BTV Official Trailer — Visual Cut v2**
- Project URL: https://screel.ai/editor/01a1b6fe-db9a-7408-876c-1f5cd31d0c03
- Render: 55-second, 720p MP4; 18.1 MB; render job completed without reported render errors.
- Render URL: https://media.screel.ai/videos/01a1b6fe-db9a-7408-876c-1f5cd31d0c03/renders/01a1b6ff-b097-7532-8e1f-9f2ff75d884b.mp4

The cut uses five generated stills with subtle motion, five Charon narration clips and captions. It has no music. It is an illustrative visual draft, not captured gameplay. All five scenes report no actual video clip status. It does not establish the final Asher or Ember designs; an anonymous silhouette is not the canonical Asher. Captions, audio balance, timing, artefacts and fades still require human playback review.

The Screel account had zero remaining credits at the last audit. No upscale or additional generation should be attempted without a fresh cost/credit check and explicit approval.

### Descript

Descript project: https://web.descript.com/project/1afe5f3e-1127-48f5-b259-73bbc0fd8567

A Mike narration asset was imported into the media bin only. The composition was not edited with it. A later AI editing attempt failed because the free AI credit allowance was insufficient. The Descript project remains incomplete; do not claim a final export exists.

### YouTube

The official channel is `@beyondtheveilofficial-btv`. Three Shorts concepts and a trailer release package were drafted, but no public upload or publication was performed. The channel must remain unchanged until the creator reviews and approves the actual final media and metadata.

## 7. Safety, privacy and creator-control constraints

- Do not commit API keys, OAuth secrets, access tokens, passwords or private exports.
- A credential previously pasted in chat should be treated as compromised; revoke it at its issuer. Never copy it into this repository.
- Do not ingest a full personal ChatGPT export into a shared corpus without BTV-only filtering and privacy review.
- Do not delete repository content, rewrite history, change GitHub security settings, merge, publish, deploy, purchase, or spend paid credits without explicit creator approval.
- Prefer feature branches, small reversible changes, evidence-linked commits and append-only logs.
- Keep canon, approved design, proposal, implementation and test evidence as distinct states.

## 8. Immediate next actions

See `docs/coordination/BTV_NEXT_EXECUTION_PLAN_2026-11-08.md`. The priority is to consolidate source records and make the Lore Bridge safe to evaluate, then prove a minimal end-to-end agent handoff, while continuing the engineering branch's existing test-first work. No new gameplay system should be invented merely to make the project appear more complete.
