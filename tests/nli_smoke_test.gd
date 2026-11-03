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


func _test_knowledge_boundaries() -> void:
	var knowledge = KnowledgeBase.new()
	knowledge.add_entry(&"npc_guard", &"name", "I am the outpost guard.")
	var known := knowledge.answer(&"npc_guard", &"name")
	_check(known.get("known", false), "Authored NPC fact is returned")
	_check(known.get("response") == "I am the outpost guard.", "Authored response is preserved")

	var unknown := knowledge.answer(&"npc_guard", &"secret")
	_check(not unknown.get("known", true), "Unknown topic stays unknown")
	_check(unknown.get("source") == "knowledge_boundary", "Unknown answer identifies knowledge boundary")


func _test_request_lifecycle() -> void:
	var gate = Gate.new()
	_check(gate.begin_request("cancel-me").get("ok", false), "Request begins")
	_check(not gate.begin_request("cancel-me").get("ok", true), "Duplicate pending request is rejected")
	_check(gate.cancel_request("cancel-me").get("ok", false), "Pending request can be cancelled")
	_check(not gate.is_pending("cancel-me"), "Cancelled request is no longer pending")
	_check(gate.begin_request("complete-me").get("ok", false), "Second request begins")
	_check(gate.complete_request("complete-me").get("ok", false), "Request completes")
	_check(not gate.begin_request("complete-me").get("ok", true), "Completed request ID cannot be replayed")


func _test_service_handoff() -> void:
	var knowledge = KnowledgeBase.new()
	knowledge.add_entry(&"npc_guard", &"name", "I am the outpost guard.")
	var service = Service.new(knowledge)
	var response: Dictionary = service.handle_utterance("what is your name?", "service-001", &"npc_guard")
	_check(response.get("ok", false), "Service accepts validated question")
	_check(response.get("result", {}).get("response") == "I am the outpost guard.", "Service returns authored NPC knowledge")

	var command: Dictionary = service.handle_utterance("scout ahead", "service-002", &"", "companion-test")
	_check(command.get("ok", false), "Service accepts validated companion command")
	_check(command.get("result", {}).get("source") == "validated_command_handoff", "Command is handed off without direct world mutation")


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		_failures += 1
		printerr("FAIL: ", label)
