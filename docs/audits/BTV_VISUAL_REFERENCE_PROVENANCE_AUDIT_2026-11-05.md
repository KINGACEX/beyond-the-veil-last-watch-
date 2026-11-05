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
