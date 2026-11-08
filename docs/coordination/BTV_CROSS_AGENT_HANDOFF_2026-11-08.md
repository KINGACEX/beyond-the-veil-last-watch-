# BTV Cross-Agent Handoff — 8 November 2026

**Task ID:** XH-001  
**Status:** READY FOR EXTERNAL ACKNOWLEDGEMENT — NOT YET ACKNOWLEDGED BY CLAUDE OR MINIMAX  
**Coordinator:** ChatGPT — Lead Coordinator  
**Creator authority:** KINGACEX (user) retains final authority  
**Purpose:** Give MiniMax Code, Claude and ChatGPT one shared, evidence-based project state and one bounded review task.

## 1. Important connection status

The repository contains role charters and a handoff protocol. Those documents do **not** prove that Claude, MiniMax Code, Claude mobile, Claude Code or any MCP client is connected or can read this repository.

Each platform must independently confirm:
- which product/client is being used (for example MiniMax Code, Claude mobile or Claude Code);
- whether the repository can actually be read;
- whether it can create a branch or commit (do not test write access unless explicitly assigned);
- which tools and permissions are available;
- whether this handoff was read successfully.

Do not claim that one agent sent a message to another unless a real message/action result exists. Until verified, coordination is by this shared repository document and creator-mediated copy/paste.

## 2. Authority and safety rules

1. The creator has final authority over canon, creative direction, scope and consequential actions.
2. ChatGPT is Lead Coordinator and independent reviewer.
3. Claude is Visual Director.
4. MiniMax Code is Implementation Agent.
5. Work from source documents and exact branch/commit references; inspect before editing.
6. No deleting files, rewriting history, force-pushing, changing GitHub security settings, merging, publishing, deploying, purchasing or spending credits without explicit creator approval.
7. Do not commit credentials, tokens, private exports or personal information.
8. Separate CONFIRMED, PROPOSED, OPEN, BLOCKED and UNKNOWN. A plan or code presence is not proof of runtime success.
9. No agent may promote a proposal to canon.
10. Do not claim Android readiness from headless CI.

## 3. Current verified engineering state

### M1 — Camera-relative movement and desktop mouse-look

- Branch: `btv/camera-relative-mouselook-001`
- Head: `de2cb1d29f81a011ddb5319e6c32d95ac3418e45`
- Report: `docs/implementation/BTV_M1_CAMERA_RELATIVE_MOUSE_LOOK_IMPLEMENTATION_2026-11-08.md`
- CI: [Run 42499393434](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42499393434) — passed on Godot 4.7.2.
- Includes camera-relative horizontal movement, diagonal normalization, camera yaw independent of player-body facing, pitch limits, desktop mouse-look, click capture, Escape release and focus-loss pointer release.
- Actual windowed desktop pointer behaviour remains unverified because CI is headless.

### M2 — Integrated Android touch controls

- Branch: `btv/mobile-touch-input-adapter-001`
- Base: M1 head `de2cb1d29f81a011ddb5319e6c32d95ac3418e45`
- Head: `3484672809ad95e4e36591e7ca7d49d5f61dfd5e`
- Report: `docs/implementation/BTV_M2_TOUCH_INPUT_ADAPTER_2026-11-08.md`
- CI: [Run 42500466981](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42500466981) — completed successfully on Godot 4.7.2.
- The successful job ran editor import/parsing, NLI smoke and contract tests, mission validator tests, core interaction acceptance tests, camera input tests, touch adapter tests, touch-control integration tests and a 10-frame main-scene launch.
- Touch HUD includes a left analog joystick, independent right-side camera-look surface, Interact exclusion, independent movement/look finger ownership, shared InputMap movement actions, focus-loss and scene-teardown cleanup, viewport resize handling and a legacy directional-pad fallback.
- Automated integration tests cover simultaneous movement/look, action release, Interact-area exclusion, focus loss, teardown and fallback.
- **Not verified:** physical Android multitouch, thumb reach, safe areas, orientation changes, latency, sensitivity, visual readability, frame pacing, memory, thermal behaviour or device performance.

The M2 branch is 26 commits ahead of `btv/test-first-contracts-001` and includes the M1 changes. It remains isolated and unmerged. Do not merge it as part of this task.

### Android export blocker

The inspected M2 branch has no `export_presets.cfg` and the CI workflow has no Android export job. A package/application identifier has not been selected. No identifier, signing configuration or export preset may be invented or silently committed. The creator must decide the package identifier before a real Android debug APK pipeline is configured. Never request or store signing passwords or private keystores in the repository.

## 4. Shared task XH-001

**Objective:** Independently review the completed M2 touch-control implementation and prepare the project for a safe, creator-approved Android export decision. This is a review and planning task first; it does not authorize implementation, merge or export.

### Assignment A — MiniMax Code (Implementation Agent)

**Requested work: code review and export-readiness assessment only.**

Read:
- `docs/agents/MINIMAX_CODE_IMPLEMENTATION_CHARTER_v1.0.md`
- `docs/agents/BTV_AGENT_TASK_AND_HANDOFF_PROTOCOL_v1.0.md`
- `docs/implementation/BTV_M2_TOUCH_INPUT_ADAPTER_2026-11-08.md`
- `scripts/touch_input_adapter.gd`
- `scripts/touch_controls.gd`
- `scenes/touch_controls.tscn`
- `tests/touch_input_adapter_test.gd`
- `tests/touch_controls_integration_test.gd`
- `.github/workflows/godot-validation.yml`

