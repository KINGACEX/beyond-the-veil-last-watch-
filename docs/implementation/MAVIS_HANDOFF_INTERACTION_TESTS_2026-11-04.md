# Mavis / MCode Technical Handoff — BTV Interaction Test Coverage

**Date:** 2026-11-04  
**Receiving collaborator:** Mavis / MCode (MiniMax-M3.1-Flash)  
**Project:** Beyond the Veil: The Last Watch (BTV)  
**Repository:** https://github.com/KINGACEX/beyond-the-veil-last-watch-  
**Active development branch:** `btv/bootstrap-prototype-001`  
**Branch baseline at handoff:** `d32eda07ad911fde92817cfff21363bab346e8d2`  
**Engine target:** Godot 4.7.2  
**Task type:** Bounded, reversible technical work; no paid tools or external services.

## 1. Your role

Act as the BTV technical implementation collaborator. Independently inspect the current source and design notes before proposing changes. ChatGPT is coordinating project scope and review; the creator retains final authority over canon, consequential architecture decisions, merges, publishing and releases.

You do not have the originating ChatGPT conversation. Treat this handoff and the linked repository files as your complete task context. Do not assume that an unmentioned feature exists.

## 2. Verified project baseline

The active branch is a Godot 4.7.2 3D greybox prototype, not a finished or playable vertical slice.

**Confirmed CI evidence:**
- GitHub Actions run [41671365779](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/41671365779) passed Godot 4.7.2 installation/version check, headless editor import, all 49 NLI smoke assertions, and a 10-frame main-scene launch.
- The current documentation update on the active branch passed [run 41828295301](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/41828295301).
- The isolated GdUnit4 probe passed 3/3 parser tests and the same 49-assertion NLI suite in [run 41674587976](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/41674587976), attempt 2.
- These are headless Ubuntu CI results. They do not establish visual/editor interaction, Android export, touch usability, or physical-device readiness.

The older Library archive `BTV_Godot_Starter.zip` is separate from the active prototype and must not be described as imported or tested.

## 3. Source files to inspect first

Read these files on `btv/bootstrap-prototype-001`:

1. `AGENTS.md` — engineering rules and BTV safeguards.
2. `README.md` — repository state and validation limits.
3. `docs/implementation/BOOTSTRAP_STATUS.md` — current scope and next gate.
4. `docs/implementation/BOOTSTRAP_002_INTERACTION.md` — intended interaction contract.
5. `scripts/player_controller.gd` — movement and proximity interaction selection.
6. `scripts/interactable.gd` — reusable interactable base.
7. `scripts/test_interactable.gd` — neutral test target.
8. `scripts/touch_controls.gd` and `scenes/touch_controls.tscn` — source-level touch overlay.
9. `scenes/player.tscn`, `scenes/main.tscn`, and `scenes/test_interactable.tscn` — scene wiring.
10. `tests/nli_smoke_test.gd` and `.github/workflows/godot-validation.yml` — existing test conventions and CI command.

## 4. Assigned task

Design and, if technically sound, implement a **separate headless interaction smoke-test harness** for the existing Bootstrap 002 interaction contract.

Focus only on test coverage for:
- The player sensor detecting an interactable that enters its configured range.
- The sensor removing an interactable after it leaves range.
- The nearest valid interactable being selected when more than one is available.
- Pressing the interaction action invoking the selected target.
- No target being invoked when none is in range.
- Invalid/freed targets being safely ignored, if the current implementation supports this case.

Do not confuse a headless scene launch with proof that these behaviours work. The test must exercise the scene/script behaviour, not merely inspect source strings.

## 5. Required deliverables

Return:
1. A concise findings report identifying any defects or testability problems found.
2. A proposed test design and acceptance matrix.
3. A minimal additive patch (prefer a new test script over rewriting gameplay code).
4. Any required workflow change, kept minimal and using the existing free Godot 4.7.2 GitHub Actions runner.
5. Exact commands and observed results. If you cannot run Godot, say so and do not claim tests passed.
6. A short manual verification checklist for the editor and Android device.

If code changes are proposed, provide a unified diff or complete replacement/new file contents with exact repository paths. Keep changes isolated and reviewable. Do not merge or modify `main`.

## 6. Strict constraints

- Do not use paid credits, paid sandboxes, subscriptions, external paid APIs, or credit-consuming agent calls.
- Do not add GdUnit4 to the active branch. The GdUnit4 probe is intentionally isolated pending a later adoption review.
- Do not modify `main`, merge branches, publish, deploy, create releases, or alter repository settings.
- Do not overwrite unrelated work.
- Do not add combat, enemies, mission facts, NPC dialogue, Veil metaphysics, Ember mechanics, faith systems, economy, or new narrative content.
- Do not add any spiritual scoring, transactional prayer, purchasable salvation, faith currency, or controllable Holy Spirit mechanics.
- Do not treat NLI dialogue as evidence or allow test interactions to mutate authoritative game state.
- Keep desktop keyboard testing intact.
- Do not claim Android readiness without actual export and device evidence.

## 7. Decision boundary

You may make additive, reversible test-code proposals within this task. Flag any required production-code change separately and explain why the test cannot be achieved without it. Do not make canon, architecture, dependency, merge, release, or paid-tool decisions.

**Return your work to the creator for review before it is applied to the active branch.**
