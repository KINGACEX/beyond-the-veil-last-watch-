extends Node3D
## Neutral weather-zone visualization lab. All zones and profiles are test data.

const WeatherBlend = preload("res://scripts/weather_profile_blend.gd")

const BASE_PROFILE := {"rain": 0.05, "wind": 0.18, "fog": 0.08, "cloud": 0.2}
const ZONE_PROFILES := [
	{"id": "forest", "profile": {"rain": 0.65, "wind": 0.3, "fog": 0.72, "cloud": 0.78}, "center": Vector3(-9.0, 0.0, 0.0), "radius": 7.0},
	{"id": "coastal", "profile": {"rain": 0.28, "wind": 0.9, "fog": 0.35, "cloud": 0.55}, "center": Vector3(9.0, 0.0, 0.0), "radius": 7.0},
]
var _sample_index := 0
var _sample_points := [Vector3(-9.0, 0.0, 0.0), Vector3(0.0, 0.0, 0.0), Vector3(9.0, 0.0, 0.0)]
var _sample_marker: MeshInstance3D

@onready var _telemetry: Label = $HUD/Telemetry


func _ready() -> void:
	_build_zones()
	_update_profile()


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_1:
			set_sample_index(0)
		elif event.keycode == KEY_2:
			set_sample_index(1)
		elif event.keycode == KEY_3:
			set_sample_index(2)


func set_sample_index(index: int) -> void:
	_sample_index = clampi(index, 0, _sample_points.size() - 1)
	_update_profile()


func get_current_profile() -> Dictionary:
	return _calculate_profile()


func _calculate_profile() -> Dictionary:
	var sample: Vector3 = _sample_points[_sample_index]
	var zones: Array = []
	for zone in ZONE_PROFILES:
		var center: Vector3 = zone.center
		var radius := float(zone.radius)
		var distance := Vector2(sample.x - center.x, sample.z - center.z).length()
		var weight := clampf(1.0 - distance / radius, 0.0, 1.0)
		if weight > 0.0:
			zones.append({"profile": zone.profile, "weight": weight})
	return WeatherBlend.blend_weather_zones(BASE_PROFILE, zones)


func _update_profile() -> void:
	var sample: Vector3 = _sample_points[_sample_index]
	if is_instance_valid(_sample_marker):
		_sample_marker.position = sample + Vector3.UP * 0.5
	var profile := _calculate_profile()
	_telemetry.text = (
		"LOCAL WEATHER ZONE VALIDATION LAB\n"
		+ "Sample point: %d   Position X: %.1f\n" % [_sample_index + 1, sample.x]
		+ "Rain: %.2f   Wind: %.2f   Fog: %.2f   Cloud: %.2f\n" % [
			profile.get("rain", 0.0), profile.get("wind", 0.0),
			profile.get("fog", 0.0), profile.get("cloud", 0.0)
		]
		+ "Keys 1 / 2 / 3 move the sample between forest / overlap / coastal zones.\n"
		+ "Normalized test channels only; no production weather effects are connected."
	)


func _build_zones() -> void:
	var ground := MeshInstance3D.new()
	ground.name = "Ground"
	var ground_mesh := BoxMesh.new()
	ground_mesh.size = Vector3(40.0, 0.3, 16.0)
	ground.mesh = ground_mesh
	ground.position = Vector3(0.0, -0.15, 0.0)
	var ground_material := StandardMaterial3D.new()
	ground_material.albedo_color = Color(0.2, 0.22, 0.24)
	ground_material.roughness = 1.0
	ground.material_override = ground_material
	add_child(ground)
	for zone in ZONE_PROFILES:
		var center: Vector3 = zone.center
		var radius := float(zone.radius)
		var zone_node := Node3D.new()
		zone_node.name = "Zone_%s" % str(zone.id).capitalize()
		zone_node.position = center
		add_child(zone_node)
		var mesh_instance := MeshInstance3D.new()
		var cylinder := CylinderMesh.new()
		cylinder.top_radius = radius
		cylinder.bottom_radius = radius
		cylinder.height = 0.12
		mesh_instance.mesh = cylinder
		var material := StandardMaterial3D.new()
		material.albedo_color = Color(0.24, 0.58, 0.38, 0.24) if zone.id == "forest" else Color(0.24, 0.48, 0.72, 0.24)
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		mesh_instance.material_override = material
		zone_node.add_child(mesh_instance)
		var label := Label3D.new()
		label.text = "%s TEST ZONE" % str(zone.id).to_upper()
		label.position = Vector3(0.0, 0.25, 0.0)
		zone_node.add_child(label)
	_sample_marker = MeshInstance3D.new()
	_sample_marker.name = "SamplePoint"
	var marker_mesh := SphereMesh.new()
	marker_mesh.radius = 0.45
	marker_mesh.height = 0.9
	_sample_marker.mesh = marker_mesh
	var marker_material := StandardMaterial3D.new()
	marker_material.albedo_color = Color(1.0, 0.82, 0.25)
	marker_material.emission_enabled = true
	marker_material.emission = Color(0.5, 0.3, 0.05)
	_sample_marker.material_override = marker_material
	add_child(_sample_marker)
