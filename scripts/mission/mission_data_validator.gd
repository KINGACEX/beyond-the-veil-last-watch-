extends RefCounted

## Validates a neutral typed registry without imposing a final Godot Resource schema.
## IDs and namespaces are trimmed but remain case-sensitive.
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
		var namespace := String(record.get("namespace", "")).strip_edges()
		var record_id := String(record.get("id", "")).strip_edges()
		var path := String(record.get("path", ""))

		if namespace.is_empty():
			_add_diagnostic(diagnostics, "missing_namespace", namespace, record_id, "namespace", path, "A registry record requires a non-empty namespace.")
			continue
		if record_id.is_empty():
			_add_diagnostic(diagnostics, "missing_id", namespace, record_id, "id", path, "A registry record requires a non-empty stable ID.")
			continue

		var namespace_bucket: Dictionary = index.get(namespace, {})
		var matches: Array = namespace_bucket.get(record_id, [])
		matches.append(record)
		namespace_bucket[record_id] = matches
		index[namespace] = namespace_bucket

		if matches.size() == 2:
			_add_diagnostic(diagnostics, "duplicate_id", namespace, record_id, "id", path, "The stable ID is duplicated within its typed namespace.")

	for reference_variant in references:
		if not reference_variant is Dictionary:
			_add_diagnostic(diagnostics, "invalid_reference", "", "", "", "", "References must be dictionaries.")
			continue

		var reference: Dictionary = reference_variant
		var from_namespace := String(reference.get("from_namespace", "")).strip_edges()
		var from_id := String(reference.get("from_id", "")).strip_edges()
		var field := String(reference.get("field", "")).strip_edges()
		var to_namespace := String(reference.get("to_namespace", "")).strip_edges()
		var to_id := String(reference.get("to_id", "")).strip_edges()

		if from_namespace.is_empty() or from_id.is_empty() or field.is_empty() or to_namespace.is_empty() or to_id.is_empty():
			_add_diagnostic(diagnostics, "invalid_reference", from_namespace, from_id, field, "", "A reference requires owner namespace/ID, field, and target namespace/ID.")
			continue

		var owner_matches: Array = _find_matches(index, from_namespace, from_id)
		if owner_matches.is_empty():
			_add_diagnostic(diagnostics, "unresolved_reference_owner", from_namespace, from_id, field, "", "The record owning this reference does not exist.")
		elif owner_matches.size() > 1:
			_add_diagnostic(diagnostics, "ambiguous_reference_owner", from_namespace, from_id, field, "", "The record owning this reference is ambiguous.")

		var target_matches: Array = _find_matches(index, to_namespace, to_id)
		if target_matches.is_empty():
			_add_diagnostic(diagnostics, "unresolved_reference_target", from_namespace, from_id, field, "", "The referenced target does not exist in the requested namespace.")
		elif target_matches.size() > 1:
			_add_diagnostic(diagnostics, "ambiguous_reference_target", from_namespace, from_id, field, "", "The referenced target resolves to more than one record.")

	return {
		"ok": diagnostics.is_empty(),
		"diagnostics": diagnostics
	}


static func _find_matches(index: Dictionary, namespace: String, record_id: String) -> Array:
	var namespace_bucket: Dictionary = index.get(namespace, {})
	return namespace_bucket.get(record_id, [])


static func _add_diagnostic(
	diagnostics: Array[Dictionary],
	code: String,
	namespace: String,
	record_id: String,
	field: String,
	path: String,
	message: String
) -> void:
	diagnostics.append({
		"code": code,
		"severity": "error",
		"namespace": namespace,
		"record_id": record_id,
		"field": field,
		"path": path,
		"message": message
	})
