# BTV Whole-Project Design, Architecture and Loophole Audit

**Audit date:** 2026-11-05  
**Repository:** KINGACEX/beyond-the-veil-last-watch-  
**Branch:** btv/bootstrap-prototype-001  
**Status:** PARTIAL WHOLE-PROJECT AUDIT — findings recorded; full canon validation blocked by missing authoritative source documents.  
**Code changes:** None. This is an audit and governance document, not gameplay implementation.

## 1. Executive conclusion

BTV has a coherent creative direction and useful engineering safeguards, but it is not yet a fully specified or validated game. The audited repository is a small Godot greybox prototype with an interaction contract and a deterministic Natural Language Interaction (NLI) foundation. Most major game systems remain design intentions, proposals, external canon documents, or unimplemented features.

This audit does not claim that every loophole has been found or closed. It establishes a repeatable whole-project review process, identifies visible risks, and records what must happen next.

### Overall status

- **CONFIRMED:** The branch contains a Godot project, a small 3D greybox scene, a player controller, proximity interaction contract, touch-button scaffolding, deterministic NLI scripts and an NLI smoke-test source file.
- **CONFIRMED:** Repository documentation explicitly states that headless CI does not prove visual behaviour, physical touch input, Android export or device performance.
- **PROPOSED / AGREED DIRECTION:** Mobile-first validation with shared PC-compatible architecture; first- and third-person perspectives; perspective-aware interactions; investigation journal; extensible Biblical Hebrew, Koine Greek and Biblical Aramaic research modules; optional player learning alongside Asher.
- **UNKNOWN:** The full authoritative Story & Lore, Character, Covenant, Faith/Prayer/Armor, Church/HCI, Veil/Enemy, World/NPC, Mission/Progression/Economy source documents are not present in the audited repository tree. The complete canon cannot yet be audited line by line.
- **BLOCKED:** Claims of full-game correctness, zero loopholes, production readiness, Android readiness, PC readiness or complete theological/historical accuracy.
- **COMPLETED:** This first repository-and-design audit pass and its risk register. This does not certify the entire game.

## 2. Audit method and coverage

This pass inspected the repository tree, README, AGENTS.md, Bootstrap 001/002, implementation status, first-experience and cross-platform briefs, ancient-language proposal, NLI foundation, Ridgeview knowledge contract, player/touch/interactable scripts, scene setup, input configuration, NLI scripts/test source and CI workflow. It also used the established BTV canon principles available to the coordinator.

This is a design/source inspection, not a full execution-based audit. No local Godot editor session, physical Android device, desktop test session, save file, export, profiling trace or complete canonical design archive was available.

| Domain | Coverage | Conclusion |
|---|---|---|
| Project scope and governance | Reviewed | Useful rules exist; universal change-control gate needed |
| Christian identity and theology | Canon summary only | Strong prohibitions exist; full source review required |
| Story, lore and endings | Partial | Authoritative documents missing |
| Asher and character arcs | Partial | Summary known; complete character source absent |
| Covenant and Church/HCI | Partial | Boundary known; operational details need source review |
| Veil, enemies and metaphysics | Partial | Unresolved areas must remain gated |
| Missions, choices and consequences | Partial | No complete mission system specification/implementation |
| Combat and survival | Partial | Deferred; requires separate design and accessibility gates |
| Ember and spiritual abilities | Partial | Names known; mechanics/theology must be canon-reviewed |
| Economy and progression | Partial | Currency names known; full rules not yet specified |
| World and NPCs | Partial | Ridgeview knowledge contract exists; full canon absent |
| NLI and companion commands | Source reviewed | Conservative foundation; contract gaps remain |
| Interaction system | Source reviewed | Minimal prototype; runtime not established by source inspection |
| Camera and controls | Source reviewed | Third-person-only baseline; dual perspective not implemented |
| Mobile/PC and responsive UI | Design reviewed | Shared architecture proposed; device validation absent |
| First-session UX and menu | Design reviewed | Proposal only |
| Ancient-language research | Design reviewed | Proposal only; feasibility not yet proven |
| Journal, evidence and saving | Design intent reviewed | Not implemented |
| Accessibility/localization | Partial | Needs acceptance matrix |
| Privacy, analytics and security | Partial | Needs project-wide data policy |
| CI, QA and release | Workflow reviewed | Headless checks exist; broader QA gates missing |
| Performance/assets/scalability | Partial | Renderer undecided; no device benchmarks |

