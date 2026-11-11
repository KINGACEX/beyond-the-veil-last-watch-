# BTV Legacy Archive Inspection — Website, Asher Asset and Older Packages
Date: 2026-11-05

## Purpose
Continue recovery of older BTV Library material without changing active game code or overwriting originals.

## CONFIRMED — Website prototype ZIP inspected

Library source: `Beyond_The_Veil_Website_v1.zip` (7,161 bytes).

Archive entries:
- `README.md` (961 bytes)
- `index.html` (8,450 bytes)
- `css/styles.css` (6,136 bytes)
- `js/app.js` (1,519 bytes)
- `css/` and `js/` directories

SHA-256: `a36f40e83c9f5570f8c9b570570a5870a936e426a787f19cee7aab20b072453c`

This is a static website prototype, not a Godot game. Its source includes known superseded/conflicting material:
- “The other Chosen” remains important to the story, contradicting the current sole-playable-protagonist direction.
- Ember codex preview includes “Spiritual Awakening,” which is not an approved ability and conflicts with the current five named ability list.
- It presents equipment/progression, relationships, teamwork and broad world-scale features as if established, though these were not verified as implemented.
- Enemy categories and descriptions need reconciliation against the current Veil/Enemy Bible.
- No public prototype/pre-production disclosure is present in the captured page text.
- Google Fonts are externally imported by CSS; offline behavior and privacy implications were not tested.

A separate review file already records v1.2 local edits and remaining checks: `docs/audits/BTV_Static_Website_Review_v1_2_Library_Copy.md`. The inspected ZIP is v1; do not treat its contents as current marketing copy or canon.

## CONFIRMED — Asher Godot asset ZIP inspected

Library source: `Asher_Vance_Godot_Ready.zip` (1,095,295 bytes).

Archive entries:
- `Asher_Vance.glb` (1,931,524 bytes uncompressed)
- `Asher_Vance.tscn` (179 bytes)
- `Asher_Vance.glb.import` (452 bytes)
- `README.txt` (586 bytes)

SHA-256: `554bd71033f110d9b2fab4fc5302fbe51b38ae75dc60df310535a55d20edd310`

The GLB is a character asset package with a simple Godot scene wrapper. It does not contain `project.godot`, scripts, gameplay, or a complete game project. The README says the files are under `characters/`, but the ZIP stores them at its root; this is a packaging-path discrepancy to correct only if the asset is later integrated. No GLB import or Godot runtime test was performed.

## Additional source integrity hashes

- `BTV Canon Changelog & Reconciliation v1.0.docx` — SHA-256 `f582cffda10f2568bdccfa76720a748e5dc21416edc8586c757a2b8aaeea3d4f`
- `BTV_Foundation_12_Visual_UI_HUD_Bible_v1.0.pdf` — SHA-256 `6474c5e4f171c3775fc0eab08d548198713779dc2fd7a5c8573eda0985451b31`
- `BTV_Master_Development_Handoff.pdf` (42-page, 240,616-byte copy) — SHA-256 `83e266a109e9713454eb8aa38bd3043258673a0751cff15fcefb2672c3cf5df5`

The 42-page Master Development Handoff has been text-extracted to `docs/source-of-truth/legacy-extracts/BTV_Master_Development_Handoff_42p_legacy.extracted.md`. It is historical and contains older material; current creator decisions and Canon Reconciliation v1.1 supersede it.

## Older prototype ZIPs — BLOCKED from binary inspection

The Library lists these packages:
- `BeyondTheVeil_v0_1_foundation.zip`
- `BeyondTheVeil_v0_1_1_foundation.zip`
- `BeyondTheVeil_v0_1_2_foundation_fixed.zip`
- `BeyondTheVeil_PlayerFoundation_v0_2.zip`
- `BeyondTheVeil_DevelopmentBuild_v0_3.zip`
- `BeyondTheVeil_Visual_Design_Sandbox_v0_1.zip`
- `BeyondTheVeil_VisualPrototype_Full_v0_4.zip`

Attempted raw-byte materialization of the first five returned an authorization-path warning. No archive bytes were accessed, extracted, modified or uploaded. Their contents, project completeness and relationship to the current repository remain UNKNOWN. The remaining two (Visual Design Sandbox v0.1 and VisualPrototype Full v0.4) were also attempted; both returned the same raw-byte authorization-path warning. Their contents remain uninspected.

Other indexed packages include Android-ready/CanonAligned builds, Godot starter/repository foundation packages, Ridgeview work packs and a website archive. Their binaries have not been comprehensively inspected.

## DOCX/PDF archival additions

Additional text extractions now include:
- `docs/source-of-truth/legacy-extracts/BTV_Canon_Changelog_Reconciliation_v1.0_legacy.md`
- `docs/source-of-truth/legacy-extracts/BTV_Master_Development_Handoff_42p_legacy.extracted.md`
- `docs/source-of-truth/legacy-extracts/BTV_Vertical_Slice_Specification_v0.1_legacy.md`
- `docs/source-of-truth/legacy-extracts/BTV_Ridgeview_Case_Design_v0.1_legacy.md`
- `docs/source-of-truth/legacy-extracts/BTV_NLI_Specification_v0.1_legacy.md`
- `docs/audits/BTV_Static_Website_Review_v1_2_Library_Copy.md`

These are archival text, not binary originals. Layout, diagrams and embedded media may be absent.

## Delivery boundary

- No game code changed.
- No active project assets were overwritten.
- No old prototype ZIP was merged into the repository.
- No Godot import, editor, Android export, device test or build was run.
- Original Library files remain untouched.

## Next safe action
Continue inventorying relevant Library files and deduplicating by file identity/hash where possible. For prototype ZIPs that cannot be materialized, record the access limitation rather than inferring their contents. If raw bytes become accessible, inspect each archive in isolation, identify any `project.godot`, scene/script inventory, engine version and provenance, then compare with the current GitHub branch without merging.
