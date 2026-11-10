# BTV Development Checkpoint 16 — Wildlife Ecology Research and Simulation — 2026-11-10

**Branch:** btv/controls-hardening-prototype-layout-plan-001  
**Engine target:** Godot 4.7.2  
**Status:** Research documented; deterministic wildlife ecology primitives and tests committed; final CI validation pending.

## 1. Research completed

Created:
[ BTV Wildlife, Biodiversity and Ecosystem Simulation Research 001 ](../../engineering/BTV_WILDLIFE_BIODIVERSITY_AND_ECOSYSTEM_SIMULATION_RESEARCH_001.md)

Research covers:
- Ghana-inspired moist forest, Guinea savanna, gallery forest, riverine, coastal wetland and highland habitat templates.
- Candidate wildlife references from Kakum, Mole, Bui and Songor.
- Species data schema, animal needs, daily routines, social grouping and habitat suitability.
- Near/mid/far/off-screen simulation tiers for Android performance.
- Weather and seasonal coupling, migration/seasonal presence and population budgets.
- Godot NavigationAgent3D, AnimationTree and scene/resource architecture.
- Evidence, species-range and canon approval gates.

The real Ghanaian reserves are ecological references only. No BTV region or final animal roster has been approved.

## 2. Simulation code implemented

Added:
- scripts/wildlife_ecology_sim.gd
- tests/wildlife_ecology_sim_test.gd

The pure deterministic module currently provides:
- Weighted habitat suitability and viability threshold.
- Nonviolent behaviour selection: shelter, drink, forage, rest and roam.
- Bounded hunger, thirst and energy updates.
- Stable ambient wander direction derived from agent ID and simulation step.

The test suite covers habitat scoring, suitability, behaviour priority, needs recovery, clamping, time bounds and deterministic wander output.

No hunting, attack, injury, capture or combat behaviour is included. No individual animal scenes, navigation, animation, species resources or population spawning have been implemented yet.

## 3. CI status

A Godot 4.7.2 workflow step has been added for the wildlife test suite. Multiple intermediate runs were cancelled by the workflow's cancel-in-progress policy as subsequent files were committed. The final branch-head workflow run must be checked before declaring the wildlife tests passed.

## 4. Next work

1. Verify the final branch-head CI run and fix parser/test failures.
2. Add species profile schema validation and a small evidence-backed sample roster.
3. Build a separate wildlife validation scene using primitive placeholder meshes and debug labels.
4. Add group spacing and nonviolent disturbance-avoidance tests.
5. Add coarse population budgets and near/mid/far LOD rules.
6. Only after those gates, connect simple animation and navigation.

## 5. Approval gates

- Final species roster and regional distribution require ecological evidence and world-map review.
- Wildlife remains an observation/ecology system, not a combat feature.
- Ember's established canon and abilities are not modified.
- Production regions remain untouched pending lab validation and Android profiling.
- No main-branch merge, release or paid service was used.
