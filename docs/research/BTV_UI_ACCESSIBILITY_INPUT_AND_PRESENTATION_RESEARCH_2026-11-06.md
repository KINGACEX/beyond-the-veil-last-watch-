# BTV UI ACCESSIBILITY, INPUT CONTEXT AND PRESENTATION RESEARCH
**Date:** 6 November 2026  
**Status:** OFFICIAL GODOT DOCUMENTATION REVIEW; BTV APPLICATIONS ARE PROPOSED  
**Project:** Beyond the Veil: The Last Watch  
**Scope:** UI structure, input focus, mobile/desktop input contexts, accessibility foundations, localization readiness and audio-system boundaries.

## 1. Executive findings

Godot's UI is built from `Control` nodes, with content controls (buttons, labels, text entry) separated conceptually from layout controls (containers, scroll containers, tabs and popups). The engine provides a theme system and explicit focus-navigation mechanisms. Godot 4.7 also documents accessibility improvements, including screen-reader support introduced in 4.5 and landmark navigation in 4.7.

For BTV, these are useful capabilities, not proof that the current prototype is accessible. The current prototype has a touch overlay and keyboard interaction, but there is no verified production HUD, menu, dialogue interface, accessibility settings screen, screen-reader test or physical-device usability result.

## 2. Official engine evidence

### 2.1 UI composition and themes

Godot's UI documentation describes Control nodes as the foundation for GUI composition. It distinguishes content controls from layout controls and documents containers, anchors, themes, fonts and custom controls.

Sources:
- Godot UI overview: https://docs.godotengine.org/en/stable/tutorials/ui/index.html
- Godot 4.7 feature list: https://docs.godotengine.org/en/4.7/about/list_of_features.html

**Evidence:** UI composition can be organized through reusable controls and layout containers rather than positioning every element independently. The feature list also documents Unicode support, CSV/gettext localization, translation contexts, pluralization, bidirectional text and right-to-left UI mirroring.

**BTV application — PROPOSED:** establish reusable UI components and shared theme resources before building the full HUD. Keep text content separate from layout and avoid hard-coded player-facing strings in gameplay logic. Use localization-ready string identifiers even if the first release ships in one language.

### 2.2 Keyboard/controller focus and input contexts

Godot's focus-navigation documentation explains that Control nodes can receive focus, built-in UI actions support focus traversal, and explicit focus-neighbor links make navigation predictable. It warns that focus actions should not be reused as gameplay actions. The engine may guess focus order when explicit neighbors are absent, which can produce unintended paths in complex interfaces.

Sources:
- Godot 4.5 keyboard/controller navigation: https://docs.godotengine.org/en/4.5/tutorials/ui/gui_navigation.html
- Godot current UI overview: https://docs.godotengine.org/en/stable/tutorials/ui/index.html

**BTV application — PROPOSED:** maintain separate gameplay actions and UI-navigation actions. Define an explicit input-context policy for gameplay, menus, dialogue, pause and touch overlays. When a modal UI opens, gameplay input must not accidentally trigger movement or interaction. On close/resume, restore a valid focus target and recalculate nearby interaction selection.

This aligns with the existing interaction acceptance matrix requirements INT-016–INT-018, which remain incompletely automated.

### 2.3 Accessibility support and engine-version caution

Godot 4.7 release notes describe screen-reader support introduced in Godot 4.5 and landmark navigation added in 4.7 to provide context as focus moves through interface regions.

Source:
- Godot 4.7 release notes: https://godotengine.org/releases/4.7/

**Evidence limitation:** the release notes establish engine capability, not that every BTV control will be exposed correctly to assistive technology or that Android screen-reader behavior has been validated for BTV.

**BTV application — PROPOSED:** accessibility requirements should include readable text scaling, clear focus indication, non-color-only status cues, adjustable audio channels, subtitle controls, remappable/alternative input where feasible, and semantic labels/context for interactive controls. Verify actual behavior on supported platforms; do not equate API availability with accessibility conformance.

### 2.4 Audio architecture

Godot's audio documentation is organized around audio buses, effects, audio streams and synchronization of gameplay with sound/music.

Source:
- Godot audio overview: https://docs.godotengine.org/en/stable/tutorials/audio/index.html

**BTV application — PROPOSED:** keep music, ambience, dialogue/voice and sound effects as separately controllable categories where the final mix supports them. Avoid encoding essential mission information only in audio. Provide subtitles or equivalent text for important spoken information and test the mix at low volume and with individual channels muted.

**Not established:** no BTV audio bus layout, sound library, music direction, voice-over scope or mix values are approved or implemented by this research.

### 2.5 Localization and text rendering

Godot 4.7's feature list documents Unicode, CSV/gettext localization, translation contexts, pluralization, bidirectional text shaping and right-to-left UI mirroring.

Source:
- Godot 4.7 feature list: https://docs.godotengine.org/en/4.7/about/list_of_features.html

