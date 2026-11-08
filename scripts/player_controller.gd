extends CharacterBody3D
class_name BTVPlayerController

## Minimal third-person greybox controller with deterministic proximity interaction.

@export_range(0.5, 12.0, 0.1) var move_speed: float = 4.0
@export_range(0.0, 30.0, 0.1) var turn_speed: float = 12.0
@export_range(0.01, 1.0, 0.01) var look_sensitivity_degrees_per_pixel: float = 0.12
@export_range(-89.0, 0.0, 1.0) var min_pitch_degrees: float = -70.0
@export_range(0.0, 89.0, 1.0) var max_pitch_degrees: float = 35.0

@onready var _camera_pivot: Node3D = $CameraPivot

var _gravity: float = 9.8
var _camera_yaw_radians: float = 0.0
var _nearby_interactables: Array[BTVInteractable] = []


func _ready() -> void:
	add_to_group("btv_player")
	_gravity = float(ProjectSettings.get_setting("physics/3d/default_gravity", 9.8))
	_camera_yaw_radians = _camera_pivot.global_rotation.y
	_sync_camera_yaw()
	var sensor: Area3D = $InteractionSensor
	sensor.area_entered.connect(_on_sensor_area_entered)
	sensor.area_exited.connect(_on_sensor_area_exited)


func _physics_process(delta: float) -> void:
	_sync_camera_yaw()
	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var move_direction := _get_camera_relative_move_direction(input_vector)
	if not is_on_floor():
		velocity.y -= _gravity * delta
	else:
		velocity.y = 0.0
	velocity.x = move_direction.x * move_speed
	velocity.z = move_direction.z * move_speed
	if move_direction.length_squared() > 0.001:
		var target_yaw := atan2(-move_direction.x, -move_direction.z)
		rotation.y = lerp_angle(rotation.y, target_yaw, min(turn_speed * delta, 1.0))
	move_and_slide()
	_sync_camera_yaw()
	if Input.is_action_just_pressed("interact"):
		_try_interact()


func _get_camera_relative_move_direction(input_vector: Vector2) -> Vector3:
	var camera_basis := _camera_pivot.global_transform.basis
	var camera_forward := -camera_basis.z
	camera_forward.y = 0.0
	camera_forward = camera_forward.normalized()
	var camera_right := camera_basis.x
	camera_right.y = 0.0
	camera_right = camera_right.normalized()

	var direction := camera_right * input_vector.x + camera_forward * -input_vector.y
	if direction.length_squared() > 1.0:
		direction = direction.normalized()
	return direction


func _apply_look_delta(mouse_delta: Vector2) -> void:
	_camera_yaw_radians -= deg_to_rad(mouse_delta.x * look_sensitivity_degrees_per_pixel)
	var pitch_delta := deg_to_rad(mouse_delta.y * look_sensitivity_degrees_per_pixel)
	_camera_pivot.rotation.x = clampf(
		_camera_pivot.rotation.x + pitch_delta,
		deg_to_rad(min_pitch_degrees),
		deg_to_rad(max_pitch_degrees)
	)
	_sync_camera_yaw()


func _sync_camera_yaw() -> void:
	var pivot_global_rotation := _camera_pivot.global_rotation
	pivot_global_rotation.y = _camera_yaw_radians
	_camera_pivot.global_rotation = pivot_global_rotation


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event := event as InputEventKey
		if key_event.pressed and not key_event.echo and key_event.keycode == KEY_ESCAPE:
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				get_viewport().set_input_as_handled()
				return

	if DisplayServer.is_touchscreen_available():
		return

	if event is InputEventMouseButton:
		var button_event := event as InputEventMouseButton
		if button_event.pressed and button_event.button_index == MOUSE_BUTTON_LEFT:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_apply_look_delta((event as InputEventMouseMotion).relative)


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_sensor_area_entered(area: Area3D) -> void:
	if area is BTVInteractable and not _nearby_interactables.has(area):
		_nearby_interactables.append(area as BTVInteractable)


func _on_sensor_area_exited(area: Area3D) -> void:
	if area is BTVInteractable:
		_nearby_interactables.erase(area as BTVInteractable)


func _select_nearest_interactable() -> BTVInteractable:
	var candidates: Array[BTVInteractable] = []
	var retained_nearby: Array[BTVInteractable] = []
	var id_counts: Dictionary = {}
	for interactable in _nearby_interactables:
		if not is_instance_valid(interactable) or interactable.is_queued_for_deletion():
			continue
		if not interactable.is_inside_tree():
			continue
		retained_nearby.append(interactable)
		if not interactable.can_interact(self):
			continue
		var authored_id := _normalized_interaction_id(interactable)
		if authored_id.is_empty():
			continue
		candidates.append(interactable)
		id_counts[authored_id] = int(id_counts.get(authored_id, 0)) + 1
	_nearby_interactables = retained_nearby
	var eligible: Array[BTVInteractable] = []
	for interactable in candidates:
		var authored_id := _normalized_interaction_id(interactable)
		if int(id_counts.get(authored_id, 0)) == 1:
			eligible.append(interactable)
	eligible.sort_custom(_interaction_order)
	if eligible.is_empty():
		return null
	return eligible[0]


func _normalized_interaction_id(interactable: BTVInteractable) -> String:
	return interactable.interaction_id.strip_edges()


func _interaction_order(a: BTVInteractable, b: BTVInteractable) -> bool:
	var distance_a := global_position.distance_squared_to(a.global_position)
	var distance_b := global_position.distance_squared_to(b.global_position)
	if not is_equal_approx(distance_a, distance_b):
		return distance_a < distance_b
	var id_a := _normalized_interaction_id(a)
	var id_b := _normalized_interaction_id(b)
	var insensitive_order := id_a.naturalnocasecmp_to(id_b)
	if insensitive_order != 0:
		return insensitive_order < 0
	return id_a < id_b


func _try_interact() -> String:
	var nearest := _select_nearest_interactable()
	if nearest == null:
		return ""
	return nearest.interact(self)
