extends SceneTree

const Service = preload("res://scripts/nli/nli_service.gd")
const KnowledgeBase = preload("res://scripts/nli/nli_knowledge_base.gd")

var failures := 0

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	_test_handoff_does_not_claim_actor_acceptance()
	_test_source_registry_resolves_authoritative_records()
	_test_allowlist_does_not_replace_source_resolution()
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
		"location": "res://docs/test-source.md",
		"content_hash": "sha256:test-fixture",
		"authority_status": "SLICE",
		"review_status": "approved",
		"permitted_scopes": ["profile-ember"]
	}
	var registered: Dictionary = knowledge.call("register_source", source)
	_check(registered.get("ok", false), "Valid approved source can be registered")
	var resolved: Dictionary = knowledge.call("resolve_source", "source-contract-001")
	_check(resolved.get("ok", false), "Registered source ID resolves")
	_check(resolved.get("record", {}).get("review_status") == "approved", "Resolver returns review status")

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

func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
