# BTV Session Checkpoint — NLI Query/Action Lifecycle Tests

**Date:** 6 November 2026  
**Observed execution window:** 08:21:48–08:22:06 UTC for the lifecycle-test commit and CI completion. README/checkpoint follow-up occurred immediately afterward; exact assistant-session start time was not separately captured.  
**Branch:** btv/test-first-contracts-001  
**Latest code commit:** c4134c8098f0f86c68d462463fd029e8013b74b1  
**Latest code/test CI:** 42187126704 — SUCCESS on the exact code commit.

## Completed since prior checkpoint

### NLI request lifecycle tests

Extended tests/nli_contract_test.gd with explicit distinction between synchronous knowledge-query processing and pending companion action requests:

- A companion command request remains pending and its ID cannot be reused.
- A knowledge query completes its processing path and its ID cannot be reused.
- A pending companion request can be cancelled.
- A cancelled request ID cannot be reused.
- A completed knowledge query cannot be cancelled and returns request_not_pending.

These tests do not claim actor acceptance or execution. They document only the current in-memory request-gate semantics.

**Commit:** c4134c8098f0f86c68d462463fd029e8013b74b1  
**CI:** 42187126704 — SUCCESS. Steps passed: Godot 4.7.2 version check, project import/parsing, NLI smoke tests, NLI contract tests, core interaction acceptance tests, 10-frame main-scene launch.  
Run: https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42187126704

### README index and evidence refresh

Updated README.md to link the proposed mission-data validation contract and identify CI run 42187126704 as the latest code/test validation. This documentation-only commit followed the verified code commit.

**README commit:** d39e0783dbb68c7f4a31f390d7601b3017e7e3e6  
A separate CI run for this documentation-only commit may be in progress; do not claim it passed until checked.

## Current verified engineering state

- Canonical request ID is normalized once at NLIService boundary.
- Blank IDs return a stable missing_request_id error.
- Returned parsed intent and companion handoff result use the same canonical ID.
- NLI reports validated, not accepted or executed.
- Query processing and pending companion action semantics have explicit regression tests.
- Cancellation only succeeds for a pending request.
- Source registry remains in-memory; hash strings are not cryptographically verified.
- No real companion adapter, actor callback lifecycle, timeout, expiry, persistence or queue policy is implemented.

## Mission-data validation

Proposed contract:
docs/implementation/MISSION_DATA_VALIDATION_CONTRACT_001.md

It remains a proposal. No Resource schema, validator, mission-state service, Ridgeview mission data or dialogue content was implemented. The next engineering step is to inspect current test harness and data conventions, then build a neutral fixture and failing tests for stable IDs/reference integrity before graph validation.

## Boundaries

- Unity evaluation branch remains on hold.
- Godot remains the active engine line.
- No merge to main.
- No canon changes or new story facts.
- No paid services, deployment, public release or Android device verification.
- A passing headless run is not a playable vertical slice.

## Exact resume point

Resume from commit c4134c8098f0f86c68d462463fd029e8013b74b1 for code/test evidence, with README documentation at d39e0783dbb68c7f4a31f390d7601b3017e7e3e6.

Next:
1. Check the README-only commit's CI result.
2. Inspect the current test harness and data conventions; no Godot Resource examples currently exist in the project tree.
3. Build a neutral mission-data fixture and failing tests for ID uniqueness and reference resolution before implementing a validator.
4. Continue NLI actor-owned lifecycle contract design, but do not add an adapter until actor API and command concurrency semantics are defined.

Do not merge, alter canon, author Ridgeview content, choose a final save architecture or claim Android readiness.
