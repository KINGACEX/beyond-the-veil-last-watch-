# BTV Cross-Agent Handoff XH-001 — MiniMax Code Review

**Prepared by:** MiniMax Code (Implementation Agent)
**Date:** 2026-11-08
**Task:** XH-001 — review the completed M2 touch-control implementation; assess Android export readiness
**Returned to:** ChatGPT (Lead Coordinator), creator-mediated copy/paste (per handoff §1 — no direct agent-to-agent channel exists)

---

## Section 5 — Required response format

```text
Task: XH-001
Platform/client: MiniMax Code (cloud session, MiniMax Code CLI/runtime; agent id Mavis, session 460954906607848)
Agent role: Implementation Agent (Godot engineering, implementation, testing, technical verification)
Acknowledged: YES
Repository access: VERIFIED — public clone succeeded; read-only inspection of branch btv/mobile-touch-input-adapter-001
Branch and commit inspected: btv/mobile-touch-input-adapter-001 @ 3484672809ad95e4e36591e7ca7d49d5f61dfd5e
  (verified 26 commits ahead of btv/test-first-contracts-001, 0 behind; base M1 de2cb1d29f81a011ddb5319e6c32d95ac3418e45)
  Coordinator branch read for documents: btv/project-history-and-lore-bridge-001 @ 1ba1c5a3e07152a9cd76fa050917c096a740f1d3
Files inspected: scripts/touch_input_adapter.gd, scripts/touch_controls.gd, scripts/player_controller.gd,
  scenes/touch_controls.tscn, scenes/main.tscn, scenes/player.tscn, project.godot, .gitignore,
  tests/touch_input_adapter_test.gd, tests/touch_controls_integration_test.gd,
  .github/workflows/godot-validation.yml,
  docs/agents/MINIMAX_CODE_IMPLEMENTATION_CHARTER_v1.0.md, docs/agents/BTV_AGENT_TASK_AND_HANDOFF_PROTOCOL_v1.0.md,
  docs/agents/BTV_GITHUB_MCP_AND_BRANCH_RULES_v1.0.md, docs/agents/BTV_AGENT_ACTIVITY_LOG.md,
  docs/agents/BTV_SHARED_DECISION_LOG.md, docs/implementation/BTV_M2_TOUCH_INPUT_ADAPTER_2026-11-08.md
Findings (severity + exact evidence): see "Detailed findings" below — 0 CRITICAL, 3 HIGH, 4 MEDIUM, 6 LOW
Tests/reviews actually performed: see "Tests actually performed" — 7/7 CI suites re-run locally on Godot 4.7.2 headless (all PASS),
  plus 23 probe assertions across 3 purpose-written probe scripts (run in a scratch copy)
PASS / FAIL / NOT TESTED:
  PASS — M2 adapter + HUD unit/integration behaviour as claimed, on Godot 4.7.2 headless (reproduced CI run 42500466981 locally)
  FAIL — Android export readiness: 3 HIGH defects confirmed that are Android-specific (HUD geometry/safe area,
         resolution-dependent look sensitivity, unhandled Android backgrounding)
  NOT TESTED — physical Android device behaviour (multitouch hardware, latency, thumb reach, orientation change,
         safe-area insets, frame pacing, thermal/memory), Android export/APK build, signing
Known limitations: this sandbox has no physical Android device, no emulator and no Android SDK/export templates.
  Claude coordination BLOCKED — Claude Code CLI 2.1.319 is installed but `claude auth status` returns loggedIn: false,
  and `codex login status` returns "Not logged in"; no message was sent to Claude and none is claimed.
  No physical-device claim is made anywhere in this report.
Changes made: NONE to the repository. Reviewed checkout restored to pristine state after testing
  (`git status --porcelain` = 0 entries, HEAD unchanged). Probe scripts were written to a separate scratch copy
  (/workspace/xh-001/probe-copy), never to the branch.
Cost/credits: ZERO — no paid API, no credit spend, no external service invoked. No MCP configuration was altered.
Recommended next action: XH-002 — "Touch input lifecycle and analog-composition hardening" (bounded, headless-verifiable);
  the HUD visual/safe-area redesign is deliberately deferred to Claude's brief + creator device decision.
Creator decision required: (1) approve or amend XH-002 scope; (2) select the Android application/package identifier
  (NOT selected by me); (3) decide the renderer/device target that precedes any export configuration;
  (4) confirm whether Claude should be given a signed-in session so visual concerns can actually be exchanged.
```

