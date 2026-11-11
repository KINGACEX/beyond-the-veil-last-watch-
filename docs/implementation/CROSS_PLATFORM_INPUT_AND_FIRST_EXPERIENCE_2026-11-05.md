# BTV Cross-Platform Input and First-Experience Foundation

**Date:** 2026-11-05  
**Branch:** `btv/bootstrap-prototype-001`  
**Status:** PROPOSED — implementation brief; no gameplay code changed in this document  
**Decision:** Mobile-first validation, shared mobile/PC architecture from the beginning.

## 1. Decision

BTV should not be developed as a mobile-only game with PC support postponed. Build one shared gameplay foundation and adapt its input and interface presentation to the active input method and screen.

- Android is the first hands-on validation target because it is the currently available device.
- Desktop keyboard and mouse remain supported in the same build and InputMap.
- Controller support should remain architecturally possible, but is not a first-milestone requirement.
- The main menu should be one responsive UI system, not separate mobile and PC implementations.
- A missing PC laptop blocks local PC hands-on testing, not PC-compatible architecture, source work, or CI checks.

This is a staged cross-platform strategy, not a promise of simultaneous release.

## 2. Current verified source findings

At baseline commit `6b897c2eface874015c8a257fe4d06a3cabf1eae`:

### `scripts/player_controller.gd`
- Reads the shared `move_left`, `move_right`, `move_forward`, and `move_back` InputMap actions.
- Converts input directly to world-space movement.
- Turns the player toward the resulting world-space direction.
- Reads the `interact` action and invokes the nearest valid interactable.
- Does not currently read camera-relative movement or camera-look actions.

### `scripts/touch_controls.gd`
- Shows the touch overlay when `DisplayServer.is_touchscreen_available()` is true.
- Uses four directional buttons and an interaction button.
- Presses/releases the same InputMap actions used by keyboard.
- Does not currently provide analog movement or a camera-look surface.

### `scenes/player.tscn`
- Contains a `CameraPivot`, `SpringArm3D` and active `Camera3D`.
- Camera pivot currently has a fixed initial pitch.
- No verified runtime camera-look control is wired in the inspected source.

### `project.godot`
- Defines keyboard movement and interaction actions.
- No look or pause actions are currently declared in the inspected input section.

### Implication
The current touch overlay is a useful smoke-test scaffold, not a complete mobile control scheme. Do not label mobile controls as complete or Android-ready.

## 3. Architecture principles

### A. One action layer
Player gameplay code should consume semantic actions, not care whether an action came from touch, keyboard, mouse or (later) controller.

Initial semantic actions:
- `move_left`, `move_right`, `move_forward`, `move_back`
- `look_left`, `look_right`, `look_up`, `look_down` or a clearly isolated look-delta interface
- `interact`
- `pause`

Do not duplicate movement or interaction logic in a mobile-only player controller.

### B. Camera-relative movement
Movement direction should be derived from the active camera's horizontal forward/right basis, flattened onto the ground plane and normalized. The player should face the resulting movement direction using the existing smoothed rotation approach.

Acceptance:
- Pressing forward moves in the direction the camera faces.
- Rotating the camera changes the forward movement direction.
- Diagonal movement is not faster than straight movement.
- Gravity and collision behaviour remain intact.

### C. Independent camera look
The camera should support:
- Mouse motion on desktop while the game has appropriate pointer focus/capture.
- A dedicated right-side touch-look region on mobile.
- Independent look input while the player is moving.
- Sensitivity settings and pitch limits.
- Safe touch-index tracking so a movement finger does not also rotate the camera.
- Touch cancellation/release cleanup so controls never remain stuck.

Do not add camera auto-aim or combat-specific assistance at this stage.

### D. Mobile movement control
Replace the four-button directional pad with a virtual analog joystick or a carefully tested equivalent. Keep interaction as a contextual action button.

Initial mobile HUD:
- Left lower area: movement joystick.
- Right half: camera-look surface.
- Contextual interact button: visible only when a valid interactable is nearby.
- Pause/settings affordance: reachable without obstructing play.

