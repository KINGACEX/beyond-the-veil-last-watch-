# BTV Development Checkpoint 18 — Wildlife LOD, Weather Transitions and Candidate Catalogue — 2026-11-10

**Branch:** btv/controls-hardening-prototype-layout-plan-001  
**Code-validation commit:** 9af715573304c520707c4ca92e12e8141d502d23  
**Engine target:** Godot 4.7.2  
**Status:** Code suites passed; documentation updated; latest documentation-triggered workflow pending.

## 1. Code changes

### Wildlife ecology

Expanded `scripts/wildlife_ecology_sim.gd` with:
- Distance-based near, mid, far and offscreen simulation tiers.
- Bounded group-separation steering hints, including deterministic handling for coincident positions.
- Nonviolent observer-disturbance responses: calm, pause and assess, retreat toward cover, or increase distance.

The caller still owns navigation, collision, animation and speed constraints. No production wildlife agents or species placements are created.

### Weather transitions

Expanded `scripts/weather_profile_blend.gd` with stateless profile interpolation. It clamps normalized progress and uses the existing schema-checked weighted blender. The caller owns time progression and easing. No visual weather effects or production climate integration are connected.

## 2. Validation

**PASS:** [Godot 4.7.2 CI run #42783248175](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42783248175).

All workflow steps passed, including project import, existing regression suites, wildlife ecology, species-profile schema, deterministic wind, weather-profile interpolation, optics tests and neutral movement lab launch.

An earlier run (#42783113662) failed one overly strict floating-point test assertion. The assertion tolerance was corrected; the separation implementation was not changed. The succeeding run #42783248175 passed the full suite.

## 3. Research catalogue

Added [BTV Wildlife Candidate Catalogue Research 001](../../engineering/BTV_WILDLIFE_CANDIDATE_CATALOGUE_RESEARCH_001.md).

The catalogue uses official Ghana Forestry Commission references for Kakum, Mole and Bui; the Ramsar Information Sheet for Songor; U.S. National Park Service material for Pleistocene Beringia; and Queensland Museum fossil records. It distinguishes modern habitat references from separate palaeo localities and time periods. It explicitly avoids claiming that all listed animals coexisted.

The catalogue is a research shortlist, not a production species roster. Scientific taxonomy, exact localities, dated evidence, conservation status and uncertainties must be verified for each resource before approval.

## 4. Files updated

- `scripts/wildlife_ecology_sim.gd`
- `tests/wildlife_ecology_sim_test.gd`
- `scripts/weather_profile_blend.gd`
- `tests/weather_profile_blend_test.gd`
- `docs/engineering/BTV_WILDLIFE_BIODIVERSITY_AND_ECOSYSTEM_SIMULATION_RESEARCH_001.md`
- `docs/engineering/BTV_WIND_WEATHER_AND_ATMOSPHERIC_SYSTEMS_RESEARCH_001.md`
- `docs/engineering/BTV_WILDLIFE_CANDIDATE_CATALOGUE_RESEARCH_001.md`
- `docs/engineering/BTV_PROTOTYPE_LAYOUT_AND_FEEL_PLAN_001.md`

## 5. Next work

1. Build an isolated wildlife validation scene with primitive placeholders and debug labels; do not use production species art yet.
2. Add tests for population budgets and deterministic near/mid/far update scheduling.
3. Build a standalone weather validation lab for transition continuity, local-zone blending and visual fallbacks.
4. Extend optics validation with material/light response cases while keeping optical calculations deterministic.
5. Continue wall-climb and ledge-mantle movement research and test-state design; do not promote traversal fixtures into player abilities until reviewed.
6. Keep Android export, physical-device profiling and renderer choice open until device QA is possible.

## 6. Approval and scope controls

- No production region or Ridgeview content was modified.
- Wildlife remains nonviolent observation/ecology simulation.
- Ember canon and abilities remain unchanged.
- Palaeo research does not imply time travel or a story-canon change.
- No main-branch merge, public release, paid service or permission expansion was performed.
- Physical Android QA remains unperformed.
