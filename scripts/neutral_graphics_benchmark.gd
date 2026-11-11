extends Node3D
## Canon-neutral structural graphics benchmark. All content is greybox test geometry.

const BenchmarkMetrics = preload("res://scripts/benchmark_metrics.gd")
const MAX_FRAME_SAMPLES := 3600

var _sun: DirectionalLight3D
var _camera: Camera3D
var _environment: Environment
var _foliage_nodes: Array[Node3D] = []
var _npc_nodes: Array[Node3D] = []
var _telemetry: Label
var _shadows_enabled := true
var _fog_enabled := false
var _foliage_enabled := true
var _npcs_enabled := true
var _frame_time_samples_ms: Array[float] = []
var _route_points: Array[Vector3] = []
var _route_active := false
var _route_segment_index := 0
var _route_segment_elapsed := 0.0
var _route_segment_start := Vector3.ZERO
const ROUTE_SEGMENT_SECONDS := 2.0
const ROUTE_CAMERA_OFFSET := Vector3(0.0, 11.0, 15.0)
const RUN_IDLE := "idle"
const RUN_WARMUP := "warmup"
const RUN_TRANSIT := "transit"
const RUN_DWELL := "dwell"
const RUN_COMPLETE := "complete"
const WARMUP_SECONDS := 5.0
const VIEWPOINT_DWELL_SECONDS := 3.0
const VIEWPOINT_TRANSIT_SECONDS := 1.0

var _run_phase := RUN_IDLE
var _run_phase_elapsed := 0.0
var _run_viewpoint_index := 0
var _run_started_at := ""
var _last_run_metadata: Dictionary = {}
var _run_export_path := ""


func _process(delta: float) -> void:
	if _route_active:
		_advance_route(delta)
	if delta > 0.0 and is_finite(delta):
		_advance_benchmark_run(delta)
		if _run_phase == RUN_DWELL:
			_frame_time_samples_ms.append(delta * 1000.0)
			if _frame_time_samples_ms.size() > MAX_FRAME_SAMPLES:
				_frame_time_samples_ms.pop_front()


func get_frame_time_summary() -> Dictionary:
	return BenchmarkMetrics.summarize_frame_times(_frame_time_samples_ms)


func get_frame_time_sample_count() -> int:
	return _frame_time_samples_ms.size()


func begin_acceptance_run() -> bool:
	if _route_points.is_empty() or not is_instance_valid(_camera):
		return false
	_frame_time_samples_ms.clear()
	_run_viewpoint_index = 0
	_run_phase_elapsed = 0.0
	_run_phase = RUN_WARMUP
	_run_started_at = Time.get_datetime_string_from_system(true)
	_last_run_metadata.clear()
	_run_export_path = ""
	_route_active = false
	_update_telemetry()
	return true


func get_acceptance_run_state() -> Dictionary:
	return {
		"phase": _run_phase,
		"phase_elapsed": _run_phase_elapsed,
		"viewpoint_index": _run_viewpoint_index,
		"viewpoint_count": _route_points.size(),
		"sample_count": _frame_time_samples_ms.size(),
		"export_path": _run_export_path,
	}


func _advance_benchmark_run(delta: float) -> void:
	if _run_phase == RUN_IDLE or _run_phase == RUN_COMPLETE or delta <= 0.0:
		return
	_run_phase_elapsed += delta
	if _run_phase == RUN_WARMUP and _run_phase_elapsed >= WARMUP_SECONDS:
		_run_phase = RUN_TRANSIT
		_run_phase_elapsed = 0.0
		_set_benchmark_viewpoint()
	elif _run_phase == RUN_TRANSIT and _run_phase_elapsed >= VIEWPOINT_TRANSIT_SECONDS:
		_run_phase = RUN_DWELL
		_run_phase_elapsed = 0.0
	elif _run_phase == RUN_DWELL and _run_phase_elapsed >= VIEWPOINT_DWELL_SECONDS:
		_run_viewpoint_index += 1
		_run_phase_elapsed = 0.0
		if _run_viewpoint_index >= _route_points.size():
			_run_phase = RUN_COMPLETE
			_last_run_metadata = build_run_metadata()
		else:
			_run_phase = RUN_TRANSIT
			_set_benchmark_viewpoint()
	_update_telemetry()


func _set_benchmark_viewpoint() -> void:
	if _run_viewpoint_index >= _route_points.size():
		return
	var target: Vector3 = _route_points[_run_viewpoint_index]
	_camera.position = target + ROUTE_CAMERA_OFFSET
	_camera.look_at(target, Vector3.UP)


func build_run_metadata() -> Dictionary:
	var viewpoints: Array[Dictionary] = []
	for point in _route_points:
		viewpoints.append({"x": point.x, "y": point.y, "z": point.z})
	return {
		"schema_version": 1,
		"project": str(ProjectSettings.get_setting("application/config/name", "BTV")),
		"captured_at": _run_started_at,
		"engine_version": Engine.get_version_info(),
		"platform": OS.get_name(),
		"viewport_size": {
			"width": int(get_viewport().get_visible_rect().size.x),
			"height": int(get_viewport().get_visible_rect().size.y),
		},
		"protocol": {
			"warmup_seconds": WARMUP_SECONDS,
			"transit_seconds_per_viewpoint": VIEWPOINT_TRANSIT_SECONDS,
			"dwell_seconds_per_viewpoint": VIEWPOINT_DWELL_SECONDS,
			"viewpoint_count": _route_points.size(),
		},
		"settings": {
			"shadows": _shadows_enabled,
			"fog": _fog_enabled,
			"foliage": _foliage_enabled,
			"npcs": _npcs_enabled,
			"foliage_proxy_count": _foliage_nodes.size(),
			"npc_proxy_count": _npc_nodes.size(),
		},
		"frame_time_measurement": {
			"source": "Godot process delta during fixed viewpoint dwell windows",
			"unit": "milliseconds",
			"sample_count": _frame_time_samples_ms.size(),
			"summary": BenchmarkMetrics.summarize_frame_times(_frame_time_samples_ms),
			"limitations": "CPU frame interval observation only; not isolated GPU time, memory, thermal or power telemetry",
		},
		"viewpoints": viewpoints,
	}


