extends RefCounted

## Neutral registry validation only. This is not a final mission Resource schema.
static func validate_registry(_records: Array, _references: Array) -> Dictionary:
	return {
		"ok": true,
		"diagnostics": []
	}
