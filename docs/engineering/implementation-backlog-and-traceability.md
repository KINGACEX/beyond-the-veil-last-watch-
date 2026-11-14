# BTV Implementation Backlog and Acceptance Traceability

**Version:** 0.1  
**Date:** 2026-11-14  
**Status:** Planning baseline derived from the approved design/QA package and previously reported local audit evidence. Reconfirm source state before assigning implementation work.

## 1. Purpose

This backlog translates the approved design package into a dependency-ordered implementation and verification plan. It is not a claim that the listed work has been started, completed or tested. The active Roblox worktree may contain newer changes; every task must begin with a fresh ownership and repository-state check.

Use the following status vocabulary:

- **CONFIRMED:** Supported by reported source inspection or test evidence.
- **PROPOSED:** Recommended work not yet accepted as an implementation detail.
- **IN PROGRESS:** An owner has explicitly started the task.
- **BLOCKED:** A required environment, dependency or decision is unavailable.
- **COMPLETED:** Acceptance criteria have been met and evidence is recorded.
- **DEFERRED:** Intentionally postponed with a reason.

## 2. Priority and dependency map

| Order | ID | Priority | Workstream | Task | Depends on |
|---:|---|---|---|---|---|
| 0 | GOV-001 | P0 | Integrator | Reconfirm branch, HEAD, dirty paths, stash, backups and active file ownership before any source edit | None |
| 1 | PER-001 | P0 | Persistence | Preserve Saved/Pending/Rejected/Disabled semantics; keep live persistence disabled | GOV-001 |
| 2 | LIFE-001 | P0 | Multiplayer | Make player initialization connect-first and idempotent; cover startup join race | GOV-001 |
| 3 | CON-001 | P0 | Gameplay + Multiplayer | Serialize or revision-guard competing Wren consent requests | GOV-001, PER-001 |
| 4 | API-001 | P0 | Integrator + Gameplay | Freeze mission/objective/evidence/consent interfaces before parallel feature expansion | PER-001, CON-001 |
| 5 | GAME-001 | P1 | Gameplay | Complete and verify the Temple-to-Ridgeview opening investigation loop | API-001 |
| 6 | GAME-002 | P1 | Gameplay | Verify Field Notes, evidence board and report draft preserve source attribution and uncertainty | GAME-001, API-001 |
| 7 | EMB-001 | P1 | Ember | Stabilize command controller around existing Hold and Regroup behavior | GOV-001 |
| 8 | EMB-002 | P1 | Ember | Implement additional commands one at a time against approved command contracts | EMB-001, API-001 |
| 9 | SEC-001 | P0 | Multiplayer/Security | Execute remote validation, player isolation and concurrency catalogue | LIFE-001, CON-001, GAME-001, EMB-001 |
| 10 | NPC-001 | P1 | Gameplay | Verify NPC interaction ownership, cleanup and region lifecycle | GAME-001 |
| 11 | UI-001 | P1 | UI/Gameplay/Ember | Implement and verify Android-first touch UI and safe-area behavior | GAME-001, EMB-001 |
| 12 | RUN-001 | P0 | QA/Integrator | Complete Studio single-client and two-client verification on supported hardware | GAME-001, GAME-002, EMB-002, SEC-001 |
| 13 | MOB-001 | P1 | QA | Measure performance and usability on actual target Android devices | UI-001, RUN-001 |
| 14 | PER-002 | P0 | Persistence + QA | Controlled save/failure/retry/reconnect tests in an approved test environment | PER-001, RUN-001 |
| 15 | REL-001 | P0 | Project owner + Integrator | Review release matrix, canon, rollback, privacy and all release gates | All required gates |

P0 indicates a data-integrity, consent, security or release prerequisite. P1 indicates core feature completion or quality. Priority does not authorize editing another workstream's files.

## 3. Task definitions and acceptance evidence

### GOV-001 — Preservation and ownership checkpoint

**Status:** Required before each source implementation or integration session.  
**Owner:** Integrator.

