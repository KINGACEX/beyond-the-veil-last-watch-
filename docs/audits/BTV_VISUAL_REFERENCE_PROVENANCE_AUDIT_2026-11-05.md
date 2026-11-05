# BTV Visual Reference Provenance Audit — 2026-11-05
Status: PARTIAL INVENTORY — one directly inspected character sheet; broader image set remains incomplete.

## Asset inspected

**Library filename:** `Asher Vance Character Showcase Sheet.png`
**Library file ID:** `file_00000000ba9482109868f0700e27bdb3`
**Format / size:** PNG, 2,107,647 bytes
**Inspection:** Original image bytes materialized read-only and visually inspected.
**GitHub status:** Not uploaded in this pass. The original remains in the Library.

### Visible contents
- Multi-view full-body character presentation: front, side and back.
- Large facial portrait and four expression examples.
- Outfit/accessory detail panels: necklace, harness/strap, fabric, backpack, boots and gloves.
- Additional environmental portrait panel.
- The sheet labels the character as Asher Vance and describes the role as protagonist / Chosen.
- Visual direction shown: dark tactical/adventure/survival clothing, backpack, gloves and boots; restrained earth/dark palette; cross necklace.

## Canon and continuity discrepancies

| Sheet content | Current governing direction | Assessment |
|---|---|---|
| Character info says **Early 20s** | Asher is presented as **18**; canon age range was 16–19 | **CONFLICT — do not use the printed age as canon** |
| Height approximately **1.85 m** | No current approved height found in governing canon | UNKNOWN; do not promote to canon |
| Athletic & functional build | General functional field-operative visual direction | Compatible as visual proposal only |
| Tactical / adventure / survival style | Tactical/formal/stealth/weather variants; white with restrained gold and cross insignia | Partially compatible; current Covenant identity styling is not demonstrated |
| Cross necklace | Cross imagery is part of BTV's Christian visual language, but accessory status and exact design are not established by this sheet alone | PROPOSED visual detail; verify against Character Bible before production |
| Backpack, gloves, boots, harness | Plausible field equipment | PROPOSED; no equipment-slot or loadout canon inferred |

The sheet is useful as a character-shape, face, expression and material reference. It is **not** a final approved model sheet. It should not be used as an authority for age, exact height, equipment inventory, rank uniform or final Covenant insignia.

## Asset handling recommendation
1. Preserve the original PNG in the Library unchanged.
2. If it is later copied into the repository, place it in a clearly labeled reference-only directory, not the runtime asset directory, until approval and licensing/provenance are established.
3. Produce a corrected derivative only after approval of any intended changes; never overwrite the original.
4. Before production use, compare face/hair/clothing proportions with the current Character Bible and the current white + restrained-gold Covenant visual direction.
5. Do not assume this image is the same asset as the separately archived `Asher_Vance.glb`; a visual match and model provenance have not been established.

## Search coverage and limitations
Targeted Library semantic searches were run for Asher, Ember, Covenant clothing, Ridgeview/Logos Rhema environments, and older Godot prototype ZIPs. They surfaced the Asher showcase sheet and multiple relevant design bibles, but did not return a confirmed Ember concept image or a confirmed environment concept image in the results inspected here.

Previously identified older ZIP packages remain blocked from raw-byte materialization:
- `BeyondTheVeil_v0_1_foundation.zip`
- `BeyondTheVeil_v0_1_1_foundation.zip`
- `BeyondTheVeil_v0_1_2_foundation_fixed.zip`
- `BeyondTheVeil_PlayerFoundation_v0_2.zip`
- `BeyondTheVeil_DevelopmentBuild_v0_3.zip`
- `BeyondTheVeil_Visual_Design_Sandbox_v0_1.zip`
- `BeyondTheVeil_VisualPrototype_Full_v0_4.zip`

The prior access attempt returned an authorization/materialization block for each. No contents were read, no files were modified and no access control was bypassed. Their contents remain UNKNOWN.

