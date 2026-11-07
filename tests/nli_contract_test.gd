extends SceneTree

const Service = preload("res://scripts/nli/nli_service.gd")
const KnowledgeBase = preload("res://scripts/nli/nli_knowledge_base.gd")
const RequestGate = preload("res://scripts/nli/nli_request_gate.gd")
const CompanionAdapter = preload("res://scripts/nli/nli_companion_adapter.gd")
const MockActor = preload("res://tests/fixtures/mock_nli_companion_actor.gd")

var failures := 0

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	_test_handoff_does_not_claim_actor_acceptance()
	_test_source_registry_resolves_authoritative_records()
	_test_source_registry_rejects_missing_and_mismatched_hashes()
	_test_allowlist_does_not_replace_source_resolution()
	_test_nonapproved_and_wrong_scope_sources_are_blocked()
	_test_request_gate_normalizes_identifiers_across_state_queries()
	_test_service_uses_one_canonical_request_id()
	_test_service_rejects_blank_request_ids_consistently()
	_test_query_and_action_requests_have_distinct_terminal_semantics()
	_test_cancellation_only_cancels_a_pending_action_request()
	_test_service_reconciles_adapter_terminal_state()
	_test_service_cancellation_reaches_dispatched_adapter()
	_test_service_keeps_delayed_execution_pending_until_terminal()
	if failures == 0:
		print("NLI_CONTRACT_TESTS: PASS")
		quit(0)
	else:
		printerr("NLI_CONTRACT_TESTS: FAIL (", failures, " failures)")
		quit(1)

func _test_handoff_does_not_claim_actor_acceptance() -> void:
	var service = Service.new()
	var response: Dictionary = service.handle_utterance("scout ahead", "contract-handoff-001", &"", "ember")
	var result: Dictionary = response.get("result", {})
	_check(response.get("ok", false), "Valid companion command reaches NLI handoff")
	_check(not result.has("accepted"), "NLI never claims companion acceptance")
	_check(result.get("stage") == "validated", "NLI reports validated before actor dispatch")
	_check(result.get("target_owner_id") == "ember", "Validated request identifies its intended companion owner")

func _test_source_registry_resolves_authoritative_records() -> void:
	var knowledge = KnowledgeBase.new()
	_check(knowledge.has_method("register_source"), "Knowledge base exposes an explicit source registry")
	_check(knowledge.has_method("resolve_source"), "Knowledge base exposes source resolution")
	if not knowledge.has_method("register_source") or not knowledge.has_method("resolve_source"):
		return
	var source := {
		"source_id": "source-contract-001",
		"source_type": "canon_document",
		"title": "Approved test source",
		"location": "res://tests/fixtures/nli_source_registry_fixture.md",
		"content_hash": FileAccess.get_sha256("res://tests/fixtures/nli_source_registry_fixture.md"),
		"authority_status": "SLICE",
		"review_status": "approved",
		"permitted_scopes": ["profile-ember"]
	}
	var registered: Dictionary = knowledge.call("register_source", source)
	_check(registered.get("ok", false), "Valid approved source can be registered")
	var resolved: Dictionary = knowledge.call("resolve_source", "source-contract-001")
	_check(resolved.get("ok", false), "Registered source ID resolves")
	_check(resolved.get("record", {}).get("review_status") == "approved", "Resolver returns review status")

func _test_source_registry_rejects_missing_and_mismatched_hashes() -> void:
	var knowledge = KnowledgeBase.new()
	var missing_source := {
		"source_id": "source-missing-file",
		"source_type": "test_fixture",
		"title": "Missing source file",
		"location": "res://tests/fixtures/does-not-exist.md",
		"content_hash": FileAccess.get_sha256("res://tests/fixtures/nli_source_registry_fixture.md"),
		"authority_status": "SLICE",
		"review_status": "approved",
		"permitted_scopes": ["profile-integrity"]
	}
	_check(knowledge.register_source(missing_source).get("code") == "source_file_missing", "Missing source files cannot be registered")
	var mismatched_source := missing_source.duplicate(true)
	mismatched_source["source_id"] = "source-wrong-digest"
	mismatched_source["location"] = "res://tests/fixtures/nli_source_registry_fixture.md"
	mismatched_source["content_hash"] = "0000000000000000000000000000000000000000000000000000000000000000"
	_check(knowledge.register_source(mismatched_source).get("code") == "source_hash_mismatch", "A forged digest cannot be registered")
	var malformed_source := mismatched_source.duplicate(true)
	malformed_source["source_id"] = "source-malformed-digest"
	malformed_source["content_hash"] = "sha256:not-a-real-digest"
	_check(knowledge.register_source(malformed_source).get("code") == "invalid_source_hash", "Malformed digest strings are rejected")


