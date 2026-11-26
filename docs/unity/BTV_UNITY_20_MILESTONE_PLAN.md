# BTV Unity Port — 20-Milestone Engineering Plan

**Branch:** `btv/unity-port-001`  
**Strategy:** Parallel implementation; Godot remains preserved and active.  
**Target:** Android-first, desktop validation retained.  
**Status:** PLAN ONLY — milestones are not implementation claims.

## Non-negotiable workflow

- Implement one small, reviewable milestone at a time.
- Inspect existing source and relevant canon before each feature.
- Do not alter Godot implementation files in this Unity workstream.
- Do not invent canon or promote proposals to canon.
- Keep gameplay rules separate from presentation and input.
- Record changed files, implementation notes, test commands, results and known limitations.
- No paid services/assets/plugins/subscriptions without approval.
- No merge, release, publication, destructive operation or public announcement without approval.
- Never claim Unity Editor, runtime, Android export, device or test validation unless actually executed and observed.

## Milestones

### Group A — Project foundation (M1–M4)
1. **Unity toolchain decision:** inspect current Unity LTS/editor availability, licensing constraints, Android build support, target-device requirements and free workflow. Record selected editor version and rationale; do not install paid dependencies.
2. **Project scaffold:** create isolated `UnityProject/` with version-controlled project settings, package manifest and documented setup. No gameplay framework yet.
3. **Architecture and conventions:** define assembly boundaries, namespaces, folder layout, scene ownership, dependency rules and configuration strategy. Keep domain logic engine-independent where practical.
4. **Bootstrap scene and diagnostics:** create minimal launch scene, deterministic startup, logging and configuration validation. No greybox presented as final art.

**Gate 1 after M4:** Unity batchmode project open/import; C# compilation; EditMode test discovery/execution; PlayMode smoke test; scene load; package/asset integrity; record exact editor version and logs.

### Group B — Player and interaction (M5–M8)
5. **Input abstraction:** define action map for keyboard/controller and Android touch; avoid hard-wiring UI to gameplay.
6. **Player locomotion:** implement tested third-person movement, gravity, collision and camera follow with tunable configuration.
7. **Interaction contract:** define reusable interaction interface, range/target selection, prompt state and safe cancellation.
8. **Vertical-slice interaction scene:** implement a small test scene with authored interactable objects and interaction feedback; use clearly labelled temporary art where final assets are unavailable.

**Gate 2 after M8:** batchmode import/compile; EditMode tests for input mapping, target selection and interaction rules; PlayMode tests for player spawn, collision, camera, interaction enter/exit and cancellation; deterministic scene smoke test. Manual visual/input check remains separately required.

### Group C — Slice world and investigation (M9–M12)
9. **Environment blockout:** build a small, navigable scene for the approved slice with lighting/performance budget documented; distinguish blockout from final art.
10. **NPC/dialogue foundation:** implement data-driven dialogue, speaker identity, interaction state and canon-safe unknown handling.
11. **Evidence/investigation framework:** model observations, source/provenance, confidence, contradictions and report entries without auto-resolving uncertainty.
12. **Mission/sequence orchestration:** implement data-driven objectives and transitions for the approved vertical-slice sequence; do not add unapproved mission facts.

**Gate 3 after M12:** batchmode compile/import; EditMode tests for dialogue data, evidence provenance, confidence/contradiction handling and mission state transitions; PlayMode tests for NPC interaction, evidence collection and save/load-independent sequence progression; scene boot and deterministic smoke tests.

### Group D — Canon-specific slice content (M13–M16)
13. **Church/service slice space:** implement the fictional Logos Rhema Temple activity space according to the locked slice; do not reproduce real HCI people/buildings.
14. **Communion context rules:** implement Communion Set contextual availability and sequence only as specified; absolutely no XP, currency, stats, health, protection or progression reward.
15. **Covenant alert and Scout Report:** implement the authored alert/report handoff and evidence review, preserving unknown identities and information boundaries.
16. **Ridgeview investigation and response:** implement only approved slice locations, characters, dialogue, evidence and response scope; run canon/content audit before acceptance.

**Gate 4 after M16:** batchmode compile/import; EditMode tests for CommunionContextZone restrictions/no-reward invariants, secrecy/knowledge boundaries, evidence provenance and mission transitions; PlayMode end-to-end slice sequence smoke test; canon checklist review. Human content review required.

### Group E — Android readiness and production handoff (M17–M20)
17. **Presentation and accessibility:** implement slice HUD, dialogue/evidence UI, scalable layouts, readable typography, safe-area handling and input feedback.
18. **Audio and asset integration:** integrate only approved/licensed/original assets; verify attribution/licences and import settings; no unlicensed marketplace content.
19. **Performance and Android build pipeline:** profile representative scenes; configure Android build only after device/API/toolchain review; produce debug build and document export settings.
20. **Release-candidate validation and handoff:** fix verified blockers, run full test suite, prepare reproducible setup/build instructions, known-issues register, asset provenance and sponsor demo checklist. No public release without approval.

**Gate 5 after M20:** batchmode compile/import; all EditMode and PlayMode tests; clean build from documented checkout; Android build/export validation; install and test on actual target device; record device model, OS, build hash, performance, memory, thermal and stability observations. If no physical device is available, explicitly mark device validation BLOCKED—not passed.

## Mandatory four-milestone test gates

Every gate is a stop/go checkpoint. A failed gate blocks the next group until failures are triaged and resolved or explicitly accepted by the project owner.

Common required checks at every gate:
1. Unity batchmode project import/open and script compilation using the pinned editor version.
2. EditMode tests for pure logic, data validation and invariants.
3. PlayMode tests for scene/runtime integration.
4. Scene boot/smoke test with explicit timeout and exit-code capture.
5. Test result artifacts (XML/logs) retained in CI where available.
6. Static scan for accidental Godot file modifications, secrets, unlicensed assets and unexpected package additions.
7. Written gate report: commit SHA, Unity version, commands, pass/fail counts, failures, unresolved risks and next decision.

Batchmode tests do not prove visual quality, touch usability, real-device performance or APK installation. These require manual/editor/device checks and must be reported separately.

## CI design

Create a separate Unity workflow, e.g. `.github/workflows/unity-validation.yml`, only after the Unity project scaffold and a supported free CI route are verified. Unity licensing and runner constraints must be checked first. Do not commit credentials or activation secrets. If safe, free Unity batchmode CI is not available, use local batchmode validation and document CI as BLOCKED rather than bypassing licensing.

The existing `.github/workflows/godot-validation.yml` must remain unchanged and continue validating only the Godot branch/workstream.

## Completion definition

The Unity port is not "complete" because a branch or empty project exists. Completion requires a playable, canon-reviewed vertical slice; all five gates passed; reproducible Android build; physical-device validation; and an approved handoff. Any unmet condition remains OPEN or BLOCKED.