Return:
1. Findings ranked Critical / High / Medium / Low, with exact path and line or function.
2. Whether the current test cases actually prove each claimed behaviour.
3. Potential defects in finger ownership, action-strength composition, input cancellation, viewport changes, Interact exclusion, player lookup and teardown.
4. Android export prerequisites that can be established without selecting an application ID or touching signing credentials.
5. A minimal proposed next engineering task and acceptance tests.

**Do not modify files in this first review.** Do not create export presets, choose an application ID, add secrets, install dependencies, alter client configuration, or spend credits. If repository access is unavailable, state that and work only from the supplied paths/content; do not imply a live repo review.

### Assignment B — Claude (Visual Director)

**Requested work: visual and usability review only.**

Read:
- `docs/agents/CLAUDE_VISUAL_DIRECTOR_CHARTER_v1.0.md`
- `docs/agents/BTV_AGENT_TASK_AND_HANDOFF_PROTOCOL_v1.0.md`
- `docs/visual/BTV_VISUAL_PRODUCTION_QUALITY_STANDARD_v1.0.md`
- `docs/source-of-truth/visual/BTV_Foundation_12_Visual_UI_HUD_Bible_v1.1_Consistency_Lock.md`
- `scenes/touch_controls.tscn`
- `scripts/touch_controls.gd`
- `docs/implementation/BTV_M2_TOUCH_INPUT_ADAPTER_2026-11-08.md`

Return:
1. A source-based review of joystick, camera-look region and Interact-button placement.
2. Risks for thumb reach, accidental touches, visual hierarchy, opacity/contrast, safe areas and orientation changes.
3. A proposed responsive HUD layout specification with measurable criteria, labelled PROPOSED.
4. A screenshot/device evidence list needed before approving the visual layout.

Do not invent Asher/Ember visuals, change canon, generate assets, spend credits or claim to have inspected a live build. The current repository source can be reviewed, but no physical-device screenshot is supplied in this task.

### Assignment C — ChatGPT (Lead Coordinator)

- Verify the returned findings against repository sources and CI evidence.
- Resolve disagreements by preserving each claim and its evidence; do not manufacture consensus.
- Convert accepted recommendations into one bounded implementation brief.
- Keep Android export blocked until the creator selects an application ID and the target-device/export requirements are known.
- Update the progress register, activity log and next execution plan only when new evidence exists.

## 5. Required response format for every agent

Return this exact structure:

```text
Task: XH-001
Platform/client:
Agent role:
Acknowledged: YES / NO
Repository access: VERIFIED / NOT VERIFIED
Branch and commit inspected:
Files inspected:
Findings (severity + exact evidence):
Tests/reviews actually performed:
PASS / FAIL / NOT TESTED:
Known limitations:
Changes made: NONE (unless separately authorized)
Cost/credits: ZERO / AMOUNT / UNKNOWN
Recommended next action:
Creator decision required:
```

If an agent cannot access the repository, it must say so and request the relevant files or use this handoff as supplied context. It must not fabricate branch inspection.

## 6. Copy/paste dispatch message

Send the following message separately to MiniMax Code and Claude. A shared repository file does not automatically deliver a notification.

> Read `docs/coordination/BTV_CROSS_AGENT_HANDOFF_2026-11-08.md` on branch `btv/project-history-and-lore-bridge-001`. This is task XH-001. First acknowledge your platform/client and whether repository access is genuinely working. Follow only the assignment for your role. This first pass is review/planning only: make no repository changes, do not choose an Android application ID, do not configure signing, do not change MCP/client settings, and do not spend credits. Return the exact response structure in Section 5, with evidence and explicit NOT TESTED labels. Do not claim communication with another agent unless it actually occurred. The creator retains final authority.

## 7. Exit criteria

XH-001 is complete only when:
- MiniMax's acknowledgement and review are received, or its access blocker is explicitly recorded;
- Claude's acknowledgement and visual review are received, or its access blocker is explicitly recorded;
- ChatGPT has independently checked both reports against source and test evidence;
- all proposed changes remain clearly labelled;
- no unapproved repository, account, export or publication action has occurred.

**Current status:** Handoff document prepared for dispatch. No message has been sent directly to MiniMax or Claude by this document creation. Their acknowledgements and live access remain UNKNOWN.


## 8. ChatGPT initial source scan — not a device review

Before external review, ChatGPT inspected the M2 adapter, HUD scene, integration tests and project configuration on `btv/mobile-touch-input-adapter-001`.

**CONFIRMED from source:**
- `BTVTouchInputAdapter` maintains separate movement and look finger IDs; rejects negative IDs and prevents one finger from owning both controls.
- Movement is clamped to a unit circle and applies a configurable deadzone.
- The HUD routes joystick strengths into the existing movement actions and sends incremental look deltas to the player camera.
- The Interact button rectangle is excluded from camera-look ownership.
- Focus-loss and scene-teardown paths cancel touch ownership and release movement actions.
- The legacy directional pad remains available when `use_analog_touch_controls` is false.
- The HUD responds to viewport-size changes.

**Review risks to test, not confirmed defects:**
- Joystick and Interact controls use fixed pixel offsets and dimensions. No explicit safe-area inset handling is visible in the inspected scene/script.
- The look surface spans the right half of the viewport. Actual overlap, thumb reach and accidental camera movement require device review.
- The integration suite fixes the test viewport at 1280×720; it does not establish behaviour across real device aspect ratios, system bars, cutouts or orientation changes.
- The tests inject synthetic touch events into the overlay's input handler. They do not prove physical touchscreen event delivery, latency or hardware multitouch behaviour.

No defect is declared from this source scan alone. MiniMax and Claude are asked to independently review these risks and provide evidence. Physical Android validation remains NOT TESTED.
