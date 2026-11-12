# Runtime geometry counts — source-derived

**Method:** the builder loops in `LogosRhemaTemplePrototype.server.luau` and
`RidgeviewLandscapeStudy.server.luau` were expanded by hand from the committed source.
**These are not runtime measurements.** Roblox Studio was not available, so no draw-call,
memory or frame-time figure exists for any of it.

| Builder | Parts |
|---|---|
| Logos Rhema temple | 177 |
| Ridgeview landscape study | 112 |
| Curiosity Archive | 22 |
| **Static world created at join** | **311** |
| Ember placeholder (per player) | 27 (+1 BillboardGui, +1 TextLabel) |

Temple breakdown: foundations 4 · side walls 12 · windows and sills 16 · front/rear walls 4 ·
foyer shell, glass and roof 13 · main roof and trims 3 · interior columns 16 · ceiling beams 4 ·
feature wall and cross 3 · platform 2 · lectern 3 · Communion table 5 · benches 48 ·
light housings 5 · welcome desk and signage 3 · forecourt, walkway and planters 4 · shrubs 6 ·
trees 24 · spawn and status 2.

Ridgeview breakdown: landscape base 1 · hill masses 6 · stone outcrops 6 · road and shoulders 12 ·
footpath segments 6 · stream segments 3 · trees 68 · lookout 6 · trail posts 2 ·
arrival marker 1 · status 1.

**Consequences for Android (see the audit, §7):** 311 runtime-created instances are
replicated to every client at join, 48 of the temple parts are bench colliders, and the whole
environment is invisible in the Studio hierarchy — visual iteration currently requires code
changes and a Play-mode reload.
