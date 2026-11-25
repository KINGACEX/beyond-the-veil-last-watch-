# BTV Android Prototype 001 — Branding and export gate

**Branch:** `btv/android-apk-prototype-001`
**Base:** `btv/bootstrap-prototype-001`
**Scope:** Android-targeted packaging preparation and original project branding only.

## Added
- `assets/branding/btv_logo.svg` — original shield emblem for BTV.
- `assets/branding/btv_wordmark.svg` — horizontal title lockup.
- `project.godot` references the SVG emblem as the project icon.

## Preserved
- Existing Godot gameplay source and scene structure.
- Existing NLI boundaries and authored-knowledge restrictions.
- Separate Roblox development track.
- No changes to `main`, no merge, no publication, no paid assets or external runtime services.

## APK readiness — not yet achieved
The repository currently has no `export_presets.cfg` and no verified Android export pipeline. The existing GitHub Actions workflow performs headless import, smoke tests and scene startup only; it does not install Android SDK/export templates or produce an APK.

The current touch controls are an early button overlay. Their safe-area layout, multi-touch behaviour, rendered scene and physical Android usability have not been validated. The project renderer remains deliberately undecided pending a target-device comparison.

## Required gates before an APK can be called playable
1. Run Godot 4.7.2 editor import and the NLI smoke suite on this branch.
2. Visually inspect and interactively test the scene.
3. Select and validate the renderer on the target Android device.
4. Complete Android export configuration with matching export templates and Android SDK.
5. Build a debug APK, install it on a physical Android device and verify touch movement, interaction, orientation, safe areas and stability.
6. Record the exact build commit, engine version, APK checksum, device/OS and test results.

No APK has been built or device-tested by this change.
