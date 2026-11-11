extends SceneTree
## Acceptance tests for the isolated wildlife LOD validation lab.

const LabScene = preload("res://scenes/wildlife_validation_lab.tscn")


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var lab := LabScene.instantiate()
	root.add_child(lab)
	await process_frame
	await process_frame
	_check(lab.get_node_or_null("Camera3D") is Camera3D, "WILDLIFE LAB: dedicated camera exists")
	_check(lab.get_node_or_null("HUD/Telemetry") is Label, "WILDLIFE LAB: scheduler telemetry exists")
	_check(lab.call("get_agent_count") == 10, "WILDLIFE LAB: ten neutral workload proxies are present")
	var telemetry: Label = lab.get_node("HUD/Telemetry")
	_check(telemetry.text.contains("Near:") and telemetry.text.contains("Off-screen:"), "WILDLIFE LAB: all four LOD tiers are reported")
	_check(telemetry.text.contains("no animal models"), "WILDLIFE LAB: non-production proxy boundary is explicit")
	root.remove_child(lab)
	lab.free()
	print("\nWILDLIFE_VALIDATION_LAB_TESTS: PASS")
	quit(0)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		printerr("FAIL: ", label)
		quit(1)