## 3. High-priority findings

### H-01 — Canon source-of-truth is incomplete in the repository
**Severity:** Critical / governance blocker. **Status:** BLOCKED.

The repository contains implementation notes and selected design briefs, but not the complete authoritative design-document set described in the project context. This risks collaborators making decisions from summaries, partial memories or old handoffs.

**Loopholes:** A feature can appear consistent with a summary but contradict a specific canon section; collaborators may not know a decision; a newer proposal may accidentally be treated as canon.

**Closure:** Locate and version the authoritative files; preserve originals; create a canonical source index; attach source references and status to decisions; create a canon conflict register; never silently resolve conflicts.

**Acceptance:** A collaborator can identify the authority for every locked story/system rule without relying on chat history.

### H-02 — Proposal, canon and implementation can be confused
**Severity:** High. **Status:** PARTIALLY ADDRESSED.

Use one project-wide delivery status vocabulary:
- CANON / LOCKED: authoritative established fact.
- APPROVED DESIGN: creator-approved design, not necessarily implemented.
- PROPOSED: recommendation awaiting approval.
- IMPLEMENTED IN SOURCE: code exists, not necessarily tested.
- ENGINE-VERIFIED: exact Godot editor/runtime tests passed.
- DEVICE-VERIFIED: tested on a named physical device and OS.
- COMPLETED: acceptance criteria passed with evidence.
- UNKNOWN / BLOCKED: evidence or prerequisite missing.

Keep these separate from canon statuses such as LOCKED, SLICE, RESERVED and OPEN. Never promote a proposal to implementation or implementation to completion based on a document alone.

### H-03 — NLI command handoff reports acceptance before the companion accepts
**Severity:** High. **Status:** SOURCE FINDING.

In scripts/nli/nli_service.gd, the companion-command result currently includes accepted=true while also stating that the companion gameplay system must explicitly accept or reject the command.

**Loophole:** UI or gameplay may interpret validation as actual companion acceptance/execution. The player could be told an order succeeded when the companion is unavailable, incapable, out of range or rejects it.

**Closure:** Replace premature acceptance with an unambiguous validated/handoff-ready state. The companion actor owns accepted, rejected and executed outcomes. Define preconditions, failure reasons, cancellation, timeouts and acknowledgement. Parser results must never mutate mission/world state.

**Acceptance:** Tests prove that parsing and validating a command cannot be represented as execution or companion acceptance.

### H-04 — NLI source allowlists do not prove that a source is real or accurate
**Severity:** High. **Status:** PARTIALLY ADDRESSED.

The knowledge base checks whether a source_id is in an NPC profile allowlist. This protects profile boundaries but does not verify that the source record exists, is accurate or supports the response.

**Loophole:** An authorized ID could refer to a missing, fabricated, stale or misrepresented source. A structurally valid entry could still turn an inference into certainty.

**Closure:** Add a source registry with stable IDs, source type, owner, evidence location, author, review status and canon linkage. Validate that each NPC record references an existing source. Require editorial review of wording against provenance. Preserve attribution for reports and uncertainty for inference/unconfirmed content.

**Acceptance:** Every factual NPC answer has a traceable source record and approved wording. NLI dialogue remains non-evidence.

### H-05 — NLI lifecycle and companion execution are only in-memory prototypes
**Severity:** High. **Status:** SOURCE LIMITATION.

Request IDs and lifecycle states are in memory; save/load persistence and an actual companion actor are not implemented.