The first implementation should prioritize comfortable thumb reach, readable hit areas, safe-area margins, and avoiding overlap with important visual content. Do not overfill the screen with buttons.

### E. Active-input-aware presentation
- Touch-first devices may show the touch HUD by default.
- When keyboard/mouse or controller input is detected, contextual hints should switch to the appropriate glyphs.
- Avoid flicker when input sources alternate rapidly; use a short debounce/cooldown.
- Do not permanently hide touch support on hybrid devices.
- Provide an option to show/hide touch controls where relevant.

### F. Responsive menus and HUD
Use Godot Control anchors, containers, and size flags rather than fixed pixel positioning for essential UI.

One shared menu flow:
- Main menu
- Continue only when a valid save exists
- New Watch
- Settings
- Accessibility
- Credits

Mobile presentation:
- Large touch targets, vertical or compact stacked layout, safe-area spacing.
- No hover-only interactions.

Desktop presentation:
- Balanced wider layout, mouse support, visible focus states and full keyboard navigation.
- Escape opens/closes pause menu where appropriate.
- Menus should remain usable without a mouse.

The menu may rearrange at different aspect ratios, but its actions and content should remain consistent. Do not implement save functionality merely to make Continue appear active.

## 4. Research lessons applied to BTV

### Digital Extremes + Nitro Games (Warframe)
The teams combined mobile expertise with the original game's knowledge, iterated on touch UI, offered HUD customisation, used contextual controls and tested with players. BTV should adopt contextual controls and iterative mobile testing, not Warframe's full control complexity.

Reference: https://mobilesyrup.com/2024/02/20/warframe-mobile-digital-extremes-nitro-games-interview

### miHoYo (Genshin Impact)
The team treated multi-platform development as a first-order requirement, considered each platform's strengths/limitations, and developed automated checks. BTV should keep common gameplay logic and use CI to catch regressions, while being realistic about its smaller team.

References:
- https://www.gamerbraves.com/the-inner-workings-of-teyvat-interview-with-the-developers-of-genshin-impact/
- https://www.psu.com/news/discussing-the-unique-free-to-play-model-of-genshin-impact-with-developer-mihoyo-on-launch-day/

### Mojang/Microsoft (Minecraft Bedrock)
Bedrock supports distinct touch, keyboard/mouse and controller schemes. Microsoft guidance emphasizes content that remains playable across different screen sizes, control methods and device performance. BTV should keep input schemes explicit and make UI responsive.

References:
- https://devblogs.microsoft.com/appcenter/guest-blog-playing-in-the-sandbox-how-we-created-minecrafts-multi-platform-design/
- https://learn.microsoft.com/en-us/minecraft/creator/documents/controlschemes?view=minecraft-bedrock-stable
- https://learn.microsoft.com/en-us/minecraft/creator/documents/designinggameplayforvariousdevices?view=minecraft-bedrock-stable

### Engine/platform guidance
Godot InputMap actions allow the same gameplay code to consume different input events, while touch events support multi-touch indices and drag events. Godot Control anchors are intended to handle different resolutions and aspect ratios. Android guidance recommends detecting active input methods and supporting touch, mouse/keyboard and controllers rather than locking an input method to a device category.

References:
- https://docs.godotengine.org/en/4.7/tutorials/inputs/inputevent.html
- https://docs.godotengine.org/en/4.7/classes/class_inputeventscreentouch.html
- https://docs.godotengine.org/en/4.7/tutorials/ui/size_and_anchors.html
- https://developer.android.com/games/develop/multiplatform/enable-natural-input-on-all-form-factors

## 5. Recommended implementation sequence

### M0 — Verify the local baseline (no production edits)
- Mavis reports local Godot version, branch, commit, clone status and baseline test results.
- Confirm the working tree is clean or document existing changes.
- Reproduce the existing CI import, NLI tests and main-scene launch.
- Capture current input behaviour and identify any editor/runtime blockers.

