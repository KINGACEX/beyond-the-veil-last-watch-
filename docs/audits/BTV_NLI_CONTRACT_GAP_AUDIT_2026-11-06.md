# BTV NLI CONTRACT GAP AUDIT — 6 NOVEMBER 2026
**Branch:** `btv/test-first-contracts-001`  
**Audit type:** Read-only code and test review  
**Status:** FINDINGS CONFIRMED FROM SOURCE; REMEDIATIONS PROPOSED  
**Scope:** Request identity, lifecycle ownership, source registry, knowledge provenance and CI evidence.

## 1. Executive result

The current NLI foundation is deliberately conservative: phrase parsing is deterministic, validation is separate from execution, dialogue is speaker-scoped, unresolved/unapproved/out-of-scope sources are rejected, and dialogue cannot be marked as evidence. The service does not claim that a companion actor accepted or executed a command.

The remaining gap is not simply “add an adapter.” The request lifecycle and source-registry contracts need explicit ownership, canonical identity, stale-callback handling, persistence and integrity verification before a production adapter can safely be connected.

No source code was changed by this audit.

## 2. Files reviewed

- `scripts/nli/nli_service.gd`
- `scripts/nli/nli_request_gate.gd`
- `scripts/nli/nli_knowledge_base.gd`
- `scripts/nli/nli_command_parser.gd`
- `scripts/nli/nli_validator.gd`
- `tests/nli_contract_test.gd`
- `docs/implementation/NLI_003_HANDOFF_AND_SOURCE_REGISTRY_CONTRACT.md`

## 3. Confirmed protections already present

| Protection | Source evidence | Status |
|---|---|---|
| Parser recognizes explicit phrase forms only | `nli_command_parser.gd` | CONFIRMED |
| Deferred `attack` command is rejected | `nli_validator.gd` | CONFIRMED |
| Unknown command/topic does not become a guessed action | parser + validator | CONFIRMED |
| NLI validates but does not execute companion commands | `nli_service.gd` | CONFIRMED |
| Companion command is not falsely marked accepted/completed | `nli_service.gd` + contract test | CONFIRMED |
| Request IDs are single-use in the in-memory gate | `nli_request_gate.gd` | CONFIRMED |
| Gate trims IDs on begin/complete/cancel and state queries | `nli_request_gate.gd` | CONFIRMED |
| Unresolved/unapproved/out-of-scope sources are rejected | `nli_knowledge_base.gd` | CONFIRMED |
| NPC knowledge must match profile scope and source allowlist | `nli_knowledge_base.gd` | CONFIRMED |
| Dialogue records with `is_evidence=true` are rejected | `nli_knowledge_base.gd` | CONFIRMED |
| Conflicting statements are returned as ambiguous | `nli_knowledge_base.gd` | CONFIRMED |

These protections are bounded by the current in-memory prototype and the automated tests actually present. They do not imply a production-ready dialogue or companion system.

## 4. Findings and loophole analysis

### NLI-GAP-001 — No actor-owned lifecycle adapter
**Severity:** P0 before companion commands are used in gameplay  
**Evidence:** `NLIService.handle_utterance()` returns `stage: validated` for a companion command and leaves the request pending. No actor adapter is present in the reviewed files.

**Risk:** A future caller may mistake “validated” for “dispatched,” or create a parallel lifecycle that allows NLI and the actor to disagree about whether an action occurred.

**Required contract:** NLI owns parsing/validation and a handoff request ID. The companion actor owns acceptance/rejection and execution state. A dispatcher may report delivery/hand-off readiness but cannot fabricate actor acceptance. All state transitions must be attributable to one owner and one request identity.

**Tests before implementation:** adapter absent; dispatch accepted by transport; actor accepts; actor rejects; actor reports execution; actor failure; duplicate acknowledgement; callback after cancellation.

**Status:** BLOCKED — actor API and runtime ownership boundary are not yet defined.

### NLI-GAP-002 — No timeout, expiry or stale-callback policy
**Severity:** P0 before asynchronous dispatch  
**Evidence:** the gate has only pending, completed and cancelled dictionaries. It has no timestamps, expiry state, timeout policy or callback generation/token.

