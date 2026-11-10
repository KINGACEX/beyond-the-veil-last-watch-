extends Node3D
## Canon-neutral structural graphics benchmark. All content is greybox test geometry.

var _sun: DirectionalLight3D
var _environment: Environment
var _foliage_nodes: Array[Node3D] = []
var _npc_nodes: Array[Node3D] = []
var _telemetry: Label
var _shadows_enabled := true
var _fog_enabled := false
var _foliage_enabled := true
var _npcs_enabled := true


func _ready() -> void:
	_build_environment()
	_build_material_bay()
	_build_lighting_bay()
	_build_vegetation_lane()
	_build_character_pad()
	_build_settlement_blockout()
	_build_route_markers()
	_update_telemetry()


func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	match event.keycode:
		KEY_1:
			_shadows_enabled = not _shadows_enabled
			_sun.shadow_enabled = _shadows_enabled
		KEY_2:
			_fog_enabled = not _fog_enabled
			_environment.fog_enabled = _fog_enabled
		KEY_3:
			_foliage_enabled = not _foliage_enabled
			for node in _foliage_nodes:
				node.visible = _foliage_enabled
		KEY_4:
			_npcs_enabled = not _npcs_enabled
			for node in _npc_nodes:
				node.visible = _npcs_enabled
	_update_telemetry()


func get_benchmark_state() -> Dictionary:
	return {
		"shadows": _shadows_enabled,
		"fog": _fog_enabled,
		"foliage": _foliage_enabled,
		"npcs": _npcs_enabled,
		"foliage_count": _foliage_nodes.size(),
		"npc_count": _npc_nodes.size(),
	}


func _build_environment() -> void:
	var camera := Camera3D.new()
	camera.name = "BenchmarkCamera"
	camera.position = Vector3(0.0, 27.0, 37.0)
	camera.look_at(Vector3(0.0, 0.0, 0.0), Vector3.UP)
	camera.current = true
	add_child(camera)
	var world := WorldEnvironment.new()
	world.name = "BenchmarkWorldEnvironment"
	_environment = Environment.new()
	_environment.background_mode = Environment.BG_SKY
	_environment.sky = Sky.new()
	_environment.sky.sky_material = ProceduralSkyMaterial.new()
	_environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	_environment.ambient_light_color = Color(0.48, 0.52, 0.58)
	_environment.ambient_light_energy = 0.55
	_environment.fog_enabled = _fog_enabled
	_environment.fog_light_color = Color(0.55, 0.62, 0.7)
	_environment.fog_density = 0.012
	world.environment = _environment
	add_child(world)
	_sun = DirectionalLight3D.new()
	_sun.name = "BenchmarkSun"
	_sun.rotation_degrees = Vector3(-48.0, -28.0, 0.0)
	_sun.light_energy = 1.1
	_sun.shadow_enabled = _shadows_enabled
	add_child(_sun)
	var ground := MeshInstance3D.new()
	ground.name = "BenchmarkGround"
	var ground_mesh := BoxMesh.new()
	ground_mesh.size = Vector3(64.0, 0.5, 40.0)
	ground.mesh = ground_mesh
	ground.position = Vector3(0.0, -0.3, 0.0)
	ground.material_override = _material(Color(0.23, 0.25, 0.27), 0.95)
	add_child(ground)


func _build_material_bay() -> void:
	var bay := Node3D.new()
	bay.name = "MaterialBay"
	bay.position = Vector3(-21.0, 0.0, -9.0)
	add_child(bay)
	var samples := [
		{"name": "SkinLike", "color": Color(0.62, 0.43, 0.34), "roughness": 0.68, "metallic": 0.0},
		{"name": "FabricLike", "color": Color(0.2, 0.32, 0.48), "roughness": 0.96, "metallic": 0.0},
		{"name": "PaintedMetal", "color": Color(0.62, 0.67, 0.72), "roughness": 0.3, "metallic": 0.72},
		{"name": "Stone", "color": Color(0.48, 0.48, 0.45), "roughness": 0.98, "metallic": 0.0},
		{"name": "Wood", "color": Color(0.36, 0.22, 0.12), "roughness": 0.88, "metallic": 0.0},
		{"name": "GlassLike", "color": Color(0.25, 0.68, 0.82, 0.48), "roughness": 0.08, "metallic": 0.0},
	]
	for index in range(samples.size()):
		var sample: Dictionary = samples[index]
		var item := MeshInstance3D.new()
		item.name = "Material_%s" % sample.name
		var mesh := SphereMesh.new()
		mesh.radius = 0.8
		mesh.height = 1.6
		item.mesh = mesh
		item.position = Vector3(float(index % 3) * 2.2, 1.0, float(index / 3) * 2.4)
		var mat := _material(sample.color, float(sample.roughness), float(sample.metallic))
		if sample.name == "GlassLike":
			mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		item.material_override = mat
		bay.add_child(item)
	var title := _label_3d("MATERIAL BAY", Vector3(0.0, 2.8, -2.0))
	bay.add_child(title)


