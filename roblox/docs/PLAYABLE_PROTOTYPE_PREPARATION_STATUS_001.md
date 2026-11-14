# BTV Roblox — Playable Prototype Preparation Status 001

**Audit date:** 2026-11-14  
**Branch:** `btv/roblox-opening-loop-003`  
**Audited base:** PR #12 head `btv/roblox-ridgeview-corrections-001` @ `938462cf`  
**Current implementation head:** `7e32af61c6f56070ad669ebbac7b669b85d4d3d7`  
**Status:** Source increment implemented; headless CI PASS; genuine Roblox Studio runtime remains pending.  
**Authority:** This document records the Roblox prototype implementation only. The BTV Master Canon, Mission Bible, Character Bible, Church Bible and Visual/UI/HUD Bible remain authoritative.

## 1. Current implementation status

### Temple-to-Ridgeview opening loop

| Feature | Status | Evidence / limitation |
|---|---|---|
| Temple world blockout | Implemented | Procedural Logos Rhema Temple prototype scene |
| Player spawning | Implemented in source | Foyer spawn and Temple respawn location; Studio spawn verification pending |
| Sanctuary onboarding | Implemented | Server-validated sanctuary-entry prompt |
| Covenant introduction | Partial | Covenant alert and Scout Report briefing; no deeper operational hub systems yet |
| Scout Report | Implemented | HUD briefing panel with authored assignment text |
| Temple-to-Ridgeview transition | Implemented | Server-validated departure prompt teleports within the same place; no separate place or streaming transition |
| Ridgeview-to-Temple return and revisit | Implemented in source | Return prompt updates the persisted region without resetting mission progress; Temple departure prompt returns the player to Ridgeview; Studio validation pending |
| Ridgeview landscape and settlement | Implemented as blockout | Procedural geometry, lighting, wayfinding, investigation props |
| NPC interactions | Implemented as scripted blockout interactions | Wren, Dorian Pike and two residents; not final character rigs or AI |
| Investigation objectives | Implemented | Server-owned sequential objective state |
| Evidence collection | Implemented | Two approved approach observations |
| Unified Field Notes | Implemented | Observations, private testimony, permission record and Pike's statement |
| Report submission | Implemented | Server-side readiness checks and report-board interaction |
| Completion reward | Not implemented | No approved reward amount or reward table was invented |
| Persistent completed progress | Implemented behind opt-in persistence | Completed mission ID and investigation record are saved when persistence is enabled |
| Persistent in-progress progress | Implemented behind opt-in persistence | Mission phase, sequence index, Ridgeview objective, current region and investigation record are saved/restored through the existing profile adapter; Studio DataStore validation remains pending |

### Ridgeview investigation and privacy

- Wren's testimony is recorded separately from the two observations.
- A separate explicit disclosure decision is required before report submission.
- Wren can keep her testimony private; the player can still complete the investigation.
- If she authorizes sharing, the scope is limited to the single observation that she saw the repairman go toward the camp.
- Pike's Wren-specific discussion is only offered after that permission is present.
- Pike's limited admission is recorded as an NPC statement, not proof of every accusation or a legal finding.
- Mission, journal and consent state are keyed per player on the server; journal updates use player-targeted remotes.
- Re-recording Wren's testimony resets the previous disclosure decision and dependent Pike admission.
- Profile schema v5 added the explicit disclosure-decision field. v4 migration treats an old false permission as unconfirmed and requires Wren's decision to be reconfirmed. Schema v6 added a validated active-mission checkpoint. Schema v7 adds the current region (`temple` or `ridgeview`); v6 migration derives a safe region from mission phase, and v1–v5 migrations create an initial checkpoint unless Ridgeview is already recorded complete.

### Ember companion

| Feature | Status | Evidence / limitation |
|---|---|---|
| Spawn and player ownership | Implemented in source | Actor map keyed by UserId; refreshes on character spawn |
| Follow movement | Implemented | Server-updated, smoothed follow movement |
| Seven command choices | UI and request path implemented | Attack, Protect, Scout, Track, Retrieve, Hold, Regroup |
| Command acknowledgement | Partial | Server stores the selected command and acknowledges through available animation track |
| Distinct command behaviours | Not implemented | The seven choices do not yet produce seven distinct gameplay behaviours; follow remains the core actor movement |
| Final Ember rig and animation | Not complete | Low-poly placeholder is used when an approved imported rig is unavailable |
| Android command controls | Implemented in HUD source | Touch-first positioning; physical-device usability remains untested |

### Multiplayer and persistence

- Mission state, investigation state, player state, companion actor ownership and dialogue sessions are keyed by UserId.
- Server-side proximity, phase, action and request-throttle checks are present in the relevant interaction paths.
- Client receives its own journal and mission snapshots; no global broadcast is used for private testimony.
- Profile persistence orchestration uses the existing adapter, session leases and serialized save path.
- `GameConfig.EnableProfilePersistence` remains **false by default** until private Studio DataStore validation is authorized.
- When persistence is enabled, mission phase, sequence index, current Ridgeview objective, current region, completed mission IDs and the per-player investigation record are saved/restored through the existing profile adapter.
- The save remains opt-in and is **not yet runtime-validated** against Roblox DataStore; the default configuration remains disabled.

