# BTV Control Readiness Gate 001

**Status:** PARTIALLY VERIFIED — AUTOMATED BASELINE PASSES; PHYSICAL AND GAME-FEEL GATES REMAIN OPEN  
**Engine:** Godot 4.7.2  
**Target:** Android-first, keyboard/mouse retained for development and later PC  
**Parent implementation:** XH-003 input-source composition, PR #6  
**Purpose:** Define what "controls are ready" means before the prototype's playable level layout is implemented.

## 1. Current verified baseline

The XH-003 implementation provides:
- Separate keyboard and touch InputMap namespaces.
- Independent keyboard and touch movement vectors, composed once and capped at unit magnitude.
- A shared logical Interact latch for keyboard and touch.
- Analog joystick movement and a separate look-finger owner.
- Touch-only cleanup on focus loss, Android pause, and overlay teardown.
- Player lookup/re-resolution for camera look.
- Nineteen passing Godot 4.7.2 headless suites on commit `28a76d8dc15980963900758a378241a1c97f6338`, run [#42666506202](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42666506202). The pipeline includes five-viewport geometry checks, concurrent three-finger input, neutral lab structure/telemetry checks, acceleration/braking/diagonal-speed tests, wall blocking, doorway/corridor clearance, gentle/steeper ramp floor-contact probes, high-step blocking/no-vertical-snap and a 10-frame lab launch.
- A source audit found that touch-camera rotation was calculated from successive viewport positions. Godot documents `InputEventScreenDrag.screen_relative` as the unscaled screen-space delta and recommends it for touch aiming across stretch modes. The current branch now routes camera look through this property and adds ownership, integration, lifecycle and reconciliation regression coverage. The updated code passed the complete 17-suite pipeline.

This is an automated baseline, not proof of perfect controls or Android readiness.

## 2. Gate A — automated input correctness

All items must pass on the exact candidate commit.

### Movement
- Keyboard-only movement preserves existing directions and speed.
- Touch-only movement works across the full analog range.
- Same-direction input from two sources never exceeds the normalized movement cap.
- Different-direction input composes predictably and never exceeds the cap.
- Releasing either source never cancels the other source.
- Releasing both sources returns movement to zero in the next physics update.
- Deadzone, rescaling, diagonal movement, and low-strength response have explicit expected values.

### Multitouch and camera
- Movement and camera look can be owned by separate fingers simultaneously through the actual viewport event path.
- Movement remains active while the look finger moves, releases, or is cancelled.
- Look remains active while the movement finger moves or releases.
- A third finger on Interact does not steal either active finger.
- A finger cannot claim two control surfaces at once.
- An unrelated finger cannot move or release another finger's control.
- Camera pitch clamps correctly at both limits; yaw remains continuous.
- Camera look never starts from the Interact button area.

### Interact
- Keyboard-only and touch-only Interact each produce exactly one logical press edge.
- Simultaneous keyboard/touch presses produce one edge.
- A second source joining an already-held Interact does not produce another edge.
- Releasing one source while the other remains held does not re-arm the control.
- Both sources must be released before another press can trigger.
- Button cancellation, focus loss, pause and teardown cannot leave Interact stuck.

### Lifecycle and compatibility
- Focus loss and Android pause release touch-owned state only.
- Resume does not restore stale touch movement or Interact.
- Scene teardown and player replacement do not leave input state or stale references.
- Keyboard/mouse control remains functional.
- Hidden touch UI never consumes input or drives the player.
- No touch control writes to keyboard-facing actions.

## 3. Gate B — layout and accessibility

The controls must remain usable at the supported viewport sizes and orientations.

- Test small, medium and large Android viewport aspect ratios, including portrait and landscape only if landscape is approved as a supported mode.
- Respect operating-system display cutouts and safe areas; no critical control may sit under a system bar, rounded corner or camera cutout.
- Verify thumb reach, hand occlusion, button spacing, joystick travel and look-surface boundaries.
- Interact and future ability controls must have consistent hit areas and visual states.
- Essential control state must not rely on colour alone.
- Text and button labels must remain legible at the smallest supported viewport.
- Controls must not obscure mission-critical evidence, subtitles or the central play space.
- Provide a low-clutter fallback layout and a way to adjust camera sensitivity.

Automated viewport geometry is covered at five representative sizes, but that is only a preliminary geometry check. Do not call layout complete based only on headless viewports. Safe areas, thumb reach, display cutouts, text scaling and actual orientation policy require the target device before platform acceptance.

## 4. Gate C — game-feel baseline

Gate C must be measured in the neutral movement and physics laboratory. The lab is the first actual gameplay construction and is deliberately separate from Ridgeview. Do not require Gate C to pass before constructing the lab; instead, require the automated input correctness checks and preliminary viewport geometry check to pass first. Ridgeview world construction remains blocked until Gate C passes.

In the lab, record a stable and reproducible baseline for:
- acceleration and deceleration;
- maximum walk/run speed and any sprint policy;
- turning response and stop distance;
- gravity, floor contact, slopes and step handling;
- camera distance, height, pitch range, sensitivity and smoothing;
- input-to-motion responsiveness;
- touch joystick deadzone and response curve.

The lab uses a neutral greybox course with a flat lane, two ramps, three steps, collision walls/corners, a doorway, corridor, camera-obstruction wall and live telemetry. Initial acceleration/deceleration candidates are implemented and tested. Wall blocking, doorway/corridor clearance, gentle/steeper ramp floor contact and high-step blocking without vertical snap pass headless probes; this is not full physical-device or final movement-feel acceptance. Do not tune movement against an unfinished character rig or decorative level.

Movement tuning is not allowed to contradict Asher's grounded human identity. Do not add superhuman movement merely to make the controller feel responsive.

## 5. Gate D — physical Android validation

Physical device testing is mandatory before controls are described as Android-ready.

Record:
- exact phone model, SoC/GPU, RAM, Android version, display resolution and refresh rate;
- Godot version, renderer, project commit and exported build;
- simultaneous joystick/look/Interact tests with two and three fingers;
- orientation and safe-area results;
- pause/resume, app switching and notification interruption;
- sustained play, input latency observations and performance;
- any accidental touches, blocked touches, stuck actions, clipping or ergonomic issues.

A desktop editor, headless runner, or simulated InputEvent test cannot substitute for this gate.

## 6. Release and construction rule

- **Neutral laboratory may begin:** after automated Gate A checks and preliminary viewport-geometry checks pass on the exact candidate commit. The lab exists to measure and tune Gate C; it is not Ridgeview world construction.
- **Ridgeview blockout may begin:** only after Gate C passes against recorded laboratory measurements, with no critical control blocker. Any physical-device limitation remains explicit.
- **Android-ready claim:** remains blocked until Gate D passes on the named target device.

The word "perfect" is not a valid acceptance criterion. Use reproducible thresholds, observed behaviour and recorded evidence.

Use evidence labels:
- **PASS:** exact test completed with recorded evidence.
- **FAIL:** defect reproduced.
- **BLOCKED:** required device, build or prerequisite unavailable.
- **NOT RUN:** not attempted.
- **PROPOSED:** acceptance rule or value not yet tested.

Never use "perfect" as a test result. The engineering goal is a controlled, measured, defect-free result within the agreed device and scope.

## 7. Current known gaps

- Physical Android multitouch and ergonomic QA has not been performed.
- Safe-area handling has not been demonstrated on a real device with display cutouts/system bars.
- Automated three-finger movement + look + Interact concurrency now has viewport-path coverage; physical-device concurrency and ergonomic testing remain outstanding.
- The neutral lab scene passes structural/telemetry, acceleration/braking, wall-blocking, doorway/corridor-clearance and gentle-ramp floor-contact tests. More varied ramp angles, low-step traversal policy, camera obstruction/sensitivity, physical-device feel and broader collision edge cases still need measured acceptance.
- The minimum Android device and supported orientation policy remain unknown.

## 8. Gate owner and change control

Any control change must:
1. Begin with a reproduction or a clearly stated design requirement.
2. Add or update a focused regression test.
3. Run the complete Godot 4.7.2 CI workflow.
4. Record the tested commit and run URL.
5. Be reviewed for Android ergonomics and BTV scope.
6. Remain unmerged until the creator's approval and required gates.

