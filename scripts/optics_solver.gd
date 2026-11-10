extends RefCounted
class_name BTVOpticsSolver

## Deterministic geometric-optics helpers for authored environment puzzles.
## The supplied normal is treated as the boundary normal; it is oriented
## against the incoming ray internally. Directions are normalized on output.

static func reflect_direction(incoming: Vector3, surface_normal: Vector3) -> Vector3:
	if incoming.length_squared() <= 0.000001 or surface_normal.length_squared() <= 0.000001:
		return Vector3.ZERO
	var direction := incoming.normalized()
	var normal := surface_normal.normalized()
	return (direction - 2.0 * direction.dot(normal) * normal).normalized()


## Returns {valid, total_internal_reflection, direction}.
## Invalid refractive indices or zero vectors return valid=false.
static func refract_direction(
	incoming: Vector3,
	surface_normal: Vector3,
	index_from: float,
	index_to: float,
) -> Dictionary:
	if index_from <= 0.0 or index_to <= 0.0:
		return _result(false, false, Vector3.ZERO)
	if incoming.length_squared() <= 0.000001 or surface_normal.length_squared() <= 0.000001:
		return _result(false, false, Vector3.ZERO)

	var direction := incoming.normalized()
	var normal := surface_normal.normalized()
	var cos_incident := -direction.dot(normal)
	if cos_incident < 0.0:
		normal = -normal
		cos_incident = -direction.dot(normal)

	var eta := index_from / index_to
	var sin_transmitted_squared := eta * eta * maxf(1.0 - cos_incident * cos_incident, 0.0)
	if sin_transmitted_squared > 1.0:
		return _result(true, true, Vector3.ZERO)

	var cos_transmitted := sqrt(maxf(1.0 - sin_transmitted_squared, 0.0))
	var transmitted := eta * direction + (eta * cos_incident - cos_transmitted) * normal
	return _result(true, false, transmitted.normalized())


static func critical_angle_radians(index_high: float, index_low: float) -> float:
	if index_high <= 0.0 or index_low <= 0.0 or index_high <= index_low:
		return -1.0
	return asin(clampf(index_low / index_high, 0.0, 1.0))


static func _result(is_valid: bool, is_total_internal_reflection: bool, ray_direction: Vector3) -> Dictionary:
	return {
		"valid": is_valid,
		"total_internal_reflection": is_total_internal_reflection,
		"direction": ray_direction,
	}
