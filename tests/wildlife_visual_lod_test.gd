extends SceneTree
## Pure tests for render-presentation LOD, separate from ecology simulation tiers.

const VisualLOD = preload("res://scripts/wildlife_visual_lod.gd")


func _initialize() -> void:
	_check(VisualLOD.classify_distance(0.0) == VisualLOD.NEAR, "WILDLIFE VISUAL LOD: zero distance is near")
	_check(VisualLOD.classify_distance(18.0) == VisualLOD.NEAR, "WILDLIFE VISUAL LOD: near boundary is inclusive")
	_check(VisualLOD.classify_distance(18.01) == VisualLOD.MID, "WILDLIFE VISUAL LOD: mid tier begins beyond near")
	_check(VisualLOD.classify_distance(45.0) == VisualLOD.MID, "WILDLIFE VISUAL LOD: mid boundary is inclusive")
	_check(VisualLOD.classify_distance(45.01) == VisualLOD.FAR, "WILDLIFE VISUAL LOD: far tier begins beyond mid")
	_check(VisualLOD.classify_distance(90.0) == VisualLOD.FAR, "WILDLIFE VISUAL LOD: far boundary is inclusive")
	_check(VisualLOD.classify_distance(90.01) == VisualLOD.OFF, "WILDLIFE VISUAL LOD: off tier begins beyond far")
	_check(VisualLOD.classify_distance(-1.0).is_empty(), "WILDLIFE VISUAL LOD: negative distance rejected")
	_check(VisualLOD.classify_distance(INF).is_empty(), "WILDLIFE VISUAL LOD: infinite distance rejected")
	_check(VisualLOD.classify_distance(10.0, 20.0, 15.0, 90.0).is_empty(), "WILDLIFE VISUAL LOD: invalid threshold ordering rejected")
	print("\nWILDLIFE_VISUAL_LOD_TESTS: PASS")
	quit(0)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		printerr("FAIL: ", label)
		quit(1)
