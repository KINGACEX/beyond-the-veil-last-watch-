extends SceneTree
## Tests weighted local weather-zone composition and invalid zone rejection.

const WeatherBlend = preload("res://scripts/weather_profile_blend.gd")
var failures := 0


func _initialize() -> void:
	_run()


func _run() -> void:
	var base := {"rain": 0.0, "wind": 0.2, "fog": 0.1}
	var forest := {"rain": 0.4, "wind": 0.7, "fog": 0.3}
	var coast := {"rain": 0.8, "wind": 1.0, "fog": 0.6}

	_check(WeatherBlend.blend_weather_zones(base, []) == base,
		"WEATHER_ZONES: no local zones preserve the base profile")
	var overlap: Dictionary = WeatherBlend.blend_weather_zones(base, [
		{"profile": forest, "weight": 1.0},
		{"profile": coast, "weight": 1.0},
	])
	_check(is_equal_approx(float(overlap.get("rain", -1.0)), 0.4),
		"WEATHER_ZONES: overlapping zones blend with the base profile")
	_check(is_equal_approx(float(overlap.get("wind", -1.0)), 0.6333333),
		"WEATHER_ZONES: all channels use normalized weighted composition")

	var zero_zone: Dictionary = WeatherBlend.blend_weather_zones(base, [
		{"profile": coast, "weight": 0.0},
	])
	_check(zero_zone == base,
		"WEATHER_ZONES: zero-weight zone has no effect")
	var negative_zone: Dictionary = WeatherBlend.blend_weather_zones(base, [
		{"profile": coast, "weight": -2.0},
	])
	_check(negative_zone == base,
		"WEATHER_ZONES: negative-weight zone is ignored")
	_check(WeatherBlend.blend_weather_zones(base, [
		{"profile": {"rain": 1.0}, "weight": 1.0},
	]).is_empty(),
		"WEATHER_ZONES: incompatible profile schema is rejected")
	_check(WeatherBlend.blend_weather_zones(base, [
		{"profile": coast, "weight": "high"},
	]).is_empty(),
		"WEATHER_ZONES: non-numeric weight is rejected")
	_check(WeatherBlend.blend_weather_zones({}, []).is_empty(),
		"WEATHER_ZONES: empty base profile is rejected")

	print("\nWEATHER_ZONE_BLEND_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