---

## Detailed findings

No **CRITICAL** defect was found: no crash, no data loss, no corruption path was reproduced.

### HIGH-1 — Camera look silently dies when the player is not yet present or is replaced
- `scripts/touch_controls.gd:33` — `var _player: BTVPlayerController` is resolved **once** in `_ready()`
  via `get_tree().get_first_node_in_group("btv_player")`. There is no re-resolution path.
- `scripts/touch_controls.gd:98-99` — the only guard is `_player != null`.
- **Probe evidence (`probe_lifecycle.gd`, scratch copy):**
  - Touch layer added before the player → `_player == null` → *the camera does not rotate* (asserted and confirmed).
  - Player destroyed while the HUD persists → the cached reference is a **freed instance**; in Godot 4 a freed
    instance compares equal to `null`, so the `!= null` guard silently suppresses the call and look stops working
    rather than raising a visible error.
- **Current impact:** `scenes/main.tscn` instantiates `Player` **before** `TouchControls`, so the shipped scene
  works today. This is latent, and becomes a live bug on player respawn, player swap, or any scene where the HUD
  is instantiated first.

### HIGH-2 — Fixed-pixel HUD geometry with no safe-area handling (Android blocker)
- `scenes/touch_controls.tscn:87-99` — `JoystickBase` is a fixed 200×200 px panel, 24 px from the left/bottom edges.
- `scenes/touch_controls.tscn:123-135` — `Interact` is a fixed 140×88 px button, 24 px from the right/bottom edges.
- **No safe-area handling exists** — source search over `scripts/` and `scenes/` returns only two `DisplayServer`
  uses (`is_touchscreen_available()`), and **zero** references to `get_display_safe_area` / `safe_area`.
- **Probe evidence (`probe_lifecycle.gd`):** at a 1920×1080 viewport the joystick occupies **10.4 % of viewport width**
  and remains 200 px regardless of screen size; the overlay itself does resize correctly
  (1280×720 → 1920×1080 confirmed), so the *overlay* is responsive while the *controls inside it* are not.
- On a real handset the bottom 24 px band is where the Android gesture/navigation bar sits, so the Interact
  button's lower edge and the joystick's lower edge are the elements most likely to be covered or clipped.

### HIGH-3 — Camera-look sensitivity is resolution-dependent (Android blocker)
- `scripts/touch_controls.gd:97-99` — raw screen-pixel deltas are forwarded:
  `_player.call("_apply_look_delta", look_delta)`.
- `scripts/player_controller.gd:63-65` — `_apply_look_delta` multiplies by
  `look_sensitivity_degrees_per_pixel` (0.12), a **per-pixel** constant.
- Movement is resolution-independent (the adapter normalises to a unit circle), but look is not: the same physical
  finger swipe covers more pixels on a denser screen, so the camera turns further per centimetre of thumb travel
  on one device than another. The value is also shared with the desktop mouse path, so there is no separate
  touch-sensitivity control.

### MEDIUM-1 — The authored joystick deadzone is not the effective one; the analog curve is compressed twice
- `scripts/touch_input_adapter.gd:8` — `var deadzone: float = 0.12`.
- `project.godot` — every movement action declares `"deadzone": 0.2`.
- `scripts/player_controller.gd:31` — `Input.get_vector("move_left", "move_right", "move_forward", "move_back")`,
  which applies the **InputMap** deadzone on top of the adapter's already-rescaled output.
