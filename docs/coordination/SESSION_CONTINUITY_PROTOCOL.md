# SESSION CONTINUITY PROTOCOL
**Version:** 1.0 | **Created:** 5 November 2026

## Purpose
Prevent long-chat handoffs from losing decisions, work status, evidence, unfinished tasks or the exact resume point. Do not rely on an automatic conversation summary as the sole record.

## When to checkpoint
Create or update a durable record:
- before a likely context-limit or long-chat handoff;
- after a major milestone or decision;
- before changing workstreams;
- whenever the user asks for a checkpoint or continuation;
- at the end of a substantial work session.
If work continues, save an interim checkpoint and update it later. Do not wait until context is nearly exhausted.

## Time and identity
Every checkpoint must state:
- Session ID (e.g. `2026-11-05_1237Z_BTV`);
- start and end timestamps, with timezone;
- exact work window covered;
- project/workstreams;
- interim or closed status;
- branch/commit, document version or artifact identifiers when relevant.
Use real timestamps. Never invent exact times. If start time is unknown, write `START TIME UNKNOWN` and state the earliest verified point. Keep separate work windows separate. Label earlier work as **PREVIOUS SESSION BASELINE**, not as work performed in the current window.

## Required checkpoint sections
1. **Session header:** ID, date, start/end, timezone, status, project and workstreams.
2. **User intent and constraints:** scope, priorities, exclusions, autonomy limits, budget/tool limits and approval gates.
3. **Topics covered — separate workstreams:** questions, findings and conclusions per topic; do not combine unrelated work.
4. **Decisions and authority:** exact decision, status, authorizing source/person, evidence and downstream impact. Never promote suggestions or prototype behaviour into approved decisions.
5. **Completed in this time window:** checklist of what changed, exact file/path, commit/artifact, and verification. Distinguish analysis, draft, code change, committed artifact, tested result and deployment.
6. **Discussed but NOT completed:** list every planned, proposed, unfinished, blocked, deferred or unverified item. Use `NOT STARTED`, `IN PROGRESS`, `BLOCKED`, `AWAITING USER`, `AWAITING VERIFICATION`, `DEFERRED`, `NOT APPROVED`.
7. **Tests and evidence:** what was tested, command/CI link, result (`PASS`, `FAIL`, `PARTIAL`, `NOT RUN`), and limitations. A narrow passing test is not broad readiness.
8. **Files and artifacts:** exact paths, versions, links, branch names, commits and provenance. Identify controlling vs historical/draft sources.
9. **Risks, blockers, conflicts and unknowns.**
10. **Next actions — ordered:** task, workstream, prerequisite, acceptance condition, and whether autonomous action is allowed or approval is required.
11. **Exact resume point:** the first action the next chat should take, including refs/files/tests and what not to repeat.
12. **Reconciliation checklist:**
   - [ ] Correct project and workstream
   - [ ] Current branch/commit/artifact version rechecked
   - [ ] No newer user decision supersedes this record
   - [ ] Completed items and evidence still present
   - [ ] Unfinished work and blockers carried forward
   - [ ] Source/canon authority respected
   - [ ] No unnecessary duplication
   - [ ] Approval gates preserved
   - [ ] Next action and acceptance test explicit

## Status and evidence discipline
Use `CONFIRMED`, `COMPLETED`, `PROPOSED`, `UNKNOWN`, `BLOCKED`, `CONFLICT`. Use domain-specific labels for canon/design (e.g. `CANON`, `APPROVED DESIGN`, `PROPOSED`, `UNKNOWN`, `CONFLICT`). Do not claim files changed, tests passed, builds playable, device readiness, merges, integrations or permissions without direct evidence.

## Workstream separation
Give every workstream its own status, task list, dependencies and artifacts. For BTV keep source recovery/canon, characters/visual provenance, NLI, player interaction, Ridgeview mission, Scripture/language research, platform validation and governance distinct.

## File naming and history
Use `SESSION_<YYYY-MM-DD>_<HHMMZ>_<PROJECT>_<TOPIC>.md`. Keep a separate immutable record for each meaningful work window; do not overwrite old session history. Update a living task board separately.

## New-chat continuation prompt
> Read the latest SESSION CONTINUITY checkpoint and linked source artifacts before acting. Treat the checkpoint as a handoff, not proof that the state is unchanged. Verify the current repository/branch/commit and relevant tests/artifacts. Preserve workstream boundaries, user decisions, approval gates and status labels. Do not repeat completed work unless verification shows it is missing or invalid. First report material drift, then resume from the exact “Resume point”. Keep a dated checklist of completed, unfinished, blocked and unverified work. If the next work period will be long, create an interim checkpoint before context becomes unreliable and a final timestamped checkpoint at the end.

## Platform limitation
This is a working procedure, not a claim that ChatGPT can continuously monitor every conversation in the background or detect its context limit with guaranteed timing. When the assistant recognizes a substantial continuation is approaching, it should proactively create/update the checkpoint. The user can also say `CHECKPOINT NOW` at any time.

**Rule:** A handoff is a state record, not merely a summary: what was requested, what is authoritative, what changed, what was verified, what remains open, and exactly how to resume.
