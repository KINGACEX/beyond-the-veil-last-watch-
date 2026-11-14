# Technical Design and QA Handbook

**Version:** 0.1  
**Status:** Approved engineering direction; implementation review required

## 1. Architecture principles

- Server-authoritative gameplay state.
- Clients request actions; servers validate and decide outcomes.
- Clear service ownership and narrow interfaces.
- Player state is isolated by user/session.
- Persistence status must distinguish accepted session state from durable storage.
- Cleanup is explicit for players, NPCs, companions and streamed regions.
- Offline tests supplement, but do not replace, Roblox Studio and device tests.

## 2. Proposed service responsibilities

| Service | Responsibility |
|---|---|
| Bootstrap | Service construction, dependency wiring and player lifecycle |
| MissionService | Mission prerequisites, objective transitions and authoritative progression |
| ProfileSessionCoordinator | In-memory profile lifecycle, dirty state, lease/session coordination |
| ProfileProgressionPersistence | Adapter between progression services and profile persistence |
| CompanionActorService | Per-player Ember actor lifecycle and accepted commands |
| DialogueService | Dialogue state, choice validation and consent-sensitive transitions |
| FieldNotesService | Evidence catalog, discovery and attribution |
| ReportService | Report draft assembly and future submission boundary |
| World services | Region activation, NPC lifecycle and interaction availability |

This is a responsibility map, not a claim that each named service exists in the current repository.

## 3. Remote request security contract

Every client-to-server request should validate, as applicable:

1. Caller identity from the server event context.
2. Request type and allowed enum values.
3. String length and structured payload shape.
4. Ownership of the referenced companion, item, profile or mission.
5. Target existence and target eligibility.
6. Distance and line-of-sight where relevant.
7. Mission prerequisites and authoritative server state.
8. Cooldown and rate limit.
9. Idempotency or duplicate request handling.
10. Current lifecycle state and whether the action is still valid.

Return bounded result codes. Do not expose stack traces, secrets, or internal persistence details to clients. Never trust client-supplied rewards, mission phase, evidence ownership, consent state or target validity.

## 4. Multiplayer isolation

Each player must have independent:
- mission progression,
- profile and session state,
- Ember instance and command queue,
- Field Notes,
- evidence sharing decisions,
- report draft,
- interaction and cooldown state.

A player must not be able to mutate another player's data by guessing user IDs, instance IDs, remote arguments or object references.

## 5. Player lifecycle and startup

Recommended lifecycle:
- Connect PlayerAdded and PlayerRemoving handlers before enumerating existing players.
- Route both existing and new players through one idempotent initialization function.
- Protect against duplicate initialization.
- Ensure partial initialization can be cleaned up.
- Keep initialization errors isolated to the affected player where possible.
- Do not mark a player ready until required profile/session state is available.

This recommendation addresses a potential event-order race and must be tested with a controlled join-during-startup scenario.

## 6. NPC and companion lifecycle

Suggested lifecycle:
- Inactive
- Available
- Interacting or executing command
- Suspended (e.g. region streaming or temporary unavailability)
- Cleaning / removed

Requirements:
- Stable server-side identity.
- Bounded task lifetime.
- Cancellation on target invalidation or owner removal.
- No orphaned pathfinding, connections or event listeners.
- Per-player ownership for companion actors.
- Safe recovery when a region unloads.

## 7. Persistence status semantics

Use distinct outcomes:

| Status | Meaning |
|---|---|
| Saved | Mutation accepted and durable save confirmed, or clean state already confirmed durable |
| Pending | Session mutation accepted, but durable save is incomplete or failed |
| Rejected | Mutation was not accepted |
| Disabled | Persistence is not active; caller must treat state as session-only |

A caller must never interpret Pending or Disabled as durable success. A Pending mutation may be lost if the server terminates before a retry or later save succeeds. Keep the live persistence gate disabled until Studio, reconnect, failure-recovery and data-safety gates pass.

## 8. QA layers

1. Static inspection and formatting.
2. Unit tests for pure policies and state transitions.
3. Integration tests with fake services/stores.
4. Build and project-structure validation.
5. Roblox Studio single-player runtime.
6. Two-client multiplayer runtime.
7. Android touch, safe-area and performance tests.
8. Release and rollback verification.

A passing offline test does not establish Studio runtime correctness. A successful Rojo build does not establish playable behavior. A desktop test does not establish Android usability.

## 9. Proposed performance targets

- 30 FPS target on the minimum supported device.
- Common interaction feedback under 250 ms where practical.
- UI transitions under 300 ms where practical.
- Primary touch targets around 44–48 logical pixels where practical.

These are targets only. Do not report them as measured results without device profiling.

## 10. Release gates

- **Source gate:** static checks, unit tests, integration tests and build pass.
- **Studio gate:** core mission and companion flow verified in Studio.
- **Multiplayer gate:** two-client isolation and concurrency verified.
- **Mobile gate:** supported Android device interaction and performance verified.
- **Persistence gate:** load/save/retry/reconnect/failure behavior verified in a controlled test environment.
- **Release gate:** canon, content, privacy, rollback and publishing approvals complete.

## 11. Change safety

- Inspect before editing.
- Preserve dirty paths and existing backups.
- Work in isolated branches/worktrees.
- Keep changes narrow and testable.
- Avoid overlapping files with other agents.
- Do not commit, push, merge, rebase, reset, clean, publish, spend money or change live persistence without explicit authorization.
- Report exact changed paths and test evidence.
