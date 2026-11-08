extends SceneTree

const Validator = preload("res://scripts/mission/mission_data_validator.gd")

var failures := 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	_test_valid_registry_and_reference()
	_test_blank_identity_is_rejected()
	_test_duplicate_ids_are_scoped_by_namespace()
	_test_missing_reference_owner_is_rejected()
	_test_missing_reference_target_is_rejected()
	_test_duplicate_target_is_ambiguous()
	_test_whitespace_is_normalized_without_case_folding()
	_test_malformed_entries_are_rejected()
	_test_diagnostics_preserve_owner_source_path()
	_test_non_string_record_identity_is_rejected()
	_test_non_string_reference_fields_are_rejected()
	if failures == 0:
		print("MISSION_DATA_VALIDATOR_TESTS: PASS")
		quit(0)
	else:
		printerr("MISSION_DATA_VALIDATOR_TESTS: FAIL (", failures, " failures)")
		quit(1)


func _test_valid_registry_and_reference() -> void:
	var result: Dictionary = Validator.validate_registry(
		[
			{"namespace": "mission", "id": "mission_intro", "path": "res://fixtures/mission.json"},
			{"namespace": "objective", "id": "objective_entry", "path": "res://fixtures/mission.json"}
		],
		[
			{
				"from_namespace": "mission",
				"from_id": "mission_intro",
				"field": "entry_objective_id",
				"to_namespace": "objective",
				"to_id": "objective_entry"
			}
		]
	)
	_check(result.get("ok", false), "Valid neutral registry and reference pass")
	_check(result.get("diagnostics", []).is_empty(), "Valid registry emits no diagnostics")


func _test_blank_identity_is_rejected() -> void:
	var result: Dictionary = Validator.validate_registry(
		[
			{"namespace": "mission", "id": "   ", "path": "fixture-a"},
			{"namespace": "   ", "id": "objective_entry", "path": "fixture-a"}
		],
		[]
	)
	_check(not result.get("ok", true), "Blank IDs and namespaces are rejected")
	_check(_has_code(result, "missing_id"), "Blank ID has stable diagnostic code")
	_check(_has_code(result, "missing_namespace"), "Blank namespace has stable diagnostic code")


func _test_duplicate_ids_are_scoped_by_namespace() -> void:
	var valid_cross_namespace: Dictionary = Validator.validate_registry(
		[
			{"namespace": "mission", "id": "shared_id", "path": "fixture-a"},
			{"namespace": "objective", "id": "shared_id", "path": "fixture-a"}
		],
		[]
	)
	_check(valid_cross_namespace.get("ok", false), "Same ID in different typed namespaces is allowed")

	var duplicate: Dictionary = Validator.validate_registry(
		[
			{"namespace": "objective", "id": "shared_id", "path": "fixture-a"},
			{"namespace": "objective", "id": "shared_id", "path": "fixture-b"}
		],
		[]
	)
	_check(not duplicate.get("ok", true), "Duplicate ID in one namespace is rejected")
	_check(_has_code(duplicate, "duplicate_id"), "Duplicate ID has stable diagnostic code")


func _test_missing_reference_owner_is_rejected() -> void:
	var result: Dictionary = Validator.validate_registry(
		[
			{"namespace": "objective", "id": "objective_entry", "path": "fixture-a"}
		],
		[
			{
				"from_namespace": "mission",
				"from_id": "mission_missing",
				"field": "entry_objective_id",
				"to_namespace": "objective",
				"to_id": "objective_entry"
			}
		]
	)
	_check(not result.get("ok", true), "Reference with missing owner is rejected")
	_check(_has_code(result, "unresolved_reference_owner"), "Missing owner has stable diagnostic code")


func _test_missing_reference_target_is_rejected() -> void:
	var result: Dictionary = Validator.validate_registry(
		[
			{"namespace": "mission", "id": "mission_intro", "path": "fixture-a"}
		],
		[
			{
				"from_namespace": "mission",
				"from_id": "mission_intro",
				"field": "entry_objective_id",
				"to_namespace": "objective",
				"to_id": "objective_missing"
			}
		]
	)
	_check(not result.get("ok", true), "Dangling reference target is rejected")
	_check(_has_code(result, "unresolved_reference_target"), "Missing target has stable diagnostic code")