func _build_lighting_bay() -> void:
	var bay := Node3D.new()
	bay.name = "LightingBay"
	bay.position = Vector3(-6.0, 0.0, -9.0)
	add_child(bay)
	for index in range(3):
		var receiver := _box("LightReceiver_%d" % index, Vector3(float(index) * 2.4, 0.9, 0.0), Vector3(1.8, 1.8, 1.8), Color(0.55, 0.58, 0.62))
		bay.add_child(receiver)
	var local_light := OmniLight3D.new()
	local_light.name = "LocalLight_A"
	local_light.position = Vector3(1.2, 3.0, 1.0)
	local_light.light_color = Color(1.0, 0.72, 0.42)
	local_light.omni_range = 8.0
	local_light.shadow_enabled = false
	bay.add_child(local_light)
	var local_light_b := OmniLight3D.new()
	local_light_b.name = "LocalLight_B"
	local_light_b.position = Vector3(5.0, 2.2, 1.0)
	local_light_b.light_color = Color(0.38, 0.65, 1.0)
	local_light_b.omni_range = 6.0
	local_light_b.shadow_enabled = false
	bay.add_child(local_light_b)
	bay.add_child(_label_3d("LIGHTING BAY", Vector3(0.0, 3.4, -2.0)))


func _build_vegetation_lane() -> void:
	var lane := Node3D.new()
	lane.name = "VegetationLane"
	lane.position = Vector3(8.0, 0.0, -8.0)
	add_child(lane)
	for index in range(12):
		var tree := Node3D.new()
		tree.name = "FoliageProxy_%02d" % index
		tree.position = Vector3(float(index % 6) * 1.8, 0.0, float(index / 6) * 3.2)
		lane.add_child(tree)
		var trunk := MeshInstance3D.new()
		var trunk_mesh := CylinderMesh.new()
		trunk_mesh.top_radius = 0.12
		trunk_mesh.bottom_radius = 0.2
		trunk_mesh.height = 1.7
		trunk.mesh = trunk_mesh
		trunk.position.y = 0.85
		trunk.material_override = _material(Color(0.34, 0.22, 0.13), 0.95)
		tree.add_child(trunk)
		var crown := MeshInstance3D.new()
		var crown_mesh := SphereMesh.new()
		crown_mesh.radius = 0.8
		crown_mesh.height = 1.6
		crown.mesh = crown_mesh
		crown.position.y = 2.0
		crown.material_override = _material(Color(0.22, 0.42, 0.24), 0.9)
		tree.add_child(crown)
		_foliage_nodes.append(tree)
	lane.add_child(_label_3d("VEGETATION LANE — 12 PROXIES", Vector3(0.0, 3.2, -2.2)))


func _build_character_pad() -> void:
	var pad := Node3D.new()
	pad.name = "CharacterPad"
	pad.position = Vector3(-5.0, 0.0, 7.0)
	add_child(pad)
	var body := MeshInstance3D.new()
	body.name = "NeutralMannequinBody"
	var body_mesh := CapsuleMesh.new()
	body_mesh.radius = 0.48
	body_mesh.height = 2.0
	body.mesh = body_mesh
	body.position.y = 1.0
	body.material_override = _material(Color(0.58, 0.6, 0.63), 0.82)
	pad.add_child(body)
	var head := MeshInstance3D.new()
	head.name = "NeutralMannequinHead"
	var head_mesh := SphereMesh.new()
	head_mesh.radius = 0.34
	head_mesh.height = 0.68
	head.mesh = head_mesh
	head.position.y = 2.2
	head.material_override = _material(Color(0.64, 0.66, 0.69), 0.78)
	pad.add_child(head)
	pad.add_child(_label_3d("NEUTRAL CHARACTER PAD", Vector3(-1.2, 3.0, 0.0)))


func _build_settlement_blockout() -> void:
	var block := Node3D.new()
	block.name = "SettlementBlockout"
	block.position = Vector3(12.0, 0.0, 7.0)
	add_child(block)
	block.add_child(_box("CourtyardWall_A", Vector3(0.0, 1.2, -3.0), Vector3(8.0, 2.4, 0.35), Color(0.43, 0.44, 0.46)))
	block.add_child(_box("CourtyardWall_B", Vector3(-4.0, 1.2, 0.0), Vector3(0.35, 2.4, 6.0), Color(0.43, 0.44, 0.46)))
	block.add_child(_box("CourtyardWall_C", Vector3(4.0, 1.2, 0.0), Vector3(0.35, 2.4, 6.0), Color(0.43, 0.44, 0.46)))
	block.add_child(_box("InteriorRoom", Vector3(0.0, 1.2, 3.0), Vector3(8.0, 2.4, 0.35), Color(0.43, 0.44, 0.46)))
	for index in range(3):
		var npc := Node3D.new()
		npc.name = "NPCPlaceholder_%02d" % index
		npc.position = Vector3(-2.0 + float(index) * 2.0, 0.0, 0.0)
		var capsule := MeshInstance3D.new()
		var capsule_mesh := CapsuleMesh.new()
		capsule_mesh.radius = 0.3
		capsule_mesh.height = 1.7
		capsule.mesh = capsule_mesh
		capsule.position.y = 0.85
		capsule.material_override = _material(Color(0.58, 0.62, 0.67), 0.9)
		npc.add_child(capsule)
		block.add_child(npc)
		_npc_nodes.append(npc)
	block.add_child(_label_3d("SETTLEMENT BLOCKOUT", Vector3(-2.0, 3.0, -4.0)))