## 2. Latest automated test evidence

**GitHub Actions run 43591379923 — PASS**  
[Open successful validation run](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/43591379923)

| Check | Result |
|---|---|
| Lune foundation regression suite | PASS |
| Lune settlement regression suite | PASS |
| Lune Ridgeview investigation suite | PASS |
| StyLua checks for the current explicit allowlist | PASS |
| Selene Luau lint | PASS |
| Rojo production place build | PASS |
| Build artifact upload | PASS |

Artifact:
- Name: `btv-roblox-place`
- Artifact ID: `14112188273`
- Generated from: `7e32af61c6f56070ad669ebbac7b669b85d4d3d7`
- Expires: **2026-11-21 11:24 UTC**
- [Open run and download artifact](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/43591379923)

### Validation scope caveat

The existing StyLua job uses an explicit file allowlist, not a whole-tree check. The current allowlist passed, but it does **not** prove every Luau file is formatted. PR #11's audit reports that 20 of 43 files fail a full-tree StyLua check. Do not interpret the current formatting pass as a whole-repository formatting pass. The dedicated format-and-widen remedy should be run after the stacked PRs are integrated, as its author recommends.

## 3. Failed runs and corrections

| Run | Result | Finding / response |
|---|---|---|
| 43589697346 | Failed | A new test asserted that the briefing still said evidence was pending after the HUD/briefing had been authored. The stale assertion was updated to test the actual briefing instruction. |
| 43589732928 | Failed | Headless tests passed; StyLua found two new test-format differences. Both were formatted. |
| 43589765502 | Failed | Headless tests passed; the temporary formatting check exposed pre-existing formatting debt in Bootstrap, ProfileSessionService and PlayerProfileSchema. Those files were removed from the narrow allowlist rather than silently broadening it. |
| 43589808990 | Failed | Headless tests passed; StyLua found formatting differences in the Ridgeview policy and settlement files. Those were corrected. |
| 43589854994 | Passed | Previous successful baseline before the active-mission persistence increment. |
| 43590360144 | Failed | Headless suites passed; StyLua flagged a blank-line formatting difference in the new schema test. Corrected. |
| 43590388382 | Failed | Headless suites passed; StyLua flagged mission-checkpoint formatting. Corrected. |
| 43590425918 | Failed | Headless suites passed; StyLua flagged mission-checkpoint formatting. Corrected. |
| 43591379923 | **Passed** | Updated active-mission persistence increment passed the configured pipeline and produced the place artifact. |

An earlier policy defect was corrected: a default false permission could be confused with an explicit private decision. A separate decision flag and schema v5 migration now prevent that. Schema v6 added validated active-mission checkpoints; schema v7 adds validated current-region state and migration. Regression coverage verifies mid-mission restoration, return/revisit region continuity, schema migration, private and consented paths, and the existing persistence adapter. Regression coverage verifies mid-mission restoration, schema migration, private and consented paths, and the existing persistence adapter.

## 4. Remaining work before a genuinely playable release candidate

### P0 — Required before calling the prototype complete
1. Validate the Temple foyer spawn, prompt flow, Ridgeview geometry, NPC dialogue, report board and completed mission state actually run in Roblox Studio.
3. Run two-client tests for player-specific journal, consent, mission state, NPC dialogue and companion ownership.
4. Validate character respawn and reconnect behaviour.
5. Test mobile HUD, touch prompts and camera on an actual Android device or authorized Studio device emulator.
6. Confirm profile save/load and lease recovery in a private test universe before enabling DataStore persistence.

### P1 — Needed for a stronger gameplay slice
1. Give Ember's seven commands distinct, canon-safe behaviours and test each one.
3. Add meaningful but canon-approved mission rewards only after the Mission/Economy Bible specifies the reward rules.
4. Improve NPC persistence and schedules; current scripted movement is a blockout routine, not persistent NPC simulation.
5. Improve environmental storytelling, NPC rigs, animation, audio, lighting and settlement detail.
6. Add loading/transition presentation and refine HUD layout at multiple phone aspect ratios.

### P2 — Later production work
- Final production character and companion assets.
- More regions and mission content.
- Broader survival, combat and world systems.
- Performance profiling at realistic server/player counts.

## 5. Runtime boundary — do not overclaim

**Confirmed:** Lune, StyLua (current allowlist), Selene and Rojo build passed on the recorded GitHub Actions run.

**Not confirmed:** Roblox Studio runtime, live multiplayer, Android device, PC device, DataStore behaviour, real server performance, NPC persistence, or player reconnection.

PR #11 contains the proposed Windows Studio runtime pipeline but remains a draft and requires maintainer authorization to install/activate. Until that happens, no genuine Studio runtime result is claimed.

## 6. Integration and governance

- This branch is stacked on PR #12's correction branch and preserves the earlier PR chain.
- PR #10, PR #11 and PR #12 remain draft and unmerged.
- No merge to `main`, publishing, paid service, destructive Git action or production DataStore enablement is included.
- The next increment must keep changes on a clearly identified branch, inspect before modifying, add regression tests and report exact commits.
