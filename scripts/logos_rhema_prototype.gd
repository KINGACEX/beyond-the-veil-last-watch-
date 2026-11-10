extends Node3D
## Logos Rhema Temple — first vertical-slice environment greybox.
## Original fictional church space; all geometry and people are non-final placeholders.

@onready var _player: BTVPlayerController = $Player
@onready var _status: Label = $HUD/Status
@onready var _phase: Label = $HUD/Phase
@onready var _toast: Label = $HUD/Toast
@onready var _prompt: Label = $HUD/Prompt
@onready var _prompt_background: ColorRect = $HUD/PromptBackground
@onready var _service_director: BTVServiceDirector = $ServiceDirector

var _materials: Dictionary = {}


func _ready() -> void:
	_build_environment()
	_build_chapel()
	_build_people()
	_build_interactions()
	_player.interaction_completed.connect(_on_interaction_completed)
	_service_director.phase_changed.connect(_on_phase_changed)
	_service_director.service_completed.connect(_on_service_completed)
	_service_director.queue_covenant_alert()
	_phase.text = "Sunday: " + _service_director.get_phase_label()
	_status.text = "LOGOS RHEMA TEMPLE — GREYBOX\nWASD / left joystick: move • Mouse / right side: look • E / INTERACT: speak or use objects."
	_toast.text = "A living community space. No timer, reward, score or forced objective."


func _process(_delta: float) -> void:
	var prompt_text := _player.get_interaction_prompt()
	var has_prompt := not prompt_text.is_empty()
	_prompt.visible = has_prompt
	_prompt_background.visible = has_prompt
	_prompt.text = "INTERACT  •  " + prompt_text if has_prompt else ""


func _build_environment() -> void:
	var world_environment := WorldEnvironment.new()
	world_environment.name = "LogosRhemaEnvironment"
	var environment := Environment.new()
	environment.background_mode = Environment.BG_SKY
	environment.sky = Sky.new()
	environment.sky.sky_material = ProceduralSkyMaterial.new()
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.56, 0.59, 0.62)
	environment.ambient_light_energy = 0.75
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	environment.fog_enabled = true
	environment.fog_light_color = Color(0.69, 0.72, 0.75)
	environment.fog_density = 0.0015
	world_environment.environment = environment
	add_child(world_environment)
	var sun := DirectionalLight3D.new()
	sun.name = "Daylight"
	sun.rotation_degrees = Vector3(-52.0, -28.0, 0.0)
	sun.light_energy = 1.0
	sun.shadow_enabled = true
	add_child(sun)


func _build_chapel() -> void:
	var floor_mat := _material("ChapelFloor", Color(0.55, 0.51, 0.44), 0.88)
	var wall_mat := _material("WarmPlaster", Color(0.72, 0.68, 0.59), 0.96)
	var wood_mat := _material("PewWood", Color(0.28, 0.20, 0.14), 0.9)
	var stage_mat := _material("StageWood", Color(0.38, 0.28, 0.19), 0.82)
	var trim_mat := _material("SoftTrim", Color(0.57, 0.48, 0.34), 0.78)
	_add_static_box("ChapelFloor", Vector3(0.0, -0.3, 0.0), Vector3(28.0, 0.6, 38.0), floor_mat)
	_add_static_box("WestWall", Vector3(-14.0, 3.4, 0.0), Vector3(0.5, 7.0, 38.0), wall_mat)
	_add_static_box("EastWall", Vector3(14.0, 3.4, 0.0), Vector3(0.5, 7.0, 38.0), wall_mat)
	_add_static_box("RearWall", Vector3(0.0, 3.4, 19.0), Vector3(28.0, 7.0, 0.5), wall_mat)
	# Split front wall leaves a central entrance rather than a loading-door opening.
	_add_static_box("FrontWallWest", Vector3(-9.0, 3.4, -19.0), Vector3(10.0, 7.0, 0.5), wall_mat)
	_add_static_box("FrontWallEast", Vector3(9.0, 3.4, -19.0), Vector3(10.0, 7.0, 0.5), wall_mat)
	_add_static_box("FrontDoorHeader", Vector3(0.0, 6.0, -19.0), Vector3(8.0, 2.0, 0.5), wall_mat)
	_add_static_box("Stage", Vector3(0.0, 0.15, -13.2), Vector3(20.0, 0.3, 5.2), stage_mat)
	_add_static_box("Pulpit", Vector3(-1.0, 0.8, -15.2), Vector3(1.2, 1.6, 0.8), wood_mat)
	_add_static_box("CommunionTable", Vector3(5.0, 0.65, -15.2), Vector3(3.0, 1.3, 1.2), trim_mat)
	_add_label("LOGOS RHEMA TEMPLE", Vector3(-5.5, 4.6, -17.0), 28)
	_add_label("STAGE", Vector3(-1.0, 2.4, -13.2), 18)

	# Four seating rows with clear, collision-tested aisles.
	for row_index in range(4):
		var z := 7.0 - float(row_index) * 3.5
		for x in [-9.0, -5.0, 5.0, 9.0]:
			_add_static_box(
				"Pew_%d_%d" % [row_index, int(x)],
				Vector3(x, 0.42, z),
				Vector3(3.0, 0.65, 0.85),
				wood_mat,
			)
			_add_static_box(
				"PewBack_%d_%d" % [row_index, int(x)],
				Vector3(x, 1.05, z + 0.38),
				Vector3(3.0, 0.8, 0.18),
				wood_mat,
			)
	_add_label("FOYER / FELLOWSHIP", Vector3(-4.0, 2.8, 15.0), 18)
	_add_label("SIDE PORCH — EMBER'S HOLD POINT", Vector3(8.0, 2.2, 16.5), 14)
	_add_static_box("SidePorchFloor", Vector3(9.0, -0.25, 16.5), Vector3(8.0, 0.5, 5.0), floor_mat)
	_add_static_box("SidePorchOuterRail", Vector3(13.0, 0.6, 16.5), Vector3(0.2, 1.2, 5.0), trim_mat)


