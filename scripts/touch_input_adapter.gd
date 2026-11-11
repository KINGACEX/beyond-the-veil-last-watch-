extends RefCounted
class_name BTVTouchInputAdapter

## Separates one movement finger from one camera-look finger.
## The UI layer owns touch-event routing; this adapter owns finger identity and deltas.

var joystick_radius: float = 72.0
var deadzone: float = 0.12

var _movement_finger_id: int = -1
var _movement_origin: Vector2 = Vector2.ZERO
var _movement_vector: Vector2 = Vector2.ZERO

var _look_finger_id: int = -1
var _last_look_position: Vector2 = Vector2.ZERO


func begin_movement(finger_id: int, origin: Vector2) -> bool:
	if finger_id < 0 or _movement_finger_id >= 0 or finger_id == _look_finger_id:
		return false
	_movement_finger_id = finger_id
	_movement_origin = origin
	_movement_vector = Vector2.ZERO
	return true


## Returns the current authoritative vector unchanged for non-owning fingers.
func update_movement(finger_id: int, position: Vector2) -> Vector2:
	if finger_id != _movement_finger_id:
		return _movement_vector
	if joystick_radius <= 0.0:
		_movement_vector = Vector2.ZERO
		return _movement_vector

	var raw_vector := (position - _movement_origin) / joystick_radius
	var magnitude := raw_vector.length()
	if magnitude > 1.0:
		raw_vector /= magnitude
		magnitude = 1.0

	var safe_deadzone := clampf(deadzone, 0.0, 0.99)
	if magnitude <= safe_deadzone:
		_movement_vector = Vector2.ZERO
	else:
		var output_magnitude := (magnitude - safe_deadzone) / (1.0 - safe_deadzone)
		_movement_vector = raw_vector.normalized() * output_magnitude
	return _movement_vector


func end_movement(finger_id: int) -> bool:
	if finger_id != _movement_finger_id:
		return false
	_movement_finger_id = -1
	_movement_origin = Vector2.ZERO
	_movement_vector = Vector2.ZERO
	return true


func begin_look(finger_id: int, initial_position: Vector2) -> bool:
	if finger_id < 0 or _look_finger_id >= 0 or finger_id == _movement_finger_id:
		return false
	_look_finger_id = finger_id
	_last_look_position = initial_position
	return true


func update_look(finger_id: int, position: Vector2) -> Vector2:
	if finger_id != _look_finger_id:
		return Vector2.ZERO
	var delta := position - _last_look_position
	_last_look_position = position
	return delta


## Accepts the engine's unscaled screen-space drag delta for camera aiming.
## This avoids content-scale-dependent sensitivity across viewport stretch modes.
func update_look_delta(finger_id: int, screen_delta: Vector2) -> Vector2:
	if finger_id != _look_finger_id:
		return Vector2.ZERO
	return screen_delta


func end_look(finger_id: int) -> bool:
	if finger_id != _look_finger_id:
		return false
	_look_finger_id = -1
	_last_look_position = Vector2.ZERO
	return true


func cancel_all() -> void:
	_movement_finger_id = -1
	_movement_origin = Vector2.ZERO
	_movement_vector = Vector2.ZERO
	_look_finger_id = -1
	_last_look_position = Vector2.ZERO


func get_movement_vector() -> Vector2:
	return _movement_vector


func has_movement_finger() -> bool:
	return _movement_finger_id >= 0


func is_movement_finger(finger_id: int) -> bool:
	return finger_id == _movement_finger_id


func has_look_finger() -> bool:
	return _look_finger_id >= 0


func is_look_finger(finger_id: int) -> bool:
	return finger_id == _look_finger_id
