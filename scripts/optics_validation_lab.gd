extends Node3D
## Isolated visual validation scene for the pure BTVOpticsSolver calculations.

const Solver = preload("res://scripts/optics_solver.gd")


func _ready() -> void:
	_draw_boundary(Vector3(-5.0, 0.0, 0.0), Vector3(5.0, 0.0, 0.0), Color(0.72, 0.78, 0.84))
	_draw_reflection_example()
	_draw_refraction_example()
	_draw_tir_example()
	_draw_shadow_material_comparison()


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


func _draw_shadow_material_comparison() -> void:
	var floor_mesh := BoxMesh.new()
	floor_mesh.size = Vector3(10.0, 0.12, 3.2)
	var floor_material := StandardMaterial3D.new()
	floor_material.albedo_color = Color(0.34, 0.36, 0.39)
	floor_material.roughness = 0.95
	var floor_instance := MeshInstance3D.new()
	floor_instance.name = "ShadowReceiverFloor"
	floor_instance.mesh = floor_mesh
	floor_instance.material_override = floor_material
	floor_instance.position = Vector3(0.0, -1.35, -3.0)
	floor_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(floor_instance)

	var caster_material := StandardMaterial3D.new()
	caster_material.albedo_color = Color(0.76, 0.78, 0.82)
	caster_material.roughness = 0.82
	_add_comparison_box("ShadowCaster", Vector3(-3.0, -0.72, -3.0), caster_material, true)

	var reference_material := StandardMaterial3D.new()
	reference_material.albedo_color = Color(0.76, 0.78, 0.82)
	reference_material.roughness = 0.82
	_add_comparison_box("NoShadowReference", Vector3(0.0, -0.72, -3.0), reference_material, false)

	var metallic := StandardMaterial3D.new()
	metallic.albedo_color = Color(0.55, 0.62, 0.72)
	metallic.metallic = 0.82
	metallic.roughness = 0.24
	_add_comparison_sphere("Material_Metallic", Vector3(2.2, -0.55, -3.0), metallic)

	var matte := StandardMaterial3D.new()
	matte.albedo_color = Color(0.72, 0.48, 0.28)
	matte.roughness = 0.95
	_add_comparison_sphere("Material_Matte", Vector3(3.7, -0.55, -3.0), matte)

	var glass_like := StandardMaterial3D.new()
	glass_like.albedo_color = Color(0.35, 0.72, 0.9, 0.42)
	glass_like.roughness = 0.08
	glass_like.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_add_comparison_sphere("Material_GlassLike", Vector3(4.8, -0.55, -3.0), glass_like)


func _add_comparison_box(
	box_name: String,
	box_position: Vector3,
	material: StandardMaterial3D,
	casts_shadow: bool
) -> void:
	var instance := MeshInstance3D.new()
	instance.name = box_name
	var mesh := BoxMesh.new()
	mesh.size = Vector3(0.9, 1.1, 0.9)
	instance.mesh = mesh
	instance.material_override = material
	instance.position = box_position
	instance.cast_shadow = (
		GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		if casts_shadow else GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	)
	add_child(instance)


func _add_comparison_sphere(
	sphere_name: String,
	sphere_position: Vector3,
	material: StandardMaterial3D
) -> void:
	var instance := MeshInstance3D.new()
	instance.name = sphere_name
	var mesh := SphereMesh.new()
	mesh.radius = 0.48
	mesh.height = 0.96
	instance.mesh = mesh
	instance.material_override = material
	instance.position = sphere_position
	instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(instance)
