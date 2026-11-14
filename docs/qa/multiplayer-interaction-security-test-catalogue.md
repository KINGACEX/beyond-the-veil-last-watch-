# Multiplayer Interaction and Security Test Catalogue

**Version:** 0.1  
**Status:** Approved QA direction; tests are specified, not executed  
**Scope:** Roblox client/server interactions, player isolation, consent, Ember and progression

## 1. Purpose and test rules

This catalogue converts the technical handbook into concrete multiplayer test cases. It is a test plan, not evidence that the cases have passed.

Run first with fake services/offline tests where possible, then in Roblox Studio using two test clients. Use test-only profiles and a controlled persistence environment. Keep live DataStore disabled.

### Priority

- **P0:** Security, data integrity, consent or progression isolation failure.
- **P1:** Core interaction, companion, mission or recovery failure.
- **P2:** Resilience, usability, diagnostics or non-critical edge case.

### Evidence required per case

Record:
- test ID and build/commit identifier,
- environment (offline, Studio single-client, Studio two-client, Android),
- setup and exact actions,
- expected and actual result,
- logs or screenshots with secrets removed,
- pass/fail/blocked status,
- defect reference if failed.

Never mark a test PASS based only on source inspection when runtime execution is required.

## 2. Remote request validation

| ID | Priority | Preconditions and action | Expected result |
|---|---|---|---|
| REM-001 | P0 | Send a valid request from the owning client | Server validates and performs only the authorized action |
| REM-002 | P0 | Send a request with an unknown action enum | Request rejected; no state mutation |
| REM-003 | P0 | Send malformed payload types, missing fields or oversized strings | Bounded rejection; no exception exposed to client |
| REM-004 | P0 | Client supplies another player's user ID or object reference | Server derives caller identity from event context and rejects unauthorized mutation |
| REM-005 | P0 | Client supplies its own claimed reward, mission phase or evidence ownership | Server ignores client authority claims and computes outcome from server state |
| REM-006 | P1 | Send the same valid request repeatedly within a short interval | Rate limit or idempotency prevents duplicate effects |
| REM-007 | P1 | Send a request after its target is removed | Request rejected safely; no stale reference or server error |
| REM-008 | P1 | Send a valid request outside required interaction range | Server rejects if proximity is part of the action contract |
| REM-009 | P1 | Send a request after player/session cleanup begins | Request rejected or safely ignored; no state resurrected |
| REM-010 | P2 | Trigger expected validation failures repeatedly | Structured diagnostics remain bounded and do not leak secrets |

## 3. Player initialization and lifecycle

| ID | Priority | Preconditions and action | Expected result |
|---|---|---|---|
| LIFE-001 | P0 | Player joins during Bootstrap startup enumeration | Player initialized exactly once |
| LIFE-002 | P0 | PlayerAdded and existing-player enumeration both reach the same player | Idempotent initializer prevents duplicate profile/session creation |
| LIFE-003 | P1 | Initialization fails partway through | Partial resources cleaned up; player not marked ready |
| LIFE-004 | P1 | Player leaves during initialization | In-flight initialization is cancelled or safely finalized; no orphaned session |
| LIFE-005 | P1 | Player leaves normally | Companion, connections, tasks and session resources are cleaned up |
| LIFE-006 | P2 | Player rejoins after a clean leave in test environment | New session starts without stale state from prior runtime |

## 4. Dialogue and consent concurrency

Use a controllable fake persistence/service dependency that can pause a call before returning. Do not rely on arbitrary sleeps as the only synchronization mechanism.

| ID | Priority | Preconditions and action | Expected result |
|---|---|---|---|
| CONS-001 | P0 | New player reaches Wren testimony choice | Consent state defaults to Private |
| CONS-002 | P0 | Player chooses Private | Wren's testimony remains unavailable to Pike's gated response |
| CONS-003 | P0 | Player explicitly chooses Share | Authoritative consent state changes once and Pike's gated response may become available |
| CONS-004 | P0 | Player A chooses Share while Player B chooses Private | Each player's consent and dialogue state remain independent |
| CONS-005 | P0 | Pause the first consent request; submit a competing opposite choice | A defined serialization/revision policy produces one deterministic final state; no last-write race |
| CONS-006 | P0 | Submit two identical share requests concurrently | No duplicate dialogue progression or duplicate side effects |
| CONS-007 | P1 | Share request is rejected by policy or missing profile | Consent remains unchanged; UI receives bounded rejection |
| CONS-008 | P1 | Player leaves while consent request is in flight | No stale player mutation after cleanup |
| CONS-009 | P1 | Attempt Pike dialogue before explicit share | Pike's gated response remains unavailable |
| CONS-010 | P1 | Share Wren testimony, then inspect Pike response | Pike's account is separately attributed and not represented as objective truth |
| CONS-011 | P2 | Consent UI is opened on a phone-sized viewport | Private/share consequences are readable and choices are not easy to tap accidentally |

## 5. Ember ownership and command isolation

The current implemented command baseline is Hold and Regroup. Protect, Scout, Track, Retrieve and Attack are future design targets and must be marked NOT IMPLEMENTED until delivered and tested.

