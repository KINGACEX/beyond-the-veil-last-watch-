# BTV First-Experience and Engagement Research Brief

**Date:** 2026-11-05  
**Project:** Beyond the Veil: The Last Watch  
**Branch:** `btv/bootstrap-prototype-001`  
**Status:** PROPOSED — research and design direction only; not canon and not implemented  
**Purpose:** Guide the next small milestone after the greybox interaction foundation.

## 1. Executive recommendation

Do not build a large open-world feature set next. First make the opening experience understandable, welcoming, responsive and memorable.

Recommended sequence:

1. Establish a simple title/menu screen.
2. Make the first playable area communicate one clear objective.
3. Make movement, camera control and interaction comfortable on Android.
4. Teach one useful gameplay action at a time through play.
5. Introduce BTV's Christian themes through character, consequence, Scripture context and meaningful choices—not repeated sermon text or spiritual scoring.
6. Measure whether players understand and complete the first experience before expanding content.

This is a proposal. Existing story canon and design documents remain authoritative.

## 2. Verified baseline and current gaps

At commit `82a0b5c88b209935e043a3ec3dfc6d223c5fda9e`, the active branch contains a Godot 4.7.2 greybox foundation. CI run [41828875112](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/41828875112) passed engine installation/version verification, editor import and parsing, the NLI smoke suite, and a 10-frame headless main-scene launch.

The current source includes:
- A third-person capsule placeholder and camera rig.
- Basic movement and a proximity interaction sensor.
- A neutral test interactable.
- Four directional touch buttons and an INTERACT button.
- A deterministic NLI foundation.

The following are not yet present or not yet verified:
- A title screen, pause menu, settings flow or first-time tutorial.
- A rendered interaction prompt or polished feedback.
- Touch camera-look controls.
- Camera-relative movement.
- A polished mobile movement control.
- Visual/editor interaction testing and physical Android validation.

The current player controller derives movement directly from input axes in world space. The camera rig is present, but no camera-look input is wired in the inspected source. The touch overlay is a minimal prototype, not a validated mobile control scheme.

## 3. Proposed opening screen

### Main menu concept

**Visual direction:** restrained white and warm gold accents, the established cross insignia used carefully, strong readable title typography, and a quiet atmospheric background. Avoid clutter, excessive glow, crowded lore text and aggressive calls to action.

**Proposed menu hierarchy:**
1. Continue — shown only when a valid save exists.
2. New Watch — starts the opening experience.
3. Settings — controls, audio, display and language.
4. Accessibility — subtitles, text size, camera sensitivity and control alternatives.
5. Credits.

Do not show unavailable options as active. Do not imply saving or settings exist until implemented.

### First-session flow

| Stage | Player experience | Design purpose |
|---|---|---|
| 1. Arrival | Clear title screen and a short, skippable introduction | Establish tone without delaying play |
| 2. Orientation | One clear objective and a visible point of interest | Give direction without a long tutorial |
| 3. Movement | Player learns movement and camera through a safe open space | Build control confidence |
| 4. Discovery | Player approaches and examines one relevant object or person | Teach interaction naturally |
| 5. Understanding | A short exchange or environmental clue adds context | Give curiosity a meaningful payoff |
| 6. Choice | A low-risk, understandable decision shows that choices matter | Support agency and character investment |
| 7. Reflection | Optional Scripture/context journal entry or reflection prompt | Connect learning and faith without coercion |

Target a compact first session, but do not force an arbitrary time limit. Let players skip or revisit non-essential explanations.

## 4. Engagement principles supported by research

### A. Teach by doing

Roblox's onboarding guidance recommends teaching essential controls, getting players to the fun quickly and leaving them wanting more. Apple's game onboarding guidance similarly recommends short, clear, interactive teaching rather than front-loading every system.

**BTV application:** introduce movement, camera and interaction separately. Let the player perform each action immediately. Avoid a wall of instructions.

