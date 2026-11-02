extends SceneTree

## Minimal headless smoke test proving that a GDScript file can execute.
## Run with: godot --headless --script scripts/dev/repository_write_probe.gd

func _initialize() -> void:
	print("BTV GDScript smoke test: execution reached successfully.")
	quit()
