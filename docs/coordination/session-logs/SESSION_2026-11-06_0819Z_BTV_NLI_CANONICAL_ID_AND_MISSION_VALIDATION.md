# BTV Session Checkpoint — NLI Canonical Request Identity and Mission Validation Contract

**Date:** 6 November 2026  
**Observed execution window:** 08:19:02–08:20:39 UTC (1 minute 37 seconds, based on GitHub commit and CI timestamps). Exact assistant-session start time was not separately captured.  
**Branch:** btv/test-first-contracts-001  
**Base checkpoint:** dcb6534b2368ebb4ee3f2b8d81e577f832332ecb  
**Latest code commit:** 3a9108cea6067237471bb66a57b169a1bd6f4df2  
**Latest verified CI:** 42186948328 — SUCCESS on the exact latest code commit.

## 1. Scope completed

Continued the existing Godot engineering stream. The proposed Unity evaluation branch remains on hold; no branch was created.

### NLI request identity — test-first correction

**Finding:** The request gate trimmed request IDs, but NLIService passed the caller's original string to the parser and returned that non-canonical value in intent/handoff envelopes. This created inconsistent identity across the service boundary.

**Test-first commit:** 4ecd33d5c41807677eac268a1219bbb73adf7fca  
Added tests requiring:
- a padded companion request ID to be canonical in the returned intent;
- the handoff result to carry the same canonical ID;
- a padded question request ID to be canonical in its intent;
- blank companion and cancellation IDs to return a stable missing-request-ID failure.

**Red test evidence:** CI run 42186799620 failed at “Run NLI handoff and source-registry contract tests”; project import/parsing and NLI smoke tests passed. The follow-up documentation-only run 42186895845 also failed because the red tests remained in the branch. These were expected test-first failures, not regressions in the pre-existing suite.

**Correction commit:** 3a9108cea6067237471bb66a57b169a1bd6f4df2  
NLIService now trims once at its public boundary, rejects blank IDs with missing_request_id, passes the canonical value to the parser and request gate, and uses it in the companion handoff result. It does not add actor acceptance, execution, dispatch, persistence or any new gameplay capability.

**Green evidence:** CI run 42186948328 passed on commit 3a9108cea6067237471bb66a57b169a1bd6f4df2. Passed steps:
- Godot 4.7.2 installation/version check;
- headless import and project parsing;
- NLI smoke tests;
- NLI handoff/source-registry contract tests;
- core interaction acceptance tests;
- 10-frame main-scene launch.

Run: https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42186948328

### Mission data validation — proposed contract

Created:
docs/implementation/MISSION_DATA_VALIDATION_CONTRACT_001.md

It defines proposed validation boundaries for:
- stable IDs and reference integrity;
- mission/objective graph reachability and cycles;
- dialogue graph reachability, conditions and terminal nodes;
- separation of dialogue, evidence acquisition and authoritative mission-state mutation;
- claim confidence versus working verification state;
- Ridgeview slice constraints, including five approaches, optional evidence, unresolved repairman status, source provenance and reserved threat-name restrictions;
- Ridgeview flag namespaces and prohibited spiritual/morality scoring;
- Godot Resource immutability and runtime-state isolation;
- deterministic diagnostics and a 24-case validation matrix.

The document is explicitly PROPOSED, not canon or implementation. No mission data, dialogue, Resource schema, validator code or mission-state service was added.

## 2. Current verified repository state

- Branch: btv/test-first-contracts-001
- Latest code commit: 3a9108cea6067237471bb66a57b169a1bd6f4df2
- CI run 42186948328: SUCCESS on that exact commit.
- Mission validation contract file was committed earlier in the same branch history at 378ad3a04a2dddc1860bb1f852749fe11d6ff233 and is included in the verified head.
- No merge to main.
- No Unity branch.
- No Android export/device validation.
- No playable vertical slice.
- No canon changes.
- No paid services, deployment or public release.

## 3. Remaining NLI gaps

The latest NLI gap audit remains applicable. Still not implemented:
1. Real companion adapter and actor-owned accepted/rejected/executing/executed transitions.
2. Callback correlation, stale callback rejection, timeout and expiry.
3. Cancellation after dispatch/execution and competing-request policy.
4. Persistent request state and pause/quit/reload recovery.
5. Cryptographic source-content hash verification.
6. Immutable source versioning, withdrawal and dependent-record invalidation.
7. Editorial verification that authored wording is supported by source passages.
8. Separate synchronous question-processing versus asynchronous action lifecycle semantics.

Do not implement an adapter until the companion actor/runtime API and ownership contract are inspected and defined. Do not invent Ember behavior or change the official command list.

## 4. Mission validation next steps

1. Inspect the current Godot test harness and Resource conventions before designing validator code.
2. Draft a neutral fixture format with no BTV story facts or names.
3. Implement ID/reference validation tests first.
4. Implement graph validation tests next (reachability, cycles, terminal state).
5. Implement dialogue/evidence authority-boundary tests.
6. Implement Resource immutability and two-instance isolation tests.
7. Only then add Ridgeview profile-specific checks using approved slice constraints.
8. Keep all mission data authoring blocked until the relevant content sources and character facts are approved.

## 5. Exact resume point

Resume from commit 3a9108cea6067237471bb66a57b169a1bd6f4df2 on btv/test-first-contracts-001.

First inspect the CI workflow/test harness and current Godot Resource patterns, then design the smallest neutral mission-data validator fixture and failing tests. In parallel, continue NLI lifecycle contract work by defining actor/callback state ownership without adding a real adapter yet.

Keep Unity evaluation paused. Do not merge, alter canon, add mission content, choose a save architecture, or claim Android readiness.
