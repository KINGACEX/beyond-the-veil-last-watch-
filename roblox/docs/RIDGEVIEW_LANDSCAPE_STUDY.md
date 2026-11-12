# Ridgeview Landscape Study

**Status:** Proposed visual study only; not canon-locked and not Studio-verified.

## Purpose

Provide a first substantial outdoor environment prototype for the Roblox opening-slice workstream while the authoritative Ridgeview geography remains unresolved.

## Implemented source

`src/server/World/RidgeviewLandscapeStudy.server.luau` creates a separate scene under `Workspace/BTV_World`, offset from the Logos Rhema Temple prototype so the two studies do not overlap.

The scene contains:
- Broad layered grassland and ridge forms.
- Stone outcrops and low-poly woodland clusters.
- A curved road and a separate footpath.
- A small stream surface used only as environmental scenery.
- A modest lookout platform connected visually to the trail.
- Lightweight, non-interactive trail posts.
- An invisible, non-colliding arrival marker at the footpath start, shared by the opening mission's travel and respawn-recovery code.

The builder uses Roblox-native Parts and Models. It introduces no external assets, named residents, mission clues, authored Scout Report evidence, settlements, Covenant facilities, or new story facts.

## Deliberate boundaries

- This is not a final Ridgeview map layout.
- The road, stream, woodland and lookout are visual proposals, not established canon.
- The scene contains no mission logic; its arrival marker is only a stable spatial anchor. The opening mission owns the gated transition and player teleport.
- No combat, rewards, evidence detection, collection loop, or companion advantage is added.
- The scene has not been executed or profiled in Roblox Studio.

## Studio review checklist

1. Confirm the Ridgeview scene appears separately from the Temple prototype.
2. Inspect road and footpath alignment, lookout access, arrival-marker placement, and collision.
3. Check that hills, trees and outcrops do not create unintended spawn traps.
4. Inspect draw calls, shadows and frame time on a low/mid-range Android device.
5. Compare the scene against the approved visual direction before treating any geography as canon.
