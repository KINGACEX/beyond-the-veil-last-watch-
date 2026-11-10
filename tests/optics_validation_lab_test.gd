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
	_check(lab.get_child_count() >= 10, "OPTICS LAB: ray examples and material/shadow stations are generated")
	_check(lab.get_node_or_null("ShadowReceiverFloor") is MeshInstance3D, "OPTICS LAB: shadow receiver exists")
	_check(lab.get_node_or_null("ShadowCaster") is MeshInstance3D, "OPTICS LAB: shadow-casting reference exists")
	_check(lab.get_node_or_null("NoShadowReference") is MeshInstance3D, "OPTICS LAB: non-shadow reference exists")
	_check(lab.get_node_or_null("Material_Metallic") is MeshInstance3D, "OPTICS LAB: metallic material sample exists")
	_check(lab.get_node_or_null("Material_Matte") is MeshInstance3D, "OPTICS LAB: matte material sample exists")
	_check(lab.get_node_or_null("Material_GlassLike") is MeshInstance3D, "OPTICS LAB: glass-like material sample exists")
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