### M1 — Shared input and camera foundation
- Introduce look and pause actions without breaking existing action names.
- Implement camera-relative movement.
- Implement isolated mouse-look.
- Keep existing keyboard movement and interaction functional.
- Add tests for vector normalization, camera-relative direction and input cleanup where practical.
- No new combat, enemies, missions, Ember systems or story content.

### M2 — Mobile control surface
- Add analog movement joystick.
- Add a separate touch-look region with independent finger tracking.
- Preserve shared InputMap/gameplay actions.
- Add contextual interact button visibility.
- Test simultaneous movement + look, multi-touch release, cancellation, and focus changes.
- Keep the old directional controls available until the new controls pass the acceptance matrix; then remove only with evidence.

### M3 — Responsive UI foundation
- Add shared responsive main-menu scene and navigation skeleton.
- Support touch, mouse and keyboard navigation.
- Add pause/settings navigation only; do not claim save or accessibility options are functional until implemented.
- Validate small phone aspect ratios and desktop widescreen using editor/emulator or automated scene checks.

### M4 — Device validation
- Android export and installation.
- Actual device checks for touch feel, text size, heat/performance, orientation, safe areas and frame pacing.
- Desktop hands-on validation when a PC is available.
- Keep platform-specific issues in separate tracked reports.

## 6. Acceptance matrix

| Test | Android touch | Desktop keyboard/mouse | CI/headless |
|---|---:|---:|---:|
| Start main scene | Required | Required | Required |
| Move forward/back/left/right | Required | Required | Logic tests where feasible |
| Camera-relative movement | Required | Required | Logic tests |
| Camera look | Required | Required | Parser/logic tests where feasible |
| Move and look simultaneously | Required | N/A | Logic tests where feasible |
| Interact with nearby target | Required | Required | Existing interaction tests |
| No interaction target | Required | Required | Existing interaction tests |
| Touch release/cancel cleanup | Required | N/A | Unit/scene tests where feasible |
| Menu navigation | Touch | Mouse + keyboard | Scene/import checks |
| Responsive layout | Phone ratios | Desktop ratios | Automated layout checks where feasible |
| Physical device performance | Required before readiness claim | Required before PC readiness claim | Not established by headless CI |

## 7. Restrictions and review gates

- Work only on `btv/bootstrap-prototype-001`.
- Preserve the existing interaction sensor, NLI tests and keyboard controls.
- No GdUnit4 integration without separate justification.
- No merges to `main`, releases, deployments, purchases or paid credits.
- No renderer decision without device evidence.
- No new gameplay canon, combat, enemies, mission content or theological mechanics.
- No analytics collecting personal religious beliefs, prayer choices or other sensitive personal data.
- Keep changes small and reviewable; report exact files, commands, results, branch and commit.
- If Mavis has uncommitted work, do not overwrite or reset it. Inspect and coordinate first.

## 8. Immediate next assignment for Mavis

**Task:** BTV M0 baseline verification and M1 input/camera implementation plan.

**Objective:** Establish the exact local state, then propose the smallest safe camera-relative movement and mouse-look patch. Do not begin M2 virtual joystick or M3 menu implementation in the same change.

**Required report before edits:**
1. Local Godot version.
2. Repository URL and branch.
3. Local HEAD commit and whether it matches the current remote branch.
4. Working-tree status.
5. Exact baseline commands and results.
6. Whether the main scene runs in the editor.
7. Current keyboard movement and interaction behaviour.
8. Whether any local work exists that must be preserved.
9. GitHub read/write/push capability, with evidence but no secrets.

**M1 acceptance criteria:**
- Existing keyboard movement still works.
- Movement becomes camera-relative.
- Mouse-look works with sensible pitch limits.
- Interaction behaviour remains unchanged.
- No new dependencies.
- Existing CI import, NLI smoke tests and main-scene launch pass.
- New tests cover movement direction and normalization where practical.
- Provide exact file list, diff summary, commands, observed results and commit SHA.
- Stop and report if the camera hierarchy, physics behaviour or local changes make the proposed patch unsafe.

**Status at creation:** M0/M1 not yet started or verified by this document. This is an assignment and architecture plan, not an implementation claim.
