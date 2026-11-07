extends SceneTree

const Parser = preload("res://scripts/nli/nli_command_parser.gd")
const Validator = preload("res://scripts/nli/nli_validator.gd")
const Gate = preload("res://scripts/nli/nli_request_gate.gd")
const KnowledgeBase = preload("res://scripts/nli/nli_knowledge_base.gd")
const Service = preload("res://scripts/nli/nli_service.gd")

var _failures: int = 0


func _initialize() -> void:
	call_deferred("_run_tests")


func _run_tests() -> void:
	_test_parser_and_validation()
	_test_knowledge_boundaries()
	_test_request_lifecycle()
	_test_service_handoff()

	if _failures == 0:
		print("NLI_SMOKE_TESTS: PASS")
		quit(0)
	else:
		printerr("NLI_SMOKE_TESTS: FAIL (", _failures, " failures)")
		quit(1)


func _test_parser_and_validation() -> void:
	var parsed := Parser.parse("scout ahead", "req-001", "companion-test")
	_check(parsed.get("ok", false), "Scout phrase parses")
	if parsed.get("ok", false):
		var intent: Dictionary = parsed["intent"]
		_check(intent.get("command") == &"scout", "Scout phrase maps to Scout")
		_check(Validator.validate(intent).get("ok", false), "Scout with target validates")

	var missing_target := Parser.parse("hold position", "req-002")
	_check(missing_target.get("ok", false), "Hold phrase parses")
	if missing_target.get("ok", false):
		_check(not Validator.validate(missing_target["intent"]).get("ok", false), "Command without companion target is rejected")

	var deferred := Parser.parse("attack", "req-003", "companion-test")
	_check(deferred.get("ok", false), "Deferred Attack command is recognised")
	if deferred.get("ok", false):
		_check(Validator.validate(deferred["intent"]).get("code") == "feature_deferred", "Attack remains deferred")

	_check(not Parser.parse("", "req-004").get("ok", false), "Empty input is rejected")
	_check(not Parser.parse("do something surprising", "req-005").get("ok", false), "Unknown phrase is rejected")
	_check(Parser.parse("what is your name?", "req-006").get("intent", {}).get("topic") == &"name", "Exact question alias resolves")
	_check(Parser.parse("where is Ridgeview Outpost?", "req-007").get("intent", {}).get("topic") == &"ridgeview_outpost", "Exact Ridgeview alias resolves")
	_check(Parser.parse("what happened at Ridgeview?", "req-008").get("code") == "clarification_required", "Unsupported question requests clarification instead of guessing")


func _test_knowledge_boundaries() -> void:
	var knowledge = KnowledgeBase.new()
	_check(knowledge.register_profile(&"npc_guard", "test-profile-npc_guard", ["test-source-guard-name-001", "test-source-guard-secret-001", "test-source-guard-name-002", "test-source-guard-reported-001", "test-source-guard-inferred-001", "test-source-guard-unconfirmed-001"]).get("ok", false), "NPC knowledge profile is registered")
	for source_id in ["test-source-guard-name-001", "test-source-guard-secret-001", "test-source-guard-name-002", "test-source-guard-reported-001", "test-source-guard-inferred-001", "test-source-guard-unconfirmed-001"]:
		_register_test_source(knowledge, source_id, "test-profile-npc_guard")
	_check(knowledge.register_profile(&"npc_guard", "duplicate-profile", []).get("code") == "profile_already_registered", "Duplicate NPC profile registration is rejected")
	_check(knowledge.add_record(_record("npc_guard", "name", "guard-name-001", "I am the outpost guard.")).get("ok", false), "Complete provenance-bearing record is accepted")
	var known := knowledge.answer(&"npc_guard", &"name")
	_check(known.get("known", false), "Authored NPC fact is returned")
	_check(known.get("response") == "I am the outpost guard.", "Authored response is preserved")
	_check(known.get("provenance_category") == "Observed", "Observed provenance is preserved in answer")
	for category in ["Reported", "Inferred", "Unconfirmed"]:
		var category_id := String(category).to_lower()
		var category_record := _record("npc_guard", category_id, "guard-" + category_id + "-001", "A test statement.", category)
		_check(knowledge.add_record(category_record).get("ok", false), category + " record is accepted")
		_check(knowledge.answer(&"npc_guard", StringName(category_id)).get("provenance_category") == category, category + " provenance is preserved")
	_check(not known.get("is_evidence", true), "NLI dialogue is never evidence")
	_check(knowledge.add_record(_record("npc_guard", "duplicate", "guard-name-001", "Duplicate identifier.")).get("code") == "duplicate_statement_id", "Duplicate statement identifier is rejected")

	var unknown := knowledge.answer(&"npc_guard", &"secret")
	_check(not unknown.get("known", true), "Unknown topic stays unknown")
	_check(unknown.get("source") == "knowledge_boundary", "Unknown answer identifies knowledge boundary")

	var evidence_record := _record("npc_guard", "secret", "guard-secret-001", "A private claim.")
	evidence_record["is_evidence"] = true
	_check(knowledge.add_record(evidence_record).get("code") == "dialogue_cannot_be_evidence", "Evidence-marked dialogue is rejected")

	var incomplete := _record("npc_guard", "secret", "guard-secret-002", "A private claim.")
	incomplete.erase("source_id")
	_check(knowledge.add_record(incomplete).get("code") == "missing_field", "Missing provenance field is rejected")

	var wrong_scope := _record("npc_guard", "secret", "guard-secret-wrong-scope", "Unauthorized source.")
	wrong_scope["source_id"] = "source-from-another-character"
	_check(knowledge.add_record(wrong_scope).get("code") == "source_outside_knowledge_scope", "Source outside NPC allowlist is rejected")
	var wrong_profile := _record("npc_guard", "secret", "guard-secret-wrong-profile", "Wrong profile.")
	wrong_profile["knowledge_scope"] = "another-npc-profile"
	_check(knowledge.add_record(wrong_profile).get("code") == "knowledge_scope_mismatch", "Cross-profile record is rejected")

	_check(knowledge.add_record(_record("npc_guard", "name", "guard-name-002", "I use a different name.")).get("ok", false), "Second authored entry is stored")
	var conflict := knowledge.answer(&"npc_guard", &"name")
	_check(conflict.get("ambiguous", false), "Conflicting entries return ambiguity")
	_check(conflict.get("source") == "knowledge_ambiguity", "Ambiguity is explicitly identified")