**BTV application — PROPOSED:** keep source dialogue, subtitles, objective text and UI labels in a localization-friendly data layer. Avoid concatenating sentence fragments where word order differs between languages. Test longer translated strings, line wrapping, font fallback and right-to-left layouts before content volume grows.

## 3. BTV-specific design constraints

The following are project constraints, not new canon:
- Preserve the established restrained white-and-gold visual direction; accessibility states must remain legible and not depend on gold/white contrast alone.
- Do not make Scripture, prayer, Communion or faith status into a HUD resource, score or gameplay buff.
- Dialogue must remain bounded by NLI/source provenance rules. UI presentation must not convert an uncertain or unverified claim into an authoritative evidence record.
- Mission/evidence UI must preserve distinctions between Observed, Reported, Inferred and Unconfirmed information, and between source confidence and current claim status.
- The same gameplay intent should be reachable through supported input methods without duplicating gameplay semantics.
- The first Android target device is still unknown; screen dimensions, touch target sizing, safe areas, scaling, orientation and performance remain unverified.

## 4. Proposed acceptance gates

| ID | Requirement | Evidence required | Status |
|---|---|---|---|
| UI-001 | Gameplay and UI navigation actions are separate | InputMap audit and automated input-context test | PROPOSED |
| UI-002 | Modal menus block unintended gameplay actions | Pause/menu integration test | PROPOSED |
| UI-003 | Focus order is deterministic | Focus-neighbor review and keyboard/controller test | PROPOSED |
| UI-004 | Focus is restored after closing a modal | Scene/UI lifecycle test | PROPOSED |
| UI-005 | Critical information is not conveyed by colour alone | Visual accessibility review | PROPOSED |
| UI-006 | Text remains readable at supported UI scales | Screenshot/manual device matrix | PROPOSED |
| UI-007 | Important spoken information has a text equivalent | Dialogue/subtitle content audit | PROPOSED |
| UI-008 | Audio categories can be adjusted independently | Settings/audio integration test | PROPOSED |
| UI-009 | Long strings and localization expansion do not clip | Pseudolocalization and layout tests | PROPOSED |
| UI-010 | Touch controls respect safe areas and usable target sizes | Physical-device QA | BLOCKED — target device not identified |
| UI-011 | Screen-reader labels/context are usable | Platform-specific assistive-technology test | UNKNOWN |
| UI-012 | Mission evidence labels preserve provenance distinctions | Data/UI contract test | PROPOSED |

These gates are recommendations for later design and QA. They are not evidence that the current build passes them.

## 5. Loophole and failure review

| Failure mode | Why it matters | Required prevention or test |
|---|---|---|
| UI focus action also moves the player | A menu selection can cause unintended gameplay | Separate action namespaces and modal input-context tests |
| Focus order guessed by engine | Focus can jump unpredictably in dense menus | Explicit focus neighbors and navigation review |
| Hidden focused control | Focus may be lost when a control is hidden | Restore focus to a valid visible control |
| UI overlays block touch inconsistently | Touch may reach gameplay beneath a modal or be swallowed unexpectedly | Test modal input capture and touch lifecycle |
| Text conveys state only by colour | Information is inaccessible to some players and may fail in varied lighting | Pair colour with labels/icons/patterns |
| Critical clue is audio-only | Players may miss required information | Subtitle/text equivalent and audio-mute test |
| Dialogue text overflows | Small screens and localization expansion break layout | Long-string, scale and pseudolocalization tests |
| UI makes uncertain claims look confirmed | Presentation silently changes evidence authority | Render source/provenance and uncertainty explicitly |
| Feature exists in engine but not target platform | Desktop tests can create false confidence | Platform-specific verification on actual target |

## 6. Recommended sequence

1. Define input contexts and the gameplay/UI action boundary.
2. Convert the existing INT-016–INT-018 interaction requirements into explicit test seams.
3. Define a small UI component/theme prototype using placeholder content, not canon-sensitive character art.
4. Specify subtitle, text scaling, focus, contrast and audio-setting acceptance criteria.
5. Test desktop/headless contracts first, then editor visual behavior, then the named Android target device.
6. Only after these gates should production HUD, dialogue, mission board or accessibility settings be implemented.

## 7. Status and limits

- **CONFIRMED:** Godot documentation describes Control-based UI, theming, focus navigation, localization features and audio buses.
- **CONFIRMED:** Godot 4.7 release notes describe screen-reader support history and landmark navigation.
- **PROPOSED:** BTV input-context, accessibility, localization and audio acceptance gates in this document.
- **UNKNOWN:** final BTV HUD layout, menu architecture, dialogue presentation, audio design, supported language set and accessibility settings.
- **BLOCKED:** physical Android touch/accessibility validation until a target device is identified and available.
- **NOT IMPLEMENTED:** this research document does not change project scenes, scripts, canon or runtime behavior.

## 8. Source limitations

The Godot UI focus search result for the latest documentation is marked as unstable; the focus details in this report use the released 4.5 documentation, while the broader feature list and release notes are specifically for 4.7. Engine documentation does not establish BTV-specific usability. No user testing, screen-reader test, audio test, localization test or device test was performed for this report.