**Loopholes:** Duplicate/replayed commands after reload; UI retries creating duplicate actions; late cancellation; a request left pending forever if downstream logic never responds.

**Closure:** Define persistent command/event IDs before production use; define legal states (created, validated, queued, accepted, rejected, executing, completed, failed, cancelled, expired); define ownership of transitions; make execution idempotent; define timeout/retry/cancellation semantics. Do not add persistence before the save architecture exists.

**Acceptance:** Duplicate, late, cancelled, replayed and expired requests cannot execute twice or report false success.

### H-06 — Camera and movement are not yet a complete third-person system
**Severity:** High. **Status:** SOURCE FINDING.

The player controller uses world-space movement from input axes. The camera rig exists but has no wired look input. The pivot has a fixed initial pitch. No first-person camera or perspective toggle exists.

**Loopholes:** Camera-relative movement and facing can disagree; perspective changes can cause sudden movement changes or clipping; first-person body/head geometry can obstruct the view; third-person camera can peek around corners or through geometry; perspective puzzles can become unfair.

**Closure:** Use one camera/perspective manager with first-person, third-person and optional shoulder framing states. Preserve one movement/interaction authority. Specify collision, pitch/yaw limits, smoothing, transitions, FOV, sensitivity and remapping. Prevent wall peeking. Define scripted-camera lock/release and accessibility alternatives for essential viewpoint-specific interactions.

**Acceptance:** No input loss, control inversion, movement discontinuity, wall-peeking exploit or perspective softlock.

### H-07 — Touch controls have interrupted-input and device-coverage risks
**Severity:** High. **Status:** SOURCE FINDING.

The overlay uses fixed-position directional buttons and an interaction button. Actions are pressed/released through global Input actions. Exit-tree cleanup exists, but focus-loss, interrupted-touch and multi-touch acceptance tests are not present.

**Loopholes:** OS interruption or focus loss may leave an action pressed; simultaneous fingers may create unexpected input; hybrid devices may have touch while keyboard/mouse is active; fixed pixel layout may clip on unusual aspect ratios/safe areas.

**Closure:** Track active touch IDs/input ownership; clear pressed states on focus loss, pause, scene change, cancellation and app resume; test simultaneous movement/look, multi-touch, cancellation, duplicate press/release and focus changes; use responsive safe-area-aware layout; detect active input method rather than permanently locking by device type.

**Acceptance:** No stuck input or movement/look coupling; controls remain usable across supported screen sizes.

### H-08 — Interaction has no player-facing prompt or complete action policy
**Severity:** High. **Status:** SOURCE LIMITATION.

The base interactable exposes a prompt string, but no prompt UI exists. The player invokes the nearest target and prints the result. There is no central policy yet for cooldown, line-of-sight, prerequisites, repeated activation or authoritative action ownership.

**Loopholes:** Players do not know what is interactable; repeated presses trigger duplicate actions; targets behind walls are selected; stale/disabled targets remain selectable; an interactable could bypass mission/economy/inventory/faith gates.

**Closure:** Add prompt/result feedback. Define target validity, range, line-of-sight, priority, tie-breaking, cooldown and re-entry. Separate presentation from gameplay authority. Validate prerequisites and execute once. Test blocked line of sight, disabled/freed targets, overlapping areas, simultaneous targets, cooldown and repeated input.

**Acceptance:** Every interaction is understandable, deterministic and cannot bypass authoritative game-state rules.

### H-09 — Save/load and persistent progression are missing
**Severity:** Critical for future progression; not a current prototype defect. **Status:** NOT IMPLEMENTED.

Journals, language learning, mission choices, settings, inventory, discoveries and progression will depend on persistence.

**Loopholes:** Corrupt/incompatible saves; duplicate rewards; lost discoveries/choices; future cloud/local conflicts; tampering with local values to bypass progression or duplicate currency.

