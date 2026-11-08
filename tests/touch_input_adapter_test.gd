extends SceneTree

const TouchAdapter = preload("res://scripts/touch_input_adapter.gd")

var failures := 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	_test_invalid_finger_ids_are_rejected()
	_test_movement_finger_tracks_joystick_vector()
	_test_movement_vector_is_clamped_and_normalized()
	_test_movement_deadzone_is_applied()
	_test_movement_finger_isolated_from_other_fingers()
	_test_look_finger_returns_incremental_delta()
	_test_same_finger_cannot_own_both_controls()
	_test_release_only_clears_matching_finger()
	_test_independent_movement_and_look_fingers()
	_test_cancel_all_resets_both_controls()
	if failures == 0:
		print("TOUCH_INPUT_ADAPTER_TESTS: PASS")
		quit(0)
	else:
		printerr("TOUCH_INPUT_ADAPTER_TESTS: FAIL (", failures, " failures)")
		quit(1)


func _new_adapter():
	return TouchAdapter.new()


func _test_invalid_finger_ids_are_rejected() -> void:
	var adapter = _new_adapter()
	_check(not adapter.begin_movement(-1, Vector2.ZERO), "Negative movement finger ID is rejected")
	_check(not adapter.begin_look(-1, Vector2.ZERO), "Negative look finger ID is rejected")


func _test_movement_finger_tracks_joystick_vector() -> void:
	var adapter = _new_adapter()
	_check(adapter.begin_movement(3, Vector2(100, 100)), "Movement finger can claim the joystick")
	var centered: Vector2 = adapter.update_movement(3, Vector2(100, 100))
	_check(centered.is_zero_approx(), "Joystick centre produces zero movement")
	var moved: Vector2 = adapter.update_movement(3, Vector2(136, 100))
	_check(moved.x > 0.0 and is_zero_approx(moved.y), "Horizontal joystick drag produces horizontal movement")


func _test_movement_vector_is_clamped_and_normalized() -> void:
	var adapter = _new_adapter()
	adapter.joystick_radius = 72.0
	adapter.deadzone = 0.0
	adapter.begin_movement(1, Vector2.ZERO)
	var diagonal: Vector2 = adapter.update_movement(1, Vector2(200, -200))
	_check(is_equal_approx(diagonal.length(), 1.0), "Joystick vector is clamped to a unit circle")


func _test_movement_deadzone_is_applied() -> void:
	var adapter = _new_adapter()
	adapter.joystick_radius = 72.0
	adapter.deadzone = 0.12
	adapter.begin_movement(2, Vector2.ZERO)
	var small: Vector2 = adapter.update_movement(2, Vector2(5, 0))
	var larger: Vector2 = adapter.update_movement(2, Vector2(36, 0))
	_check(small.is_zero_approx(), "Joystick movement inside the deadzone is ignored")
	_check(larger.x > 0.0 and larger.x < 1.0, "Movement outside the deadzone is rescaled smoothly")


func _test_movement_finger_isolated_from_other_fingers() -> void:
	var adapter = _new_adapter()
	adapter.begin_movement(4, Vector2.ZERO)
	var expected: Vector2 = adapter.update_movement(4, Vector2(30, 0))
	var wrong_finger: Vector2 = adapter.update_movement(9, Vector2(0, 100))
	_check(wrong_finger.is_equal_approx(expected), "A different finger receives the unchanged active movement vector")
	_check(adapter.get_movement_vector().is_equal_approx(expected), "Wrong-finger input leaves movement state unchanged")


func _test_look_finger_returns_incremental_delta() -> void:
	var adapter = _new_adapter()
	_check(adapter.begin_look(7, Vector2(20, 20)), "Look finger can claim the camera-look surface")
	var first: Vector2 = adapter.update_look(7, Vector2(25, 17))
	var second: Vector2 = adapter.update_look(7, Vector2(30, 20))
	_check(first.is_equal_approx(Vector2(5, -3)), "First look update returns movement since the previous touch position")
	_check(second.is_equal_approx(Vector2(5, 3)), "Later look update returns an incremental delta")


func _test_same_finger_cannot_own_both_controls() -> void:
	var adapter = _new_adapter()
	_check(adapter.begin_movement(5, Vector2.ZERO), "Finger first claims movement")
	_check(not adapter.begin_look(5, Vector2.ZERO), "One finger cannot also claim camera look")
	_check(adapter.begin_look(6, Vector2.ZERO), "A separate finger can claim camera look")


func _test_release_only_clears_matching_finger() -> void:
	var adapter = _new_adapter()
	adapter.begin_movement(10, Vector2.ZERO)
	adapter.update_movement(10, Vector2(50, 0))
	_check(not adapter.end_movement(11), "Wrong finger cannot release movement")
	_check(not adapter.get_movement_vector().is_zero_approx(), "Wrong-finger release preserves active movement")
	_check(adapter.end_movement(10), "Owning finger can release movement")
	_check(adapter.get_movement_vector().is_zero_approx(), "Movement release resets the vector")


func _test_independent_movement_and_look_fingers() -> void:
	var adapter = _new_adapter()
	_check(adapter.begin_movement(12, Vector2(10, 10)), "Movement finger is assigned")
	_check(adapter.begin_look(13, Vector2(200, 200)), "Independent look finger is assigned")
	adapter.update_movement(12, Vector2(40, 10))
	var look_delta: Vector2 = adapter.update_look(13, Vector2(205, 196))
	_check(not adapter.get_movement_vector().is_zero_approx(), "Movement remains active while camera look updates")
	_check(look_delta.is_equal_approx(Vector2(5, -4)), "Look finger updates independently while movement is active")


func _test_cancel_all_resets_both_controls() -> void:
	var adapter = _new_adapter()
	adapter.begin_movement(14, Vector2.ZERO)
	adapter.update_movement(14, Vector2(40, 0))
	adapter.begin_look(15, Vector2.ZERO)
	adapter.cancel_all()
	_check(adapter.get_movement_vector().is_zero_approx(), "Cancellation clears the movement vector")
	_check(not adapter.has_movement_finger(), "Cancellation releases movement finger ownership")
	_check(not adapter.has_look_finger(), "Cancellation releases look finger ownership")
	_check(adapter.update_look(15, Vector2(20, 20)).is_zero_approx(), "Cancelled look finger cannot continue moving the camera")


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
