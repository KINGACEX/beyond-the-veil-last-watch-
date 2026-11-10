extends Node3D
## Isolated visual validation scene for the pure BTVOpticsSolver calculations.

const Solver = preload("res://scripts/optics_solver.gd")


func _ready() -> void:
	_draw_boundary(Vector3(-5.0, 0.0, 0.0), Vector3(5.0, 0.0, 0.0), Color(0.72, 0.78, 0.84))
	_draw_reflection_example()
	_draw_refraction_example()
	_draw_tir_example()


func _draw_reflection_example() -> void:
	var start := Vector3(-4.0, 2.0, 0.0)
	var hit := Vector3(-2.0, 0.0, 0.0)
	var direction := (hit - start).normalized()
	var reflected: Vector3 = Solver.reflect_direction(direction, Vector3.UP)
	_draw_ray([start, hit, hit + reflected * 2.4], Color(1.0, 0.72, 0.24))


func _draw_refraction_example() -> void:
	var start := Vector3(-0.4, 2.0, 0.0)
	var hit := Vector3(0.0, 0.0, 0.0)
	var direction := (hit - start).normalized()
	var result: Dictionary = Solver.refract_direction(direction, Vector3.UP, 1.0, 1.33)
	if bool(result.valid) and not bool(result.total_internal_reflection):
		var transmitted: Vector3 = result.direction
		_draw_ray([start, hit, hit + transmitted * 3.0], Color(0.25, 0.72, 1.0))


func _draw_tir_example() -> void:
	var hit := Vector3(3.0, 0.0, 0.0)
	var start := hit - Vector3(sin(deg_to_rad(50.0)), cos(deg_to_rad(50.0)), 0.0) * 2.0
	var direction := (hit - start).normalized()
	var result: Dictionary = Solver.refract_direction(direction, Vector3.UP, 1.5, 1.0)
	if bool(result.valid) and bool(result.total_internal_reflection):
		var reflected: Vector3 = Solver.reflect_direction(direction, Vector3.UP)
		_draw_ray([start, hit, hit + reflected * 2.6], Color(0.45, 1.0, 0.55))


func _draw_boundary(from_point: Vector3, to_point: Vector3, tint: Color) -> void:
	_draw_ray([from_point, to_point], tint, 0.035)


func _draw_ray(points: Array[Vector3], tint: Color, thickness: float = 0.055) -> void:
	var mesh := ImmediateMesh.new()
	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = tint
	material.emission_enabled = true
	material.emission = tint
	material.emission_energy_multiplier = 0.8
	mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	for index in range(points.size() - 1):
		mesh.surface_add_vertex(points[index])
		mesh.surface_add_vertex(points[index + 1])
	mesh.surface_end()
	var instance := MeshInstance3D.new()
	instance.mesh = mesh
	instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(instance)
