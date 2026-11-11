# Bootstrap 002 — Reusable Interaction

**Status:** IMPLEMENTED IN SOURCE — NOT ENGINE-VERIFIED  
**Branch:** `btv/bootstrap-prototype-001`

## Goal
Establish a minimal reusable interaction contract and prove it with one neutral test object. This milestone does not introduce mission logic, dialogue trees, inventory, combat, Ember commands, spiritual progression or final UI.

## Design
- `BTVInteractable` is a base `Area3D` contract with an exported prompt and an overridable `interact(actor)` method.
- Concrete interactables return a short result string. They own their own gameplay effect; the player controller only discovers and invokes the contract.
- The player owns a small forward-facing `Area3D` sensor. It tracks nearby compatible interactables.
- Pressing the `interact` input action (E on keyboard or the touch `INTERACT` button) invokes the nearest available interactable.
- A touch overlay provides four directional movement buttons and an interaction button; it feeds the same InputMap actions as keyboard input.
- The touch overlay is shown only when `DisplayServer.is_touchscreen_available()` reports a touchscreen.
- The neutral test target returns a diagnostic message and changes no game state.

## Scene setup
- Interactable areas use collision layer 2.
- The player's sensor monitors collision layer 2.
- The test target is placed ahead of the player in the prototype scene.

## Acceptance checks
1. Project imports without parse/resource errors.
2. Player can move and collide with the floor as before.
3. Test marker is visible ahead of the player.
4. Approaching the marker and pressing E prints the test response in the Godot Output panel.
5. Leaving the marker's sensor range and pressing E produces no interaction response.
6. Moving away from one target and into range of another selects the nearest target.

## Current limitations
- Prompt is exposed as data but no on-screen prompt UI is implemented yet.
- Touch controls are a minimal directional-button prototype, not a final virtual joystick or polished mobile HUD.
- Touch layout, multi-touch behaviour, safe-area handling, scaling and device usability still require Android testing.
- No Godot editor/runtime/device validation has been recorded for this branch.
- Multiple interactables are supported by the sensor list, but target selection and runtime behaviour still require engine testing.

## Next step after verification
Validate the touch overlay on an Android device, then add a reusable prompt/result presentation layer. Keep mission and narrative state outside the base interaction contract.
