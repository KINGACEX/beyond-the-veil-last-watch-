# NLI-005 — Companion Actor Adapter Contract

**Status:** ADAPTER PROTOTYPE IMPLEMENTED AND CI-TESTED; NO PRODUCTION COMPANION ACTOR EXISTS YET  
**Branch:** `btv/nli-lifecycle-guard-001`

## Purpose

The NLI service validates a bounded command and returns a handoff envelope. The companion adapter is the boundary between that envelope and a companion actor. The adapter does not decide whether a command is wise, safe, possible, or narratively appropriate. Those decisions remain with the actor and authoritative gameplay systems.

## Current code

- `scripts/nli/nli_companion_adapter.gd`: validates the handoff envelope and actor contract, starts lifecycle tracking, and passes the request to the actor.
- `scripts/nli/nli_request_lifecycle.gd`: owns the request state machine.
- `tests/fixtures/mock_nli_companion_actor.gd`: test double only; not a production Ember actor.
- `tests/nli_lifecycle_guard_test.gd`: tests the adapter boundary and lifecycle outcomes.

## Required actor interface

A production companion actor must implement:

```gdscript
func get_nli_actor_id() -> String

func receive_nli_command(
    envelope: Dictionary,
    decision_callback: Callable,
    completion_callback: Callable
) -> void
```

The envelope contains only:
- `request_id`
- `actor_id`
- `scene_generation`
- `command`

The actor must:
1. Verify the request is still relevant to its own current state.
2. Decide whether to accept or reject it.
3. Invoke the decision callback exactly once with `(accepted: bool, reason: String)`.
4. If accepted, execute through its normal gameplay controller, not by granting the NLI adapter direct world-state authority.
5. Invoke the completion callback exactly once with `(succeeded: bool, reason: String)` after execution finishes.
6. Never report success merely because it received the request.

The adapter reports dispatch, not acceptance. Actor rejection is retained as `rejected_by_actor`; execution success as `executed`; execution failure as `failed`.

## Scene generation and time

Pending requests can be cancelled through `cancel_request(request_id, now_msec)`; callbacks arriving after cancellation are ignored by the lifecycle guard.\n\nThe adapter is informed when the active scene generation changes through `set_active_scene_generation`. A callback from an old scene is rejected by the lifecycle guard. The host must call this method as part of its authoritative scene-transition handling.

The caller supplies `now_msec` from the same monotonic clock domain used by `Time.get_ticks_msec()`. The adapter uses Godot's monotonic tick clock for asynchronous callbacks. The host must call `expire_due(now_msec)` periodically; the adapter does not create a timer or background process.

## Explicit integration gaps

- No production Ember actor implements this contract yet.
- The adapter is not yet wired into `NLIService` or a scene controller.
- The service's existing request gate and the new adapter lifecycle are not yet unified. Do not treat their states as one source of truth.
- Pause, scene teardown, application quit, save/reload and actor interruption still need explicit policies.
- Actor command execution must be separately constrained by gameplay permissions, distance, navigation, line-of-sight, cooldowns and mission rules where applicable.
- The current mock actor exists solely to verify callback ordering and lifecycle behaviour.

## Acceptance gate before production use

A real companion actor integration must demonstrate:
- the actor identity is registered by an authoritative scene owner;
- only the intended actor receives the command;
- actor acceptance/rejection is based on its live state;
- invalid, unavailable, busy or out-of-range requests are rejected with reasons;
- accepted actions are executed by the actor's normal controller;
- exactly one terminal outcome is recorded;
- stale callbacks after scene transition, cancellation or expiry cannot change gameplay;
- service and adapter request state are reconciled without duplicate completion;
- all cases pass automated tests and a real in-scene gameplay test.

Until these conditions are met, this is an integration prototype, not a working Ember command system.
