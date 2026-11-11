extends SceneTree
## Structural checks for generic, canon-neutral wildlife presentation prototypes.

const LabScene = preload("res://scenes/wildlife_visual_prototype_lab.tscn")


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
	var state: Dictionary = lab.call("get_visual_prototype_state")
	_check(state.get("prototype_count", 0) == 3, "WILDLIFE VISUAL: three generic forms exist")
	_check(state.get("moving_part_count", 0) == 2, "WILDLIFE VISUAL: paired wing parts are animated")
	_check(not state.get("production_assets", true), "WILDLIFE VISUAL: production asset boundary is explicit")
	_check(not state.get("species_assignments", true), "WILDLIFE VISUAL: no unsupported species assignment")
	_check(lab.get_node("HUD/Telemetry").text.contains("generic placeholders"), "WILDLIFE VISUAL: telemetry identifies placeholder status")
	var near_tiers: Dictionary = lab.call("update_visual_lod_for_camera", Vector3(-12.0, 0.08, 0.0))
	_check(near_tiers.get("mammal") == "near", "WILDLIFE VISUAL: near tier selected at close range")
	var far_tiers: Dictionary = lab.call("update_visual_lod_for_camera", Vector3(48.0, 0.08, 0.0))
	_check(far_tiers.get("mammal") == "far", "WILDLIFE VISUAL: far tier selected at long range")
	_check(not lab.get_node("GenericMammalStudy/Leg_FurPlaceholder").visible, "WILDLIFE VISUAL: far tier removes small limb geometry")
	_check(not lab.get_node("GenericBirdStudy/Wing_Left_FeatherPlaceholder").visible, "WILDLIFE VISUAL: far tier removes wing detail")
	var off_tiers: Dictionary = lab.call("update_visual_lod_for_camera", Vector3(88.0, 0.08, 0.0))
	_check(off_tiers.get("mammal") == "off", "WILDLIFE VISUAL: off tier selected beyond far range")
	_check(not lab.get_node("GenericMammalStudy").visible, "WILDLIFE VISUAL: off tier hides specimen root")
	lab.call("update_visual_lod_for_camera", Vector3(-12.0, 0.08, 0.0))
	_check(lab.get_node("GenericMammalStudy/Leg_FurPlaceholder").visible, "WILDLIFE VISUAL: near tier restores full detail")
	root.remove_child(lab)
	lab.free()
	print("\nWILDLIFE_VISUAL_PROTOTYPE_TESTS: PASS")
	quit(0)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		printerr("FAIL: ", label)
		quit(1)