**Closure:** Design a versioned save schema first. Separate settings, progression, world state, journal discoveries and accessibility preferences. Define atomic writes, backups, corruption recovery and migration. Validate loaded data. Keep local/offline operation as baseline. Cloud accounts require separate privacy/security approval.

**Acceptance:** Test save/load, interrupted writes, corrupt files, schema migration and duplicate-reward scenarios.

### H-10 — Evidence, sources and conclusions need distinct data types
**Severity:** High. **Status:** DESIGN GAP.

A journal can confuse NPC claims, observations, documents, interpretations and mission conclusions if all appear as equivalent facts.

**Closure:** Distinguish source artifact, observed clue, attributed report, interpretation, hypothesis, confirmed conclusion and fictional narrative clue. Store who observed/reported it, when, where and under what conditions. Allow hypotheses to change without rewriting evidence. NLI dialogue is never itself evidence. Preserve uncertainty and conflicts.

**Acceptance:** No NPC claim or player guess is silently upgraded into objective truth.

### H-11 — Ancient-language system has scholarly, localization and accessibility risks
**Severity:** High. **Status:** PROPOSAL; not implemented.

Additional closure requirements:
- Separate language, script, transliteration convention, dialect/period, source edition and translation record.
- Do not assume Biblical Hebrew, Koine Greek and Biblical Aramaic cover every language/period in the story.
- Distinguish source text, reconstruction, transliteration, gloss and contextual translation.
- Record variant readings and uncertainty.
- Require qualified review for factual educational entries.
- Test right-to-left text, mixed-script punctuation, vowel marks, fonts, accessibility and Android rendering.
- Provide alternate paths for essential progression.
- Never gate the Gospel or essential biblical understanding behind language skill.
- Do not claim fluency from a small vocabulary set.
- No unreviewed AI-generated translations in gameplay.

**Acceptance:** Each content pack is source-traceable, versioned, reviewed, accessible and independently testable.

### H-12 — Christian integrity needs a feature-level review gate
**Severity:** Critical. **Status:** PRINCIPLES KNOWN; full feature audit pending canon source review.

Existing prohibitions against spiritual scoring, transactional prayer and purchasable salvation/faith/holiness/divine favour are necessary but not exhaustive.

**Additional risks to block:**
- Prayer as a repeatable consumable buff or currency generator.
- Scripture as a magical password/spell detached from context.
- Ember/Veil abilities implying control over the Holy Spirit or purchase of divine power.
- XP/karma/reputation presented as holiness or God's approval.
- Evangelism represented by coercion, conversion counters or rewards for pressuring NPCs.
- Church attendance, Communion or sacred practices treated as generic vending-machine buffs.
- Fictional theology presented as biblical doctrine.
- Suffering, disability or failure framed as proof of insufficient faith.
- Salvation portrayed as earned by good behaviour or game completion.

Every faith-related feature must answer: What does Scripture say in context? Is it explicit teaching, interpretation or fiction? Does it imply transaction with God? Does it score spiritual worth? Does it coerce? Does it confuse Covenant/Church/HCI authority? Is the practice represented accurately? Require approved source and theological review before release.

### H-13 — Covenant, Church and HCI boundaries need operational definitions
**Severity:** High. **Status:** PARTIAL SUMMARY; full source review required.

**Loopholes:** Covenant may become a substitute church or acquire unsupported spiritual authority; ranks may be confused with holiness; Communion may appear outside approved contexts; HCI may become a generic mission kiosk.

**Closure:** Document each institution's purpose, authority, membership, limitations, accountability and relationship to Scripture. Ranks are organizational, not spiritual. Preserve CommunionContextZone and First Sunday Communion Set rules from canon. Validate all Church/HCI interactions against the authoritative source.

### H-14 — Ember, Veil and enemy mechanics must remain canon-gated
**Severity:** Critical. **Status:** BLOCKED pending source review.

