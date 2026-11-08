extends RefCounted

## Validates a neutral typed registry without imposing a final Godot Resource schema.
## IDs and namespaces must be Strings; their contents are trimmed but remain case-sensitive.
## Each record is a Dictionary with namespace, id and optional path.
## Each reference is a Dictionary with from_namespace, from_id, field,
## to_namespace and to_id.

static func validate_registry(records: Array, references: Array) -> Dictionary:
	var diagnostics: Array[Dictionary] = []
	var index: Dictionary = {}

	for record_variant in records:
		if not record_variant is Dictionary:
			_add_diagnostic(diagnostics, "invalid_record", "", "", "", "", "Registry entries must be dictionaries.")
			continue

		var record: Dictionary = record_variant
		var raw_namespace: Variant = record.get("namespace", "")
		var raw_id: Variant = record.get("id", "")
		var path := String(record.get("path", ""))

		if typeof(raw_namespace) != TYPE_STRING:
			_add_diagnostic(diagnostics, "invalid_namespace_type", "", "", "namespace", path, "A registry namespace must be a String.")
			continue
		if typeof(raw_id) != TYPE_STRING:
			_add_diagnostic(diagnostics, "invalid_id_type", String(raw_namespace).strip_edges(), "", "id", path, "A registry ID must be a String.")
			continue

		var record_namespace := String(raw_namespace).strip_edges()
		var record_id := String(raw_id).strip_edges()

		if record_namespace.is_empty():
			_add_diagnostic(diagnostics, "missing_namespace", record_namespace, record_id, "namespace", path, "A registry record requires a non-empty namespace.")
			continue
		if record_id.is_empty():
			_add_diagnostic(diagnostics, "missing_id", record_namespace, record_id, "id", path, "A registry record requires a non-empty stable ID.")
			continue

		var namespace_bucket: Dictionary = index.get(record_namespace, {})
		var matches: Array = namespace_bucket.get(record_id, [])
		matches.append(record)
		namespace_bucket[record_id] = matches
		index[record_namespace] = namespace_bucket

		if matches.size() == 2:
			_add_diagnostic(diagnostics, "duplicate_id", record_namespace, record_id, "id", path, "The stable ID is duplicated within its typed namespace.")

	for reference_variant in references:
		if not reference_variant is Dictionary:
			_add_diagnostic(diagnostics, "invalid_reference", "", "", "", "", "References must be dictionaries.")
			continue

		var reference: Dictionary = reference_variant
		var required_string_fields := ["from_namespace", "from_id", "field", "to_namespace", "to_id"]
		var invalid_type := false
		for field_name_variant in required_string_fields:
			var field_name := String(field_name_variant)
			if reference.has(field_name) and typeof(reference[field_name]) != TYPE_STRING:
				_add_diagnostic(diagnostics, "invalid_reference_field_type", "", "", field_name, String(reference.get("path", "")), "Reference field '%s' must be a String." % field_name)
				invalid_type = true
		if invalid_type:
			continue

		var from_namespace := String(reference.get("from_namespace", "")).strip_edges()
		var from_id := String(reference.get("from_id", "")).strip_edges()
		var field := String(reference.get("field", "")).strip_edges()
		var to_namespace := String(reference.get("to_namespace", "")).strip_edges()
		var to_id := String(reference.get("to_id", "")).strip_edges()

		if from_namespace.is_empty() or from_id.is_empty() or field.is_empty() or to_namespace.is_empty() or to_id.is_empty():
			_add_diagnostic(diagnostics, "invalid_reference", from_namespace, from_id, field, String(reference.get("path", "")), "A reference requires owner namespace/ID, field, and target namespace/ID.")
			continue

		var owner_matches: Array = _find_matches(index, from_namespace, from_id)
		var diagnostic_path := String(reference.get("path", ""))
		if diagnostic_path.is_empty() and owner_matches.size() == 1:
			diagnostic_path = String(owner_matches[0].get("path", ""))
		if owner_matches.is_empty():
			_add_diagnostic(diagnostics, "unresolved_reference_owner", from_namespace, from_id, field, diagnostic_path, "The record owning this reference does not exist.")
		elif owner_matches.size() > 1:
			_add_diagnostic(diagnostics, "ambiguous_reference_owner", from_namespace, from_id, field, diagnostic_path, "The record owning this reference is ambiguous.")

		var target_matches: Array = _find_matches(index, to_namespace, to_id)
		if target_matches.is_empty():
			_add_diagnostic(diagnostics, "unresolved_reference_target", from_namespace, from_id, field, diagnostic_path, "The referenced target does not exist in the requested namespace.")
		elif target_matches.size() > 1:
			_add_diagnostic(diagnostics, "ambiguous_reference_target", from_namespace, from_id, field, diagnostic_path, "The referenced target resolves to more than one record.")

	return {
		"ok": diagnostics.is_empty(),
		"diagnostics": diagnostics
	}


static func _find_matches(index: Dictionary, type_namespace: String, record_id: String) -> Array:
	var namespace_bucket: Dictionary = index.get(type_namespace, {})
	return namespace_bucket.get(record_id, [])


static func _add_diagnostic(
	diagnostics: Array[Dictionary],
	code: String,
	type_namespace: String,
	record_id: String,
	field: String,
	path: String,
	message: String
) -> void:
	diagnostics.append({
		"code": code,
		"severity": "error",
		"namespace": type_namespace,
		"record_id": record_id,
		"field": field,
		"path": path,
		"message": message
	})
