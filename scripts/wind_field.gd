extends RefCounted
class_name BTVWindField

## Pure, deterministic wind sampling and bounded drag calculations.
## This module does not apply forces to bodies or alter player controls.

static func sample_wind(
	mean_direction: Vector3,
	mean_speed: float,
	gust_direction: Vector3 = Vector3.ZERO,
	gust_speed: float = 0.0,
	gust_blend: float = 0.0,
	local_offset: Vector3 = Vector3.ZERO,
) -> Vector3:
	var mean_velocity := Vector3.ZERO
	if mean_direction.length_squared() > 0.000001:
		mean_velocity = mean_direction.normalized() * maxf(mean_speed, 0.0)

	var gust_velocity := mean_velocity
	if gust_direction.length_squared() > 0.000001:
		gust_velocity = gust_direction.normalized() * maxf(gust_speed, 0.0)

	return mean_velocity.lerp(gust_velocity, clampf(gust_blend, 0.0, 1.0)) + local_offset


## Smooth deterministic gust offset. The caller supplies simulation time and seed phase.
static func gust_speed_offset(simulation_time: float, frequency: float, phase: float, amplitude: float) -> float:
	return sin(simulation_time * maxf(frequency, 0.0) + phase) * maxf(amplitude, 0.0)


## Simplified quadratic drag for explicitly opted-in game props.
## The result is force-like in project units; it is not SI-calibrated.
static func calculate_drag_force(
	body_velocity: Vector3,
	wind_velocity: Vector3,
	air_density: float,
	drag_coefficient: float,
	reference_area: float,
	game_scale: float = 1.0,
	max_force: float = 100.0,
) -> Vector3:
	var relative_air_velocity := wind_velocity - body_velocity
	var relative_speed := relative_air_velocity.length()
	if relative_speed <= 0.000001 or max_force <= 0.0:
		return Vector3.ZERO

	var density := maxf(air_density, 0.0)
	var coefficient := maxf(drag_coefficient, 0.0)
	var area := maxf(reference_area, 0.0)
	var scale := maxf(game_scale, 0.0)
	var magnitude := 0.5 * density * coefficient * area * relative_speed * relative_speed * scale
	return relative_air_velocity.normalized() * minf(magnitude, max_force)