Known Ember abilities include Veil Sight, Guardian Instinct, Veil Energy, Tracking Sense and Spirit Guidance. Exact mechanics, limitations, costs, visual language and theological meaning must come from canon.

**Loopholes:** Spirit Guidance or the Holy Spirit becomes a controllable meter/AI companion; Veil Sight becomes an all-purpose truth detector; abilities have no limits/counterplay; implementation invents Veil metaphysics or enemy origins; abilities reveal facts the character cannot know.

**Closure:** For each ability define capability, limits, cost, failure, forbidden use, knowledge boundaries and canon source. Keep unresolved metaphysics OPEN. Design enemy behaviour only after canon and content boundaries are reviewed. Require narrative/theological review.

### H-15 — Mission choices need consequence, recovery and softlock design
**Severity:** High. **Status:** NOT FULLY SPECIFIED.

The Ridgeview knowledge contract protects unresolved facts and five approaches (Speak/Preach, Investigate, Rescue, Defend, Withdraw), but the full mission system is not implemented.

**Loopholes:** Missing clue permanently blocks objective; NPC becomes unavailable before required interaction; choice appears meaningful but changes nothing; hidden consequence is unforeseeable; dialogue/evidence/mission state diverge after reload; companion command bypasses prerequisites.

**Closure:** Create mission state diagrams and prerequisites. Separate critical-path and optional clues. Define fail-forward and recovery. Author and test choice consequences. Define companion availability/failure. Test branches, revisits, cancellation, reload and missing-clue paths. Keep unresolved Ridgeview facts OPEN.

### H-16 — Economy needs anti-exploit and spiritual-integrity controls
**Severity:** High. **Status:** Names known; rules not implemented.

Aces and Covenant Credits are established names; sources, sinks, limits and relationships need design.

**Loopholes:** Infinite repeat rewards, duplicate mission payouts, save reload exploits, inflation, pay-to-win gates, grinding requirements, essential progression blocked by spending, spiritual status implied by currency.

**Closure:** Define earning/spending/caps/sinks/refunds/failure. Validate all state transitions. Use transaction IDs and idempotency for rewards. Prohibit purchases of salvation, faith, holiness or divine favour. No real-money monetization without separate approval and legal/age-appropriate review. Test repeat reward, rollback, duplicate payout and negative/overflow values.

### H-17 — Accessibility and player comfort are not acceptance-tested
**Severity:** High. **Status:** DESIGN GAP.

**Closure:** Remappable controls; separate movement/look sensitivity; adjustable camera distance/FOV where feasible; camera shake/motion blur/head-bob controls; subtitle size/contrast/speaker labels/background; UI scaling and safe areas; hold/toggle alternatives; no essential clue based only on colour, sound, tiny text, rapid tapping or precision timing; readable ancient scripts with transliteration; keyboard/touch/controller navigation; pause/re-entry without losing critical progress.

**Acceptance:** Documented accessibility test matrix before content scale-up.

### H-18 — Privacy and analytics need a full data inventory
**Severity:** High. **Status:** PARTIALLY ADDRESSED.

**Closure:** Inventory data collected, stored, transmitted and retained. Never infer/collect religion, beliefs, prayer choices, confession, salvation views or spiritual state. Prefer local aggregate usability telemetry, transparent and controllable. No voice recording/transcription by default. No persistent AI conversation memory without separate informed design and approval. Define retention, deletion, export, consent, security and age-appropriate controls before accounts/cloud. Review third-party SDK data and permissions.

### H-19 — Future AI/NLI must not become unbounded authority
**Severity:** Critical for any future LLM integration. **Status:** Current NLI is deterministic; future AI is out of scope.

**Loopholes:** Model invents lore/Scripture/NPC memories/mission facts; prompt injection causes tool execution; model mutates inventory, relationships, missions or economy; private NPC knowledge leaks; unbounded input creates cost/latency/privacy problems.

