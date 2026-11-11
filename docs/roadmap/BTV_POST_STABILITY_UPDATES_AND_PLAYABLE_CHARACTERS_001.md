# BTV Post-Stability Updates and Playable Character Expansion 001

**Status:** PROPOSED — RECORDED FOR POST-STABILITY; NOT PART OF CORE RELEASE  
**Project:** Beyond the Veil: The Last Watch  
**Engine:** Godot 4.7.2 baseline  
**Platform order:** Android first; PC scalability later

## 1. Purpose

Reserve a clearly identified update track for additional content after the core game is complete, tested and stable. This roadmap protects the initial release from feature creep while preserving the user's direction for future updates.

The game should have a dedicated **Updates** section in its main menu or title-screen navigation once the core release is stable. Until then, the section is a planned product requirement, not a live news feed or a promise of a release date.

## 2. First proposed feature — selected key characters become playable

**User-requested direction:** In a later update, players should be able to play a small selection of important established characters other than Asher.

**Scope guardrails:**
- Keep Asher as the sole playable character in the initial Ridgeview vertical slice and core-release baseline.
- The later feature should select from existing, approved key characters. Do not invent names, biographies, affiliations, abilities or story outcomes to fill a roster.
- Do not assume every supporting character should become playable. The roster should remain small and narratively justified.
- Character availability may be limited to suitable chapters, missions, or replay modes where the established story supports it.
- Each playable character needs a clear narrative reason, appropriate perspective, and meaningful but canon-consistent differences.
- Preserve story continuity, chronology, relationships, evidence state, and the consequences of player choices.
- Avoid making characters interchangeable skins. Their perspective and interactions should matter, while remaining within established canon.
- Do not grant characters new supernatural abilities or alter the established theology, character identities, or world rules as a side effect of the feature.
- No character roster or chapter assignment is approved by this roadmap. Those decisions require a separate character/canon review.

## 3. Research and design work required before implementation

When the core release has passed its stability gate, conduct a dedicated research and design phase covering:
1. Canon audit: identify which existing characters could credibly support playable sections.
2. Narrative structure: determine whether the feature uses authored chapters, optional missions, replay selection, or another justified structure.
3. Character differentiation: movement feel, interaction affordances, camera framing, accessibility and animation requirements.
4. Save compatibility: ensure existing saves and player choices remain valid.
5. Content architecture: data-driven character profiles and controlled scene/mission eligibility, avoiding duplicated mission logic.
6. UI/UX: character selection, unlock/availability communication, accessibility and mobile thumb reach.
7. Performance: memory, animation/rig budgets, scene loading, Android thermal and battery behaviour.
8. QA: regression coverage for save migration, dialogue, branching, mission state, camera, input and device performance.
9. Release management: update size, versioning, patch notes, rollback strategy and user-facing communication.

Compare alternatives and document costs, risks, dependencies and acceptance criteria before implementation. Use current official Godot documentation and measured project benchmarks; do not rely on assumptions about performance.

## 4. Dedicated Updates section

**Planned location:** Main menu/title screen, labelled **Updates**.

The section should eventually contain:
- current game version and release date;
- concise patch notes grouped by version;
- new content and feature summaries;
- bug fixes and known issues;
- platform-specific compatibility notes;
- credits/attributions for newly added third-party assets where applicable.

**Offline-first requirement:** The Updates section must remain useful without a network connection. Bundle the current release notes with the game. A network-fed news feed is optional and must not be required for normal play.

**Release controls:** No remote content delivery, analytics, account requirement, paid update, or automatic download is implied. Any such system requires separate privacy, security, platform and approval review.

## 5. Candidate update sequence

These are planning groups, not dates or commitments:
- **Update 1 — Additional playable perspectives:** a small, reviewed selection of established key characters.
- **Update 2 — Additional story content:** only canon-approved stories that fit the completed game's continuity.
- **Update 3 — Quality and accessibility improvements:** improvements justified by player feedback and measured QA.
- **Update 4 — Platform and performance improvements:** Android compatibility and later PC scalability, subject to separate hardware and platform planning.

The sequence may change after research. No update should be promised until scope, feasibility, testing and approval are complete.

## 6. Entry conditions

Do not begin implementation of this roadmap until:
- the core game content is complete;
- the core story and canon are reviewed and locked for the release;
- save/load and progression are stable;
- the target Android device matrix has been tested;
- performance, memory, thermal and crash checks meet documented project thresholds;
- critical and high-priority defects are resolved or explicitly accepted;
- regression tests pass on the release candidate;
- a release checkpoint records the stability decision.

## 7. Governance

- This roadmap does not authorize changes to Master Canon or existing character bibles.
- New playable-character identities, abilities, missions, story branches or outcomes require explicit review and approval.
- No merge, public announcement, release, paid service or destructive migration is authorized by this planning document.
- Each update requires a research brief, scope, dependencies, risk register, acceptance tests, checkpoint and rollback plan.
- If a post-release feature threatens core stability, defer it rather than weakening the release baseline.

## 8. Acceptance criteria for the future playable-character feature

The feature may be considered complete only when:
- the selected characters are canon-approved and narratively justified;
- the playable roster is intentionally limited and clearly communicated;
- character-specific sections preserve story and save continuity;
- controls and camera remain consistent and accessible;
- no existing core mission or save is broken;
- regression and target-device tests pass;
- performance and memory costs are measured on the supported device matrix;
- patch notes and the in-game Updates section accurately describe what shipped.

**Current decision:** Record the feature as a post-stability candidate. Do not implement it in the core prototype.
