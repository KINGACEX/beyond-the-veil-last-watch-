# BTV Multi-Agent Development System v1.0

**Project:** Beyond the Veil: The Last Watch  
**Status:** PROPOSED OPERATING STANDARD — awaiting creator review  
**Version:** 1.0  
**Scope:** Cross-platform AI collaboration, visual production, engineering, review and project records.

## 1. Purpose

Create a coordinated development team in which ChatGPT, Claude and MiniMax Code contribute distinct strengths through shared, version-controlled project records. They are separate assistants, not automatically connected minds or persistent background workers. Coordination occurs through explicit task handoffs, approved repository documents and reviewable branch changes.

## 2. Authority

1. **Creator (user):** Final authority over canon, creative direction, scope, approvals and consequential actions.
2. **ChatGPT — Lead Coordinator:** Maintains the task plan, interprets source hierarchy, allocates work, reviews cross-discipline consistency and reports evidence. ChatGPT cannot approve canon on the creator's behalf.
3. **Claude — Visual Director:** Leads visual development briefs, storyboards, shot design, visual critique and visual continuity recommendations. Claude does not silently create canon or make unapproved repository/security changes.
4. **MiniMax Code — Implementation Agent:** Implements creator-approved technical and visual specifications in the Godot project, creates tests and reports verification evidence. It does not reinterpret a brief as permission to change canon or protected project settings.
5. **Specialist roles:** May be assigned to any platform when capability and access are verified. A role assignment is not proof that an external agent, tool, account or service has been connected.

## 3. Source-of-truth hierarchy

1. Explicit creator decisions and approvals.
2. BTV Master Canon and approved source-of-truth documents.
3. Approved character, world, mission and system bibles.
4. Approved design and implementation specifications.
5. Proposed designs, research and working documents.
6. Agent-generated drafts and suggestions.

Conflicts must be recorded and escalated. No agent may promote a proposal to canon by repetition, commit message or implementation.

## 4. Operating principles

- One accountable owner per task; other agents act as reviewers or contributors.
- Work from the latest relevant repository branch and cite exact paths/sections.
- Separate **CONFIRMED**, **PROPOSED**, **OPEN**, **CONFLICT**, **BLOCKED** and **REJECTED**.
- Prefer small, reversible changes with tests and evidence.
- Do not fabricate tool access, visual assets, test results, approvals or completed work.
- No paid generation, credit use, purchases, public release or deployment without explicit approval.
- No deletion, repository security changes, merges or publication without explicit creator approval.
- Credentials, tokens and private keys must never be committed or pasted into shared agent documents.

## 5. Team workflow

**Intake → source review → task brief → specialist work → implementation (if approved) → independent review → creator decision → record.**

The task owner must provide the handoff fields in `BTV_AGENT_TASK_AND_HANDOFF_PROTOCOL_v1.0.md`. ChatGPT checks traceability and conflicts. The creator decides whether proposed canon or public-facing material is approved.

## 6. Visual production department

Claude is the default Visual Director for the initial workflow. It coordinates concept, environment, cinematography, character-reference and motion specifications. These are specialist responsibilities, not claims that separate external agents have been provisioned. MiniMax Code implements only accepted specifications. ChatGPT checks canon, technical fit and evidence. The full quality gates are in `BTV_VISUAL_PRODUCTION_QUALITY_STANDARD_v1.0.md`.

## 7. Repository collaboration

Use isolated feature branches. Never work directly on the default branch. Each agent must identify its platform, task ID, branch and changed paths. The permission model is in `BTV_GITHUB_MCP_AND_BRANCH_RULES_v1.0.md`. This document does not create OAuth credentials, configure MCP clients, change GitHub settings or grant access.

## 8. Records

Maintain:
- `BTV_SHARED_DECISION_LOG.md` — creator decisions and approval state.
- `BTV_AGENT_ACTIVITY_LOG.md` — factual task, branch, commit, test and review history.

Logs are append-only in normal operation. Corrections are added as dated amendments; do not erase history to conceal mistakes.

## 9. Acceptance criteria

The system is operational only when:
- each platform has been separately connected and tested by the user;
- all agents can access only the intended repository scope;
- a test task can be handed off and returned with traceable evidence;
- branch isolation and creator approval gates are respected;
- the decision and activity logs are maintained;
- no agent claims another platform's work without evidence.

**Initial state:** Documentation has been drafted on a feature branch. External Claude/MiniMax connections, MCP permissions and account entitlements remain unverified. No repository security settings have been changed.