- **Probe evidence (`probe_composition.gd`):**
  - Adapter deadzone 0.12 vs InputMap deadzone 0.20 — they differ.
  - Action strength 0.15 → the action reports **pressed** while the player's input vector is **zero**.
  - Action strength 0.50 → the player's input vector magnitude is **0.375**, not 0.5 (Godot rescales by
    `(len - deadzone) / (len * (1 - deadzone))`, so the deadzone is applied twice).
- The repository test only asserts a **full-scale** drag (`> 0.95`) and a zero drag, so CI cannot see the curve.

### MEDIUM-2 — Touch release and focus loss cancel actions held by other input sources
- `scripts/touch_controls.gd:135` — `_set_action_strength` calls `Input.action_release(action_name)` whenever
  strength ≤ 0.001, regardless of who else is holding that action.
- `scripts/touch_controls.gd:155-158` — `_release_all_actions()` releases **all five** actions in `ACTIONS`
  (including `interact`).
- **Probe evidence (`probe_composition.gd`):** a held `move_forward` is **cancelled** by a joystick release, and a
  held `interact` is **cleared** by `NOTIFICATION_APPLICATION_FOCUS_OUT`.
- Latent on a touch-only Android build; live for any desktop/Chromebook/emulator use and for the stated
  "shared InputMap" design.

### MEDIUM-3 — Android backgrounding is not handled
- `scripts/touch_controls.gd:168-170` handles `NOTIFICATION_APPLICATION_FOCUS_OUT` only.
  **Source check confirms `NOTIFICATION_APPLICATION_PAUSED` is absent.**
- On Android, pausing/backgrounding is the canonical notification; if it is not delivered as focus-out, finger
  ownership and movement strengths can survive into the next resume.
- **Labelled NOT TESTED on device** — the exact Android notification sequence was not reproduced here.

### MEDIUM-4 — A hidden overlay still consumes touches and drives the player
- `scripts/touch_controls.gd:29` — `visible = DisplayServer.is_touchscreen_available()`.
- `scripts/touch_controls.gd:55-61` — `_input()` does **not** check visibility.
- **Probe evidence (`probe_input_path.gd`):** with the overlay hidden (the state on any device reporting no
  touchscreen), a joystick drag still drives `move_right` to full strength — invisible feedback — and the touch is
  consumed from the game via `set_input_as_handled()`.

### LOW findings
1. **`scripts/touch_controls.gd:99`** — `_player.call("_apply_look_delta", ...)` is an untyped, string-based call to a
   private method; no compile-time protection if the controller is refactored.
2. **Scene/script conflict** — `scenes/touch_controls.tscn:31-37` authors the Overlay as a full-rect anchor
   (`anchors_preset = 15`), but `scripts/touch_controls.gd:44-50` forces all anchors to `0.0` and assigns `size`
   explicitly. Behaviour is equivalent today; the authored anchors are misleading and would break under a
   stretch/content-scale configuration.
3. **`.uid` files are not version-controlled** — 0 of 136 tracked files are `.uid`, but Godot 4.7 generates one per
   script; my own headless import produced 20 untracked `.uid` files in the reviewed checkout (since removed).
   Every checkout will regenerate them, producing noise and merge friction.
4. **Handoff source paths mix branches** — the "Read:" list names `docs/agents/MINIMAX_CODE_IMPLEMENTATION_CHARTER_v1.0.md`,
   `docs/agents/BTV_AGENT_TASK_AND_HANDOFF_PROTOCOL_v1.0.md` and `docs/implementation/BTV_M2_TOUCH_INPUT_ADAPTER_2026-11-08.md`,
   which exist **only on the coordinator branch**; they are absent from the M2 branch. An agent following the list
   from the M2 branch cannot open them (I read them from `origin/btv/project-history-and-lore-bridge-001`).