Acceptance evidence:
- Repository identity and current branch are verified.
- HEAD SHA is recorded.
- Tracked and untracked dirty paths are inventoried.
- Existing stash entries and recovery snapshots are identified without mutation.
- Active agent ownership and exact file locks are recorded.
- A verified, separate recovery snapshot exists before risky integration.
- No unrelated dirty work is staged or included.

### PER-001 — Persistence status contract

**Known baseline:** A local correction was independently reviewed and reported to pass six Lune suites, scoped StyLua checks, Rojo build and diff checks. Studio runtime, reconnect and live DataStore behavior remain unverified.

Acceptance evidence:
- Successful durable write is the only route to Saved.
- Accepted in-memory mutation after failed write is Pending.
- Invalid or unaccepted mutation is Rejected and leaves profile unchanged.
- Disabled means session-only; no durable-save claim is made.
- Retry persists the latest accepted dirty profile in fake-store tests.
- Live persistence remains disabled until PER-002 and release approval.

### LIFE-001 — Player initialization ordering

**Known baseline:** A possible startup race was identified where existing-player enumeration may precede PlayerAdded connection.

Acceptance evidence:
- PlayerAdded is connected before existing players are enumerated.
- One idempotent initializer handles both paths.
- A controlled test injects a join during startup enumeration.
- Each player receives exactly one session and one initialization sequence.
- Partial initialization and leave-during-initialization clean up safely.
- Bootstrap changes have one declared owner and are isolated from other active edits.

### CON-001 — Consent concurrency

**Known baseline:** Dialogue consent mutation may yield through a persistence call before state is committed, permitting competing requests.

Acceptance evidence:
- Consent defaults to Private.
- Pike's gated response remains unavailable until explicit Share.
- Competing Private/Share requests have a documented deterministic serialization or revision policy.
- Rejected requests do not mutate consent.
- Two players' consent states remain isolated.
- Pike's account remains separately attributed; sharing does not make it objective truth.
- Tests use a controllable delayed dependency, not arbitrary sleeps alone.

### API-001 — Mission and evidence interface freeze

**Owner:** Integrator with Gameplay and Persistence.

Acceptance evidence:
- Mission phase and objective transition rules are documented.
- Objective completion is server-authoritative and idempotent.
- Field Note identifiers and source attribution are stable.
- Observation, testimony, physical record, interpretation and unverified information remain distinct.
- Consent is explicit and player-scoped.
- Report draft does not imply submission, verdict or reward.
- Profile mutations use the accepted persistence status contract.
- Interface changes are versioned and communicated before dependent agents edit code.

### GAME-001 — Opening mission loop

Acceptance evidence:
- Temple opening interactions are reachable and have clear prerequisites.
- Ridgeview transition and settlement navigation work in Studio.
- Mission objectives update only from server-validated actions.
- Wren testimony and consent choice are reachable.
- Pike's gated response follows the explicit consent contract.
- Progression is isolated per player.
- Offline tests and Studio evidence identify the tested commit/build.

### GAME-002 — Investigation records and report draft

Acceptance evidence:
- Field Notes are stable-ID, deduplicated and player-scoped.
- Evidence Board distinguishes observation, testimony, physical record, interpretation and unresolved information.
- Wren's testimony is private by default and is shared only after explicit choice.
- Pike's account is separately attributed.
- Incomplete evidence remains incomplete; the report does not invent a conclusion.
- No unsupported submission, verdict or reward UI is presented.

### EMB-001 / EMB-002 — Ember commands

Acceptance evidence:
- Existing Hold and Regroup behavior is preserved.
- Exactly one active primary command is authoritative per Ember.
- Invalid, unknown or unimplemented commands are rejected or clearly unavailable.
- Command interruption and cancellation are deterministic.
- Navigation failure has bounded retry and safe fallback.
- Actor ownership, cleanup and target validation are server-side.
- Each additional command is separately implemented and tested; no feature is marked complete based on UI presence alone.
- Two-player tests show no cross-player control or state leakage.

