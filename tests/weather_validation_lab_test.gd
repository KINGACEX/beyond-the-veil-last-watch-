extends SceneTree
## Acceptance tests for local weather zone visualization and profile composition.

const LabScene = preload("res://scenes/weather_validation_lab.tscn")


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var lab := LabScene.instantiate()
	root.add_child(lab)
	await process_frame
	_check(lab.get_node_or_null("Camera3D") is Camera3D, "WEATHER LAB: dedicated camera exists")
	_check(lab.get_node_or_null("HUD/Telemetry") is Label, "WEATHER LAB: profile telemetry exists")
	_check(lab.get_node_or_null("Zone_Forest") is Node3D, "WEATHER LAB: forest test zone exists")
	_check(lab.get_node_or_null("Zone_Coastal") is Node3D, "WEATHER LAB: coastal test zone exists")
	_check(lab.get_node_or_null("SamplePoint") is MeshInstance3D, "WEATHER LAB: sample marker exists")
	var forest: Dictionary = lab.call("get_current_profile")
	_check(float(forest.get("rain", 0.0)) > 0.05, "WEATHER LAB: forest sample applies local profile")
	lab.call("set_sample_index", 1)
	var overlap: Dictionary = lab.call("get_current_profile")
	_check(float(overlap.get("rain", 0.0)) < float(forest.get("rain", 1.0)), "WEATHER LAB: overlap sample blends toward base conditions")
	lab.call("set_sample_index", 2)
	var coast: Dictionary = lab.call("get_current_profile")
	_check(float(coast.get("wind", 0.0)) > float(forest.get("wind", 0.0)), "WEATHER LAB: coastal sample reflects stronger wind profile")
	var telemetry: Label = lab.get_node("HUD/Telemetry")
	_check(telemetry.text.contains("Keys 1 / 2 / 3"), "WEATHER LAB: interactive sample controls are documented")
	root.remove_child(lab)
	lab.free()
	print("\nWEATHER_VALIDATION_LAB_TESTS: PASS")
	quit(0)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		printerr("FAIL: ", label)
		quit(1)
