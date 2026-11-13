# Covenant Headquarters Blockout 001

**Status:** PROPOSED greybox study — not canon, not final art, not a finished HQ.  
**Purpose:** Establish a small, testable, navigable footprint for the first Covenant Headquarters vertical slice.

## Included

- Exterior arrival court and entry opening.
- Central arrival/reception area.
- Left operations/briefing wing with a mission-board display panel and explicit anchor.
- Right training-court wing.
- White base materials, restrained gold trim and a small cross-centred entrance emblem.
- Structural collision on floors, perimeter walls, partitions and pillars.
- Markers for player spawn, reception NPC, operations briefing, mission board, training court and Ember follow-path waypoints.
- A separate playtest scene that instances the existing capsule player and touch controls.

## Deliberate limitations

- The scene is a blockout made from primitive meshes. It is not production architecture or visual-quality approval.
- The reception NPC, mission board and Ember path are **anchors only**. There is no NPC actor, mission runtime, Ember actor, dialogue or command execution yet.
- No location name, HQ history, command hierarchy, facility lore or named NPC has been created. Those remain UNKNOWN or PROPOSED.
- The emblem is a restrained placeholder, not a final insignia design.
- The scene is separate from the existing main greybox scene. It does not replace the main scene.
- It does not reuse the Logos Rhema chapel study; Church and Covenant spaces remain distinct.
- Lighting, collision, scale and camera framing require visual editor review and Android profiling.

## Test

Run:

`godot --headless --path . --script res://tests/covenant_hq_blockout_test.gd`

The test checks scene loading, required layout markers, structural collision coverage and the separate playtest scene. **CONFIRMED:** GitHub Actions run [43411504832](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/43411504832) passed this test with Godot 4.7.2. Passing it proves scene structure only; it does not prove visual quality, navigation feel or device performance.