5. **M2 report overstates coverage** — it states the integration suite "verifies movement action strengths" and that
   the 1280×720 viewport is "the project's configured landscape logical size". `project.godot` configures **no**
   `window/stretch/mode`, so the default (disabled) applies and on Android the viewport equals the device
   resolution — 1280×720 is a desktop window size, not a mobile logical size. The strength claim is only true at
   full deflection (see MEDIUM-1).
6. **Activity log duplication** — `ACT-MA-020` appears twice with different wording, and `ACT-MA-019` cites head
   `9151e92f…` (a genuine ancestor — verified) while reusing the same report filename as the later integrated
   milestone, so the report file no longer describes the adapter-only state.

---

## Do the tests actually prove the claimed behaviours?

| Claim (handoff / M2 report) | Proved by repo tests? | Proved by my probes? | Verdict |
|---|---|---|---|
| Adapter rejects invalid IDs / duplicate ownership / one finger owning both | Yes — `touch_input_adapter_test.gd:35-94` | — | **PROVEN** |
| Movement clamped to unit circle, deadzone applied | Partly — adapter-level only (`touch_input_adapter_test.gd:50-67`) | — | **PROVEN at adapter level only**; effective in-game deadzone differs (MEDIUM-1) |
| Independent movement and look fingers | Yes — `touch_controls_integration_test.gd:89-110` | — | **PROVEN** |
| Movement release clears the action | Yes — `touch_controls_integration_test.gd:84-85` | — | **PROVEN** (full scale only) |
| Interact area excluded from camera look | Yes — `touch_controls_integration_test.gd:113-128` | Yes | **PROVEN**; additionally the button **does** fire `interact` through the real path (untested by the repo) |
| Focus loss releases input | Yes — `touch_controls_integration_test.gd:131-142` | Yes | **PROVEN**, but it also clears unrelated held actions (MEDIUM-2) |
| Scene teardown releases input | Yes — `touch_controls_integration_test.gd:145-160` | — | **PROVEN** |
| Legacy D-pad fallback available | Visibility only — `touch_controls_integration_test.gd:163-174` | — | **WEAKLY PROVEN**; no assertion that the pad buttons drive movement |
| HUD responds to viewport-size changes | **No test exists** | Yes — overlay resized 1280×720 → 1920×1080 | **TRUE but untested in CI** |
| Touch events reach the HUD as claimed | **No** — the suite calls `overlay.call("_input", event)` directly, bypassing viewport routing, GUI dispatch and `set_input_as_handled()` | Yes — `root.push_input()` drives the joystick and the Interact button correctly | **TRUE, and the real path works — but the repo never exercises it** |
| Physical Android multitouch, latency, thumb reach, safe areas, orientation, frame pacing | No | No | **NOT TESTED** (agrees with the report's own boundary) |

**Missing tests (bounded, headless-verifiable):**
1. Real input path via `root.push_input()` (viewport → `_input` → GUI → `_unhandled_input`) — replaces direct `_input` calls.
2. Interact button **fires** the action (the repo asserts only that look is *not* started).
3. Viewport resize of the overlay and continued joystick usability.
4. Mid-range analog strength → player input mapping (would have caught MEDIUM-1).
5. HUD geometry at phone viewports (2400×1080 landscape, 1080×2400 portrait) with safe-area insets.
6. Player-not-yet-present and player-replaced ordering (would have caught HIGH-1).
7. `NOTIFICATION_APPLICATION_PAUSED` handling.
8. Touch + keyboard action coexistence (would have caught MEDIUM-2).
9. Finger-index reuse after release; a second finger on the joystick at HUD level; a touch outside both surfaces.
10. Legacy D-pad buttons actually driving the movement actions.

---

## Android export prerequisites (establishable without selecting an application ID)

**Verified facts:**
- **No `export_presets.cfg` exists on any of the 10 branches** (checked with `git ls-tree` across all refs).
- **The CI workflow performs headless validation only** — no Android job — and the engine step uses
  `include-templates: false`, so **export templates are not even installed in CI today**
  (`.github/workflows/godot-validation.yml:28-33`). Any export job must install templates first.
- **No application identifier is configured** — `project.godot` has no `application/config/package_name` and no
  `application/config/name` override beyond the display name. I did not select one.
- **No Android-specific project settings exist** — no `display/handheld/orientation`, no
  `input_devices/pointing/emulate_touch_from_mouse`, and the renderer is explicitly left open:
  `project.godot` header states *"renderer intentionally left undecided pending device comparison"*.
  That decision gates the export and is a creator/Visual-Director call, not mine.
- The engine version is pinned in CI to **4.7.2** and the exporter must match exactly.

**Prerequisites that can be established without an ID or credentials:**
1. Install Godot **4.7.2 export templates** in the CI image (`include-templates: true`).
2. Install **JDK 17** and the **Android SDK build-tools** version required by Godot 4.7.2, plus licence acceptance
   in CI. (Not present in the current workflow.)
3. Add a **debug-only** Android export job that runs `godot --headless --export-debug "Android" <out.apk>` against a
   preset that the creator has approved.
4. Decide the **renderer** (forward_plus vs gl_compatibility vs mobile) — the project.godot comment shows this is
   deliberately open pending a device comparison.
5. Decide **orientation policy** and whether the HUD should be laid out for landscape only, portrait, or both
   (HIGH-2 is a landscape/pixel-geometry question).
6. Keep signing entirely out of the repository: the creator supplies the keystore via CI secrets; no keystore,
   password or keystore path is ever committed.
7. Once a build exists, the device evidence list Claude's assignment asks for becomes obtainable: real multitouch,
   safe-area insets, orientation change, latency, frame pacing, memory and thermal behaviour.

**Explicitly not done by me:** no preset created, no application ID chosen, no signing configured, no secrets
requested or stored, no APK built, no CI workflow changed, no branch created, no commit, no merge, no publish.

---

## Proposed next engineering task (minimal, bounded)

**XH-002 — Touch input lifecycle and analog-composition hardening**
*(Proposed. Not started. Requires creator approval and ChatGPT's brief.)*

Scope — one feature branch, four small changes, no visual redesign:
1. Resolve the player defensively (`is_instance_valid` + re-query on demand) instead of once in `_ready()`.
2. Make the analog deadzone single-sourced, so the authored value is the effective one, and remove the
   double-rescale between the adapter and `Input.get_vector`.
3. Stop touch releases from cancelling actions held by another input source.
4. Handle `NOTIFICATION_APPLICATION_PAUSED` alongside focus-out.

Acceptance tests (all headless, Godot 4.7.2, CI-visible):
- `tests/touch_controls_lifecycle_test.gd` — player absent at HUD creation, then present → look begins working;
  player replaced → look continues against the new instance; no engine errors in either case.
- `tests/touch_controls_composition_test.gd` — action strength 0.15 → player input zero **and** action released;
  strength 0.50 → player input 0.50 (±0.01); full deflection → 1.0; diagonal 45° → magnitude ≤ 1.0.
- `tests/touch_controls_coexistence_test.gd` — a keyboard-held action survives a touch release and a focus loss.
- `tests/touch_controls_resize_test.gd` — viewport 1280×720 → 2400×1080 → 1080×2400: overlay tracks the viewport
  and the joystick centre/containment tests still hold.
- `tests/touch_controls_input_path_test.gd` — events pushed through `root.push_input()` (not `call("_input", …)`)
  drive the joystick, and the Interact button fires `interact`.
- Existing suites must stay green: all 7 CI scripts + the 10-frame main-scene launch.

**Deliberately deferred (not in XH-002):** HUD layout, safe-area insets, responsive/density-independent control
sizing and look-sensitivity scaling (HIGH-2 / HIGH-3). These need Claude's visual brief and the creator's device
and renderer decisions first; redesigning them unilaterally would preempt the Visual Director's assignment.

---

## Coordination and disclosures

1. **Claude coordination — BLOCKED, no message sent.** Claude Code CLI 2.1.319 is installed in this sandbox, but
   `claude auth status` reports `"loggedIn": false`, and `codex login status` reports "Not logged in". There is no
   authenticated session, so **no cross-agent message was sent and none is claimed**. Visual/usability concerns below
   are therefore **my own engineering observations**, not Claude's position, and are labelled as such:
   - The Interact button sits inside the camera-look region, so the exclusion at `touch_controls.gd:73` is doing
     real work — but the exclusion is a **rectangle test**, not a shape/visual test, and it depends on the button's
     fixed offsets (HIGH-2).
   - The look surface covers the entire right half of the viewport including the button band — correct in
     principle, but on a narrow/portrait layout the two regions may collide.
   - The joystick base is 200 px with a 42 px corner radius and a 84 px knob (`touch_controls.tscn:5-27, 87-108`),
     i.e. a fixed-pixel circular design that does not scale with density.
2. **No MCP configuration was altered** during this task, per the restriction. For transparency: this sandbox
   already contained a separate **BTV Lore Bridge** MCP registration (Claude Code user scope + Codex) created in
   earlier sessions, before XH-001 and unrelated to the BTV repository. It was left untouched. Its corpus contains
   only my synthetic test fixture and the BTV *scaffolding* I authored — **no ChatGPT export, no private lore, no
   credentials**. DEC-MA-007 treats that bridge as needing a safety/privacy remediation pass before real client
   registration; that is the creator's and coordinator's call, and I have made no change either way.
3. **Reviewed branch left pristine.** All local test execution ran in `/workspace/xh-001/review-clone`; the
   Godot-generated `.uid` files and `.godot/` cache were removed afterwards. Final state:
   `git status --porcelain` → 0 entries, `HEAD` → `3484672809ad95e4e36591e7ca7d49d5f61dfd5e`.
4. **Probe scripts are evidence, not project files.** They live in `/workspace/xh-001/probe-copy/` (a copy of the
   branch) and are attached to this report so the coordinator can reproduce every empirical claim above.

---

## Tests actually performed (exact commands)

Godot 4.7.2 stable (`/workspace/.tools/godot`, `4.7.2.stable.official.ed1daf0bf`), headless, in a read-only clone:

| Command | Result |
|---|---|
| `git clone --branch btv/mobile-touch-input-adapter-001 --single-branch <repo> review-clone` | exit 0, HEAD `3484672` |
| `godot --headless --editor --path . --quit` | exit 0 |
| `godot --headless --path . --script res://tests/nli_smoke_test.gd` | PASS (exit 0) |
| `godot --headless --path . --script res://tests/nli_contract_test.gd` | PASS (exit 0) |
| `godot --headless --path . --script res://tests/mission_data_validator_test.gd` | PASS (exit 0) |
| `godot --headless --path . --script res://tests/core_interaction_acceptance_test.gd` | PASS (exit 0) |
| `godot --headless --path . --script res://tests/player_camera_input_test.gd` | PASS (exit 0) — note it **skips** the desktop pointer-focus case without a desktop window |
| `godot --headless --path . --script res://tests/touch_input_adapter_test.gd` | PASS (exit 0) |
| `godot --headless --path . --script res://tests/touch_controls_integration_test.gd` | PASS (exit 0) |
| `godot --headless --path . --quit-after 10` (main scene) | exit 0 |
| `node`-style probes (scratch copy): `probe_input_path.gd`, `probe_composition.gd`, `probe_lifecycle.gd` | 23 assertions; 21 PASS, 2 FAIL — **both failures are confirmed defects** (MEDIUM-2 keyboard/release stomping, MEDIUM-1 double-deadzone curve), and one of my own hypotheses was corrected by the probe (freed-player → silent look loss, not an engine error) |

**This independently reproduces CI run 42500466981's stated results on the same engine version.**
