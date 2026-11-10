extends SceneTree
## Headless check: scene loads, model has expected mesh count and rough size.
## Requires the GLB to be present (see tools/transfer_chapel_glb.sh).
## Run: godot --headless --path . --script res://tests/chapel_study_001_load_test.gd

const SCENE_PATH := "res://scenes/chapel/logos_rhema_chapel_study_001.tscn"

func _init() -> void:
	var packed := load(SCENE_PATH) as PackedScene
	if packed == null:
		push_error("FAIL: scene did not load")
		quit(1)
		return
	var root: Node = packed.instantiate()
	var meshes: Array[Node] = root.find_children("*", "MeshInstance3D", true, false)
	var bounds := AABB()
	var first := true
	for n in meshes:
		var mi := n as MeshInstance3D
		var box: AABB = mi.global_transform * mi.get_aabb()
		bounds = box if first else bounds.merge(box)
		first = false
	print("meshes=", meshes.size(), " size=", bounds.size)
	var ok := meshes.size() == 264 and absf(bounds.size.x - 24.02) < 0.5 and absf(bounds.size.z - 28.0) < 0.5
	root.free()
	if ok:
		print("PASS")
		quit(0)
	else:
		push_error("FAIL: unexpected mesh count or dimensions")
		quit(1)