| ID | Priority | Preconditions and action | Expected result |
|---|---|---|---|
| EMB-001 | P0 | Player A issues a command to Player B's Ember identifier | Server rejects; Player B's Ember is unchanged |
| EMB-002 | P0 | Player A and Player B issue commands simultaneously to their own Ember | Both command states remain independent |
| EMB-003 | P1 | Owner issues valid Hold or Regroup | Existing supported behavior works as specified |
| EMB-004 | P1 | Owner issues an unknown or currently unimplemented command | Server rejects or UI marks unavailable; no placeholder execution |
| EMB-005 | P1 | Owner repeats the same command rapidly | Duplicate requests do not spawn parallel command loops |
| EMB-006 | P1 | Owner changes command while prior command is active | Prior task is cancelled once; only new accepted command remains active |
| EMB-007 | P1 | Ember target becomes invalid during command | Command ends safely and returns to a defined fallback |
| EMB-008 | P1 | Navigation cannot find a path | Bounded retry then safe fallback; no infinite loop |
| EMB-009 | P1 | Owner leaves while Ember is moving or interacting | Ember and its tasks are cleaned up |
| EMB-010 | P2 | Region streams out while Ember is active | Actor suspends or cleans up without stale references |
| EMB-011 | P2 | Owner uses command UI on Android | Touch targets are accessible and do not obstruct movement |

## 6. Mission, Field Notes and report isolation

| ID | Priority | Preconditions and action | Expected result |
|---|---|---|---|
| MIS-001 | P0 | Client requests a mission phase without satisfying prerequisites | Server rejects; authoritative phase unchanged |
| MIS-002 | P0 | Player A completes an objective while Player B is active | Only Player A's mission state changes |
| MIS-003 | P0 | Two clients submit the same objective completion concurrently | Completion is idempotent; no duplicate reward or evidence |
| MIS-004 | P1 | Client requests an unknown Field Note ID | Request rejected; journal unchanged |
| MIS-005 | P1 | Player discovers a valid Field Note twice | Stable ID prevents duplicate entries |
| MIS-006 | P1 | Player A discovers evidence | Player B does not gain that evidence unless a designed sharing rule explicitly permits it |
| MIS-007 | P1 | Report draft contains observation, testimony and interpretation | Categories and source attribution remain distinct |
| MIS-008 | P1 | Player attempts to submit a report where only draft support exists | No false submission, verdict or reward is shown |
| MIS-009 | P2 | Journal/report is requested repeatedly | Bounded response and no unnecessary persistent mutation |

## 7. Persistence and session recovery

Keep the live persistence gate disabled until a controlled test environment and explicit release approval exist.

| ID | Priority | Preconditions and action | Expected result |
|---|---|---|---|
| PER-001 | P0 | Fake store save succeeds | Caller receives Saved only after durable success is confirmed |
| PER-002 | P0 | Fake store save fails after session mutation is accepted | Caller receives Pending, never Saved |
| PER-003 | P0 | Invalid mutation is submitted | Rejected; profile remains unchanged |
| PER-004 | P0 | Persistence is disabled | Result is Disabled/session-only; no durable-save claim |
| PER-005 | P1 | Pending dirty profile receives a later successful retry | Retry saves the latest accepted profile state |
| PER-006 | P1 | Two players have pending mutations | Retry and save state remain isolated by player/session |
| PER-007 | P1 | Player leaves with pending state in test environment | Lifecycle attempts the defined save path; result is logged honestly |
| PER-008 | P1 | Simulated server termination occurs before retry | Test demonstrates and documents possible loss of pending session-only changes |
| PER-009 | P1 | Reconnect after successful controlled save | Expected durable profile is restored without cross-player leakage |
| PER-010 | P2 | Save is already clean and repeated idempotent save is requested | Result reflects verified clean durable state without duplicate write where supported |

## 8. NPC and interaction lifecycle

| ID | Priority | Preconditions and action | Expected result |
|---|---|---|---|
| NPC-001 | P1 | Player begins NPC interaction within valid range | Interaction starts for the correct player |
| NPC-002 | P1 | Second player attempts to hijack an exclusive interaction | Ownership or concurrency policy is enforced |
| NPC-003 | P1 | NPC is removed during dialogue | Interaction closes safely; no stale reference |
| NPC-004 | P1 | Player leaves during NPC interaction | Interaction and associated connections are cleaned up |
| NPC-005 | P2 | Region streams out during ambient NPC activity | NPC lifecycle suspends or cleans up safely |
| NPC-006 | P2 | NPC receives repeated interaction requests | Duplicate dialogue/session instances are prevented |

## 9. Test execution order

1. Offline unit tests for validation and policy functions.
2. Fake-service integration tests for consent concurrency, profile failure/retry and idempotency.
3. Roblox Studio single-client functional tests.
4. Roblox Studio two-client isolation and concurrency tests.
5. Android device usability and performance tests.
6. Controlled persistence recovery tests only after the test environment is approved.

## 10. Exit criteria

- All P0 cases pass in the environment appropriate to the behavior.
- P1 failures are resolved or explicitly accepted with documented risk.
- No cross-player state mutation is observed.
- Consent remains private by default and concurrency-safe.
- Unsupported Ember commands are not exposed as functional.
- Pending persistence is never presented as durable success.
- Evidence and testimony remain correctly attributed.
- Test evidence identifies the exact build and environment.
- Blocked Studio/Android cases remain BLOCKED, not PASS.

## 11. Known environment limitation

The previously reported development host is Debian 12 on ARM64 and has no Roblox Studio runtime. Native Studio execution is not supported on that host. Offline Lune tests and Rojo builds cannot substitute for Studio two-client or Android device verification. Use a supported Windows/macOS Studio machine for runtime acceptance.
