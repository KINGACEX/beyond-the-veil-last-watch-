extends RefCounted
class_name BTVWildlifeSpeciesProfile

## Data-contract validation for modern, historical and palaeo-wildlife records.
## Validation does not approve species for canon or a production region.

const TEMPORAL_CLASSES := ["modern", "historical", "deep_time"]
const CONSERVATION_STATUSES := [
	"extant",
	"extinct_in_wild",
	"extinct",
	"regionally_extirpated",
	"reintroduced",
]
const EVIDENCE_TYPES := [
	"modern_observation",
	"historical_record",
	"body_fossil",
	"trace_fossil",
	"palaeoenvironmental",
]

static func validate_profile(profile: Dictionary) -> Array[String]:
	var errors: Array[String] = []
	_require_string(profile, "id", errors)
	_require_string(profile, "common_name", errors)
	_require_string(profile, "scientific_name", errors)
	_require_string(profile, "geographic_range", errors)
	_require_string(profile, "taxonomic_source", errors)

	var temporal_class := str(profile.get("temporal_class", ""))
	if not TEMPORAL_CLASSES.has(temporal_class):
		errors.append("temporal_class must be modern, historical or deep_time")

	var status := str(profile.get("conservation_status", ""))
	if not CONSERVATION_STATUSES.has(status):
		errors.append("conservation_status is missing or unsupported")

	_require_nonempty_array(profile, "biomes", errors)
	_require_nonempty_array(profile, "evidence_types", errors)
	_require_nonempty_array(profile, "sources", errors)
	_require_nonempty_array(profile, "uncertainty_notes", errors)

	var evidence: Array = profile.get("evidence_types", [])
	for item in evidence:
		if not EVIDENCE_TYPES.has(str(item)):
			errors.append("evidence_types contains unsupported value: %s" % str(item))

	var confidence: Variant = profile.get("reconstruction_confidence", null)
	if not confidence is Dictionary or confidence.is_empty():
		errors.append("reconstruction_confidence must be a non-empty dictionary")
	else:
		for key in confidence:
			var value: Variant = confidence[key]
			if not (value is int or value is float):
				errors.append("reconstruction_confidence values must be numeric")
				continue
			if float(value) < 0.0 or float(value) > 1.0:
				errors.append("reconstruction_confidence values must be within 0..1")

	if temporal_class == "deep_time":
		_require_string(profile, "geological_interval", errors)
		_require_nonempty_array(profile, "fossil_localities", errors)
		if not evidence.has("body_fossil") and not evidence.has("trace_fossil"):
			errors.append("deep_time profiles require body_fossil or trace_fossil evidence")
		if status != "extinct":
			errors.append("deep_time fossil-only profiles must use extinct status")
	elif evidence.has("body_fossil") or evidence.has("trace_fossil"):
		# Fossil evidence can support a modern/historical profile, but it must not
		# silently change that profile's temporal classification.
		if not profile.has("evidence_context"):
			errors.append("fossil evidence on non-deep_time profiles requires evidence_context")

	return errors


static func is_valid_profile(profile: Dictionary) -> bool:
	return validate_profile(profile).is_empty()


static func _require_string(profile: Dictionary, key: String, errors: Array[String]) -> void:
	var value: Variant = profile.get(key, null)
	if not value is String or str(value).strip_edges().is_empty():
		errors.append("%s must be a non-empty string" % key)


static func _require_nonempty_array(profile: Dictionary, key: String, errors: Array[String]) -> void:
	var value: Variant = profile.get(key, null)
	if not value is Array or value.is_empty():
		errors.append("%s must be a non-empty array" % key)
