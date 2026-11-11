extends SceneTree
## Contract tests for evidence-aware modern and palaeo species profiles.

const Profile = preload("res://scripts/wildlife_species_profile.gd")
var failures := 0


func _initialize() -> void:
	_run()


func _run() -> void:
	var modern_profile := {
		"id": "sample_forest_bird",
		"common_name": "Sample forest bird",
		"scientific_name": "Genus species",
		"temporal_class": "modern",
		"conservation_status": "extant",
		"geographic_range": "Documented range to be researched",
		"taxonomic_source": "Taxonomic authority and access date to be supplied",
		"biomes": ["tropical_forest"],
		"evidence_types": ["modern_observation"],
		"sources": ["Primary field guide or biodiversity database citation"],
		"uncertainty_notes": ["Behaviour and local abundance require regional verification"],
		"reconstruction_confidence": {"habitat": 0.8, "diet": 0.6, "appearance": 0.9}
	}
	_check(Profile.is_valid_profile(modern_profile),
		"WILDLIFE_PROFILE: complete modern profile passes")

	var deep_time_profile := {
		"id": "sample_palaeo_mammal",
		"common_name": "Sample palaeo mammal",
		"scientific_name": "Genus species",
		"temporal_class": "deep_time",
		"conservation_status": "extinct",
		"geographic_range": "Fossil range requires locality-by-locality research",
		"taxonomic_source": "Peer-reviewed taxonomic reference to be supplied",
		"geological_interval": "Named geological interval required",
		"fossil_localities": ["Named formation and locality required"],
		"biomes": ["palaeo_steppe"],
		"evidence_types": ["body_fossil", "palaeoenvironmental"],
		"sources": ["Primary fossil catalogue or peer-reviewed source"],
		"uncertainty_notes": ["Soft tissue colour and vocalisation unknown"],
		"reconstruction_confidence": {"habitat": 0.7, "diet": 0.6, "locomotion": 0.5}
	}
	_check(Profile.is_valid_profile(deep_time_profile),
		"WILDLIFE_PROFILE: complete deep-time profile passes")

	var missing_locality := deep_time_profile.duplicate(true)
	missing_locality.erase("fossil_localities")
	_check(not Profile.is_valid_profile(missing_locality),
		"WILDLIFE_PROFILE: deep-time record requires fossil locality")

	var missing_fossil_evidence := deep_time_profile.duplicate(true)
	missing_fossil_evidence["evidence_types"] = ["palaeoenvironmental"]
	_check(not Profile.is_valid_profile(missing_fossil_evidence),
		"WILDLIFE_PROFILE: palaeoenvironment alone cannot satisfy fossil evidence requirement")

	var invalid_confidence := modern_profile.duplicate(true)
	invalid_confidence["reconstruction_confidence"]["diet"] = 1.5
	_check(not Profile.is_valid_profile(invalid_confidence),
		"WILDLIFE_PROFILE: confidence values are bounded to 0..1")
	var non_finite_confidence := modern_profile.duplicate(true)
	non_finite_confidence["reconstruction_confidence"]["appearance"] = INF
	_check(not Profile.is_valid_profile(non_finite_confidence),
		"WILDLIFE_PROFILE: non-finite confidence values are rejected")

	var unsupported_evidence := modern_profile.duplicate(true)
	unsupported_evidence["evidence_types"] = ["guesswork"]
	_check(not Profile.is_valid_profile(unsupported_evidence),
		"WILDLIFE_PROFILE: unsupported evidence types are rejected")

	var fossil_context_missing := modern_profile.duplicate(true)
	fossil_context_missing["evidence_types"] = ["modern_observation", "body_fossil"]
	_check(not Profile.is_valid_profile(fossil_context_missing),
		"WILDLIFE_PROFILE: mixed fossil evidence requires explicit evidence context")
	var empty_fossil_context := modern_profile.duplicate(true)
	empty_fossil_context["evidence_types"] = ["modern_observation", "body_fossil"]
	empty_fossil_context["evidence_context"] = "   "
	_check(not Profile.is_valid_profile(empty_fossil_context),
		"WILDLIFE_PROFILE: empty evidence context is rejected")
	var contextual_fossil_record := modern_profile.duplicate(true)
	contextual_fossil_record["evidence_types"] = ["modern_observation", "body_fossil"]
	contextual_fossil_record["evidence_context"] = "Fossil evidence is cited as historical context, not a modern occurrence claim."
	_check(Profile.is_valid_profile(contextual_fossil_record),
		"WILDLIFE_PROFILE: contextualized mixed evidence remains valid")

	print("\nWILDLIFE_SPECIES_PROFILE_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
