# NLI-004 — Asynchronous Request Lifecycle Guard

**Status:** PROTOTYPE COMPONENT IMPLEMENTED; SERVICE/ACTOR INTEGRATION NOT YET IMPLEMENTED  
**Branch:** `btv/nli-lifecycle-guard-001`  
**Engine:** Godot 4.7.2  
**Scope:** In-memory lifecycle guard only. This is not an actor dispatcher, timer service, persistence layer, or world-state authority.

## Implemented component

`scripts/nli/nli_request_lifecycle.gd` introduces `NLIRequestLifecycle` as a separate owner for asynchronous companion handoff state.

Each request records:
- canonical request ID;
- intended actor owner ID;
- scene generation;
- monotonic creation and deadline values supplied by the caller;
- lifecycle state;
- actor rejection reason, when applicable.

Supported transitions:

```text
pending -> accepted -> executing -> executed
pending -> rejected_by_actor
pending -> cancelled
accepted -> cancelled
pending -> expired
accepted -> expired
```

The guard rejects:
- blank or reused request IDs;
- missing actor owner IDs;
- invalid timeout/clock/generation parameters;
- callbacks from the wrong actor;
- callbacks from a different scene generation;
- actor acknowledgements after the deadline;
- duplicate acknowledgements;
- cancellation after execution has started.

The caller supplies a monotonic clock. No timer, background task, network request, or scene-tree dependency is created by this class. The caller must invoke `expire_due(now_msec)` to expire requests that receive no callback.

## Test evidence

`tests/nli_lifecycle_guard_test.gd` specifies and exercises:
1. actor ownership;
2. actor rejection as a terminal state;
3. stale callback after cancellation;
4. deadline expiry and late acknowledgement;
5. scene-generation mismatch;
6. duplicate acknowledgement;
7. cancellation boundary after execution starts;
8. single-use request IDs.

The initial test-first commit intentionally failed because the lifecycle implementation did not yet exist. After adding the component, the complete Godot 4.7.2 validation workflow passed on commit `c597d88cc57d8fe1dc9940e1253329e99ac69a84`.

## Explicit limitations — do not overclaim

This component is not yet wired into `NLIService`, a real Ember actor, or the scene lifecycle. Existing NLI service requests still use the existing request gate. No game command is dispatched by this component.

Before runtime integration:
1. define the authoritative scene-generation provider;
2. define a monotonic clock owner and expiry scheduling point;
3. connect validated NLI handoff envelopes to the intended actor;
4. make actor acceptance/rejection the only source of those outcomes;
5. route execution completion back through the guard;
6. define pause, scene teardown, save/reload and app-quit behavior;
7. decide whether cancellation during execution uses a separate actor interrupt contract;
8. add service-level integration tests and an in-scene actor test.

## Next acceptance gate

A service-level test must prove that a validated command can be handed to an actor, accepted/rejected by that actor, cancelled/expired safely, and completed exactly once, while a stale callback cannot mutate the active scene. The guard alone does not satisfy this gate.