**Closure:** Keep authoritative gameplay deterministic and outside the model. If AI is ever introduced, use typed allowlisted tools, strict schemas, source-bounded retrieval and game-side validation. Treat player text, NPC text and external documents as untrusted. No arbitrary file/network/save/mission/economy mutation. Add length/rate/timeout/cost/offline fallback controls. Require approval for paid APIs, cloud processing, voice collection or persistent memory. Essential gameplay must have a deterministic path.

### H-20 — CI does not test the whole product
**Severity:** High. **Status:** PARTIALLY ADDRESSED.

The workflow imports/parses the project, runs NLI smoke tests and launches the main scene headlessly. This does not prove visuals, controls, touch, physics feel, Android export or performance.

**Closure:** Maintain separate gates for source validation, editor import, unit tests, headless integration, manual editor interaction, Android export/install, physical Android usability/performance, desktop keyboard/mouse, accessibility/localization, narrative/theological review, and release regression/rollback. Every result states platform, engine, commit, exact command/manual steps and observed result.

## 4. Universal whole-game loophole checklist

Every feature must answer the following before implementation.

**Purpose and authority**
- What player value does it add?
- Which canon/source authorizes it?
- Who owns the authoritative state change?
- What is explicitly out of scope?

**Normal and abnormal flows**
- What are preconditions and postconditions?
- What if the player repeats it, does it out of order, pauses, quits, reloads or loses focus?
- What if a target/source is missing, invalid, stale or contradictory?
- What if the player lacks the required resource?
- What happens on timeout, failure, cancellation and retry?

**Exploit and recovery**
- Can a prerequisite be bypassed?
- Can a reward/action be duplicated?
- Can a player become permanently stuck?
- Can a camera/input/physics interaction expose unintended information?
- Can an optional failure block essential progress?
- Is there a fair recovery route?

**Integrity and safety**
- Can it contradict canon, Scripture or a character's knowledge?
- Can a UI label imply an action succeeded when it has not?
- Can it imply spiritual worth, divine favour or salvation is earned?
- Does it coerce religious participation?
- Does it collect sensitive data or incur unexpected costs?

**Quality**
- Does it work with all supported perspectives and input methods?
- Is it accessible?
- Does it persist safely?
- Are tests measurable and repeatable?
- Is rollback possible?

A feature does not pass merely because no loophole was noticed. It passes only when important risks have explicit mitigations and acceptance tests demonstrate them.

## 5. Whole-game feature review domains

Apply the checklist to all of these, not only newly discussed features:

1. Player movement, camera, perspectives and controls.
2. Interaction, objects and environment.
3. Story, lore, dialogue, characters and NPC knowledge.
4. Scripture, prayer, faith, evangelism, Church and HCI.
5. Covenant organization, ranks and authority.
6. Veil, Ember, supernatural abilities and spiritual conflict.
7. Enemies, combat, survival, difficulty and non-combat alternatives.
8. Missions, branches, choices, companions and consequences.
9. World regions, exploration, navigation, streaming and boundaries.
10. Inventory, items, Aces, Covenant Credits and progression.
11. Journal, evidence, research and ancient languages.
12. Menus, HUD, settings, accessibility and localization.
13. Save/load, migrations, offline play and future cloud options.
14. AI/NLI, privacy, security, data and cost.
15. Assets, licenses, audio, performance and renderer.
16. CI, QA, device tests, release, rollback and project governance.

## 6. Established direction to preserve

- Christian action-adventure survival RPG; not a direct Bible retelling.
- Semi-open interconnected regions, not an unrestricted full open world.
- Asher Vance remains within the established age range (16–19) and is a Covenant-trained field member, not a divine replacement.
- Preserve Covenant rank structure and distinction from the Church.
- Preserve Aces and Covenant Credits as distinct named currencies; do not invent their economy rules without review.
- Preserve established Ember ability names and do not invent spiritual mechanics.
- Preserve HCI/church details and CommunionContextZone restrictions.
- No spiritual scoring, transactional prayer, purchasable salvation/faith/holiness/divine favour, or controllable Holy Spirit resource.
- Mobile-first validation, shared mobile/PC architecture.
- First- and third-person perspectives with distinct strengths, fair perspective-specific interactions and anti-exploit camera rules.
- Ancient-language research: Hebrew, Koine Greek and Biblical Aramaic as independent extensible modules; Asher and player learning tracks separate; player education optional.
- Free/local tools by default; no unnecessary paid services, credits or subscriptions.
- Work on approved feature branch until review; no unapproved merge, release or deployment.

