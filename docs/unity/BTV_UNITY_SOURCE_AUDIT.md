# BTV Unity Port — Source Audit and Branch Record

**Status:** AUDIT RECORDED — NO UNITY RUNTIME IMPLEMENTATION YET  
**Source branch:** `btv/bootstrap-prototype-001`  
**Source commit:** `8b4c693674f8bae9542004d82e2bd379836fc4c4`  
**Unity branch:** `btv/unity-port-001`  
**Unity branch base:** exactly `8b4c693674f8bae9542004d82e2bd379836fc4c4`

## Repository verification

- Repository: `KINGACEX/beyond-the-veil-last-watch-`
- Visibility: public
- Default branch: `main`
- Audited branch: `btv/bootstrap-prototype-001`
- Audited commit: `8b4c693674f8bae9542004d82e2bd379836fc4c4`
- Recursive Git tree: 123 entries; GitHub reported `truncated=false`.
- The source branch is an actual Godot project, not merely design documentation.
- The Unity branch was created from the verified source branch commit. Godot files and history are therefore preserved in the Unity branch's ancestry.

## Existing implementation inventory

- `project.godot`: Godot project configuration.
- `scenes/main.tscn`, `scenes/player.tscn`, `scenes/test_interactable.tscn`, `scenes/touch_controls.tscn`: current prototype scenes.
- `scripts/player_controller.gd`, `scripts/interactable.gd`, `scripts/test_interactable.gd`, `scripts/touch_controls.gd`: current gameplay/input scripts.
- `scripts/nli/`: deterministic parser, intent, knowledge base, request gate, service and validator.
- `tests/nli_smoke_test.gd`: headless NLI smoke-test harness.
- `.github/workflows/godot-validation.yml`: Godot 4.7.2 CI workflow.
- `AGENTS.md`: existing engineering and canon safeguards.
- No Unity project files were present in the audited tree.

The README and implementation status describe this as a greybox foundation with an initial reusable interaction and NLI systems. The README explicitly says it is not a playable vertical slice or finished game. The status document says Android device validation remains outstanding. The README records a prior passing Godot headless CI run; this audit did not rerun Godot CI.

## Canon and design source inventory

The controlling index is `docs/source-of-truth/README.md`. It states the authority order:
1. Latest explicit creator decision/correction.
2. Master Canon as reconciled by accepted creator decisions.
3. Specialized Bibles within their domains.
4. Vertical Slice Specification for details locked to that slice.
5. Older handoffs, prompts, mockups and generated artifacts.

Key source files present:
- `docs/source-of-truth/canon/BTV_Canon_Reconciliation_and_Story_Veil_Decisions_v1.1.md`
- `docs/source-of-truth/canon/BTV_Master_Canon_v1.0.md`
- `docs/source-of-truth/characters/BTV_Character_Bible_v1.0.md`
- `docs/source-of-truth/covenant/BTV_Covenant_Bible_v1.0.md`
- `docs/source-of-truth/faith/BTV_Faith_Prayer_Armor_of_God_Bible_v1.0.md`
- `docs/source-of-truth/church/BTV_Church_HCI_Service_Communion_Bible_v1.0.md`
- `docs/source-of-truth/veil/BTV_Veil_Enemy_Encyclopedia_v1.0.md`
- `docs/source-of-truth/veil/BTV_Veil_Rules_and_Metaphysics_Bible_v0.1.md`
- `docs/source-of-truth/world/BTV_World_NPC_Bible_v1.0.md`
- `docs/source-of-truth/story/BTV_Story_and_Lore_Bible_v1.0.md`
- `docs/source-of-truth/missions/BTV_Mission_Progression_Economy_Bible_v1.0.md`
- `docs/source-of-truth/gameplay/BTV_Core_Gameplay_Specification_v1.0.md`
- `docs/source-of-truth/vertical-slice/BTV_Vertical_Slice_Specification_v1.0.md`
- `docs/source-of-truth/vertical-slice/BTV_Development_Gates_and_Backlog_v0.1.md`
- `docs/source-of-truth/visual/BTV_Foundation_12_Visual_UI_HUD_Bible_v1.1_Consistency_Lock.md`
- `docs/source-of-truth/systems/BTV_Natural_Language_Interaction_System_Spec_v0.1.md`

The source-of-truth index reports 22 imported source Markdown documents and warns that imported material is not automatically current, consistent, approved, implemented or production-ready. Preserve that distinction. Review the reconciliation document and relevant specialized Bible before implementing any domain.

## Important constraints discovered

- Existing Godot implementation must remain untouched by Unity work.
- Unity is a separate implementation of shared BTV canon/design, not a conversion that deletes or replaces Godot.
- The locked vertical slice specifies Asher's first Sunday Communion, Covenant alert and Scout Report, evidence review, journey to Ridgeview, on-foot investigation, response and final report.
- The vertical slice explicitly reserves full combat, full companion, communication and world-state systems outside its slice scope. Do not prematurely implement reserved systems.
- The Master Canon prohibits transactional prayer, spiritual scoring, purchasable salvation, faith/holiness/divine-favour currencies, and treating God or the Holy Spirit as player-controlled combat resources.
- Unknown or conflicting canon must remain marked UNKNOWN/CONFLICT and be escalated rather than invented.
- The current Godot prototype is greybox. No claim of finished characters, final art, complete gameplay or Android readiness is supported by the audited status files.

## Unity implementation policy

- Keep Unity implementation under a clearly isolated root, proposed as `UnityProject/`.
- Use C# and Unity-native scenes/prefabs/assets; do not copy GDScript or Godot scene files as executable implementation.
- Share canon and design documentation; share only engine-neutral assets/data after provenance, licence and compatibility checks.
- Unity editor version, render pipeline and Android minimum/API targets are NOT YET SELECTED. Select only after a documented compatibility and target-device review.
- Prefer free tooling and local validation. No paid Unity plan, asset, plugin, cloud build or subscription without explicit approval.
- Do not merge the Unity branch into Godot or main without separate explicit approval.

## Branch creation result

Created `btv/unity-port-001` from the exact verified source branch `btv/bootstrap-prototype-001`, whose head was `8b4c693674f8bae9542004d82e2bd379836fc4c4`.

This records branch creation only. No Unity project, C# gameplay system, Unity editor run, Android build or Unity test has been produced or verified by this audit.