func _test_request_lifecycle() -> void:
	var gate = Gate.new()
	_check(gate.begin_request("cancel-me").get("ok", false), "Request begins")
	_check(not gate.begin_request("cancel-me").get("ok", true), "Duplicate pending request is rejected")
	_check(gate.cancel_request("cancel-me").get("ok", false), "Pending request can be cancelled")
	_check(not gate.is_pending("cancel-me"), "Cancelled request is no longer pending")
	_check(gate.is_cancelled("cancel-me"), "Cancelled request is recorded")
	_check(not gate.begin_request("cancel-me").get("ok", true), "Cancelled request ID cannot be replayed")
	_check(not gate.begin_request("   ").get("ok", true), "Blank request ID is rejected")
	_check(gate.begin_request("complete-me").get("ok", false), "Second request begins")
	_check(gate.complete_request("complete-me").get("ok", false), "Request completes")
	_check(not gate.begin_request("complete-me").get("ok", true), "Completed request ID cannot be replayed")


func _test_service_handoff() -> void:
	var knowledge = KnowledgeBase.new()
	knowledge.register_profile(&"npc_guard", "test-profile-npc_guard", ["test-source-service-guard-name-001"])
	_register_test_source(knowledge, "test-source-service-guard-name-001", "test-profile-npc_guard")
	knowledge.add_record(_record("npc_guard", "name", "service-guard-name-001", "I am the outpost guard."))
	var service = Service.new(knowledge)
	var response: Dictionary = service.handle_utterance("what is your name?", "service-001", &"npc_guard")
	_check(response.get("ok", false), "Service accepts validated question")
	_check(response.get("result", {}).get("response") == "I am the outpost guard.", "Service returns authored NPC knowledge")

	var command: Dictionary = service.handle_utterance("scout ahead", "service-002", &"", "companion-test")
	_check(command.get("ok", false), "Service accepts validated companion command")
	_check(command.get("result", {}).get("source") == "validated_command_request", "Command is handed off without direct world mutation")


func _register_test_source(knowledge: NLIKnowledgeBase, source_id: String, scope: String) -> void:
	knowledge.register_source({
		"source_id": source_id,
		"source_type": "test_fixture",
		"title": "NLI smoke-test source",
		"location": "res://tests/fixtures/nli_source_registry_fixture.md",
		"content_hash": FileAccess.get_sha256("res://tests/fixtures/nli_source_registry_fixture.md"),
		"authority_status": "SLICE",
		"review_status": "approved",
		"permitted_scopes": [scope]
	})


func _record(npc_id: String, topic_id: String, statement_id: String, response_text: String, provenance: String = "Observed") -> Dictionary:
	return {
		"npc_id": npc_id,
		"topic_id": topic_id,
		"statement_id": statement_id,
		"response_text": response_text,
		"provenance_category": provenance,
		"source_id": "test-source-" + statement_id,
		"knowledge_scope": "test-profile-" + npc_id,
		"canon_status": "SLICE",
		"is_evidence": false
	}


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		_failures += 1
		printerr("FAIL: ", label)