func export_last_run_metadata() -> String:
	if _last_run_metadata.is_empty():
		return ""
	var user_directory := DirAccess.open("user://")
	if user_directory == null:
		return ""
	if not user_directory.dir_exists("benchmark_runs"):
		var make_result := user_directory.make_dir("benchmark_runs")
		if make_result != OK:
			return ""
	var directory := "user://benchmark_runs"
	var safe_stamp := _run_started_at.replace(":", "-").replace("T", "_")
	var file_name := "btv_benchmark_%s_%d.json" % [safe_stamp, Time.get_ticks_msec()]
	var path := directory.path_join(file_name)
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return ""
	file.store_string(JSON.stringify(_last_run_metadata, "\\t"))
	file.close()
	_run_export_path = path
	_update_telemetry()
	return path


func start_route_playback() -> void:
	if _route_points.is_empty() or not is_instance_valid(_camera):
		return
	_route_segment_index = 0
	_route_segment_elapsed = 0.0
	_route_segment_start = _camera.position
	_route_active = true


func stop_route_playback() -> void:
	_route_active = false


func get_route_state() -> Dictionary:
	return {
		"active": _route_active,
		"segment_index": _route_segment_index,
		"segment_count": _route_points.size(),
		"segment_elapsed": _route_segment_elapsed,
	}


func _advance_route(delta: float) -> void:
	if not _route_active or delta <= 0.0 or not is_finite(delta):
		return
	if _route_segment_index >= _route_points.size():
		_route_active = false
		return
	_route_segment_elapsed = minf(_route_segment_elapsed + delta, ROUTE_SEGMENT_SECONDS)
	var progress := _route_segment_elapsed / ROUTE_SEGMENT_SECONDS
	var target := _route_points[_route_segment_index]
	_camera.position = _route_segment_start.lerp(target + ROUTE_CAMERA_OFFSET, progress)
	_camera.look_at(target, Vector3.UP)
	if progress >= 1.0:
		_route_segment_index += 1
		_route_segment_elapsed = 0.0
		_route_segment_start = _camera.position
		if _route_segment_index >= _route_points.size():
			_route_active = false


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
		KEY_5:
			start_route_playback()
		KEY_6:
			stop_route_playback()
		KEY_7:
			begin_acceptance_run()
		KEY_8:
			export_last_run_metadata()
	_update_telemetry()


func get_benchmark_state() -> Dictionary:
	return {
		"shadows": _shadows_enabled,
		"fog": _fog_enabled,
		"foliage": _foliage_enabled,
		"npcs": _npcs_enabled,
		"foliage_count": _foliage_nodes.size(),
		"npc_count": _npc_nodes.size(),
		"frame_time_sample_count": _frame_time_samples_ms.size(),
		"acceptance_run_phase": _run_phase,
	}


func _build_environment() -> void:
	_camera = Camera3D.new()
	_camera.name = "BenchmarkCamera"
	_camera.position = Vector3(0.0, 27.0, 37.0)
	_camera.look_at(Vector3(0.0, 0.0, 0.0), Vector3.UP)
	_camera.current = true
	add_child(_camera)
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
	_route_points = [
		Vector3(-21.0, 0.16, -9.0),
		Vector3(-6.0, 0.16, -9.0),
		Vector3(8.0, 0.16, -8.0),
		Vector3(8.0, 0.16, 7.0),
		Vector3(-5.0, 0.16, 7.0),
		Vector3(12.0, 0.16, 7.0),
	]
	var route_material := _material(Color(0.9, 0.72, 0.22), 0.78)
	for index in range(_route_points.size()):
		var marker := MeshInstance3D.new()
		marker.name = "RouteWaypoint_%d" % index
		var mesh := SphereMesh.new()
		mesh.radius = 0.18
		mesh.height = 0.36
		marker.mesh = mesh
		marker.position = _route_points[index]
		marker.material_override = route_material
		route.add_child(marker)
		if index == _route_points.size() - 1:
			continue
		var start: Vector3 = _route_points[index]
		var finish: Vector3 = _route_points[index + 1]
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
		+ "Frame-time samples: %d   Acceptance run: %s / viewpoint %d of %d\\n" % [_frame_time_samples_ms.size(), _run_phase, _run_viewpoint_index, _route_points.size()]
		+ "7 Start 5s warm-up + fixed-viewpoint capture   8 Export JSON metadata\\n"
		+ "Last export: %s\\n" % (_run_export_path if not _run_export_path.is_empty() else "not exported")
		+ "CPU frame intervals only; no GPU, memory, thermal or Android performance claims."
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