### SEC-001 — Security and multiplayer acceptance

Acceptance evidence:
- All P0 cases in the Multiplayer Interaction and Security Test Catalogue pass in the appropriate environment.
- Malformed, unauthorized, stale, duplicate and out-of-range requests are rejected safely.
- No client-supplied identity, mission phase, evidence ownership or reward is trusted.
- Cross-player mission, consent, Ember and Field Notes state remains isolated.
- Startup, leave, cleanup and concurrency cases are tested.
- Runtime-only cases are marked BLOCKED if Studio/two-client access is unavailable.

### NPC-001 — NPC lifecycle

Acceptance evidence:
- NPCs have stable identities and defined availability/interacting/suspended/cleanup states.
- Exclusive interaction policy is enforced where applicable.
- Player leave, NPC removal and region streaming do not leave stale connections or tasks.
- Repeated requests do not create duplicate interaction sessions.
- Any ambient routines are bounded for mobile performance.

### UI-001 / MOB-001 — Android-first interface and performance

Acceptance evidence:
- Movement and camera controls do not conflict with interaction, journal or companion controls.
- Touch targets, readable dialogue and safe-area layout are tested on physical Android devices.
- Mission Journal, Evidence Board, Dialogue and Ember Commands are usable without blocking essential movement.
- Frame rate, memory, load time and interaction latency are measured on named devices and builds.
- Proposed targets in the technical handbook remain targets until actual measurements are recorded.

### RUN-001 / PER-002 / REL-001 — Runtime, persistence and release

Acceptance evidence:
- Studio single-client and two-client runs are recorded against exact build identifiers.
- Controlled fake/test persistence covers success, failure, retry and reconnect.
- No live DataStore is enabled without explicit approval and an independently reviewed data-safety plan.
- Pending session changes are not represented as durable and the server-termination loss risk is documented.
- Rollback steps are tested or clearly marked unverified.
- Project owner approves canon, privacy, publishing and release decisions separately.

## 4. Current known baseline and limitations

The following are carried forward from previously reported audits, not freshly re-inspected in this document update:

- The persistence status correction was reported as locally accepted after independent offline review.
- Six Lune suites, scoped StyLua checks, a Rojo build and diff checks were reported passing for that local change.
- Roblox Studio and physical Android runtime verification were unavailable on the previously reported Debian ARM64 host.
- The broader StyLua check over src and tests had reported formatting differences in 19 files; do not reformat unrelated files as part of this backlog.
- Selene was reported unable to launch on that host; treat as BLOCKED until a supported environment resolves it.
- The live persistence gate was reported disabled.
- Ember's implemented baseline was Hold and Regroup; Attack, Protect, Scout, Track and Retrieve remained design targets.
- Report handling was described as draft-only, without submission, verdict or reward.
- The consent concurrency and startup ordering cases require explicit reproduction and tests.

If AnyClaw's newer evidence contradicts any item, update the status and attach the newer source evidence. Do not treat this inherited baseline as current proof.

## 5. Workstream handoff template

Every task handoff must include:

- Task ID and status.
- Owner and next owner.
- Base branch and commit SHA.
- Complete changed-path list, including untracked files.
- Behavior changed and behavior intentionally unchanged.
- Exact test commands and actual results.
- Runtime environment and evidence links/locations.
- Known risks and unresolved questions.
- Recovery snapshot path and checksum, if created.
- Git state: commit/push status and remaining dirty paths.

## 6. Stop conditions

Stop and report BLOCKED if:
- The active repository or branch cannot be verified.
- The target file is owned by another active agent.
- The proposed change requires overwriting dirty work.
- A test requires Roblox Studio or physical Android access that is unavailable.
- A task requires live DataStore, migration, public publishing, paid services or canon change.
- A failure would require reset, clean, force-push or discarding another agent's work.

This backlog authorizes planning and coordination only. It does not authorize implementation in another agent's active worktree, live persistence, migration, publishing, merging into main or destructive Git operations.
