extends CharacterBody3D
class_name BTVPlayerController

## Minimal third-person greybox controller with a reusable proximity interaction sensor.
## Keyboard input is for the first desktop smoke test; touch controls are a later gate.

@export_range(0.5, 12.0, 0.1) var move_speed: float = 4.0
@export_range(0.0, 30.0, 0.1) var turn_speed: float = 12.0

var _gravity: float = 9.8
var _nearby_interactables: Array[BTVInteractable] = []


func _ready() -> void:
	_gravity = float(ProjectSettings.get_setting("physics/3d/default_gravity", 9.8))
	var sensor: Area3D = $InteractionSensor
	sensor.area_entered.connect(_on_sensor_area_entered)
	sensor.area_exited.connect(_on_sensor_area_exited)


func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_back"
	)
	var move_direction := Vector3(input_vector.x, 0.0, input_vector.y).normalized()

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

	if Input.is_action_just_pressed("interact"):
		_try_interact()


func _on_sensor_area_entered(area: Area3D) -> void:
	if area is BTVInteractable:
		var interactable := area as BTVInteractable
		if not _nearby_interactables.has(interactable):
			_nearby_interactables.append(interactable)


func _on_sensor_area_exited(area: Area3D) -> void:
	if area is BTVInteractable:
		_nearby_interactables.erase(area)


func _try_interact() -> void:
	var nearest: BTVInteractable = null
	var nearest_distance := INF

	for interactable in _nearby_interactables:
		if not is_instance_valid(interactable):
			continue
		var distance := global_position.distance_squared_to(interactable.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest = interactable

	if nearest != null:
		print(nearest.interact(self))