func _build_people() -> void:
	var civilian_mat := _material("CivilianPlaceholder", Color(0.36, 0.43, 0.48), 0.9)
	var leader_mat := _material("LeaderPlaceholder", Color(0.55, 0.48, 0.37), 0.88)
	var civilian_positions := [
		Vector3(-9.0, 0.0, 5.5), Vector3(-5.0, 0.0, 5.5),
		Vector3(5.0, 0.0, 5.5), Vector3(9.0, 0.0, 5.5),
		Vector3(-9.0, 0.0, 2.0), Vector3(-5.0, 0.0, 2.0),
		Vector3(5.0, 0.0, 2.0), Vector3(9.0, 0.0, 2.0),
		Vector3(-9.0, 0.0, -1.5), Vector3(9.0, 0.0, -1.5),
	]
	for index in range(civilian_positions.size()):
		_add_placeholder_person("Congregant_%02d" % index, civilian_positions[index], "Congregant", civilian_mat)
	var leader_data := [
		["Pastor_Elias_Warrick", "Pastor Elias Warrick", Vector3(-7.0, 0.0, -14.0)],
		["Pastor_Maribel_Santos", "Pastor Maribel Santos", Vector3(-3.5, 0.0, -14.0)],
		["Tobias_Reed", "Tobias Reed", Vector3(0.0, 0.0, -14.0)],
		["Deacon_Amos_Whitaker", "Deacon Amos Whitaker", Vector3(3.5, 0.0, -14.0)],
		["Leah_Okoye", "Leah Okoye", Vector3(7.0, 0.0, -14.0)],
	]
	for data in leader_data:
		_add_placeholder_person(str(data[0]), data[2], str(data[1]), leader_mat)


func _build_interactions() -> void:
	var service_board := BTVServicePhaseInteractable.new()
	service_board.name = "ServiceSequenceBoard"
	service_board.interaction_id = "logos-rhema-service-sequence"
	service_board.interaction_prompt = "Advance the Sunday service sequence (prototype control)"
	service_board.service_director = _service_director
	_add_interactable(service_board, Vector3(10.0, 0.0, 11.0), Color(0.65, 0.54, 0.34))

	var visitor := BTVVisitorInteractable.new()
	visitor.name = "UnnamedVisitor"
	visitor.interaction_id = "logos-rhema-visitor"
	visitor.interaction_prompt = "Listen to the visitor"
	visitor.service_director = _service_director
	_add_interactable(visitor, Vector3(-10.0, 0.0, 11.0), Color(0.44, 0.62, 0.66))

	var communion_zone := Area3D.new()
	communion_zone.name = "CommunionContextZone"
	communion_zone.position = Vector3(4.0, 1.5, -14.5)
	communion_zone.collision_layer = 0
	communion_zone.collision_mask = 1
	communion_zone.monitoring = true
	var zone_shape := CollisionShape3D.new()
	var zone_box := BoxShape3D.new()
	zone_box.size = Vector3(12.0, 3.0, 7.0)
	zone_shape.shape = zone_box
	communion_zone.add_child(zone_shape)
	communion_zone.body_entered.connect(_on_communion_body_entered)
	communion_zone.body_exited.connect(_on_communion_body_exited)
	add_child(communion_zone)