func _test_allowlist_does_not_replace_source_resolution() -> void:
	var knowledge = KnowledgeBase.new()
	knowledge.register_profile(&"npc_guard", "profile-npc_guard", ["source-does-not-exist"])
	var record := {
		"npc_id": "npc_guard",
		"topic_id": "name",
		"statement_id": "statement-unresolved-source",
		"response_text": "I am the guard.",
		"provenance_category": "Observed",
		"source_id": "source-does-not-exist",
		"knowledge_scope": "profile-npc_guard",
		"canon_status": "SLICE",
		"is_evidence": false
	}
	var result: Dictionary = knowledge.add_record(record)
	_check(not result.get("ok", false), "Allowlisted but unresolved source is rejected")
	_check(result.get("code") == "source_unresolved", "Unresolved source has a stable failure code")

func _test_nonapproved_and_wrong_scope_sources_are_blocked() -> void:
	var knowledge = KnowledgeBase.new()
	var pending_source := {
		"source_id": "source-pending-001",
		"source_type": "canon_document",
		"title": "Pending source",
		"location": "res://tests/fixtures/nli_source_registry_fixture.md",
		"content_hash": FileAccess.get_sha256("res://tests/fixtures/nli_source_registry_fixture.md"),
		"authority_status": "SLICE",
		"review_status": "pending",
		"permitted_scopes": ["profile-pending"]
	}
	_check(knowledge.register_source(pending_source).get("ok", false), "Pending source can be recorded for review")
	_check(knowledge.resolve_source("source-pending-001").get("code") == "source_not_approved", "Pending source cannot authorize NPC knowledge")
	knowledge.register_profile(&"npc_scope", "profile-scope", ["source-wrong-scope"])
	knowledge.register_source({
		"source_id": "source-wrong-scope",
		"source_type": "canon_document",
		"title": "Approved but out-of-scope source",
		"location": "res://tests/fixtures/nli_source_registry_fixture.md",
		"content_hash": FileAccess.get_sha256("res://tests/fixtures/nli_source_registry_fixture.md"),
		"authority_status": "SLICE",
		"review_status": "approved",
		"permitted_scopes": ["different-profile"]
	})
	var wrong_scope_record := {
		"npc_id": "npc_scope",
		"topic_id": "fact",
		"statement_id": "statement-wrong-scope",
		"response_text": "A scoped statement.",
		"provenance_category": "Observed",
		"source_id": "source-wrong-scope",
		"knowledge_scope": "profile-scope",
		"canon_status": "SLICE",
		"is_evidence": false
	}
	_check(knowledge.add_record(wrong_scope_record).get("code") == "source_scope_mismatch", "Approved source outside the NPC scope is rejected")

func _test_request_gate_normalizes_identifiers_across_state_queries() -> void:
	var gate = RequestGate.new()
	_check(gate.begin_request("  padded-request  ").get("ok", false), "Request gate accepts a whitespace-padded identifier")
	_check(gate.is_pending(" padded-request "), "Pending lookup normalizes the request identifier")
	_check(gate.complete_request("padded-request").get("ok", false), "Completion accepts the normalized identifier")
	_check(gate.is_completed("  padded-request  "), "Completed lookup normalizes the request identifier")
	_check(gate.begin_request("  cancel-request  ").get("ok", false), "Second normalized request begins")
	_check(gate.cancel_request(" cancel-request ").get("ok", false), "Cancellation accepts the normalized identifier")
	_check(gate.is_cancelled("cancel-request  "), "Cancelled lookup normalizes the request identifier")

func _test_service_uses_one_canonical_request_id() -> void:
	var service = Service.new()
	var response: Dictionary = service.handle_utterance("scout ahead", "  canonical-command-001  ", &"", "ember")
	var intent: Dictionary = response.get("intent", {})
	var result: Dictionary = response.get("result", {})
	_check(response.get("ok", false), "Padded service request ID is accepted")
	_check(intent.get("request_id") == "canonical-command-001", "Parsed intent exposes canonical request ID")
	_check(result.get("request_id") == "canonical-command-001", "Handoff result exposes the same canonical request ID")

	var question_response: Dictionary = service.handle_utterance("who are you", "  canonical-question-001  ", &"npc_unknown")
	var question_intent: Dictionary = question_response.get("intent", {})
	_check(question_response.get("ok", false), "Padded question request ID is accepted")
	_check(question_intent.get("request_id") == "canonical-question-001", "Question intent exposes canonical request ID")

func _test_service_rejects_blank_request_ids_consistently() -> void:
	var service = Service.new()
	var command_response: Dictionary = service.handle_utterance("scout ahead", "   ", &"", "ember")
	_check(not command_response.get("ok", false), "Blank companion request ID is rejected")
	_check(command_response.get("code") == "missing_request_id", "Blank companion request has stable missing-ID error")

	var cancel_response: Dictionary = service.handle_utterance("cancel", "   ")
	_check(not cancel_response.get("ok", false), "Blank cancellation request ID is rejected")
	_check(cancel_response.get("code") == "missing_request_id", "Blank cancellation request has stable missing-ID error")

