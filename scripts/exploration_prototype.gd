extends Node3D
## First playable, non-combat exploration greybox. Built from mobile-conscious primitives.

@onready var _player: BTVPlayerController = $Player
@onready var _status: Label = $HUD/Status
@onready var _toast: Label = $HUD/InteractionToast

var _toast_seconds := 0.0
var _materials: Dictionary = {}
var _journal: BTVExplorationJournal
var _observation_total := 0
var _last_observation_title := ""
var _last_observation_is_new := false
var _last_journal_save_succeeded := true


func _ready() -> void:
	_journal = BTVExplorationJournal.new()
	_build_environment()
	_build_world()
	_player.interaction_completed.connect(_on_interaction_completed)
	_toast.text = "Explore the clearing and approach the marked observation points."
	_toast.modulate.a = 1.0


func _process(delta: float) -> void:
	if _toast_seconds > 0.0:
		_toast_seconds = maxf(_toast_seconds - delta, 0.0)
		_toast.modulate.a = clampf(_toast_seconds / 0.5, 0.0, 1.0) if _toast_seconds < 0.5 else 1.0
	elif not _toast.text.is_empty():
		_toast.text = ""


func _on_interaction_completed(message: String) -> void:
	if not _last_observation_title.is_empty():
		var discovery_state := "already recorded" if not _last_observation_is_new else "new field note"
		var save_state := "saved locally" if _last_journal_save_succeeded else "save failed — retry later"
		_toast.text = "%s — %s (%s)\n%s\nJournal: %d/%d observations" % [
			_last_observation_title,
			discovery_state,
			save_state,
			message,
			_journal.get_observed_count(),
			_observation_total,
		]
		_last_observation_title = ""
	else:
		_toast.text = message
	_toast_seconds = 6.0
	_toast.modulate.a = 1.0


func _on_observation_recorded(observation_id: String, title: String) -> void:
	_last_observation_title = title
	_last_observation_is_new = _journal.record_observation(observation_id)
	_last_journal_save_succeeded = true
	if _last_observation_is_new:
		_last_journal_save_succeeded = _journal.save_to_disk()
	_status.text = "WASD move • Mouse look • Space jump • Shift dash • E interact\nMobile: left joystick to move, right side to look, action buttons on the right.\nJournal: %d/%d field notes recorded (local save)." % [_journal.get_observed_count(), _observation_total]


func _build_environment() -> void:
	var world_environment := WorldEnvironment.new()
	world_environment.name = "ExplorationWorldEnvironment"
	var environment := Environment.new()
	environment.background_mode = Environment.BG_SKY
	environment.sky = Sky.new()
	environment.sky.sky_material = ProceduralSkyMaterial.new()
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.48, 0.55, 0.62)
	environment.ambient_light_energy = 0.65
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	environment.fog_enabled = true
	environment.fog_light_color = Color(0.62, 0.70, 0.76)
	environment.fog_density = 0.003
	world_environment.environment = environment
	add_child(world_environment)
	var sun := DirectionalLight3D.new()
	sun.name = "Sun"
	sun.rotation_degrees = Vector3(-48.0, -32.0, 0.0)
	sun.light_energy = 1.0
	sun.shadow_enabled = true
	add_child(sun)


