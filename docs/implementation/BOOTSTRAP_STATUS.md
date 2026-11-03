# BTV Bootstrap 001 — Status

**Branch:** `btv/bootstrap-prototype-001`  
**Status:** IMPLEMENTED IN SOURCE — NOT ENGINE-VERIFIED  
**Scope:** minimal Godot project scaffold and desktop greybox movement test.

## Included

- Project configuration with a main scene.
- Basic input actions for W/A/S/D and arrow keys.
- A flat collision floor and directional light.
- A capsule placeholder player using CharacterBody3D.
- A SpringArm3D and Camera3D rig.
- A small GDScript movement controller.
- Generated Godot cache and export folders excluded from Git.

## Deliberate constraints

- No renderer is selected in project settings. Renderer choice remains open until measured on the target Android device.
- No final player identity, character art, combat, enemies, Veil rules, Ember behaviour, faith systems, missions, or economy are introduced.
- The capsule is a temporary greybox placeholder, not Asher's final model.
- Keyboard controls are only for an initial desktop smoke test. Touch-first controls remain required for the Android milestone.
- No external assets or paid services are used.

## Verification still required

1. Open with the agreed Godot 4.7.2 editor and confirm project import.
2. Check the project for parse/resource errors.
3. Run the main scene and verify floor collision, movement, gravity, camera, and rotation.
4. Compare renderer options on the actual Android target before selecting one.
5. Add touch controls and test on-device.
6. Record the actual device, frame time, memory, thermal behaviour, and stability.

**No Godot editor run, automated test, Android export, or device test has been performed by this change.**

## Next implementation task

After the bootstrap passes the editor smoke test, add a reusable interaction contract and one neutral test interactable. Do not begin mission, combat, spiritual progression, or narrative content until the relevant canon and vertical-slice gates are checked.
