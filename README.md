# Beyond the Veil: The Last Watch

BTV is a Christian action-adventure survival RPG set in a modern world of spiritual conflict, exploration, survival, and the Covenant's Last Watch.

## Current repository state

The `btv/bootstrap-prototype-001` branch contains the first minimal Godot project scaffold:

- `project.godot` — project entry point and keyboard movement actions.
- `scenes/main.tscn` — simple greybox test area.
- `scenes/player.tscn` — capsule placeholder, collision, and third-person camera rig.
- `scripts/player_controller.gd` — basic CharacterBody3D movement controller.

## Intended toolchain

The current development gate identifies Godot 4.7.2 as the intended version. Confirm the installed editor and export templates before treating this as a validated project. The renderer is deliberately not selected yet; compare supported renderers on the actual target Android device before deciding.

## Open and run

1. Open this folder in Godot 4.7.x.
2. Allow the project to import.
3. Run the project (F5 / Run Project).
4. Use W/A/S/D or the arrow keys to move the capsule.

This is a greybox bootstrap, not a playable game build. Touch controls, final camera tuning, art, interaction, saving, Android export, and performance validation are not implemented.

## Status

See [the bootstrap status report](docs/implementation/BOOTSTRAP_STATUS.md).
