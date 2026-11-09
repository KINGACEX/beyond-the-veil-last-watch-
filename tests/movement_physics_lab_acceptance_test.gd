extends SceneTree
## Acceptance checks for the first actual gameplay construction.
## This verifies scene structure and measurement affordances, not physical-device feel.

const LabScene = preload("res://scenes/movement_physics_lab.tscn")

var failures := 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 720)
	await process_frame
	var lab := LabScene.instantiate()
	root.add_child(lab)
	await process_frame
	await process_frame

	_check(lab.get_node_or_null("Player") is BTVPlayerController, "LAB: existing player controller is used")
	_check(lab.get_node_or_null("TouchControls") != null, "LAB: mobile touch controls are present")
	_check(lab.get_node_or_null("HUD/Telemetry") is Label, "LAB: telemetry label is present")

	var course := lab.get_node_or_null("Course") as Node3D
	_check(course != null, "LAB: neutral course is generated")
	if course != null:
		for required in [
			"Ground",
			"Ramp_Gentle",
			"Ramp_Steeper",
			"Step_01",
			"Step_02",
			"Step_03",
			"Wall_Front",
			"Corner_Wall_A",
			"Corner_Wall_B",
			"Doorway_Left",
			"Doorway_Right",
			"Corridor_Left",
			"Corridor_Right",
			"Camera_Occlusion_Wall",
		]:
			_check(course.get_node_or_null(required) is StaticBody3D, "LAB: %s collision course element exists" % required)
		var ground := course.get_node("Ground") as StaticBody3D
		_check(ground.get_node_or_null("CollisionShape3D") is CollisionShape3D, "LAB: ground has a collision shape")
		_check(ground.get_node_or_null("MeshInstance3D") is MeshInstance3D, "LAB: ground has a visible greybox mesh")
		var ramp := course.get_node("Ramp_Gentle") as StaticBody3D
		_check(ramp.rotation_degrees.x > 0.0, "LAB: ramp angle is explicitly configured for measurement")
		_check(course.get_node_or_null("LaneStart") is MeshInstance3D, "LAB: start measurement marker exists")
		_check(course.get_node_or_null("LaneFinish") is MeshInstance3D, "LAB: finish measurement marker exists")

	var telemetry: Label = lab.get_node("HUD/Telemetry")
	_check(telemetry.text.contains("Speed:"), "LAB: telemetry reports player speed")
	_check(telemetry.text.contains("Input:"), "LAB: telemetry reports composed input")
	_check(telemetry.text.contains("Camera pitch:"), "LAB: telemetry reports camera pitch")

	root.remove_child(lab)
	lab.free()
	print("\nMOVEMENT_PHYSICS_LAB_ACCEPTANCE_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
