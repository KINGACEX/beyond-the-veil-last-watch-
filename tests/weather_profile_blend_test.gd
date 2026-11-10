extends SceneTree
## Tests for normalized, deterministic weather-profile blending.

const WeatherBlend = preload("res://scripts/weather_profile_blend.gd")
var failures := 0


func _initialize() -> void:
	_run()


func _run() -> void:
	var clear := {"cloud_cover": 0.1, "rain": 0.0, "fog": 0.1, "wind": 0.2}
	var storm := {"cloud_cover": 0.9, "rain": 1.0, "fog": 0.6, "wind": 0.8}
	var blended := WeatherBlend.blend_profiles([clear, storm], [0.25, 0.75])
	_check(is_equal_approx(float(blended.get("cloud_cover", -1.0)), 0.7),
		"WEATHER_BLEND: weighted cloud cover is correct")
	_check(is_equal_approx(float(blended.get("rain", -1.0)), 0.75),
		"WEATHER_BLEND: weighted rain intensity is correct")
	_check(is_equal_approx(float(blended.get("wind", -1.0)), 0.65),
		"WEATHER_BLEND: weighted wind intensity is correct")

	var repeated := WeatherBlend.blend_profiles([clear, storm], [0.25, 0.75])
	_check(blended == repeated, "WEATHER_BLEND: identical inputs are deterministic")

	var negative_weight := WeatherBlend.blend_profiles([clear, storm], [1.0, -2.0])
	_check(negative_weight == clear, "WEATHER_BLEND: negative weights are treated as zero")

	_check(WeatherBlend.blend_profiles([], []) == {},
		"WEATHER_BLEND: empty profile set returns empty result")
	_check(WeatherBlend.blend_profiles([clear], []) == {},
		"WEATHER_BLEND: mismatched profile and weight counts are rejected")
	_check(WeatherBlend.blend_profiles([clear, {"rain": 0.5}], [1.0, 1.0]) == {},
		"WEATHER_BLEND: mismatched profile schemas are rejected")
	_check(WeatherBlend.blend_profiles([clear, storm], [0.0, 0.0]) == {},
		"WEATHER_BLEND: zero total weight is rejected")

	var out_of_range := {"cloud_cover": 2.0, "rain": -1.0, "fog": 0.0, "wind": 0.0}
	var bounded := WeatherBlend.blend_profiles([out_of_range], [1.0])
	_check(is_equal_approx(float(bounded["cloud_cover"]), 1.0)
		and is_equal_approx(float(bounded["rain"]), 0.0),
		"WEATHER_BLEND: intensity channels are clamped to 0..1")

	print("\nWEATHER_PROFILE_BLEND_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