func _build_world() -> void:
	var ground_material := _material("Ground", Color(0.25, 0.31, 0.23), 1.0)
	var path_material := _material("Path", Color(0.46, 0.40, 0.30), 1.0)
	var stone_material := _material("Stone", Color(0.38, 0.42, 0.43), 0.94)
	var water_material := _material("Water", Color(0.12, 0.34, 0.43, 0.82), 0.18)
	water_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	water_material.metallic = 0.12
	var trunk_material := _material("TreeTrunk", Color(0.28, 0.18, 0.11), 0.96)
	var canopy_material := _material("Canopy", Color(0.16, 0.34, 0.19), 0.92)
	var canopy_light := _material("CanopyLight", Color(0.28, 0.43, 0.23), 0.92)
	_add_static_box("Ground", Vector3(0.0, -0.55, 0.0), Vector3(90.0, 1.0, 90.0), ground_material)

	# A broad, readable path connects the starting clearing to the water and ridge.
	_add_visual_box("Path_Main", Vector3(0.0, 0.015, -8.0), Vector3(5.0, 0.04, 34.0), path_material)
	_add_visual_box("Path_West", Vector3(-9.0, 0.02, -16.0), Vector3(18.0, 0.04, 3.0), path_material)
	_add_visual_box("Path_East", Vector3(9.0, 0.02, -20.0), Vector3(18.0, 0.04, 3.0), path_material)

	# Low navigation landmarks: rock shelf, stepped rise and a short ramp.
	_add_static_box("RockShelf", Vector3(-13.0, 0.55, -10.0), Vector3(5.0, 1.1, 4.0), stone_material)
	_add_static_box("LowStep_A", Vector3(13.0, 0.18, -7.0), Vector3(4.0, 0.36, 2.0), stone_material)
	_add_static_box("LowStep_B", Vector3(13.0, 0.48, -9.0), Vector3(4.0, 0.6, 2.0), stone_material)
	_add_static_box("LowStep_C", Vector3(13.0, 0.78, -11.0), Vector3(4.0, 0.96, 2.0), stone_material)
	_add_static_box("Ramp_Short", Vector3(0.0, 0.32, -28.0), Vector3(5.0, 0.35, 8.0), stone_material, Vector3(-8.0, 0.0, 0.0))

	# Shallow pond is a visual landmark only; no swimming or water physics are implied.
	var pond := MeshInstance3D.new()
	pond.name = "Pond_Surface_VisualOnly"
	var pond_mesh := CylinderMesh.new()
	pond_mesh.top_radius = 6.0
	pond_mesh.bottom_radius = 6.0
	pond_mesh.height = 0.06
	pond.mesh = pond_mesh
	pond.position = Vector3(0.0, 0.04, -27.0)
	pond.material_override = water_material
	add_child(pond)
	_add_visual_box("PondBank_North", Vector3(0.0, 0.12, -20.8), Vector3(15.0, 0.24, 1.0), stone_material)
	_add_visual_box("PondBank_South", Vector3(0.0, 0.12, -33.2), Vector3(15.0, 0.24, 1.0), stone_material)

	# Tree clusters form a modest exploration boundary and framing, not a dense forest.
	var tree_positions := [
		Vector3(-22, 0, -5), Vector3(-22, 0, -15), Vector3(-20, 0, -25),
		Vector3(-16, 0, -34), Vector3(-8, 0, -39), Vector3(3, 0, -40),
		Vector3(14, 0, -37), Vector3(22, 0, -28), Vector3(23, 0, -15),
		Vector3(22, 0, -2), Vector3(17, 0, 8), Vector3(-18, 0, 8),
		Vector3(-25, 0, 18), Vector3(-12, 0, 24), Vector3(4, 0, 24),
		Vector3(19, 0, 20), Vector3(28, 0, 10), Vector3(30, 0, -10),
	]
	for index in range(tree_positions.size()):
		_add_tree("Tree_%02d" % index, tree_positions[index], trunk_material, canopy_material if index % 3 != 0 else canopy_light, 0.85 + float(index % 4) * 0.1)

	# Simple boulders and non-interactive distant ridge silhouettes.
	for index in range(9):
		var rock := StaticBody3D.new()
		rock.name = "Boulder_%02d" % index
		rock.position = Vector3(-19.0 + float(index) * 4.7, 0.35, -18.0 + float(index % 3) * 5.0)
		rock.scale = Vector3(1.2, 0.7, 0.9)
		var rock_collision := CollisionShape3D.new()
		rock_collision.name = "CollisionShape3D"
		var rock_shape := SphereShape3D.new()
		rock_shape.radius = 1.0
		rock_collision.shape = rock_shape
		rock.add_child(rock_collision)
		var rock_mesh_instance := MeshInstance3D.new()
		var rock_mesh := SphereMesh.new()
		rock_mesh.radius = 1.0
		rock_mesh.height = 1.5
		rock_mesh_instance.mesh = rock_mesh
		rock_mesh_instance.material_override = stone_material
		rock.add_child(rock_mesh_instance)
		add_child(rock)

	_add_observation("Clearing_FieldNote", Vector3(0.0, 0.0, 2.0), "CLEARING", "The clearing is a safe navigation test space. Use it to assess camera control, acceleration, braking and turning.")
	_add_observation("Pond_FieldNote", Vector3(7.0, 0.0, -24.0), "POND", "This pond is currently a visual landmark only. Water movement, shoreline ecology and swimming remain future systems.")
	_add_observation("Ridge_FieldNote", Vector3(-12.0, 1.1, -10.0), "ROCK SHELF", "The raised shelf tests approach angles, jumping and camera framing. It is not a final traversal challenge.")
	_add_observation("Forest_FieldNote", Vector3(19.0, 0.0, 7.0), "TREE LINE", "The tree line is a low-density vegetation study. Future foliage needs wind response, material variation and measured mobile LOD.")

	_add_label("BTV — EXPLORATION PROTOTYPE", Vector3(-5.5, 4.0, 9.0), 36)
	_add_label("POND", Vector3(-2.0, 1.5, -27.0), 24)
	_add_label("RIDGE", Vector3(-14.0, 3.0, -12.0), 24)
	_status.text = "WASD move • Mouse look • Space jump • Shift dash • E interact\nMobile: left joystick to move, right side to look, action buttons on the right.\nJournal: %d/%d field notes recorded (local save)." % [_journal.get_observed_count(), _observation_total]