func _build_route_markers() -> void:
	var route := Node3D.new()
	route.name = "BenchmarkRoute"
	add_child(route)
	var route_points: Array[Vector3] = [
		Vector3(-21.0, 0.16, -9.0),
		Vector3(-6.0, 0.16, -9.0),
		Vector3(8.0, 0.16, -8.0),
		Vector3(8.0, 0.16, 7.0),
		Vector3(-5.0, 0.16, 7.0),
		Vector3(12.0, 0.16, 7.0),
	]
	var route_material := _material(Color(0.9, 0.72, 0.22), 0.78)
	for index in range(route_points.size()):
		var marker := MeshInstance3D.new()
		marker.name = "RouteWaypoint_%d" % index
		var mesh := SphereMesh.new()
		mesh.radius = 0.18
		mesh.height = 0.36
		marker.mesh = mesh
		marker.position = route_points[index]
		marker.material_override = route_material
		route.add_child(marker)
		if index == route_points.size() - 1:
			continue
		var start: Vector3 = route_points[index]
		var finish: Vector3 = route_points[index + 1]
		var segment_vector := finish - start
		var segment := MeshInstance3D.new()
		segment.name = "RouteSegment_%d" % index
		var segment_mesh := BoxMesh.new()
		segment_mesh.size = Vector3(0.1, 0.05, segment_vector.length())
		segment.mesh = segment_mesh
		segment.position = (start + finish) * 0.5
		segment.rotation.y = atan2(segment_vector.x, segment_vector.z)
		segment.material_override = route_material
		route.add_child(segment)


func _update_telemetry() -> void:
	if not is_instance_valid(_telemetry):
		_telemetry = Label.new()
		_telemetry.name = "Telemetry"
		_telemetry.position = Vector2(18.0, 18.0)
		_telemetry.size = Vector2(680.0, 150.0)
		_telemetry.add_theme_color_override("font_color", Color(0.96, 0.97, 0.98))
		_telemetry.add_theme_font_size_override("font_size", 16)
		var background := ColorRect.new()
		background.name = "TelemetryBackground"
		background.position = Vector2(8.0, 8.0)
		background.size = Vector2(700.0, 170.0)
		background.color = Color(0.035, 0.04, 0.045, 0.86)
		var hud := CanvasLayer.new()
		hud.name = "HUD"
		add_child(hud)
		hud.add_child(background)
		hud.add_child(_telemetry)
	_telemetry.text = (
		"NEUTRAL GRAPHICS BENCHMARK — STRUCTURAL BUILD\n"
		+ "Zones: Material | Lighting | Vegetation | Character | Settlement\n"
		+ "1 Shadows: %s   2 Fog: %s   3 Foliage: %s   4 NPC proxies: %s\n" % [
			"ON" if _shadows_enabled else "OFF",
			"ON" if _fog_enabled else "OFF",
			"ON" if _foliage_enabled else "OFF",
			"ON" if _npcs_enabled else "OFF",
		]
		+ "Foliage proxies: %d   NPC placeholders: %d\n" % [_foliage_nodes.size(), _npc_nodes.size()]
		+ "Greybox only. No FPS, memory, renderer or Android performance claims."
	)


func _material(color: Color, roughness: float, metallic: float = 0.0) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = clampf(roughness, 0.0, 1.0)
	material.metallic = clampf(metallic, 0.0, 1.0)
	return material


func _box(box_name: String, box_position: Vector3, box_size: Vector3, color: Color) -> MeshInstance3D:
	var instance := MeshInstance3D.new()
	instance.name = box_name
	var mesh := BoxMesh.new()
	mesh.size = box_size
	instance.mesh = mesh
	instance.position = box_position
	instance.material_override = _material(color, 0.92)
	return instance


func _label_3d(value: String, label_position: Vector3) -> Label3D:
	var label := Label3D.new()
	label.text = value
	label.position = label_position
	label.font_size = 36
	label.modulate = Color(0.95, 0.95, 0.9)
	return label
