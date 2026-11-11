# Logos Rhema Temple — Roblox Visual Prototype

**Status:** IMPLEMENTED AS SOURCE / PROPOSED VISUAL STUDY / NOT STUDIO-VERIFIED  
**Scope:** First opening-slice environment study for the Roblox edition.  
**Canon authority:** Subordinate to the BTV Master Canon and the Church, World, and Visual/UI/HUD references.

## Purpose

Create a first authored environment that supports the approved opening sequence, which begins in the Communion context at Logos Rhema Temple. This prototype is intended to replace an empty greybox with a readable, original contemporary church environment built from Roblox-native parts.

## Canon boundaries

- Logos Rhema Temple is the approved fictional in-game church.
- The scene does not copy Harvest Chapel International or any real-world church building.
- The Church remains distinct from the Covenant.
- No Covenant insignia, Covenant facility styling, or invented Covenant personnel are placed in this church.
- No named church leaders, NPCs, service order, doctrine, dialogue, or institutional history are invented.
- The Communion table is environmental set dressing only. No Communion item, interaction, reward, buff, stat change, currency, or XP mechanic is implemented.
- The room layout, dimensions, materials, furniture arrangement, and signage treatment are a **PROPOSED VISUAL LAYOUT**, not locked canon.
- The scene does not resolve any unknown world-map, regional, architectural, or character details.

## Included in the source prototype

The server-side scene builder creates:

- a contemporary sanctuary and attached foyer;
- a stone/concrete and timber material palette with restrained blue and gold accents;
- tall side glazing, structural columns, roof fascia, and ceiling beams;
- a restrained cross feature wall;
- a simple front platform, lectern, and unadorned Communion table;
- balanced seating blocks with a central aisle;
- warm, restrained interior point lighting;
- an original exterior approach, walkway, planters, low-cost trees, and temple name sign;
- a neutral foyer spawn point for prototype inspection.

The scene is generated under `Workspace/BTV_World/LogosRhemaTemple_VisualPrototype`. The builder is idempotent within a server session: it skips creation if that scene already exists.

## Deliberate omissions

- Asher's final model and clothing: BLOCKED pending approved visual reference assets.
- Ember's final model, anatomy, rig, and animation: BLOCKED pending approved reference assets.
- Named congregation members, church staff, or dialogue: UNKNOWN; no characters are fabricated.
- Final architectural approval, service choreography, and interior decoration: PROPOSED / creator review.
- Communion interaction and the larger opening mission sequence: not implemented.
- Audio, music, and Scripture text: not added; no unreviewed compositions or quotations.
- Final lighting profiles and mobile performance: require Roblox Studio/device profiling.

## Technical constraints

- Geometry uses anchored Roblox Parts and built-in materials; no paid assets, external asset IDs, or third-party models.
- The environment is a first visual pass, not a claim of AAA asset quality.
- Runtime geometry count, draw calls, memory, and frame rate have not been measured.
- The server script has not yet been executed in Roblox Studio.
- The scene should be reviewed on a low/mid-range Android device before increasing detail or effects.

## Next review gates

1. Import the Rojo project into Roblox Studio and confirm the scene script executes.
2. Inspect collision, entrance clearance, camera sightlines, lighting, and scale.
3. Profile on Android and reduce geometry or lighting where required.
4. Compare the result against approved BTV church/visual references.
5. Obtain creator review before treating the layout as final.
6. Add the approved Asher and Ember assets only after their reference dependencies are available.

## Current verification

- Source file committed: YES.
- Repository read-back: VERIFIED after commit.
- Luau syntax/type check: NOT RUN.
- Roblox Studio execution: NOT RUN.
- Android performance test: NOT RUN.