**Risk:** A delayed actor callback may update a request after the player has cancelled it, changed scenes or started a newer command. A pending request can remain pending indefinitely.

**Required contract:** define request creation time, expiry, cancellation semantics, callback correlation and terminal-state rules. A callback must be ignored unless its request identity and lifecycle generation still match the active request.

**Tests before implementation:** timeout; expiry; callback after timeout; callback after cancel; duplicate callback; callback after scene teardown; callback for unknown ID; callback from an earlier retry.

**Status:** PROPOSED; no production behavior implemented.

### NLI-GAP-003 — Request ID normalization is internal, not yet an explicit end-to-end contract
**Severity:** P1  
**Evidence:** `NLIRequestGate` trims IDs before storing/checking them. The parser and returned intent retain the caller-supplied request ID string. The current tests prove gate state-query normalization, not canonical identity across parser → service → adapter → actor → callback.

**Risk:** Components may log, compare or serialize different string representations for the same logical request. The gate currently treats padded and unpadded IDs as equivalent, while downstream components may not.

**Required contract:** normalize once at the service boundary, reject empty IDs, and use the same canonical ID in the parsed intent, service result, logs, adapter message, actor acknowledgement and persistence. Do not silently normalize different IDs in separate components.

**Tests before implementation:** padded ID returns canonical ID everywhere; duplicate padded/unpadded IDs rejected; callback uses canonical ID; empty/whitespace ID rejected; serialization round-trip preserves identity.

**Status:** PROPOSED; current gate normalization is confirmed, end-to-end canonicalization is not.

### NLI-GAP-004 — Source content hash is metadata, not verified integrity
**Severity:** P0 before external or mutable source ingestion  
**Evidence:** `register_source()` requires a non-empty `content_hash` string but does not calculate a digest, validate its algorithm/format, read the referenced content or compare bytes with the declared hash. Current tests use fixture values such as `sha256:test-fixture`.

**Risk:** A source record can claim a hash that does not match the underlying file. The registry therefore records an asserted hash, not cryptographic proof of source integrity.

**Required contract:** define supported hash algorithm and canonical byte encoding; compute digest from the actual source bytes in a trusted ingestion step; reject mismatches; bind source version and immutable identity; define behavior when content changes or disappears.

**Tests before implementation:** valid digest accepted; malformed digest rejected; content mismatch rejected; same ID with changed bytes rejected or explicitly versioned; missing file rejected; algorithm identifier mismatch rejected.

**Status:** BLOCKED — source-loading and hashing boundary is not implemented.

### NLI-GAP-005 — Source registry has no update/withdraw/version lifecycle
**Severity:** P1 before production content updates  
**Evidence:** source registration is append-only in the in-memory knowledge base; duplicate IDs are rejected. Resolver checks review status but there is no controlled update, withdrawal, stale marking, version replacement or invalidation method.

**Risk:** A source that becomes stale or withdrawn cannot be updated through a defined registry API in the current prototype. Rebuilding the knowledge base may be the only way to replace it, with no audit trail.

**Required contract:** immutable source versions, explicit supersedes relationships, review transitions, withdrawal reason, dependent-record invalidation and audit history. Never mutate a previously approved source silently.

**Tests before implementation:** pending→approved; approved→stale; approved→withdrawn; new version supersedes old; dependent NPC records stop resolving when source is withdrawn; old save/record references remain auditable.

**Status:** PROPOSED; not implemented.

### NLI-GAP-006 — Request state is in-memory only
**Severity:** P0 before pause/quit/reload support  
**Evidence:** `NLIRequestGate` stores dictionaries on the object and explicitly describes itself as in-memory. The knowledge base also stores sources, profiles and entries in memory.

**Risk:** pending/terminal request state and source review decisions do not survive process or scene lifecycle changes. Restoring an in-flight action without an explicit recovery policy could duplicate or falsely complete it.

**Required contract:** first decide which states are allowed to persist. On reload, do not automatically replay a companion action. Reconcile saved request identity with actor/world state and mark unrecoverable requests as interrupted/unknown rather than executed.

**Tests before implementation:** pause/resume; scene unload/reload; application quit/restart; corrupted registry; schema version migration; no duplicate dispatch after recovery.

