# BTV Source-of-Truth Library

This directory contains source-document copies recovered from the user's ChatGPT Library on **2026-11-05**. The source files were imported as text without rewriting their body content. Their original status labels are preserved.

## Authority order

1. The creator's latest explicit decision or correction.
2. The BTV Master Canon as reconciled by accepted creator decisions.
3. Specialized Bibles within their own domains.
4. The Vertical Slice Specification for details explicitly locked to that slice; it cannot silently rewrite global canon.
5. Older handoffs, prompts, mockups, generated images and prototype artifacts.

The controlling reconciliation document is [BTV Canon Reconciliation & Story/Veil Decisions v1.1](canon/BTV_Canon_Reconciliation_and_Story_Veil_Decisions_v1.1.md). Do not treat older documents or visual mockups as equal authority.

## Canon and governance

- [Master Canon v1.0](canon/BTV_Master_Canon_v1.0.md)
- [Canon Reconciliation & Story/Veil Decisions v1.1](canon/BTV_Canon_Reconciliation_and_Story_Veil_Decisions_v1.1.md)
- [Master Development Handoff](governance/BTV_Master_Development_Handoff.md)

## Domain Bibles

- [Story & Lore Bible v1.0](story/BTV_Story_and_Lore_Bible_v1.0.md)
- [Character Bible v1.0](characters/BTV_Character_Bible_v1.0.md)
- [Covenant Bible v1.0](covenant/BTV_Covenant_Bible_v1.0.md)
- [Faith, Prayer & Armor of God Bible v1.0](faith/BTV_Faith_Prayer_Armor_of_God_Bible_v1.0.md)
- [Church / HCI / Service / Communion Bible v1.0](church/BTV_Church_HCI_Service_Communion_Bible_v1.0.md)
- [Veil & Enemy Encyclopedia v1.0](veil/BTV_Veil_Enemy_Encyclopedia_v1.0.md)
- [Veil Rules & Metaphysics Bible v0.1](veil/BTV_Veil_Rules_and_Metaphysics_Bible_v0.1.md)
- [World & NPC Bible v1.0](world/BTV_World_NPC_Bible_v1.0.md)
- [Mission / Progression / Economy Bible v1.0](missions/BTV_Mission_Progression_Economy_Bible_v1.0.md)

## Gameplay and vertical-slice design

- [Core Gameplay Specification v1.0](gameplay/BTV_Core_Gameplay_Specification_v1.0.md)
- [Vertical Slice Specification v1.0 (Merged; controlling slice source)](vertical-slice/BTV_Vertical_Slice_Specification_v1.0.md)
- [Vertical Slice Specification v0.2 (historical draft)](vertical-slice/BTV_Vertical_Slice_Specification_v0.2.md)
- [Ridgeview Case Design v0.2](vertical-slice/BTV_Ridgeview_Case_Design_v0.2.md)
- [Investigation & Evidence Bible v0.1](investigation/BTV_Investigation_and_Evidence_Bible_v0.1.md)
- [Mystery & Revelation Register (Library filename v0.3; body title v0.2)](investigation/BTV_Mystery_and_Revelation_Register_v0.3.md)

## Systems, production and presentation

