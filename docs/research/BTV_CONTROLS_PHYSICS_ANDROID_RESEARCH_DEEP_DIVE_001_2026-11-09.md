# BTV Controls, Physics and Android Research Deep Dive 001

**Date:** 2026-11-09  
**Research depth:** Level 3 — foundational input and movement system  
**Status:** INITIAL TECHNICAL DEEP DIVE — touch-delta correction, neutral lab, movement-response and initial collision probes passed CI; physical and full game-feel validation remain open  
**Engine baseline:** Godot 4.7.2  
**Platform priority:** Android first; PC later  
**Scope:** input scaling, touch-camera response, CharacterBody3D movement, test-lab sequencing and renderer/device constraints

## 1. Executive findings

1. The existing controller is a functional greybox baseline, not a tuned movement system. Horizontal velocity is assigned directly from the input direction multiplied by `move_speed`. This produces immediate target-speed changes; no authored acceleration or braking curve currently exists.
2. The camera-touch path previously calculated drag from successive viewport positions. Godot 4.7 documents `InputEventScreenDrag.screen_relative` as an unscaled screen-space delta and explicitly recommends it for touch aiming across stretch modes. The current branch has been changed to pass this delta through a finger-ownership check. The new code is awaiting CI.
3. The 19-suite pipeline, including the touch-camera correction, neutral lab acceptance, motion-response tests, wall/doorway/corridor/ramp probes and 10-frame lab launch, passed on commit `c9dbe133891febdc76d7e93cfdaf85b2d3702710` in [run #42666264480](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42666264480).
4. The existing five-size layout suite is a useful geometry regression check, but does not measure Android safe areas, thumb reach, system bars, cutouts or physical touch behaviour.
5. Godot's `CharacterBody3D` is the appropriate starting class for a grounded player controller. `move_and_slide()` belongs in the physics update and uses the body's velocity; floor classification, floor snap, maximum floor angle and slide collision reporting must be measured in the neutral lab rather than guessed.
6. Godot 4.7 documents Mobile as the renderer intended for mobile GPUs, while Compatibility supports older/low-end hardware. The final choice cannot be made responsibly until the target phone's GPU/API support is known and a representative benchmark exists.
7. The control gate sequence is corrected: automated input checks and preliminary viewport geometry permit construction of the neutral lab; the lab is where Gate C game-feel measurements are established; Ridgeview construction remains blocked until Gate C passes. Physical Android readiness remains separately blocked until device testing.

## 2. Current-state source audit

### Confirmed in current controller source

- `BTVPlayerController` extends `CharacterBody3D`.
- Horizontal velocity is set to `move_direction * move_speed` each physics tick.
- Gravity is read from `physics/3d/default_gravity`.
- Movement is camera-relative.
- Character yaw is interpolated using `lerp_angle` and `turn_speed * delta`.
- Movement and touch look use separate finger ownership in the touch adapter.
- The camera pitch is clamped by exported minimum and maximum angles.
- Touch input is kept in a dedicated action namespace and composed with keyboard input by the player controller.

### Confirmed defect / correction in progress

The old look handler computed delta by subtracting consecutive `InputEventScreenDrag.position` values. In Godot, `position` is expressed in viewport coordinates, and the documentation warns that `relative` is scaled by the content scale factor. The `screen_relative` property is unscaled and recommended for touch aiming regardless of stretch mode.

**Change made and verified on this branch:** `touch_controls.gd` now uses `event.screen_relative`; `touch_input_adapter.gd` adds an owner-checked delta path; integration, lifecycle, reconciliation, viewport and adapter tests supply explicit screen deltas. The full 17-suite CI run passed.

### Known gaps

- Initial acceleration/deceleration candidates are now implemented and covered by a headless response-envelope test; final feel and measured physical-device stop distance remain unapproved.
- The neutral lab scene and repeatable greybox course now exist; game-feel measurements and acceptance are not yet complete.
- No physical Android device QA or safe-area validation.
- No confirmed minimum phone specification or supported orientation policy.
- No renderer selection backed by target-device benchmarks.
- Wall blocking, doorway/corridor clearance and gentle-ramp floor contact now have passing headless probes. Steeper slopes, steps, corners under repeated contact and physical-device collision feel remain unvalidated.
- No measured input-to-motion latency, frame-time, memory, thermal or battery data.

## 3. Primary-source findings

### 3.1 Touch-camera scaling

Godot 4.7's `InputEventScreenDrag` reference says:
- `position` is in the viewport coordinate system;
- `relative` is automatically scaled according to the project content-scale factor;
- `screen_relative` is unscaled in screen coordinates and should be preferred for touch aiming across stretch modes.

**Decision:** use `screen_relative` for camera look input, then apply one documented sensitivity scale in the player controller. Do not compensate with viewport-size-specific multipliers unless device tests demonstrate a need.

### 3.2 Movement vectors and deadzones

Godot's 4.7 controller-input guide recommends `Input.get_vector()` for two-axis movement because it limits vector length to 1 and uses a circular deadzone. The project also has a custom analog joystick adapter with a 0.12 radial deadzone and rescaling. A direct audit of `project.godot` confirms the four movement actions have `deadzone = 0.0`, matching the source comments and avoiding an unintended second deadzone.

**Decision:** retain the current custom radial joystick shaping provisionally. The InputMap movement deadzone is confirmed as 0.0, so the authored 0.12 adapter deadzone is not followed by a second movement-action deadzone. Still test the complete path from joystick displacement through InputMap strengths to the final player vector and record exact values in the lab.

### 3.3 Vector movement response

Godot 4.7 documents `Vector3.move_toward(to, delta)` as moving a vector toward a target by a fixed amount without overshooting. This gives a simple, physics-tick-aware way to apply an acceleration/deceleration budget to the horizontal velocity vector.

**Decision:** use `Vector3.move_toward` provisionally for horizontal velocity. The initial candidate values are 16 m/s² acceleration and 22 m/s² braking for a 4 m/s movement cap. These imply roughly 0.25 s to reach full speed and 0.18 s to brake from full speed in a straight line. They are hypotheses for testing, not final approved game-feel values. The 18-suite CI test checks progressive acceleration, a measurable braking phase, eventual stop and diagonal speed cap; it does not certify human-perceived feel.

### 3.4 CharacterBody3D physics

Godot documents `CharacterBody3D` as a script-controlled character body. `move_and_slide()` uses the body's velocity, should be called from `_physics_process()`, and can modify velocity after collisions. The class exposes floor-related controls such as `floor_max_angle`, `floor_snap_length`, `floor_stop_on_slope`, `floor_constant_speed`, and slide-collision inspection.

**Decision:** keep the player on CharacterBody3D for the first lab. Build a measured test course containing flat ground, controlled ramps, stairs/steps, walls, corners and ledges. Record collision outcomes and floor state. Avoid introducing custom stair logic or extra movement modes until default behaviour is measured.

### 3.5 Android display geometry

Android's official display-cutout guidance explains that cutouts can extend into the display surface and that system bars/navigation areas matter when content is edge-to-edge.

**Decision:** headless viewport geometry is not safe-area certification. Once the target phone is identified, test actual system bars, cutouts/rounded corners where present, gesture navigation, orientation and thumb reach. Keep critical controls clear of unsafe display regions.

### 3.6 Renderer options

Godot 4.7 lists three renderer families:
- **Mobile:** intended for mobile platforms and optimized for mobile GPUs.
- **Compatibility:** supports older/low-end mobile hardware with a less advanced feature set.
- **Forward+:** the advanced desktop-oriented renderer and not the default target for this Android-first project.

Godot's system requirements distinguish Vulkan-capable Mobile/Forward+ from OpenGL ES 3.0 Compatibility support.

**Decision:** Mobile is the leading candidate for a modern Vulkan-capable target; Compatibility remains a fallback candidate if the target hardware requires broader legacy support. This is not a final selection. The phone model, GPU, graphics API support and benchmark evidence are missing.

## 4. Alternatives and trade-offs

| Decision | Option A | Option B | Current recommendation |
|---|---|---|---|
| Touch look delta | Viewport position differencing | Engine-provided unscaled screen delta | B — avoids content-scale-dependent touch sensitivity |
| Player movement | Immediate velocity assignment | Acceleration/deceleration toward a target velocity | Use B as a lab experiment; do not pick final rates before testing |
| Ground collision | CharacterBody3D + move_and_slide | Custom move_and_collide response | Keep CharacterBody3D + move_and_slide as baseline; test alternatives only if the lab exposes a real limitation |
| Renderer | Mobile | Compatibility | Mobile candidate; Compatibility fallback pending device benchmark |
| Safe-area layout | Static viewport margins | Device/system inset-aware layout | Device-aware approach required; exact implementation deferred until target device and Godot API are verified |
| Scope order | Ridgeview first | Neutral lab first | Neutral lab first; Ridgeview only after measured movement/collision/camera gate |

## 5. Neutral movement and physics lab — proposed acceptance course

The lab must be a functional measurement environment, not a production-art scene.

1. **Flat baseline:** marked straight lanes and measured distances for start, acceleration, constant-speed travel, release and stop.
2. **Direction changes:** 90-degree and 180-degree changes to measure turning and momentum response.
3. **Diagonal control:** verify no diagonal speed advantage and consistent normalization.
4. **Ramp set:** gentle, moderate and steep ramps with recorded floor classification and speed behaviour.
5. **Step set:** several low step/ledge heights; document pass/fail rather than silently adding climbing assistance.
6. **Collision set:** isolated wall, inside corner, outside corner, doorway and narrow passage.
7. **Camera set:** open area, wall obstruction, low ceiling, close-follow and pitch-limit checks.
8. **Input interruption:** pause/resume, focus loss, touch release, simultaneous movement/look and Interact ownership.
9. **Repeatability:** run each route with keyboard and touch; record build SHA, engine version, physics settings and tuning parameters.

### Measurements to capture

- input vector and magnitude;
- horizontal velocity over time;
- acceleration and deceleration time;
- stopping distance;
- turn response and yaw error;
- grounded state and floor angle;
- slide collision count and collider;
- camera yaw/pitch and sensitivity;
- frame time and physics tick behaviour;
- test device, resolution, refresh rate and renderer once known.

No numeric target is approved yet. First capture baseline behaviour, then choose values against player feel and device constraints.

## 6. Decision and gate corrections

The previous plan required Gates A–C before Block 0. That sequencing is circular because Gate C requires measured movement and collision work in the neutral lab.

**Corrected rule:**
- Gate A automated input correctness and the preliminary viewport geometry check must pass before the neutral lab is constructed.
- The neutral lab is the first gameplay construction and is the instrument for measuring Gate C.
- Ridgeview greybox construction remains blocked until Gate C has passed with recorded values and no critical control blockers.
- Physical Android Gate D remains mandatory before claiming Android-ready controls.

## 7. Source ledger

All sources below were checked on 2026-11-09. Primary sources take precedence over tutorials, forum opinions and marketing material.

| Source | Type / version | Finding used | Confidence |
|---|---|---|---|
| https://docs.godotengine.org/en/4.7/classes/class_inputeventscreendrag.html | Official Godot 4.7 API | `screen_relative` is unscaled and preferred for touch aiming across stretch modes | High |
| https://docs.godotengine.org/en/4.7/tutorials/inputs/controllers_gamepads_joysticks.html | Official Godot 4.7 guide | `Input.get_vector()` supports circular deadzone and unit-length limiting | High |
| https://docs.godotengine.org/en/4.7/classes/class_characterbody3d.html | Official Godot 4.7 API | CharacterBody3D movement, floor properties and collision behaviour | High |
| https://docs.godotengine.org/en/4.7/classes/class_vector3.html | Official Godot 4.7 API | Fixed-distance `Vector3.move_toward` for movement response | High |
| https://docs.godotengine.org/en/4.7/about/list_of_features.html | Official Godot 4.7 feature matrix | Renderer positioning and platform targets | High |
| https://docs.godotengine.org/en/4.7/about/system_requirements.html | Official Godot 4.7 requirements | Mobile GPU/API compatibility distinctions | High |
| https://developer.android.com/develop/ui/views/layout/display-cutout | Official Android developer guidance | Display cutouts and edge-to-edge safe layout considerations | High |

### Research map status

- **Project source, scenes, tests, CI and governance docs:** searched and inspected.
- **Official Godot 4.7 documentation:** searched for the input, physics, renderer and requirements topics above.
- **Official Android display-cutout guidance:** searched.
- **Independent academic research and third-party game postmortems:** not yet searched; not necessary to establish the API correction, but still needed for later game-feel/art-production deep dives.
- **Godot issue tracker, Android device-specific reports and community discussions:** not yet searched; schedule after the target phone and renderer candidate are known.
- **Physical device, Android export and profiling:** blocked; target phone model and exportable build are not yet verified.
- **Renderer benchmark and asset pipeline:** not yet executed; defer until device identification and representative lab/benchmark scene.

## 8. Risks and follow-up

| Risk | Impact | Mitigation / next evidence |
|---|---|---|
| Touch look sensitivity varies by stretch mode | Camera feels inconsistent across screens | Use screen_relative; run viewport and device tests |
| Double deadzone or strength remapping | Low joystick input feels unresponsive | Inspect InputMap deadzones and measure complete input path |
| Immediate velocity changes feel abrupt | Poor traversal feel and stopping control | Compare acceleration/braking curves in the neutral lab |
| Slopes/steps behave unpredictably | Player catches, slides or appears to float | Measured ramp/step course with recorded CharacterBody3D settings |
| Renderer unsupported or too costly | Startup failure or poor performance | Identify GPU/API; benchmark Mobile and Compatibility |
| Unsafe touch placement | Accidental touches or blocked controls | Physical safe-area and ergonomic validation |

## 9. Current decision status

- **CONFIRMED:** 19-suite Godot 4.7.2 CI passed on commit `c9dbe133891febdc76d7e93cfdaf85b2d3702710`.
- **CONFIRMED:** current controller directly assigns horizontal target velocity; acceleration/braking tuning is absent.
- **CONFIRMED:** Godot 4.7 recommends unscaled screen-relative deltas for touch aiming across stretch modes.
- **COMPLETED:** touch look now uses `screen_relative`; viewport and lifecycle-related regression tests pass.
- **COMPLETED:** neutral movement/physics lab scene, test course and telemetry are constructed and pass the lab acceptance suite.
- **IMPLEMENTED / TESTED:** provisional 16 m/s² acceleration and 22 m/s² braking response passes the automated motion-envelope test.
- **TESTED:** wall blocking, 1.4 m doorway passage, narrow corridor passage and gentle-ramp floor contact pass headless probes.
- **IN PROGRESS:** Gate C measurement and movement-feel tuning in the lab, including steep ramps, steps, camera obstruction and broader collision cases.
- **UNKNOWN:** final acceleration, braking, turning, slope, step and camera sensitivity values.
- **UNKNOWN:** minimum Android device, GPU/API support and renderer choice.
- **BLOCKED:** physical Android safe-area, ergonomics and performance validation.
- **NOT STARTED:** Ridgeview blockout.