func _add_interactable(interactable: BTVInteractable, point: Vector3, marker_color: Color) -> void:
	interactable.position = point
	interactable.collision_layer = 2
	interactable.collision_mask = 0
	interactable.monitoring = true
	var collision := CollisionShape3D.new()
	var sphere := SphereShape3D.new()
	sphere.radius = 2.2
	collision.shape = sphere
	interactable.add_child(collision)
	var marker := MeshInstance3D.new()
	var marker_mesh := CylinderMesh.new()
	marker_mesh.top_radius = 0.18
	marker_mesh.bottom_radius = 0.18
	marker_mesh.height = 0.85
	marker.mesh = marker_mesh
	marker.position.y = 0.45
	marker.material_override = _material("InteractableMarker", marker_color, 0.7)
	interactable.add_child(marker)
	add_child(interactable)


func _add_placeholder_person(person_id: String, point: Vector3, label_text: String, material: StandardMaterial3D) -> void:
	var body := StaticBody3D.new()
	body.name = person_id + "_Greybox"
	body.position = point + Vector3(0.0, 0.9, 0.0)
	body.collision_layer = 1
	body.collision_mask = 1
	var collision := CollisionShape3D.new()
	var capsule_shape := CapsuleShape3D.new()
	capsule_shape.radius = 0.34
	capsule_shape.height = 1.8
	collision.shape = capsule_shape
	body.add_child(collision)
	var visual := MeshInstance3D.new()
	var capsule_mesh := CapsuleMesh.new()
	capsule_mesh.radius = 0.34
	capsule_mesh.height = 1.8
	visual.mesh = capsule_mesh
	visual.material_override = material
	body.add_child(visual)
	var label := Label3D.new()
	label.text = label_text
	label.position.y = 1.25
	label.font_size = 16
	label.modulate = Color(0.96, 0.94, 0.87)
	label.outline_size = 5
	body.add_child(label)
	add_child(body)

	# Each greybox person is independently approachable and can be greeted.
	# Dialogue is intentionally generic and carries no progression or reward.
	var talk_area := BTVChapelPersonInteractable.new()
	talk_area.name = person_id + "_Interaction"
	talk_area.position = point + Vector3(0.0, 0.9, 0.0)
	talk_area.interaction_id = "chapel-person-" + person_id.to_lower()
	talk_area.interaction_prompt = "Speak with " + label_text
	talk_area.character_name = label_text
	talk_area.greeting = "Welcome. Please feel free to join the service."
	talk_area.follow_up = "I hope you find a place to settle in and fellowship."
	talk_area.collision_layer = 2
	talk_area.collision_mask = 0
	talk_area.monitoring = true
	var talk_collision := CollisionShape3D.new()
	var talk_shape := SphereShape3D.new()
	talk_shape.radius = 1.5
	talk_collision.shape = talk_shape
	talk_area.add_child(talk_collision)
	add_child(talk_area)


func _add_static_box(box_name: String, point: Vector3, size: Vector3, material: StandardMaterial3D) -> void:
	var body := StaticBody3D.new()
	body.name = box_name
	body.position = point
	body.collision_layer = 1
	body.collision_mask = 1
	var collision := CollisionShape3D.new()
	collision.name = "CollisionShape3D"
	var shape := BoxShape3D.new()
	shape.size = size
	collision.shape = shape
	body.add_child(collision)
	var mesh_instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	mesh_instance.material_override = material
	body.add_child(mesh_instance)
	add_child(body)


func _add_label(value: String, point: Vector3, font_size: int) -> void:
	var label := Label3D.new()
	label.text = value
	label.position = point
	label.font_size = font_size
	label.modulate = Color(0.96, 0.94, 0.87)
	label.outline_size = 5
	add_child(label)


func _material(material_name: String, color: Color, roughness: float) -> StandardMaterial3D:
	if _materials.has(material_name):
		return _materials[material_name]
	var material := StandardMaterial3D.new()
	material.resource_name = material_name
	material.albedo_color = color
	material.roughness = roughness
	_materials[material_name] = material
	return material


func _on_interaction_completed(message: String) -> void:
	_toast.text = message
	_toast.modulate.a = 1.0


func _on_phase_changed(phase_id: String, phase_label: String) -> void:
	_phase.text = "Sunday: " + phase_label
	_toast.text = "Service phase updated: " + phase_id.replace("_", " ")


func _on_service_completed() -> void:
	_status.text = "LOGOS RHEMA TEMPLE — SERVICE COMPLETE\nYou may remain, fellowship, or leave. No reward or progression is granted."
	_toast.text = "The service has ended. A Covenant alert is queued but remains gated by context."


func _on_communion_body_entered(body: Node3D) -> void:
	if body.is_in_group("btv_player"):
		_service_director.set_communion_context_active(true)


func _on_communion_body_exited(body: Node3D) -> void:
	if body.is_in_group("btv_player"):
		_service_director.set_communion_context_active(false)
