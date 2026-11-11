extends SceneTree
## Structural checks for generic, canon-neutral wildlife presentation prototypes.

const LabScene = preload("res://scenes/wildlife_visual_prototype_lab.tscn")
var failures := 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var lab := LabScene.instantiate()
	root.add_child(lab)
	await process_frame
	await process_frame
	_check(lab.get_node_or_null("Camera3D") is Camera3D, "WILDLIFE VISUAL: dedicated camera exists")
	_check(lab.get_node_or_null("HUD/Telemetry") is Label, "WILDLIFE VISUAL: telemetry exists")
	_check(lab.get_node_or_null("GenericMammalStudy/Body_FurPlaceholder") is MeshInstance3D, "WILDLIFE VISUAL: mammal fur placeholder exists")
	_check(lab.get_node_or_null("GenericBirdStudy/Body_FeatherPlaceholder") is MeshInstance3D, "WILDLIFE VISUAL: bird feather placeholder exists")
	_check(lab.get_node_or_null("GenericBirdStudy/Wing_Left_FeatherPlaceholder") is MeshInstance3D, "WILDLIFE VISUAL: animated wing placeholder exists")
	_check(lab.get_node_or_null("GenericReptileStudy/Body_ScalePlaceholder") is MeshInstance3D, "WILDLIFE VISUAL: reptile scale placeholder exists")
	_check(lab.get_node_or_null("Habitat_WoodlandPresentation/WoodlandPad") is MeshInstance3D, "WILDLIFE VISUAL: woodland presentation pad exists")
	_check(lab.get_node_or_null("Habitat_OpenPerchPresentation/Perch_Branch_PresentationOnly") is MeshInstance3D, "WILDLIFE VISUAL: open-perch presentation prop exists")
	_check(lab.get_node_or_null("Habitat_RockyShelfPresentation/Rock_00") is MeshInstance3D, "WILDLIFE VISUAL: rocky-shelf presentation prop exists")
	_check(lab.get_node_or_null("GenericBirdStudy/Leg_BirdPlaceholder_0") is MeshInstance3D, "WILDLIFE VISUAL: bird locomotion placeholders exist")
	var state: Dictionary = lab.call("get_visual_prototype_state")
	_check(state.get("prototype_count", 0) == 3, "WILDLIFE VISUAL: three generic forms exist")
	_check(state.get("moving_part_count", 0) == 13, "WILDLIFE VISUAL: gait, wing and tail parts are registered for motion")
	_check(state.get("habitat_presentation_count", 0) == 3, "WILDLIFE VISUAL: three generic habitat presentations exist")
	_check(not state.get("habitat_species_evidence", true), "WILDLIFE VISUAL: habitat set dressing is not species evidence")
	_check(state.get("habitat_evidence_status", "").contains("not species occurrence evidence"), "WILDLIFE VISUAL: habitat uncertainty boundary is explicit")
	_check(state.get("nonviolent_visual_only", false), "WILDLIFE VISUAL: prototype remains visual-only and nonviolent")
	_check(not state.get("production_assets", true), "WILDLIFE VISUAL: production asset boundary is explicit")
	_check(not state.get("species_assignments", true), "WILDLIFE VISUAL: no unsupported species assignment")
	_check(lab.get_node("HUD/Telemetry").text.to_lower().contains("generic placeholders"), "WILDLIFE VISUAL: telemetry identifies placeholder status")
	var mammal_root := lab.get_node("GenericMammalStudy") as Node3D
	var bird_root := lab.get_node("GenericBirdStudy") as Node3D
	var reptile_root := lab.get_node("GenericReptileStudy") as Node3D
	_check(mammal_root.position.x < -5.0 and bird_root.position.x > -5.0 and bird_root.position.x < 5.0 and reptile_root.position.x > 5.0, "WILDLIFE VISUAL: body-form studies retain separate authored habitat-stage positions")
	_check(lab.get_node("Habitat_WoodlandPresentation").get_meta("species_assignment") == "none", "WILDLIFE VISUAL: woodland presentation carries no species assignment")
	_check(lab.get_node("Habitat_RockyShelfPresentation").get_meta("evidence_status") == "not_species_evidence", "WILDLIFE VISUAL: rocky presentation is explicitly not evidence")
	var mammal_leg := lab.get_node("GenericMammalStudy/Leg_FurPlaceholder") as MeshInstance3D
	var bird_wing := lab.get_node("GenericBirdStudy/Wing_Left_FeatherPlaceholder") as MeshInstance3D
	var start_x := mammal_root.position.x
	lab.call("_process", 0.5)
	state = lab.call("get_visual_prototype_state")
	_check(state.get("animation_mode") == "locomotion", "WILDLIFE VISUAL: deterministic cycle enters locomotion")
	_check(absf(mammal_root.position.x - start_x) > 0.01, "WILDLIFE VISUAL: mammal proxy moves along its bounded visual path")
	_check(absf(mammal_leg.rotation.z) > 0.01, "WILDLIFE VISUAL: mammal legs receive a gait cycle")
	_check(absf(bird_wing.rotation.z) > 0.01, "WILDLIFE VISUAL: bird wing motion is active")
	lab.call("_process", 2.0)
	state = lab.call("get_visual_prototype_state")
	_check(state.get("animation_mode") == "idle", "WILDLIFE VISUAL: locomotion cycle enters endpoint idle")
	_check(is_zero_approx(mammal_leg.rotation.z), "WILDLIFE VISUAL: mammal gait settles during idle")
	var near_tiers: Dictionary = lab.call("update_visual_lod_for_camera", Vector3(-12.0, 0.08, 0.0))
	_check(near_tiers.get("mammal") == "near", "WILDLIFE VISUAL: near tier selected at close range")
	var mid_tiers: Dictionary = lab.call("update_visual_lod_for_camera", Vector3(30.0, 0.08, 0.0))
	_check(mid_tiers.get("mammal") == "mid", "WILDLIFE VISUAL: mid tier selected at medium range")
	_check(not lab.get_node("GenericMammalStudy/Leg_FurPlaceholder").visible, "WILDLIFE VISUAL: mid tier removes limb detail")
	_check(lab.get_node("GenericMammalStudy/Body_FurPlaceholder").visible, "WILDLIFE VISUAL: mid tier preserves the main silhouette")
	var far_tiers: Dictionary = lab.call("update_visual_lod_for_camera", Vector3(60.0, 0.08, 0.0))
	_check(far_tiers.get("mammal") == "far", "WILDLIFE VISUAL: far tier selected at long range")
	_check(not lab.get_node("GenericMammalStudy/Leg_FurPlaceholder").visible, "WILDLIFE VISUAL: far tier removes small limb geometry")
	_check(not lab.get_node("GenericBirdStudy/Wing_Left_FeatherPlaceholder").visible, "WILDLIFE VISUAL: far tier removes wing detail")
	var off_tiers: Dictionary = lab.call("update_visual_lod_for_camera", Vector3(110.0, 0.08, 0.0))
	_check(off_tiers.get("mammal") == "off", "WILDLIFE VISUAL: off tier selected beyond far range")
	_check(not lab.get_node("GenericMammalStudy").visible, "WILDLIFE VISUAL: off tier hides specimen root")
	lab.call("update_visual_lod_for_camera", Vector3(-12.0, 0.08, 0.0))
	_check(lab.get_node("GenericMammalStudy/Leg_FurPlaceholder").visible, "WILDLIFE VISUAL: near tier restores full detail")
	root.remove_child(lab)
	lab.free()
	print("\nWILDLIFE_VISUAL_PROTOTYPE_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
