extends RefCounted
class_name BTVWildlifeVisualLOD

## Visual presentation tiers are independent from the wildlife simulation scheduler.

const NEAR := "near"
const MID := "mid"
const FAR := "far"
const OFF := "off"


static func classify_distance(distance: float, near_limit: float = 18.0, mid_limit: float = 45.0, far_limit: float = 90.0) -> String:
	if not is_finite(distance) or distance < 0.0:
		return ""
	if not (is_finite(near_limit) and is_finite(mid_limit) and is_finite(far_limit)):
		return ""
	if near_limit < 0.0 or mid_limit <= near_limit or far_limit <= mid_limit:
		return ""
	if distance <= near_limit:
		return NEAR
	if distance <= mid_limit:
		return MID
	if distance <= far_limit:
		return FAR
	return OFF