Sources:
- [Roblox Creator Hub — Onboarding](https://create.roblox.com/docs/production/game-design/onboarding)
- [Apple Developer — Onboarding for Games](https://developer.apple.com/app-store/onboarding-for-games/)

### B. Make mobile controls feel native

Android's game-development guidance recommends supporting the input methods available on the device and adapting the interface to the active input. Its multi-form-factor guidance also stresses keyboard navigation and support beyond touchscreens.

Apple's touch-control guidance recommends predictable movement and camera areas, accessible button placement, clear press states and reducing unnecessary controls.

**BTV application:** prototype a left-side virtual stick or touch-drag movement area, a right-side camera-look area, and one contextual interaction button. Keep keyboard input working. Show the interaction button only when useful. Add visible pressed states and configurable sensitivity. Test on the actual Android device before calling it complete.

Sources:
- [Android Developers — Enable natural input on all form factors](https://developer.android.com/games/develop/multiplatform/enable-natural-input-on-all-form-factors)
- [Android Developers — Develop games for all screens](https://developer.android.com/games/develop/all-screens)
- [Apple Developer — Game controls](https://developer.apple.com/design/human-interface-guidelines/game-controls)

### C. Give players agency, mastery and connection

Research on game engagement repeatedly uses the Self-Determination Theory concepts of autonomy, competence and relatedness. A 2024 study found that perceived achievability and immersibility can support competence and autonomy, which in turn are associated with continued use. A 2024 review of narrative and motivation also proposes meaningful choices, appropriately matched challenges and character relationships as useful design directions, while noting that further empirical testing is needed.

**BTV application:**
- Autonomy: meaningful, understandable choices; do not pretend cosmetic choices have major consequences.
- Competence: clear feedback and challenges that build gradually.
- Relatedness: memorable characters, believable relationships and opportunities to help others.
- Immersion: environmental storytelling and discoveries that reward attention.

Sources:
- [Teng et al. (2024), Creatability, achievability, and immersibility](https://doi.org/10.1016/j.ijinfomgt.2023.102732)
- [Narrative and Self-Determination Theory in Video Game Design Research](https://pmc.ncbi.nlm.nih.gov/articles/PMC12487717/)

### D. Keep sessions accessible and purposeful

GameAnalytics' 2025 benchmark report describes 11,600 games and reports that median mobile sessions are around 5–6 minutes, while top-tier games average around 8–9 minutes. These are market observations, not a target that BTV must copy. The useful lesson is to make short play sessions feel complete and worthwhile.

**BTV application:** each short play session should offer a clear objective, a satisfying discovery or completed task, and a natural stopping point. Avoid artificial timers and manipulative daily-pressure systems.

Source:
- [GameAnalytics — 2025 Mobile Gaming Benchmarks](https://www.gameanalytics.com/cn/reports/2025-mobile-gaming-benchmarks)

## 5. Educational and Gospel-centred design

BTV should remain an adventure first, with Christian truth integral to its world and story.

### Educational loop

Use a simple learning pattern:
1. Encounter a question or situation.
2. Investigate through the world or a character.
3. Receive accurate, understandable context.
4. Apply the idea through a choice or action.
5. Optionally revisit the explanation in a journal or codex.

Possible learning areas, subject to canon review:
- Biblical literacy: understand a passage in its context, not as an isolated slogan.
- Moral reasoning: consider truthfulness, courage, mercy, responsibility and forgiveness through character situations.
- History and culture: use carefully researched context where relevant to the setting.
- Practical knowledge: navigation, observation, cooperation and problem-solving.

### Evangelistic integrity

- Present the Gospel clearly and accurately, centred on Jesus Christ.
- Let the story show grace, redemption, sacrifice, truth and hope through characters and consequences.
- Make optional Scripture notes and reflection resources available.
- Never score salvation, faith, prayer, holiness or divine favour.
- Never make prayer a transaction or a way to purchase an advantage.
- Do not pressure players into a prayer, profession of faith or religious choice to progress.
- Distinguish what Scripture says from a character's interpretation or an unresolved story question.
- Have Scripture references and theological claims reviewed before release.

## 6. Measurement plan

Use analytics to improve clarity and accessibility, not to pressure players.

Suggested privacy-conscious, aggregate events:
- Main menu: New Watch selected; Continue selected.
- Tutorial: movement prompt shown/completed; interaction prompt shown/completed.
- First experience: objective started/completed; first interactable used.
- Usability: control scheme selected; settings changed.
- Stability: crash-free sessions and load failures.

Do not collect personal religious beliefs, prayer choices, confession content, or other sensitive personal data. Do not treat a player's faith response as a performance metric.

Review:
- Where players stop during onboarding.
- Whether they discover the interaction prompt.
- Whether they can complete the first objective without assistance.
- Whether touch and keyboard users can both complete the same basic flow.
- Whether players voluntarily return, without artificial pressure.

## 7. Proposed development order

| Priority | Work item | Why it comes next | Gate |
|---|---|---|---|
| P0 | Verify movement, camera, sensor and interaction in Godot editor | The current CI is headless and does not prove interactive behaviour | Recorded manual test results |
| P0 | Complete Mavis's separate interaction test harness review | Prevent regressions in the existing interaction foundation | Test script, exact commands and results |
| P1 | Improve input architecture: camera look and camera-relative movement | Essential for a third-person mobile experience | Keyboard and touch input tests |
| P1 | Add contextual interaction prompt and clear feedback | Players need to know what can be interacted with | Prompt appears/disappears correctly |
| P1 | Create title/menu wireframe and first-session flow | Establish the first impression before building more world content | Design review; no canon changes |
| P2 | Implement menu and settings in a separate additive milestone | Makes the prototype feel like a real game entry point | Menu navigation and save-state tests |
| P2 | Build a small educational/Gospel discovery sequence | Prove the game's distinctive purpose in play | Scripture/theology and UX review |
| P3 | Android export, install and device usability testing | Verify the actual target platform | APK and device evidence |

## 8. Scope guardrails

This brief does not authorize:
- New story canon, mission facts, dialogue or character backstory.
- Combat, enemy or advanced Ember implementation.
- A renderer decision without target-device comparison.
- Paid assets, APIs, subscriptions or credit-consuming tools.
- Changes to `main`, merges, releases or deployments.

Keep this work on `btv/bootstrap-prototype-001`. Make each implementation milestone small, additive and testable.

## 9. Current conclusion

**CONFIRMED:** The branch is a real Godot 4.7.2 greybox prototype with successful headless CI.

**PROPOSED:** Prioritize the first-session experience, mobile input, interaction feedback and a restrained main menu before expanding the world.

**UNKNOWN:** Mavis's latest local environment status, whether she has completed the assigned interaction test harness, and whether she can push a reviewable branch or commit.

**BLOCKED:** Visual and Android readiness claims remain blocked until editor/runtime and physical-device checks are performed.

**Next highest-value action:** obtain Mavis's preliminary report and complete the interaction verification gate; then implement the input/prompt improvements in separate reviewable changes.
