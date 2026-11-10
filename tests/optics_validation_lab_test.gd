extends SceneTree
## Confirms the separate optics validation scene can be instantiated safely.

const LabScene = preload("res://scenes/optics_validation_lab.tscn")


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var lab := LabScene.instantiate()
	root.add_child(lab)
	await process_frame
	_check(lab.get_node_or_null("Camera3D") is Camera3D, "OPTICS LAB: dedicated camera exists")
	_check(lab.get_child_count() >= 5, "OPTICS LAB: boundary and three ray examples are generated")
	root.remove_child(lab)
	lab.free()
	print("\nOPTICS_LAB_SCENE_TESTS: PASS")
	quit(0)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		printerr("FAIL: ", label)
		quit(1)