func _material(material_name: String, color: Color, roughness: float) -> StandardMaterial3D:
	if _materials.has(material_name):
		return _materials[material_name]
	var material := StandardMaterial3D.new()
	material.resource_name = material_name
	material.albedo_color = color
	material.roughness = roughness
	_materials[material_name] = material
	return material


func _add_static_box(box_name: String, box_position: Vector3, box_size: Vector3, material: StandardMaterial3D, rotation_degrees: Vector3 = Vector3.ZERO) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = box_name
	body.position = box_position
	body.rotation_degrees = rotation_degrees
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = box_size
	collision.shape = shape
	body.add_child(collision)
	var mesh_instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = box_size
	mesh_instance.mesh = mesh
	mesh_instance.material_override = material
	body.add_child(mesh_instance)
	add_child(body)
	return body


func _add_visual_box(box_name: String, box_position: Vector3, box_size: Vector3, material: StandardMaterial3D) -> void:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = box_name
	var mesh := BoxMesh.new()
	mesh.size = box_size
	mesh_instance.mesh = mesh
	mesh_instance.position = box_position
	mesh_instance.material_override = material
	add_child(mesh_instance)


func _add_tree(tree_name: String, tree_position: Vector3, trunk_material: StandardMaterial3D, canopy_material: StandardMaterial3D, scale_factor: float) -> void:
	var tree := StaticBody3D.new()
	tree.name = tree_name
	tree.position = tree_position
	tree.scale = Vector3.ONE * scale_factor
	var trunk_collision := CollisionShape3D.new()
	trunk_collision.name = "CollisionShape3D"
	var trunk_shape := CylinderShape3D.new()
	trunk_shape.radius = 0.34
	trunk_shape.height = 3.4
	trunk_collision.shape = trunk_shape
	trunk_collision.position.y = 1.7
	tree.add_child(trunk_collision)
	var trunk := MeshInstance3D.new()
	var trunk_mesh := CylinderMesh.new()
	trunk_mesh.top_radius = 0.22
	trunk_mesh.bottom_radius = 0.34
	trunk_mesh.height = 3.4
	trunk.mesh = trunk_mesh
	trunk.position.y = 1.7
	trunk.material_override = trunk_material
	tree.add_child(trunk)
	var crown := MeshInstance3D.new()
	var crown_mesh := SphereMesh.new()
	crown_mesh.radius = 1.7
	crown_mesh.height = 3.3
	crown.mesh = crown_mesh
	crown.position.y = 3.6
	crown.material_override = canopy_material
	tree.add_child(crown)
	add_child(tree)


func _add_observation(node_name: String, point_position: Vector3, title: String, description: String) -> void:
	var area := BTVExplorationObservation.new()
	area.name = node_name
	area.position = point_position
	area.collision_layer = 2
	area.collision_mask = 0
	area.monitoring = true
	area.observation_id = "field-note-" + node_name.to_lower()
	area.observation_title = title
	area.interaction_id = area.observation_id
	area.interaction_prompt = "Read field note: " + title
	area.observation_text = title + " — " + description
	area.observation_recorded.connect(_on_observation_recorded)
	_observation_total += 1
	var collision := CollisionShape3D.new()
	var shape := SphereShape3D.new()
	shape.radius = 1.2
	collision.shape = shape
	area.add_child(collision)
	var marker := MeshInstance3D.new()
	marker.name = "Marker"
	var marker_mesh := CylinderMesh.new()
	marker_mesh.top_radius = 0.14
	marker_mesh.bottom_radius = 0.14
	marker_mesh.height = 0.75
	marker.mesh = marker_mesh
	marker.position.y = 0.38
	marker.material_override = _material("ObservationMarker", Color(0.78, 0.69, 0.35), 0.65)
	area.add_child(marker)
	add_child(area)


func _add_label(value: String, label_position: Vector3, font_size: int) -> void:
	var label := Label3D.new()
	label.text = value
	label.position = label_position
	label.font_size = font_size
	label.modulate = Color(0.94, 0.96, 0.9)
	label.outline_size = 6
	add_child(label)