## 7. Recommended closure order

| Priority | Work | Reason |
|---|---|---|
| P0 | Restore/index authoritative canon documents | Prevent story/theology mistakes |
| P0 | Obtain Mavis's current branch/worktree/test report | Avoid conflicting edits |
| P0 | Complete interaction test harness and manual prototype verification | Establish trustworthy baseline |
| P1 | Correct NLI handoff semantics and strengthen source registry | Prevent false acceptance/unsupported NPC claims |
| P1 | Define shared input/camera/perspective architecture | Controls affect every later system |
| P1 | Define save schema and state ownership before persistence | Prevent costly rewrites |
| P1 | Adopt universal loophole review and acceptance gate | Make safeguards repeatable |
| P2 | Implement interaction prompts, robust touch handling and responsive UI | Improve first playable experience |
| P2 | Build minimal journal/evidence model | Establish investigation state/provenance |
| P3 | Prototype one reviewed Hebrew entry and RTL rendering | Validate language architecture cheaply |
| P4 | Add missions, economy, combat, Ember, world and NPC systems only after their own canon/design gates | Avoid premature systems |
| P5 | Android, desktop and accessibility verification | Establish actual readiness |

## 8. Mavis follow-up assignment — audit validation, not broad implementation

**Task:** BTV whole-project audit follow-up and baseline verification.

**Objective:** Validate source-level findings and identify additional defects without destabilizing the project.

**Required first response:**
- Repository URL, branch and local HEAD.
- Whether local HEAD matches remote.
- Full git status and uncommitted changes.
- Godot version and export-template status.
- Exact baseline CI-equivalent commands and observed outputs.
- Existing tests, including interaction coverage.
- Any local work that must be preserved.

**Allowed work after baseline is safe:**
- Review NLI handoff semantics and propose a minimal additive correction.
- Design missing NLI/source-registry tests.
- Design interaction test harness and edge-case matrix.
- Inspect input focus-loss and touch cancellation behaviour.
- Report exact files and line-level findings.

**Restrictions:**
- Do not implement broad game systems.
- Do not overwrite, reset or discard existing work.
- Do not edit main or merge branches.
- No paid services, dependencies or external APIs.
- Do not author unresolved story, mission, NPC, theological, Veil, enemy or economy facts.
- Do not add unreviewed biblical-language content.
- Do not claim a test passed unless it was run and output is provided.

**Deliverables:** Prioritized findings, evidence, minimal patch proposal, tests, exact commands/results, branch and commit if changes are made.

## 9. What this audit does not certify

This document does not prove that every original design document has been inspected; that all canon conflicts are resolved; that no loopholes remain; that code works in the Godot editor or on a physical device; that the NLI or interaction test harness has been executed in the current environment; or that the camera, touch controls, journal, save system, language system, combat, economy, missions or spiritual abilities are implemented.

## 10. Audit result

**COMPLETED:** First whole-project repository/design audit pass; risk register and universal review gate documented.

**CONFIRMED:** Current repository scope and source limitations described above.

**BLOCKED:** Full canon audit until authoritative design documents are available for direct inspection.

**NEXT ACTION:** Restore/index canonical documents and obtain Mavis's current M0 status report. Then close P0 source and interaction verification gates before expanding gameplay.

**Audit principle:** BTV does not call a feature safe, complete or canon-compliant because it sounds reasonable. It must have an identified authority, explicit boundaries, tested edge cases and evidence.
