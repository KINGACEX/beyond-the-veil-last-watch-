# BTV Development Checkpoint 17 — Wildlife Schema and Weather Blending — 2026-11-10

**Branch:** btv/controls-hardening-prototype-layout-plan-001  
**Validated commit:** c2325ea6eeadd924dd7d5df924a9232332966022  
**Engine target:** Godot 4.7.2  
**Status:** New data contracts implemented and CI-validated; scene-level ecology/weather work remains pending.

## 1. Confirmed validation

**PASS:** [Godot 4.7.2 CI run #42782571229](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42782571229).

All 33 validation steps passed, including project import/editor parsing, existing NLI and interaction contracts, touch controls, movement physics lab, jump/double-jump, dash, optics solver and lab, deterministic wind field, wildlife ecology simulation, the new wildlife species-profile schema, the new weather-profile blend suite, and a 10-frame headless launch of the neutral movement lab.

## 2. Wildlife profile schema

Added:
- `scripts/wildlife_species_profile.gd`
- `tests/wildlife_species_profile_test.gd`

The schema requires identity/taxonomy, temporal class, conservation status, geographic range, biomes, evidence types, sources, uncertainty notes and bounded reconstruction confidence. Deep-time profiles additionally require a geological interval, fossil locality and body-fossil or trace-fossil evidence. Fossil evidence attached to a modern/historical record requires explicit context.

This is a data completeness validator, not proof that a record is scientifically accurate. No actual species roster or region placement is approved by this checkpoint.

## 3. Weather profile blending

Added:
- `scripts/weather_profile_blend.gd`
- `tests/weather_profile_blend_test.gd`

The helper blends normalized numeric weather channels using non-negative weights, rejects mismatched schemas and produces deterministic output. Tests cover weighted blending, repeatability, bounds and invalid input handling.

No time-based weather transition, local zones, particle presentation or production climate integration is implemented yet. Wind remains excluded from player forces by default.

## 4. Next work

1. Build a small cited candidate catalogue grouped by Ghanaian reference biome, international biome and palaeo time slice; verify each record's range, age, locality and evidence.
2. Add explicit co-occurrence checks so species are not grouped solely because they share a broad biome label.
3. Build a standalone wildlife validation lab with placeholder meshes, debug labels and no production-region integration.
4. Add group-spacing, disturbance-avoidance and near/mid/far population-budget tests.
5. Build a standalone weather validation lab; test time-transition continuity and local-zone blending before visual integration.
6. Continue the optics lab toward material/lighting validation, keeping optical correctness in deterministic math.

## 5. Approval and safety gates

- Wildlife remains observation/ecology-first and nonviolent.
- Ember canon and established abilities remain unchanged.
- No unverified species are added to production regions.
- No time-travel mechanism or new story canon is implied by palaeo research.
- Weather cannot impair navigation, accessibility or puzzle readability.
- No paid service, merge to main, release or public announcement was performed.
- Physical Android QA and renderer/device profiling remain unperformed.
