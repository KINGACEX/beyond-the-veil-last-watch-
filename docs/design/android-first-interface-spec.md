# Android-First Interface Specification

**Version:** 0.1  
**Status:** Approved design direction; device validation pending  
**Target:** Roblox mobile, Android-first

## 1. Design goals

- Keep movement and camera control immediately accessible.
- Keep mission context and companion commands discoverable without covering the play space.
- Support readable dialogue and investigation on phone-sized screens.
- Respect device safe areas, variable aspect ratios and touch interaction.
- Minimize HUD clutter and avoid requiring precision taps.

## 2. Proposed control layout

- **Lower-left:** movement joystick.
- **Right-side gesture area:** camera control.
- **Right-side contextual region:** interaction prompt and primary action.
- **Journal access:** persistent, compact entry point that does not cover movement.
- **Ember commands:** compact radial, drawer or contextual panel; only show commands supported by the current build.
- **Dialogue:** centered or lower-screen panel with readable text and clearly separated response choices.

The exact positions must be adapted to Roblox's actual mobile input behavior and safe-area constraints. This document is not a pixel-perfect layout.

## 3. Screen specifications

### Mission Journal
- Current mission title and concise objective.
- Clear distinction between mandatory and optional objectives.
- Completed objectives remain readable but visually secondary.
- Avoid exposing hidden objectives or spoilers before mission authorization.

### Evidence Board
- Group entries by evidence category.
- Show source attribution and sharing state.
- Keep interpretations visually distinct from observations and testimony.
- Preserve unresolved questions rather than forcing a conclusion.

### Dialogue
- Speaker identity is clear.
- Dialogue text uses comfortable line length and readable contrast.
- Choices are explicit and not hidden behind scrolling.
- Consent choices explain what sharing means.
- Avoid accidental activation from nearby movement controls.

### Ember Commands
- Show only commands available in the current build and encounter.
- Explain the command in concise language.
- Indicate accepted, rejected or unavailable states.
- Prevent repeated taps from issuing duplicate effects.
- Provide a clear cancel or return-to-follow behavior where supported.

## 4. Accessibility and touch requirements

Proposed targets:
- Main touch targets approximately 44–48 logical pixels or larger where practical.
- Adequate spacing between destructive or consequential choices.
- Text scaling and layout should not clip at supported device sizes.
- High-contrast text and control states.
- Avoid conveying state through color alone.
- Dialogue and journal content should remain usable in portrait and landscape if both orientations are supported.

These are design targets and must be measured in-device; they are not verified performance results.

## 5. Performance considerations

- Avoid unnecessary per-frame UI work.
- Update journal and command UI from state changes rather than polling.
- Keep effects and animations lightweight.
- Limit simultaneous overlays.
- Use streaming-aware world interactions so distant content does not leave stale prompts.
- Measure on representative low- and mid-range Android hardware.

## 6. Device validation checklist

- [ ] Actual Android phone test completed.
- [ ] Safe-area insets respected.
- [ ] Joystick and camera do not overlap key interaction controls.
- [ ] Dialogue choices can be selected reliably.
- [ ] Evidence Board remains readable.
- [ ] Ember controls do not block movement.
- [ ] UI remains usable at different resolutions and aspect ratios.
- [ ] No critical UI clipping under text scaling.
- [ ] Performance measured during a representative gameplay segment.
- [ ] Two-player mobile session checked where feasible.

## 7. Release boundary

A UI that renders in source or in a desktop preview is not mobile-validated. Mark device behavior UNKNOWN until tested on actual supported Android hardware.
