extends SceneTree

const Lifecycle = preload("res://scripts/nli/nli_request_lifecycle.gd")
const CompanionAdapter = preload("res://scripts/nli/nli_companion_adapter.gd")
const MockActor = preload("res://tests/fixtures/mock_nli_companion_actor.gd")

var failures := 0

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	_test_acceptance_is_actor_owned()
	_test_rejection_is_terminal()
	_test_cancelled_request_rejects_late_callback()
	_test_expired_request_rejects_late_callback()
	_test_scene_generation_rejects_stale_callback()
	_test_duplicate_acknowledgement_is_rejected()
	_test_execution_cannot_be_cancelled_as_pending()
	_test_request_ids_are_single_use()
	_test_execution_failure_is_retained()
	_test_adapter_dispatches_only_validated_handoffs()
	_test_actor_rejection_is_actor_owned()
	_test_actor_failure_is_reported()
	_test_stale_scene_callback_cannot_complete_request()
	_test_duplicate_actor_acknowledgement_is_ignored()
	_test_actor_identity_must_match_handoff()
	_test_adapter_cancellation_rejects_late_actor_callback()
	_test_actor_without_contract_is_not_dispatched()
	if failures == 0:
		print("NLI_LIFECYCLE_GUARD_TESTS: PASS")
		quit(0)
	else:
		printerr("NLI_LIFECYCLE_GUARD_TESTS: FAIL (", failures, " failures)")
		quit(1)

func _test_acceptance_is_actor_owned() -> void:
	var lifecycle = Lifecycle.new()
	_check(lifecycle.begin_request("r-accept", "ember", 4, 100, 1000).get("ok", false), "Request begins")
	_check(lifecycle.actor_accept("r-accept", "other_actor", 4, 110).get("code") == "actor_mismatch", "Only intended actor may acknowledge")
	var accepted: Dictionary = lifecycle.actor_accept("r-accept", "ember", 4, 120)
	_check(accepted.get("ok", false), "Intended actor can accept")
	_check(accepted.get("state") == "accepted", "Acceptance has explicit state")

func _test_rejection_is_terminal() -> void:
	var lifecycle = Lifecycle.new()
	lifecycle.begin_request("r-reject", "ember", 1, 0, 1000)
	var rejected: Dictionary = lifecycle.actor_reject("r-reject", "ember", 1, "Actor unavailable", 10)
	_check(rejected.get("ok", false), "Actor can reject request")
	_check(rejected.get("state") == "rejected_by_actor", "Rejection is explicit terminal outcome")
	_check(lifecycle.actor_accept("r-reject", "ember", 1, 11).get("code") == "request_not_pending", "Rejected request cannot later be accepted")

func _test_cancelled_request_rejects_late_callback() -> void:
	var lifecycle = Lifecycle.new()
	lifecycle.begin_request("r-cancel", "ember", 2, 0, 1000)
	_check(lifecycle.cancel_request("r-cancel", 1).get("ok", false), "Pending request cancels")
	_check(lifecycle.actor_accept("r-cancel", "ember", 2, 2).get("code") == "request_not_pending", "Late callback cannot revive cancellation")

func _test_expired_request_rejects_late_callback() -> void:
	var lifecycle = Lifecycle.new()
	lifecycle.begin_request("r-expire", "ember", 2, 100, 50)
	_check(lifecycle.actor_accept("r-expire", "ember", 2, 150).get("code") == "request_expired", "Deadline is exclusive and request expires at deadline")
	_check(lifecycle.get_state("r-expire") == "expired", "Expired state is retained")
	_check(lifecycle.actor_accept("r-expire", "ember", 2, 151).get("code") == "request_not_pending", "Late acknowledgement cannot revive expiry")

func _test_scene_generation_rejects_stale_callback() -> void:
	var lifecycle = Lifecycle.new()
	lifecycle.begin_request("r-scene", "ember", 8, 0, 1000)
	var stale: Dictionary = lifecycle.actor_accept("r-scene", "ember", 9, 1)
	_check(stale.get("code") == "stale_scene_callback", "Callback from another scene generation is rejected")
	_check(lifecycle.get_state("r-scene") == "pending", "Stale callback leaves current request unchanged")

func _test_duplicate_acknowledgement_is_rejected() -> void:
	var lifecycle = Lifecycle.new()
	lifecycle.begin_request("r-duplicate", "ember", 1, 0, 1000)
	_check(lifecycle.actor_accept("r-duplicate", "ember", 1, 1).get("ok", false), "First acknowledgement succeeds")
	_check(lifecycle.actor_accept("r-duplicate", "ember", 1, 2).get("code") == "request_not_pending", "Duplicate acknowledgement cannot transition twice")

func _test_execution_cannot_be_cancelled_as_pending() -> void:
	var lifecycle = Lifecycle.new()
	lifecycle.begin_request("r-executing", "ember", 1, 0, 1000)
	lifecycle.actor_accept("r-executing", "ember", 1, 1)
	_check(lifecycle.mark_executing("r-executing").get("ok", false), "Accepted request enters executing")
	_check(lifecycle.cancel_request("r-executing", 2).get("code") == "execution_already_started", "Cancellation after execution requires a separate interrupt contract")
	_check(lifecycle.complete_request("r-executing").get("state") == "executed", "Actor completion is explicit")

func _test_request_ids_are_single_use() -> void:
	var lifecycle = Lifecycle.new()
	lifecycle.begin_request("r-once", "ember", 1, 0, 1000)
	lifecycle.cancel_request("r-once", 1)
	_check(lifecycle.begin_request("r-once", "ember", 1, 2, 1000).get("code") == "duplicate_request", "Terminal request ID cannot be reused")