func _test_query_and_action_requests_have_distinct_terminal_semantics() -> void:
	var service = Service.new()
	var command: Dictionary = service.handle_utterance("scout ahead", "lifecycle-command-001", &"", "ember")
	_check(command.get("ok", false), "Companion command request validates")
	var duplicate_command: Dictionary = service.handle_utterance("scout ahead", "lifecycle-command-001", &"", "ember")
	_check(duplicate_command.get("code") == "duplicate_request", "Companion action request remains pending and single-use")

	var question: Dictionary = service.handle_utterance("who are you", "lifecycle-question-001", &"npc_unknown")
	_check(question.get("ok", false), "Knowledge query completes its processing path")
	var duplicate_question: Dictionary = service.handle_utterance("who are you", "lifecycle-question-001", &"npc_unknown")
	_check(duplicate_question.get("code") == "duplicate_request", "Completed knowledge query ID cannot be reused")


func _test_cancellation_only_cancels_a_pending_action_request() -> void:
	var service = Service.new()
	var command: Dictionary = service.handle_utterance("scout ahead", "lifecycle-cancel-001", &"", "ember")
	_check(command.get("ok", false), "Companion request is created before cancellation")
	var cancellation: Dictionary = service.handle_utterance("cancel", "lifecycle-cancel-001")
	var cancellation_result: Dictionary = cancellation.get("result", {})
	_check(cancellation.get("ok", false), "Pending companion request can be cancelled")
	_check(cancellation_result.get("code") == "request_cancelled", "Cancellation returns explicit cancelled state")
	var reused: Dictionary = service.handle_utterance("scout ahead", "lifecycle-cancel-001", &"", "ember")
	_check(reused.get("code") == "duplicate_request", "Cancelled request ID cannot be reused")

	var completed_service = Service.new()
	completed_service.handle_utterance("who are you", "lifecycle-question-cancel-001", &"npc_unknown")
	var completed_cancellation: Dictionary = completed_service.handle_utterance("cancel", "lifecycle-question-cancel-001")
	var completed_result: Dictionary = completed_cancellation.get("result", {})
	_check(not completed_cancellation.get("ok", false), "Completed knowledge query cannot be cancelled")
	_check(completed_result.get("code") == "request_not_pending", "Cancellation rejects a non-pending request")


func _test_service_reconciles_adapter_terminal_state() -> void:
	var service = Service.new()
	var adapter = CompanionAdapter.new()
	var actor = MockActor.new()
	var validated: Dictionary = service.handle_utterance("scout ahead", "service-adapter-success", &"", "ember")
	var handoff: Dictionary = validated.get("result", {})
	var forged: Dictionary = handoff.duplicate(true)
	forged["command"] = "protect"
	var forged_result: Dictionary = service.dispatch_companion_handoff(forged, adapter, actor, 31, Time.get_ticks_msec(), 30000)
	_check(forged_result.get("code") == "handoff_mismatch", "Service rejects a modified handoff even when its request ID is valid")
	var dispatched: Dictionary = service.dispatch_companion_handoff(handoff, adapter, actor, 31, Time.get_ticks_msec(), 30000)
	_check(dispatched.get("ok", false), "Service dispatches its exact validated handoff through the adapter")
	_check(service.get_companion_request_state("service-adapter-success") == "executed", "Service reads adapter-owned executed state")
	var duplicate: Dictionary = service.handle_utterance("scout ahead", "service-adapter-success", &"", "ember")
	_check(duplicate.get("code") == "duplicate_request", "Reconciled terminal request ID remains single-use")


func _test_service_cancellation_reaches_dispatched_adapter() -> void:
	var service = Service.new()
	var adapter = CompanionAdapter.new()
	var actor = MockActor.new()
	actor.mode = "delayed"
	var validated: Dictionary = service.handle_utterance("scout ahead", "service-adapter-cancel", &"", "ember")
	service.dispatch_companion_handoff(validated.get("result", {}), adapter, actor, 32, Time.get_ticks_msec(), 30000)
	var cancellation: Dictionary = service.handle_utterance("cancel", "service-adapter-cancel")
	_check(cancellation.get("ok", false), "Service cancellation reaches the dispatched adapter")
	_check(adapter.get_state("service-adapter-cancel") == "cancelled", "Adapter lifecycle records the cancellation")
	actor.accept_saved()
	_check(adapter.get_state("service-adapter-cancel") == "cancelled", "Late actor acknowledgement cannot revive service cancellation")


func _test_service_keeps_delayed_execution_pending_until_terminal() -> void:
	var service = Service.new()
	var adapter = CompanionAdapter.new()
	var actor = MockActor.new()
	actor.mode = "delayed"
	var validated: Dictionary = service.handle_utterance("scout ahead", "service-adapter-delayed", &"", "ember")
	service.dispatch_companion_handoff(validated.get("result", {}), adapter, actor, 33, Time.get_ticks_msec(), 30000)
	actor.accept_saved()
	_check(service.get_companion_request_state("service-adapter-delayed") == "executing", "Service preserves adapter executing state without premature completion")
	actor.complete_saved()
	_check(service.get_companion_request_state("service-adapter-delayed") == "executed", "Service reconciles the adapter after actor completion")


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
