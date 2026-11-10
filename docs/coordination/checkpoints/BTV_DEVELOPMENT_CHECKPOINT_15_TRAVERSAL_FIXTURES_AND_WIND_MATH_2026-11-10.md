# BTV Development Checkpoint 15 — Traversal Fixture and Wind Math — 2026-11-10

**Branch:** btv/controls-hardening-prototype-layout-plan-001  
**Godot target:** 4.7.2  
**Status:** Traversal test fixtures passed CI. Wind-field math and tests are committed; the latest full CI run is still in progress.

## 1. Traversal test fixture update

Added three separate neutral-lab wall fixtures:
- ClimbWall_Short — explicitly tagged as a test surface.
- ClimbWall_Tall — explicitly tagged as a test surface.
- ClimbWall_Untagged — deliberately left untagged for negative testing.

Updated the neutral movement lab acceptance test to assert the fixture nodes, explicit group/metadata tags and untagged negative case.

**PASS:** [Godot 4.7.2 CI run #42781407203](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42781407203), tested commit 738cd4d57837e48b68706367a7ae8763c076ac2d. Full existing suite and the updated neutral lab acceptance test passed.

These are measurement fixtures only. No wall traversal implementation or production-region integration is included.

## 2. Wind-field math implementation

Added:
- scripts/wind_field.gd — deterministic wind-vector blending, bounded sinusoidal gust offset and simplified quadratic drag calculation.
- tests/wind_field_test.gd — tests for calm air, normalized mean wind, gust blending/clamping, deterministic gust output, amplitude bounds, drag direction, quadratic speed scaling, matched air/body velocity, force caps and invalid input handling.
- A Godot CI step to run the new wind-field test suite.

The drag function is explicitly project-unit-scaled and capped. It does not apply forces to any body and does not alter player movement.

**LATEST CI:** [Run #42781545131](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42781545131), tested commit 4e524beb8e60e572635b2c6cd191db76687feac8. Status was in progress at checkpoint creation; no pass/fail claim is made for the new wind-field test until the run completes.

## 3. Research record

[ BTV Wind, Weather and Atmospheric Systems Research 001 ](../../engineering/BTV_WIND_WEATHER_AND_ATMOSPHERIC_SYSTEMS_RESEARCH_001.md)

The research recommends a deterministic vector-field/weather-profile architecture, shader-driven foliage, bounded particle effects, depth/height fog for the mobile baseline and optional advanced effects only after device profiling.

## 4. Next steps

1. Verify the latest CI run and fix any wind-field test or parser failures.
2. Add deterministic weather-profile blending and tests.
3. Build a separate weather validation scene after the state layer is stable.
4. Keep traversal work limited to safe, abstract game controls and neutral test coverage; no real-world stunt guidance or simulation.
5. Preserve the Android export/device QA gate and do not claim visual or performance validation from headless CI alone.