- [Natural Language Interaction System Spec v0.1](systems/BTV_Natural_Language_Interaction_System_Spec_v0.1.md)
- [Economy, Progression & Production Readiness v1.0](production/BTV_Economy_Progression_and_Production_Readiness_v1.0.md)
- [Foundation #12 Visual / UI / HUD Bible v1.0](visual/BTV_Foundation_12_Visual_UI_HUD_Bible_v1.0.md)
- [Foundation #12 Visual / UI / HUD Bible v1.1 Consistency Lock](visual/BTV_Foundation_12_Visual_UI_HUD_Bible_v1.1_Consistency_Lock.md)
- [Work Session Handoff — 2026-11-01](handoffs/BTV_Work_Session_Handoff_2026-11-01.md)

## Import record

- 22 source Markdown documents imported.
- 10,736 source lines across those documents.
- Source text was retrieved from the ChatGPT Library and committed to the btv/bootstrap-prototype-001 branch.
- One duplicate Library copy of the Investigation & Evidence Bible had the same content hash and was not imported twice.
- The import preserves historical wording. It does not mean every imported document is current, internally consistent, creator-approved, implemented, tested or production-ready.

## Legacy and non-Markdown Library material

The Library also contains older DOCX/PDF records, generated concept images, app mockups, character sheets and an Asher Godot asset ZIP. These are historical/reference artifacts, not automatic canon. The 2026-11-05 audit records the selected legacy conflicts and asset findings. Binary legacy files and image assets have not been copied into this source directory.

## Required rule

When a newer accepted decision conflicts with an older source, preserve the older file as history, follow the higher-authority decision, and record a correction task. Never silently rewrite history or promote a proposal to canon.

## Historical slice-source extracts

The following earlier Part 1 and Part 2 DOCX text extracts were recovered on 2026-11-05. They are archival and non-authoritative; use the merged Vertical Slice Specification v1.0 and latest creator decisions for current slice status.

- [Part 1 — A Sunday at Logos Rhema Temple (historical extract)](legacy-extracts/BTV_Vertical_Slice_Part_1_Sunday_at_Logos_Rhema_legacy.extracted.md)
- [Part 2 — The Scout Report (historical extract)](legacy-extracts/BTV_Vertical_Slice_Part_2_Scout_Report_legacy.extracted.md)
- [Parts 1–2 vs merged v1.0 delta audit](../audits/BTV_VERTICAL_SLICE_PARTS_1_2_VS_MERGED_V1_DELTA_AUDIT_2026-11-05.md)

## Visual-reference provenance and character inventory

- The Library contains multiple Asher Vance images, including a character turnaround and older gameplay/UI mockups. Their approval status is not established by filenames. The turnaround's printed age conflicts with current age-18 presentation; the infiltration mockup contains legacy command/UI mechanics. Ember's rare original canid lineage is LOCKED by Foundation #11; exact appearance remains OPEN. See [Visual Reference Provenance Audit](../audits/BTV_VISUAL_REFERENCE_PROVENANCE_AUDIT_2026-11-05.md) and [Character & Visual Reference Inventory Audit](../audits/BTV_CHARACTER_AND_VISUAL_REFERENCE_INVENTORY_AUDIT_2026-11-05.md) before using these assets.

## Project coordination and verification audits

- [Separated Workstream Execution Board](../coordination/BTV_SEPARATED_WORKSTREAM_EXECUTION_BOARD_2026-11-05.md) — distinct workstreams, dependencies, owners/gates and execution order.
- [Repository Verification & Documentation Drift Audit](../audits/BTV_REPOSITORY_VERIFICATION_AND_DOCUMENTATION_DRIFT_2026-11-05.md) — latest CI evidence, source gaps, stale handoffs and NLI contract findings.
- [Character & Visual Reference Inventory Audit](../audits/BTV_CHARACTER_AND_VISUAL_REFERENCE_INVENTORY_AUDIT_2026-11-05.md) — Asher, Ember and wider character visual references.

## Engineering and QA contracts

- [NLI 003 — Handoff State and Source Registry Contract](../implementation/NLI_003_HANDOFF_AND_SOURCE_REGISTRY_CONTRACT.md) — proposed contract; not implemented.
- [Core Interaction 003 — Edge-Case Acceptance Matrix](../qa/CORE_INTERACTION_003_EDGE_CASE_ACCEPTANCE_MATRIX.md) — proposed QA cases; not yet executed.

## Session continuity and coordination

- [Session Continuity Protocol](../coordination/SESSION_CONTINUITY_PROTOCOL.md) — reusable rules for detailed, timestamped long-chat checkpoints and new-chat handoffs.
- [BTV continuity setup checkpoint — 5 November 2026, 12:37–12:38 UTC](../coordination/session-logs/SESSION_2026-11-05_1237Z_BTV_CONTINUITY_SYSTEM_SETUP.md) — records this setup window, previous verified engineering baseline, open tasks and exact resume point.

## Cross-platform governance and latest project records

- [Multi-agent development system](../agents/BTV_MULTI_AGENT_DEVELOPMENT_SYSTEM_v1.0.md) — creator-led Claude / MiniMax Code / ChatGPT collaboration model; documented, not yet connected.
- [Story Development Agent charter](../agents/BTV_STORY_DEVELOPMENT_AGENT_CHARTER_v0.1.md) — story-review workflow and source hierarchy.
- [Shared decision log](../agents/BTV_SHARED_DECISION_LOG.md) and [agent activity log](../agents/BTV_AGENT_ACTIVITY_LOG.md) — approval and evidence history.
- [Cross-platform progress register](../coordination/BTV_CROSS_PLATFORM_PROGRESS_REGISTER_2026-11-08.md) — engineering, story, agent, Lore Bridge and media status.
- [Next execution plan](../coordination/BTV_NEXT_EXECUTION_PLAN_2026-11-08.md) — prioritized and gated work.
- [Current cross-agent handoff XH-001](../coordination/BTV_CROSS_AGENT_HANDOFF_2026-11-08.md) — common MiniMax/Claude/ChatGPT task brief and response protocol.
- [MiniMax Lore Bridge static review](../audits/BTV_LORE_BRIDGE_STATIC_REVIEW_2026-11-08.md) — archive review and safety requirements; code not executed.
- [Trailer production status](../media/BTV_TRAILER_PRODUCTION_STATUS_2026-11-08.md) — Screel draft render, Descript status and publication gate.

## Supporting character, story and world-design records

- [Kay family character bible](../characters/KAY_FAMILY_CHARACTER_BIBLE_v1.0.md) and [naming addendum](../characters/KAY_FAMILY_NAMING_ADDENDUM_v1.1.md).
- [Global character naming and cultural representation framework](../design/BTV_GLOBAL_CHARACTER_NAMING_AND_CULTURAL_REPRESENTATION_FRAMEWORK_v0.1.md).
- [Annual community calendar proposal](../design/BTV_ANNUAL_COMMUNITY_CALENDAR_FRAMEWORK_PROPOSAL_v0.1.md).
- [Church festival and community event proposal](../design/CHURCH_FESTIVAL_AND_COMMUNITY_EVENT_FRAMEWORK_PROPOSAL_v0.1.md).
- [New-game NPC generation and Christian name lexicon proposal](../design/BTV_NEW_GAME_NPC_GENERATION_AND_CHRISTIAN_NAME_LEXICON_PROPOSAL_v0.1.md).
- [Initial story gap register](../story/BTV_STORY_GAP_REGISTER_INITIAL_TRIAGE_v0.1.md).
- [Opening-to-Ridgeview narrative flow](../story/BTV_VERTICAL_SLICE_OPENING_TO_RIDGEVIEW_NARRATIVE_FLOW_v0.1.md).

These supporting records retain their original labels. Proposals do not become canon merely because they are indexed here.


- [Lore Bridge v1.1 remediation specification](../implementation/BTV_LORE_BRIDGE_V1_1_REMEDIATION_SPEC.md) — proposed engineering requirements; not yet implemented.


- [Ridgeview Revelation & Evidence Matrix v0.1](../story/BTV_RIDGEVIEW_REVELATION_AND_EVIDENCE_MATRIX_v0.1.md) — source-traced analytical matrix and test scenarios derived from the merged Vertical Slice Specification; not new canon.
