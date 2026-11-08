# BTV Shared Decision Log

**Purpose:** Trace creator decisions that affect cross-agent work.  
**Rule:** This is a record, not an authority that overrides higher-level canon. Link the source decision and affected documents.

## Status key

- **CONFIRMED:** explicitly decided by the creator or supported by an authoritative source.
- **PROPOSED:** awaiting creator decision.
- **REJECTED:** declined; do not reintroduce without a new request.
- **OPEN:** not yet decided.
- **SUPERSEDED:** replaced by a later recorded decision; retain for history.
- **OPERATING CONSTRAINT:** rule governing work; not a creative canon decision.

## Initial entries

| ID | Date (UTC) | Decision | Status | Source / affected work |
|---|---|---|---|---|
| DEC-MA-001 | 2026-11-08 | Establish a multi-platform BTV team: Claude for visual direction, MiniMax Code for implementation, ChatGPT for coordination and independent review; creator retains final authority. | CONFIRMED DIRECTION | Creator request; multi-agent system v1.0 |
| DEC-MA-002 | 2026-11-08 | No deleting repository content, changing security settings, merging or publishing without creator approval. | CONFIRMED | Creator instruction; GitHub MCP and branch rules |
| DEC-MA-003 | 2026-11-08 | Build the formal multi-agent system, including charters, handoff protocol, visual quality standards, repository rules and shared logs. | CONFIRMED DIRECTION | Creator request; system v1.0 |
| DEC-MA-004 | 2026-11-08 | Actual MCP connections, account permissions, paid credits and platform availability must be verified separately; documentation alone does not establish them. | OPERATING CONSTRAINT | Evidence-based status rule |
| DEC-MA-005 | 2026-11-08 | Consolidate BTV work already completed across prior ChatGPT sessions, repository work, media production and the MiniMax Lore Bridge review into the GitHub repository, while preserving status and provenance. | CONFIRMED DIRECTION | Creator request; cross-platform progress register |
| DEC-MA-006 | 2026-11-08 | Keep the active engineering baseline separate from the documentation consolidation branch; port the nine multi-agent governance files into the new branch created from the current engineering baseline. | COMPLETED IMPLEMENTATION CHOICE | Repository branch structure; `btv/project-history-and-lore-bridge-001` |
| DEC-MA-007 | 2026-11-08 | Treat the supplied MiniMax Lore Bridge as a promising external prototype requiring a safety and privacy remediation pass before installation or real client registration. | REVIEW RECOMMENDATION — NOT CREATOR CANON | Static review only; `BTV_LORE_BRIDGE_STATIC_REVIEW_2026-11-08.md` |
| DEC-MA-008 | 2026-11-08 | The existing Screel trailer render is a review draft made from illustrative stills, not gameplay footage; it remains unpublished and requires creator playback review. | STATUS RECORD | Trailer production status document |
| DEC-MA-009 | 2026-11-08 | The full playable opening-to-Ridgeview vertical slice and physical Android validation remain incomplete. | STATUS RECORD | Current implementation status and README |

## New decision template

| ID | Date (UTC) | Decision | Status | Rationale | Source / affected paths | Supersedes |
|---|---|---|---|---|---|---|
| DEC-MA-XXX | YYYY-MM-DD | [Decision] | OPEN | [Reason] | [Links] | [ID or —] |

## Approval record

A proposal becomes confirmed only after an explicit creator decision. Record the exact scope of approval; approval to draft is not approval to implement, spend, merge or publish. The Lore Bridge review recommendation is not an approved architecture change until the creator accepts it.