## Outcome
- **COMPLETED:** One Asher character showcase PNG directly inspected.
- **CONFIRMED:** The sheet contains a printed age conflict (Early 20s versus current age 18).
- **PROPOSED:** Use only as a non-authoritative visual reference pending canon and provenance checks.
- **UNKNOWN:** Ember/environment concept art availability in the searched results; older ZIP contents; relationship between this sheet and the Asher GLB.
- **NO CODE CHANGE:** No runtime asset or project file modified.
- **NO BUILD/TEST:** No Godot import, scene, Android or device test performed.

## Correction — governing visual and Ember sources checked after initial issue

This section supersedes any earlier implication in this report that Ember's species/lineage is UNKNOWN.

### Ember: source-of-truth correction

The Library's **Foundation #11 — Ember Companion Bible v1.0** (PDF; 4 pages) was materialized read-only and its complete text inspected. It is marked **ESTABLISHED CANON-CANDIDATE / RECOMMENDED CANON LOCK** and its canon-lock summary/appendix explicitly marks the following as LOCK:
- rare original canid lineage (original wild-dog/canid lineage);
- natural created origin, with innate/limited Veil sensitivity;
- remote wilderness and long-term Veil exposure;
- companion and field-partner relationship with Asher;
- no conventional RPG skill tree;
- layered context-aware companion AI;
- survival/protection priorities and contextual commands;
- no replacement of God, Christ, Scripture, prayer or the Holy Spirit.

The exact appearance and breed characteristics remain OPEN. The v1.1 Visual/UI/HUD Consistency Lock independently describes Ember as a believable canid and locks the continuity direction (no wings, demonic anatomy, cybernetics, angelic transformation or human speech).

**Correction to previous wording:** “Ember species UNKNOWN” is not supported by the available Foundation #11 source. The correct distinction is **lineage LOCKED; exact appearance OPEN**. The old Character Bible v1.0 contains an older generic “species/origin/history UNKNOWN” entry and should be treated as stale where it conflicts with the more specific Foundation #11 lock and v1.1 visual lock. This is a documentation reconciliation issue, not a new canon decision.

### Asher: visual continuity source

The v1.1 Visual/UI/HUD Consistency Lock identifies the approved Asher gameplay references as the visual baseline and requires a young field-operative presentation with consistent face, hairstyle, proportions and practical equipment. It also explicitly says not to redesign Asher as an older adult action hero. The older Character Bible v1.0 records age 16–19; the later explicit creator decision establishes age 18. Therefore the showcase sheet's printed “Early 20s” remains a clear conflict.

The sheet is still useful as a provisional face/shape/expression and clothing reference, but its printed age, approximate 1.85 m height, and equipment details are not authority. Its dark tactical outfit does not by itself satisfy the Covenant's white base, restrained gold and cross-centered insignia direction. The necklace and loadout remain proposed visual details unless separately confirmed.

### Important distinction

The v1.1 visual lock refers to supplied **gameplay references** as approved visual baseline. This audit has directly inspected only the named Asher showcase sheet and the Asher GLB package metadata/contents previously reported. It has **not** yet established that the showcase sheet itself is one of the approved gameplay references, nor that the GLB visually matches it. That link remains UNKNOWN.

### Updated outcome
- **CONFIRMED:** Ember's original rare canid lineage is locked by Foundation #11; exact appearance remains open.
- **CONFIRMED:** v1.1 Visual/UI/HUD lock provides a cross-document continuity baseline for Asher, Ember, Covenant, environment and HUD.
- **CONFLICT:** Asher showcase sheet's “Early 20s” conflicts with current age 18.
- **STALE SOURCE:** Character Bible v1.0's generic Ember species/origin UNKNOWN entry is superseded in this domain by the more specific Foundation #11 lock and v1.1 consistency lock.
- **UNKNOWN:** Whether this specific Asher showcase sheet is among the approved gameplay references; whether the GLB matches it; whether additional original Ember/environment gameplay-reference images can be surfaced.
