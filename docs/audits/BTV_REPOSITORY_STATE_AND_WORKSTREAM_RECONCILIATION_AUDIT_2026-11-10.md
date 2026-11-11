# BTV Repository State and Workstream Reconciliation Audit — 2026-11-10

**Status:** READ-ONLY INSPECTION COMPLETED; documentation alignment action recorded  
**Audited branch:** `btv/controls-hardening-prototype-layout-plan-001`  
**Audited HEAD:** `8bce9a4ce497f6ca36a3aa0344e16b49d72b0d68`  
**Latest verified CI:** [Run #42783455949](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42783455949) — 35/35 workflow steps successful.

## 1. Repository and branch state

- Repository: `KINGACEX/beyond-the-veil-last-watch-`.
- Default branch: `main`, at `d3b028a4488dd0c48489924ea88e9710e266ef0a` during this audit.
- Current engineering branch: `btv/controls-hardening-prototype-layout-plan-001`, at `8bce9a4ce497f6ca36a3aa0344e16b49d72b0d68`.
- The audited engineering branch is isolated from `main`; no merge or release was performed.
- CI is configured for the audited branch and pins Godot 4.7.2.
- The project main scene remains `scenes/movement_physics_lab.tscn`; this is a neutral test laboratory, not the Ridgeview playable slice.

## 2. Latest CI evidence

Run #42783455949 completed successfully on the audited HEAD. The inspected job reported success for:
- Godot 4.7.2 installation/version verification and headless editor import;
- NLI and mission-data contracts;
- camera, keyboard/touch input and touch lifecycle/composition suites;
- movement physics and collision suites;
- jump/double-jump and traversal-dash suites;
- deterministic optics solver and optics validation lab;
- wind field, wildlife ecology, wildlife species schema and weather profile blending;
- 10-frame neutral movement lab launch.

This is automated headless validation only. It is not a rendered visual inspection, human movement-feel acceptance, Android export/install, physical touch test, or sustained device benchmark.

## 3. Open pull requests and parallel-agent reconciliation

The repository currently has these relevant open draft PRs:
- PR #7: `btv/agent-minimax-xh-003`, XH-003 touch/keyboard source ownership.
- PR #6: `btv/xh-003-input-source-composition-spec-001`, a parallel XH-003 implementation.
- PR #5: MiniMax evidence pack.
- PR #4: XH-002 touch-input hardening.
- PR #2: mission-validator strict types.

PR #6 and PR #7 explicitly implement the same XH-003 design against the same earlier base and must not be merged independently. The audited branch already contains a separate touch action namespace and corresponding touch composition/coexistence tests. No PR was merged, edited, closed or cherry-picked during this audit.

The MiniMax evidence and XH-003 branches are divergent from the audited branch. They remain review sources, not safe fast-forward candidates. Any reconciliation requires a file-level diff and test comparison; do not merge the full branches wholesale.

## 4. Existing visual/environment foundations found

The repository already contains:
- `docs/art/BTV_VISUAL_ART_BIBLE_v1.0.md`;
- `docs/technical/BTV_TECHNICAL_GRAPHICS_SPECIFICATION_v1.0.md`;
- `docs/research/BTV_ANDROID_GRAPHICS_AND_DEVICE_BENCHMARK_RESEARCH_2026-11-06.md`;
- `docs/qa/BTV_NEUTRAL_GRAPHICS_BENCHMARK_SCENE_ACCEPTANCE_CONTRACT_v1.0.md`;
- lighting/optics, wind/weather, wildlife ecology and wildlife candidate catalogue research;
- `scenes/optics_validation_lab.tscn` and `scenes/movement_physics_lab.tscn`.

Avoid creating duplicate visual bibles or benchmark contracts. The next useful step is to extend the existing pure simulation primitives and establish deterministic test seams. A wildlife validation scene and weather presentation lab are still not present in the audited tree.

## 5. Documentation drift found

At audit time, `README.md` and `docs/implementation/BOOTSTRAP_STATUS.md` still described `btv/test-first-contracts-001` as the active branch and cited older CI runs. The README also linked the existing visual/graphics benchmark documents but did not reflect the current movement, optics, wind, wildlife and weather validation coverage.

The README's active-branch and latest-validation pointers are aligned in this milestone. The bootstrap status document is retained as a historical baseline and points readers to this audit rather than having its historical implementation record rewritten.

## 6. Confirmed / unknown / blocked

**CONFIRMED**
- The audited branch and commit are accessible.
- The latest audited CI run passed all 35 steps.
- The current test scene is a neutral movement lab.
- Existing visual, graphics and Android benchmark specifications are present.
- XH-003 parallel PRs remain open drafts and require reconciliation.

**UNKNOWN**
- Physical Android performance, memory, thermal behaviour and touch latency.
- Final renderer choice and minimum supported device.
- Visual quality of production materials, wildlife models, vegetation and lighting on device.
- Human acceptance of final movement feel.

**BLOCKED**
- Android export/device acceptance until a target device and export test path are available.
- Ridgeview production blockout until movement Gate C is formally accepted.
- PR reconciliation/merge pending explicit creator review.

## 7. Actions taken and boundaries

- No branch was merged, rebased, force-pushed or deleted.
- No PR was changed.
- No paid service, external dependency, credential or permission was added.
- No canon, story, character or production-region data was changed.
- README status pointers were corrected; the historical bootstrap status was annotated.