func _test_duplicate_target_is_ambiguous() -> void:
	var result: Dictionary = Validator.validate_registry(
		[
			{"namespace": "mission", "id": "mission_intro", "path": "fixture-a"},
			{"namespace": "objective", "id": "objective_entry", "path": "fixture-a"},
			{"namespace": "objective", "id": "objective_entry", "path": "fixture-b"}
		],
		[
			{
				"from_namespace": "mission",
				"from_id": "mission_intro",
				"field": "entry_objective_id",
				"to_namespace": "objective",
				"to_id": "objective_entry"
			}
		]
	)
	_check(not result.get("ok", true), "Reference to duplicate target is rejected")
	_check(_has_code(result, "ambiguous_reference_target"), "Ambiguous target has stable diagnostic code")


func _test_whitespace_is_normalized_without_case_folding() -> void:
	var padded: Dictionary = Validator.validate_registry(
		[
			{"namespace": " objective ", "id": " objective_entry ", "path": "fixture-a"},
			{"namespace": "mission", "id": "mission_intro", "path": "fixture-a"}
		],
		[
			{
				"from_namespace": "mission",
				"from_id": "mission_intro",
				"field": "entry_objective_id",
				"to_namespace": "objective",
				"to_id": "objective_entry"
			}
		]
	)
	_check(padded.get("ok", false), "Whitespace-padded IDs and namespaces resolve after trimming")

	var case_sensitive: Dictionary = Validator.validate_registry(
		[
			{"namespace": "objective", "id": "Objective_Entry", "path": "fixture-a"},
			{"namespace": "objective", "id": "objective_entry", "path": "fixture-a"}
		],
		[]
	)
	_check(case_sensitive.get("ok", false), "ID matching remains case-sensitive")


func _test_malformed_entries_are_rejected() -> void:
	var result: Dictionary = Validator.validate_registry(
		[null],
		[
			{
				"from_namespace": "mission",
				"from_id": "mission_intro",
				"field": "entry_objective_id",
				"to_namespace": "objective"
			}
		]
	)
	_check(not result.get("ok", true), "Malformed records and references are rejected")
	_check(_has_code(result, "invalid_record"), "Malformed record has stable diagnostic code")
	_check(_has_code(result, "invalid_reference"), "Malformed reference has stable diagnostic code")


func _test_diagnostics_preserve_owner_source_path() -> void:
	var result: Dictionary = Validator.validate_registry(
		[
			{"namespace": "mission", "id": "mission_intro", "path": "res://fixtures/intro.json"}
		],
		[
			{
				"from_namespace": "mission",
				"from_id": "mission_intro",
				"field": "entry_objective_id",
				"to_namespace": "objective",
				"to_id": "objective_missing"
			}
		]
	)
	var diagnostic := _find_diagnostic(result, "unresolved_reference_target")
	_check(not diagnostic.is_empty(), "Dangling target produces a diagnostic")
	_check(diagnostic.get("path") == "res://fixtures/intro.json", "Reference diagnostic identifies its owning source file")


func _find_diagnostic(result: Dictionary, code: String) -> Dictionary:
	for diagnostic in result.get("diagnostics", []):
		if diagnostic is Dictionary and diagnostic.get("code") == code:
			return diagnostic
	return {}


func _has_code(result: Dictionary, code: String) -> bool:
	for diagnostic in result.get("diagnostics", []):
		if diagnostic is Dictionary and diagnostic.get("code") == code:
			return true
	return false


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)


func _test_non_string_record_identity_is_rejected() -> void:
	var result: Dictionary = Validator.validate_registry(
		[
			{"namespace": 17, "id": "mission_intro", "path": "fixture-a"},
			{"namespace": "objective", "id": true, "path": "fixture-b"}
		],
		[]
	)
	_check(not result.get("ok", true), "Non-string registry identity fields are rejected")
	_check(_has_code(result, "invalid_namespace_type"), "Non-string namespace has a stable type diagnostic")
	_check(_has_code(result, "invalid_id_type"), "Non-string ID has a stable type diagnostic")


func _test_non_string_reference_fields_are_rejected() -> void:
	var result: Dictionary = Validator.validate_registry(
		[
			{"namespace": "mission", "id": "mission_intro", "path": "fixture-a"},
			{"namespace": "objective", "id": "objective_entry", "path": "fixture-a"}
		],
		[
			{
				"from_namespace": "mission",
				"from_id": "mission_intro",
				"field": 42,
				"to_namespace": "objective",
				"to_id": "objective_entry"
			}
		]
	)
	_check(not result.get("ok", true), "Non-string reference fields are rejected")
	_check(_has_code(result, "invalid_reference_field_type"), "Non-string reference field has a stable type diagnostic")
