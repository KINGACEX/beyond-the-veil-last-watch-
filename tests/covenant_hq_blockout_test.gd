extends SceneTree

const ENVIRONMENT_SCENE := "res://scenes/covenant_hq/covenant_headquarters_blockout_001.tscn"
const PLAYTEST_SCENE := "res://scenes/covenant_hq/covenant_headquarters_playtest_001.tscn"

func _init() -> void:
	var environment_packed := load(ENVIRONMENT_SCENE) as PackedScene
	if environment_packed == null:
		push_error("FAIL: Covenant HQ blockout scene did not load.")
		quit(1)
		return

	var environment_root := environment_packed.instantiate()
	var required_markers := [
		"Markers/PlayerSpawn",
		"Markers/ReceptionNpcAnchor",
		"Markers/OperationsBriefingAnchor",
		"Markers/MissionBoardAnchor",
		"Markers/TrainingCourtAnchor",
		"Markers/EmberFollowPath/PointA",
		"Markers/EmberFollowPath/PointB",
		"Markers/EmberFollowPath/PointC",
	]
	for marker_path in required_markers:
		if environment_root.get_node_or_null(marker_path) == null:
			push_error("FAIL: Missing HQ layout marker: " + marker_path)
			environment_root.free()
			quit(1)
			return

	var static_bodies := environment_root.find_children("*", "StaticBody3D", true, false)
	var collision_shapes := environment_root.find_children("*", "CollisionShape3D", true, false)
	if static_bodies.size() < 12 or collision_shapes.size() < 12:
		push_error("FAIL: HQ blockout is missing structural collision coverage.")
		environment_root.free()
		quit(1)
		return
	environment_root.free()

	var playtest_packed := load(PLAYTEST_SCENE) as PackedScene
	if playtest_packed == null:
		push_error("FAIL: Covenant HQ playtest scene did not load.")
		quit(1)
		return
	var playtest_root := playtest_packed.instantiate()
	if playtest_root.get_node_or_null("Environment") == null:
		push_error("FAIL: Playtest scene is missing the HQ environment.")
		playtest_root.free()
		quit(1)
		return
	if playtest_root.get_node_or_null("Player") == null:
		push_error("FAIL: Playtest scene is missing the prototype player.")
		playtest_root.free()
		quit(1)
		return
	if playtest_root.get_node_or_null("TouchControls") == null:
		push_error("FAIL: Playtest scene is missing touch controls.")
		playtest_root.free()
		quit(1)
		return

	playtest_root.free()
	print("[BTV HQ] Blockout structure, anchors, collision and playtest scene passed.")
	quit(0)