**Status:** BLOCKED — persistence architecture is unapproved and actor reconciliation is absent.

### NLI-GAP-007 — Source and knowledge scope enforcement is present, but source wording support is not mechanically checked
**Severity:** P1 content-governance control  
**Evidence:** `add_record()` checks the source ID, review status, allowlist, scope, provenance category, canon status and evidence flag. It does not prove that `response_text` is entailed by the cited source.

**Risk:** A valid source identifier can be attached to wording that overstates, misquotes or contradicts the source. The schema enforces provenance linkage, not semantic entailment.

**Required contract:** content review must compare each statement with the exact source passage and preserve uncertainty. This is a human/editorial approval gate unless a separately validated process is designed; an automated model score must not become authority.

**Tests/reviews:** citation passage present; quotation exactness; paraphrase within source meaning; uncertainty retained; conflicting passages remain unresolved; translation/context reviewed for Scripture.

**Status:** PROPOSED editorial QA; no automated entailment guarantee.

### NLI-GAP-008 — Questions complete their request gate immediately, while companion requests remain pending
**Severity:** P2; clarify semantics  
**Evidence:** service completes the request after knowledge-base lookup for question intents, including an unknown answer. Companion commands return before completion so the request remains pending.

**Risk:** “completed” currently means the NLI query operation finished, not necessarily that the player received or read the response. The same state vocabulary may be misread across query and action workflows.

**Required contract:** distinguish request-processing completion from player presentation/acknowledgement if downstream UI needs it. Do not overload one state machine for synchronous knowledge lookup and asynchronous actor actions.

**Tests:** unknown answer still terminates processing; dialogue UI failure does not imply answer was never generated; companion state machine remains separate.

**Status:** PROPOSED semantics clarification.

### NLI-GAP-009 — No explicit rate/queue policy for competing companion commands
**Severity:** P1 before real-time actor dispatch  
**Evidence:** request gate prevents duplicate IDs but does not prevent multiple distinct pending command IDs for the same companion.

**Risk:** Multiple valid commands could be issued while an earlier one is unresolved. Without an actor-owned queue/replacement policy, ordering and cancellation behavior become ambiguous.

**Required contract:** decide whether each companion supports one active request, a bounded queue, safe replacement or parallel independent tasks. Define priority, interruption and player feedback. Do not assume that request deduplication is a concurrency policy.

**Tests:** second request while first pending; same command repeated with new ID; conflicting commands; queue overflow; cancellation of queued request; actor unavailable; scene transition.

**Status:** BLOCKED pending companion command and actor behavior design.

## 5. Priority remediation order

1. Define canonical request identity and separate query completion from action lifecycle semantics.
2. Specify actor-owned lifecycle and callback correlation before implementing an adapter.
3. Define timeout, cancellation, expiry, competing-request and scene-transition policies.
4. Define immutable source versioning and cryptographic ingestion/verification.
5. Define pause/quit/reload recovery only after actor/world reconciliation rules exist.
6. Add source-wording editorial QA and registry withdrawal/version review.
7. Implement only after the contract tests are written and fail for the expected reasons.

## 6. Evidence and verification boundary

- **CONFIRMED:** source inspection of the files listed above on branch `btv/test-first-contracts-001`.
- **CONFIRMED:** the request gate has whitespace normalization and the previous test-first regression was fixed.
- **CONFIRMED:** NLI contract tests currently exercise handoff non-acceptance, source resolution, source scope/review rejection and request-gate normalization.
- **UNKNOWN:** whether a separate local/uncommitted companion adapter exists outside this GitHub repository; no such adapter is present in the reviewed branch files.
- **NOT VERIFIED:** actor runtime acknowledgement, timeout/expiry, stale callbacks, persistence, hash verification, concurrency/queue behavior or semantic entailment.
- **NO CODE CHANGES:** this is an audit document, not an implementation.

## 7. Sources

Repository source files are linked by path in this document. The governing implementation contract is `docs/implementation/NLI_003_HANDOFF_AND_SOURCE_REGISTRY_CONTRACT.md`. The audit should be updated only when corresponding code, tests and CI evidence are committed.
