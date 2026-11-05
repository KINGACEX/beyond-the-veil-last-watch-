# NLI 003 — Handoff State and Source Registry Contract
**Status:** PROPOSED — NOT IMPLEMENTED  
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
