# NLI 003 — Handoff State and Source Registry Contract
**Status:** PARTIALLY IMPLEMENTED — test-first contract and service correction landed on isolated branch; full actor lifecycle remains open  
**Scope:** NLI service, companion adapter and NPC knowledge provenance. No canon changes.

## 1. Defect to resolve
The current NLI service returns `accepted: true` for a companion command while stating that the companion system must still accept or reject it. Separately, the knowledge base checks source-ID allowlists but does not resolve those IDs to authoritative records.

## 2. State ownership
| State | Meaning | Owner |
|---|---|---|
| parsed | Text mapped to typed intent | Parser |
| rejected | Input/intent failed validation | Validator/service |
| validated | Syntax and policy checks passed | Validator |
| handoff_ready | Request delivered to owning actor | NLI adapter |
| accepted | Actor explicitly accepts | Companion/gameplay actor |
| rejected_by_actor | Actor refuses with reason | Companion/gameplay actor |
| executing | Actor began action | Actor |
| executed | Actor reports completion | Actor |
| cancelled | Pending request cancelled | Request lifecycle |
| expired / failed | Deadline or terminal failure | Lifecycle/actor |

**Invariant:** NLI may report validated or handoff_ready. It must never claim actor acceptance, execution or completion.

## 3. Result envelope
Proposed fields: request_id, intent_kind, stage, owner_id, failure_code, logical created/updated time, optional expiry, source_refs and typed result payload. NLI cannot mutate mission, inventory, evidence, relationship, faith or world state.

## 4. Companion preconditions
The companion actor checks existence, active state, official command vocabulary, implementation availability, perception/range, conflicting state, scene context and duplicate/stale/cancelled request status. Failure returns a stable reason; no silent substitution, teleport or omniscient target search.

## 5. Source registry
Every source ID must resolve to one registry record containing:
- stable source_id and source_type;
- title and repository/resource location;
- content hash or version;
- authority status (LOCKED, SLICE, RESERVED, OPEN, historical);
- review status (approved, pending, stale, withdrawn);
- permitted owner/knowledge scope and review note.

An allowlisted but unresolved, stale, withdrawn or ambiguous source cannot authorize a factual NPC answer.

## 6. Knowledge validation
Require a registered NPC profile, resolvable source, approved review status, profile allowlist membership, matching scope, valid provenance, wording supported by source, unique statement ID and `is_evidence=false`. Conflicts return ambiguity; they are not silently ranked.

## 7. Lifecycle cases
Test duplicate pending/completed/cancelled IDs; cancel before/after completion; actor removed or scene changed; timeout; pause/quit/reload; offline; actor rejection; stale callbacks after cancellation; competing requests; missing/withdrawn/version-changed sources; conflicting statements. Cancellation after execution starts must use an explicit interrupt contract.

## 8. Minimum tests
| Case | Expected |
|---|---|
| Valid Scout request | validated → handoff_ready only |
| Actor accepts/rejects | Actor alone emits outcome |
| Actor completes | Actor alone emits executed |
| Duplicate request | Rejected; no second action |
| Cancel pending | Cancelled; stale callback ignored |
| Missing/stale source | Factual answer blocked |
| Allowlisted nonexistent source | Record rejected |
| Wrong NPC scope | Record rejected |
| Dialogue marked evidence | Record rejected |
| Conflicting source statements | Ambiguity returned |

## 9. Implementation order
1. Add failing tests for premature acceptance and unresolved source IDs.
2. Define result states and compatibility rules.
3. Implement source registry/resolver separately.
4. Change service to validated/handoff_ready only.
5. Add companion actor acknowledgement contract.
6. Add stale callback, expiry and cancellation behavior.
7. Run Godot 4.7.2 import and NLI tests; record actual outcomes.

No LLM/network dependency, new dialogue facts, command-list changes, or production save system are authorized by this specification.


## 10. Implementation evidence — 5 November 2026

**COMPLETED on isolated branch `btv/test-first-contracts-001`:**
- Added contract tests before changing the service semantics.
- Replaced the false `accepted: true` result with `stage: validated`; the result identifies the intended companion owner but does not claim that an adapter dispatched it.
- Kept companion requests pending rather than marking them completed inside NLI.
- Added source records with identity, type, title, location, content hash, authority status, review status and permitted scopes.
- Added source resolution; unresolved, unapproved and out-of-scope records are rejected.
- Updated smoke-test fixtures to register their test sources explicitly.

**Still PROPOSED / NOT IMPLEMENTED:**
- A real companion adapter that dispatches the validated request and reports `handoff_ready`.
- Actor-owned `accepted`, `rejected_by_actor`, `executing`, `executed`, cancellation and failure transitions.
- Expiry, timeout, stale callback handling, pause/quit/reload persistence and cancellation-after-execution semantics.
- A separate production source-registry service or persistent registry lifecycle; the current prototype registry is in-memory and held by the knowledge-base component.
- Cryptographic content-hash verification and source-version invalidation.

**Verification:** CI run `42027258305` passed the first NLI contract tests before the final validated-vs-handoff wording refinement. The expanded suite and latest branch head are awaiting their own CI result. Do not claim the complete NLI lifecycle is finished.


## 11. Additional lifecycle regression evidence — 5 November 2026

A test-first review found that `begin_request`, `complete_request` and `cancel_request` normalized request IDs with `strip_edges()`, but the read-only state queries `is_pending`, `is_completed` and `is_cancelled` did not. This made equivalent whitespace-padded IDs behave inconsistently across the same lifecycle.

**Regression tests added first** in `tests/nli_contract_test.gd`:
- pending lookup normalizes request ID;
- completed lookup normalizes request ID;
- cancelled lookup normalizes request ID.

The initial test run `42031539741` failed on all three lookup assertions while the begin/complete/cancel operations passed. This confirmed the inconsistency.

**Correction:** the three read-only query methods now call `strip_edges()` before checking their state dictionaries.

**Fix commit:** `67b799558b4a7690275dfb383b3a23e7cb8599cc`.

**Verification:** GitHub Actions run `42031646069` passed on that commit, including NLI smoke tests, NLI contract tests, core interaction acceptance tests and the 10-frame main-scene launch.

This fixes identifier normalization only. It does not implement actor-owned companion lifecycle, persistence, expiry, timeout, stale callbacks or cryptographic source-hash verification.


## 12. Source-file integrity verification — 7 November 2026

**IMPLEMENTED on isolated branch `btv/nli-lifecycle-guard-001`; CI verification pending:**
- Source registration now requires a 64-character hexadecimal SHA-256 digest.
- Source locations are restricted to project `res://` resources.
- Registration calculates the digest with Godot `FileAccess.get_sha256` and rejects missing files, malformed digests and mismatches.
- Source resolution recalculates the digest so changed or missing content cannot continue authorizing NPC knowledge.
- Tests use a dedicated non-canon fixture and verify missing-file, malformed-digest and incorrect-digest rejection.
- The fixture is explicitly test-only and must never be registered as production canon.

**Boundary:** This is file-integrity verification, not a full provenance or authorization system. A matching hash proves that the bytes match the registered digest; it does not prove that a document is authoritative, approved by the user, semantically supports a statement, or is safe to expose to a particular NPC. Existing review status, authority status, permitted scopes and NPC allowlists remain separate checks.
