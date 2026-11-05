# BTV GODOT 4.7 WORLD NAVIGATION AND REGION-BOUNDARY RESEARCH
**Date:** 5 November 2026  
**Status:** OFFICIAL ENGINE DOCUMENTATION REVIEW — proposed implications only  
**Project:** Beyond the Veil: The Last Watch  
**Scope:** NavigationServer3D, NavigationRegion3D, navmesh boundaries, region connections and bake performance.

## 1. Godot 4.7 navigation architecture

Godot's 3D navigation system uses NavigationServer3D and navigation maps:
- A navigation map contains navigation regions.
- A NavigationRegion3D provides a NavigationMesh resource defining walkable space.
- Regions can be enabled/disabled and assigned to maps.
- Regions can connect by proximity when their compatible edges are within the map's edge-connection margin.
- NavigationAgent3D uses the navigation map to request paths and manage movement-related navigation queries.

Official sources:
- 3D navigation overview: https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_introduction_3d.html
- NavigationServer3D: https://docs.godotengine.org/en/stable/classes/class_navigationserver3d.html
- NavigationRegion3D: https://docs.godotengine.org/en/stable/classes/class_navigationregion3d.html
- Using navigation meshes: https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationmeshes.html
- Connecting navigation meshes: https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_connecting_navmesh.html
- NavigationAgent3D: https://docs.godotengine.org/en/stable/classes/class_navigationagent3d.html

## 2. Important performance and correctness details

Godot's documentation highlights:
- Navigation mesh baking is normally performed on a background thread when supported.
- Runtime performance problems can come from parsing source geometry from the SceneTree, not only from the bake itself.
- Simplifying/merging geometry and using simpler collision shapes can reduce parsing work compared with detailed visual meshes.
- Forcing an immediate navigation-map update flushes queued NavigationServer commands and can be expensive or introduce bugs if used without care.
- Overlapping navigation meshes from different regions should generally be avoided; closest-region ownership can otherwise be unexpected.
- Navigation region edge connections should be designed deliberately, not used as a substitute for correct level boundaries.

These points matter for a region-based game because a large number of decorative meshes should not automatically become navigation source geometry.

## 3. Proposed BTV design implications

These are **PROPOSED**, not approved architecture:
1. Keep visual geometry, collision geometry and navigation geometry conceptually separate.
2. Bake navigation from simplified, intentional walkable geometry rather than every decorative mesh.
3. Treat navmesh boundaries as part of level design: players should understand where a path ends or a traversal route changes.
4. If a region is split into multiple navigation regions, validate that intended connections work and unintended gaps/overlaps do not.
5. Avoid forcing immediate map updates during ordinary gameplay unless a measured requirement justifies it.
6. Do not select a world-streaming or map-partitioning architecture before the actual region layout, target device and NPC navigation requirements are known.

## 4. Navigation acceptance tests for a future BTV region

Before a region is accepted:
- Player can traverse all intended walkable routes.
- NPC/companion navigation does not cut through walls or inaccessible slopes.
- Navigation boundaries align with visible and collision boundaries.
- Region transitions connect where intended and remain disconnected where intended.
- Doors, gates and temporary blockers have explicit navigation behaviour.
- Narrow passages and small obstacles do not create unexpected path failures.
- Unreachable destinations return a safe failure rather than an infinite retry or teleport.
- Navigation remains stable after region enable/disable or scene transitions.
- Repeated navigation queries do not trigger unnecessary immediate map synchronisation.
- Bake and runtime costs are measured on representative geometry and, later, the verified target device.

## 5. BTV-specific constraints
- Do not turn the semi-open interconnected world into a seamless open world by implication.
- Do not add Ridgeview or mission navigation content until the recovered Vertical Slice v1.0 and Ridgeview data contracts are the source.
- Do not infer hidden paths, secret areas or supernatural navigation from generic engine examples.
- Do not claim Android navigation performance without target-device evidence.

## 6. Limitations
This is a documentation review, not an implemented navigation system. No BTV NavigationRegion3D, NavigationMesh, NavigationAgent3D, map partition or region-streaming system was added or tested.
