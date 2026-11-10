extends Control

## Touch controls share gameplay actions with keyboard input.
## The analog surface uses independent movement/look finger ownership.
##
## Touch drives its own action namespace (`touch_move_*`, `touch_interact`).
## Godot keeps a single state per action, so two sources bound to the same
## action overwrite one another: a touch release could clear a keyboard hold,
## and a keyboard press could mask the joystick's analog strength. Giving each
## source its own actions makes the interference structurally impossible
## instead of heuristically avoidable, and lets the player controller sum the
## sources once (see BTVPlayerController._compose_movement_intent).

const ACTIONS: Array[StringName] = [
	&"touch_move_forward",
	&"touch_move_back",
	&"touch_move_left",
	&"touch_move_right",
	&"touch_interact",
]
const TouchInputAdapter = preload("res://scripts/touch_input_adapter.gd")

@export var use_analog_touch_controls: bool = true

@onready var _legacy_pad: Control = $MovePad
@onready var _forward: Button = $MovePad/Forward
@onready var _back: Button = $MovePad/Back
@onready var _left: Button = $MovePad/Left
@onready var _right: Button = $MovePad/Right
@onready var _interact: Button = $Interact
@onready var _joystick_base: Control = $JoystickBase
@onready var _joystick_knob: Control = $JoystickBase/Knob
@onready var _look_surface: Control = $LookSurface

var _adapter = TouchInputAdapter.new()
var _player: BTVPlayerController
## Actions the legacy button pad is currently holding. The pad and the analog
## joystick are mutually exclusive by construction - the pad is hidden while
## the analog surface is enabled - so this only guards against a repeated
## button_down on the same action.
var _pressed_actions: Dictionary = {}


func _ready() -> void:
	_sync_overlay_rect()
	get_viewport().size_changed.connect(_sync_overlay_rect)
	visible = DisplayServer.is_touchscreen_available()
	_legacy_pad.visible = not use_analog_touch_controls
	_joystick_base.visible = use_analog_touch_controls
	_look_surface.visible = use_analog_touch_controls
	_resolve_player()
	_bind_action(_forward, &"touch_move_forward")
	_bind_action(_back, &"touch_move_back")
	_bind_action(_left, &"touch_move_left")
	_bind_action(_right, &"touch_move_right")
	_bind_action(_interact, &"touch_interact")
	_adapter.joystick_radius = _joystick_radius()
	_update_joystick_visual(Vector2.ZERO)


## Returns the player that owns the camera, or null when none is available.
## The lookup is re-run whenever the cached instance is gone, so a player that
## spawns after the HUD, or is replaced on respawn, is picked up automatically.
func _resolve_player() -> BTVPlayerController:
	if _player != null and is_instance_valid(_player):
		return _player
	_player = get_tree().get_first_node_in_group("btv_player") as BTVPlayerController
	return _player


func _sync_overlay_rect() -> void:
	anchor_left = 0.0
	anchor_top = 0.0
	anchor_right = 0.0
	anchor_bottom = 0.0
	offset_left = 0.0
	offset_top = 0.0
	size = get_viewport_rect().size
	if is_node_ready():
		_update_joystick_visual(_adapter.get_movement_vector())


func _input(event: InputEvent) -> void:
	if not use_analog_touch_controls:
		return
	# A hidden overlay must not consume touches or drive the player.
	if not visible:
		return
	if event is InputEventScreenTouch:
		_handle_screen_touch(event as InputEventScreenTouch)
	elif event is InputEventScreenDrag:
		_handle_screen_drag(event as InputEventScreenDrag)