func _test_execution_failure_is_retained() -> void:
	var lifecycle = Lifecycle.new()
	lifecycle.begin_request("r-failed", "ember", 1, 0, 1000)
	lifecycle.actor_accept("r-failed", "ember", 1, 1)
	lifecycle.mark_executing("r-failed")
	var failed: Dictionary = lifecycle.fail_request("r-failed", "Path unavailable")
	_check(failed.get("ok", false), "Executing request can record actor failure")
	_check(failed.get("state") == "failed", "Failure is retained as terminal state")
	_check(lifecycle.complete_request("r-failed").get("code") == "request_not_executing", "Failed request cannot later complete")

func _test_adapter_dispatches_only_validated_handoffs() -> void:
	var adapter = CompanionAdapter.new()
	var actor = MockActor.new()
	var now := Time.get_ticks_msec()
	var handoff := {"stage": "validated", "request_id": "adapter-success", "target_owner_id": "ember", "command": "scout"}
	var result: Dictionary = adapter.dispatch(handoff, actor, 10, now, 30000)
	_check(result.get("ok", false), "Validated handoff is dispatched")
	_check(adapter.get_state("adapter-success") == "executed", "Actor acceptance and completion advance the request")
	var invalid := handoff.duplicate(true)
	invalid["request_id"] = "adapter-unvalidated"
	invalid["stage"] = "draft"
	_check(adapter.dispatch(invalid, actor, 10, Time.get_ticks_msec(), 30000).get("code") == "handoff_not_validated", "Unvalidated envelope is blocked before actor dispatch")

func _test_actor_rejection_is_actor_owned() -> void:
	var adapter = CompanionAdapter.new()
	var actor = MockActor.new()
	actor.mode = "reject"
	var now := Time.get_ticks_msec()
	var handoff := {"stage": "validated", "request_id": "adapter-reject", "target_owner_id": "ember", "command": "scout"}
	adapter.dispatch(handoff, actor, 11, now, 30000)
	_check(adapter.get_state("adapter-reject") == "rejected_by_actor", "Actor rejection is retained without adapter approval")

func _test_actor_failure_is_reported() -> void:
	var adapter = CompanionAdapter.new()
	var actor = MockActor.new()
	actor.mode = "fail"
	var now := Time.get_ticks_msec()
	var handoff := {"stage": "validated", "request_id": "adapter-fail", "target_owner_id": "ember", "command": "scout"}
	adapter.dispatch(handoff, actor, 12, now, 30000)
	_check(adapter.get_state("adapter-fail") == "failed", "Actor execution failure is retained")

func _test_stale_scene_callback_cannot_complete_request() -> void:
	var adapter = CompanionAdapter.new()
	var actor = MockActor.new()
	actor.mode = "delayed"
	var now := Time.get_ticks_msec()
	var handoff := {"stage": "validated", "request_id": "adapter-stale", "target_owner_id": "ember", "command": "scout"}
	adapter.dispatch(handoff, actor, 13, now, 30000)
	adapter.set_active_scene_generation(14)
	actor.accept_saved()
	_check(adapter.get_state("adapter-stale") == "pending", "Callback from an old scene cannot accept the request")
	adapter.expire_due(now + 30001)
	_check(adapter.get_state("adapter-stale") == "expired", "Unacknowledged stale request can expire")

func _test_duplicate_actor_acknowledgement_is_ignored() -> void:
	var adapter = CompanionAdapter.new()
	var actor = MockActor.new()
	actor.mode = "duplicate"
	var now := Time.get_ticks_msec()
	var handoff := {"stage": "validated", "request_id": "adapter-duplicate", "target_owner_id": "ember", "command": "scout"}
	adapter.dispatch(handoff, actor, 15, now, 30000)
	_check(adapter.get_state("adapter-duplicate") == "executed", "Duplicate acknowledgement cannot prevent one successful completion")

func _test_actor_identity_must_match_handoff() -> void:
	var adapter = CompanionAdapter.new()
	var actor = MockActor.new()
	actor.actor_id = "not_ember"
	var handoff := {"stage": "validated", "request_id": "adapter-wrong-actor", "target_owner_id": "ember", "command": "scout"}
	var result: Dictionary = adapter.dispatch(handoff, actor, 16, Time.get_ticks_msec(), 30000)
	_check(result.get("code") == "actor_mismatch", "Adapter rejects actor identity mismatch before dispatch")


func _test_adapter_cancellation_rejects_late_actor_callback() -> void:
	var adapter = CompanionAdapter.new()
	var actor = MockActor.new()
	actor.mode = "delayed"
	var now := Time.get_ticks_msec()
	var handoff := {"stage": "validated", "request_id": "adapter-cancel", "target_owner_id": "ember", "command": "scout"}
	adapter.dispatch(handoff, actor, 17, now, 30000)
	_check(adapter.cancel_request("adapter-cancel", Time.get_ticks_msec()).get("ok", false), "Adapter can cancel a pending actor request")
	actor.accept_saved()
	_check(adapter.get_state("adapter-cancel") == "cancelled", "Late actor callback cannot revive cancelled request")

func _test_actor_without_contract_is_not_dispatched() -> void:
	var adapter = CompanionAdapter.new()
	var actor = RefCounted.new()
	var handoff := {"stage": "validated", "request_id": "adapter-no-contract", "target_owner_id": "ember", "command": "scout"}
	var result: Dictionary = adapter.dispatch(handoff, actor, 18, Time.get_ticks_msec(), 30000)
	_check(result.get("code") == "actor_contract_missing", "Actor without the required interface is rejected")


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
