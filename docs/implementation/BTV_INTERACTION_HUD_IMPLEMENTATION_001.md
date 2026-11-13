# BTV Interaction HUD — Implementation 001

**Status:** IMPLEMENTED — headless regression passed; visual/device review outstanding.  
**Date:** 13 November 2026  
**Scope:** Generic interaction presentation for the prototype and HQ blockout playtest scenes.

## Implemented

- `BTVPlayerController` emits `interaction_target_changed(prompt)` when the deterministic nearest eligible interactable changes.
- `BTVPlayerController` emits `interaction_feedback(message)` after a target interaction.
- `BTVInteractionHUD` listens to those signals and presents the current prompt and interaction result.
- Desktop hint uses `E`; touchscreen-capable devices use `Tap Interact`.
- HUD is attached to the existing main prototype scene and the separate Covenant HQ playtest scene.
- The HUD does not own mission state, NPC knowledge, story decisions or interaction eligibility. The interactable/controller contract remains authoritative.

## Validation

GitHub Actions run [43411985668](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/43411985668) passed on commit `775cd8cc3c6cc6ad927122799e56d83371bed68a`. The interaction HUD regression verified:
1. Nearby target shows its authored prompt.
2. Displayed prompt matches the selected interactable.
3. Interaction result is presented.
4. Leaving the target hides the prompt.

The same run passed the other 16 test scripts, chapel scene-load test, HQ blockout test and 10-frame main-scene launch.

## Known limitations

- The UI uses a fixed 16-pixel viewport margin. It does **not** yet query or apply device-specific safe-area insets.
- No Android physical-device review has been performed.
- No visual/editor review of typography, scaling, contrast or panel styling has been performed.
- Feedback remains visible until replaced; timed dismissal and accessibility settings are not implemented.
- The HUD is a generic interaction foundation. NPC dialogue, mission-board selection and companion commands are not implemented by this change.
- Localization is not implemented.

Do not describe this as a finished interaction system or Android-certified UI. It is a tested presentation foundation.