func _handle_screen_touch(event: InputEventScreenTouch) -> void:
	if event.pressed:
		if _control_contains_screen_point(_joystick_base, event.position):
			_adapter.joystick_radius = _joystick_radius()
			if _adapter.begin_movement(event.index, _joystick_center_screen()):
				var movement: Vector2 = _adapter.update_movement(event.index, event.position)
				_apply_movement_vector(movement)
				_update_joystick_visual(movement)
				get_viewport().set_input_as_handled()
		elif _control_contains_screen_point(_look_surface, event.position) and not _control_contains_screen_point(_interact, event.position):
			if _adapter.begin_look(event.index, event.position):
				get_viewport().set_input_as_handled()
	else:
		var handled := false
		if _adapter.end_movement(event.index):
			_apply_movement_vector(Vector2.ZERO)
			_update_joystick_visual(Vector2.ZERO)
			handled = true
		if _adapter.end_look(event.index):
			handled = true
		if handled:
			get_viewport().set_input_as_handled()


func _handle_screen_drag(event: InputEventScreenDrag) -> void:
	var handled := false
	if _adapter.is_movement_finger(event.index):
		_adapter.joystick_radius = _joystick_radius()
		var movement: Vector2 = _adapter.update_movement(event.index, event.position)
		_apply_movement_vector(movement)
		_update_joystick_visual(movement)
		handled = true
	if _adapter.is_look_finger(event.index):
		var look_delta: Vector2 = _adapter.update_look(event.index, event.position)
		var player: BTVPlayerController = _resolve_player()
		if player != null and not look_delta.is_zero_approx():
			player.apply_look_delta(look_delta)
		handled = true
	if handled:
		get_viewport().set_input_as_handled()


func _control_contains_screen_point(control: Control, screen_point: Vector2) -> bool:
	var local_point := control.get_global_transform_with_canvas().affine_inverse() * screen_point
	return Rect2(Vector2.ZERO, control.size).has_point(local_point)


func _joystick_center_screen() -> Vector2:
	return _joystick_base.get_global_transform_with_canvas() * (_joystick_base.size * 0.5)


func _joystick_radius() -> float:
	return minf(_joystick_base.size.x, _joystick_base.size.y) * 0.35


func _update_joystick_visual(movement: Vector2) -> void:
	var center := _joystick_base.size * 0.5
	_joystick_knob.position = center - (_joystick_knob.size * 0.5) + movement * _joystick_radius()


func _apply_movement_vector(movement: Vector2) -> void:
	_set_action_strength(&"touch_move_right", maxf(movement.x, 0.0))
	_set_action_strength(&"touch_move_left", maxf(-movement.x, 0.0))
	_set_action_strength(&"touch_move_back", maxf(movement.y, 0.0))
	_set_action_strength(&"touch_move_forward", maxf(-movement.y, 0.0))


## Applies an analog strength to a touch-owned action.
## No ownership bookkeeping is needed: the action belongs to the touch
## namespace, so no other input source can be holding it.
func _set_action_strength(action_name: StringName, strength: float) -> void:
	var safe_strength := clampf(strength, 0.0, 1.0)
	if safe_strength > 0.001:
		Input.action_press(action_name, safe_strength)
	else:
		Input.action_release(action_name)


func _bind_action(button: Button, action_name: StringName) -> void:
	button.button_down.connect(_press_action.bind(action_name))
	button.button_up.connect(_release_action.bind(action_name))


func _press_action(action_name: StringName) -> void:
	if _pressed_actions.has(action_name):
		return
	_pressed_actions[action_name] = true
	Input.action_press(action_name)


func _release_action(action_name: StringName) -> void:
	_pressed_actions.erase(action_name)
	Input.action_release(action_name)


## Releases only the touch-owned actions, so a keyboard or gamepad that is
## holding the same gameplay action is never cancelled by touch cleanup.
func _release_all_actions() -> void:
	for action_name in ACTIONS:
		Input.action_release(action_name)
	_pressed_actions.clear()


func _cancel_all_touch_input() -> void:
	_adapter.cancel_all()
	_apply_movement_vector(Vector2.ZERO)
	_update_joystick_visual(Vector2.ZERO)
	_release_all_actions()


func _notification(what: int) -> void:
	# NOTIFICATION_APPLICATION_PAUSED is the Android backgrounding path and is
	# not guaranteed to be delivered as a focus loss.
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT or what == NOTIFICATION_APPLICATION_PAUSED:
		_cancel_all_touch_input()


func _exit_tree() -> void:
	_cancel_all_touch_input()
