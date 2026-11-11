# BTV Roblox — Android-First Workflow

**Primary device:** Android phone  
**Cost policy:** Free-first; no paid subscriptions, credits, assets or APIs without explicit approval.

## What Android can do

- inspect and edit source files through GitHub mobile/web;
- create and review feature branches and commits;
- edit Markdown, JSON and Luau source;
- review diffs and change history;
- prepare UI layouts, asset briefs and environment specifications;
- play Roblox experiences and test published/private builds when available;
- record device observations, screenshots and defects.

## What Android cannot do natively

Roblox Studio is a Windows/macOS desktop application. The Roblox Android player is not a Studio editor. Android cannot locally run Studio's full 3D scene editor, publish workflow, or the Studio test-server/client simulator.

Do not represent a Luau file committed to GitHub as a playable Roblox game until it has been imported and run in Studio.

## Recommended phone workflow

1. Open the BTV repository in GitHub.
2. Switch to `btv/roblox-foundation-001`.
3. Work only under `roblox/` for Roblox-specific changes.
4. Use GitHub's browser editor (github.dev) for multi-file editing where practical; use GitHub mobile for review and branch/commit visibility.
5. Make one small change per commit with a clear message.
6. Review the diff before committing.
7. Keep a short manual test note in the relevant docs.
8. Do not merge to the Godot workstream or main branch without explicit approval.

## Optional Android terminal

A terminal such as Termux can support Git and text-based utilities, but it does not make Roblox Studio available on Android. Install only from a trusted official distribution source and do not store GitHub personal access tokens in shared scripts, screenshots or repository files. A terminal is optional; GitHub's web editor is the simpler baseline.

## Desktop integration handoff

When Windows/macOS access becomes available:
1. Install Roblox Studio from the official Roblox Creator site.
2. Install Rojo from its official project/release source.
3. Open the Roblox Studio project and connect Rojo to `roblox/default.project.json`.
4. Sync the source tree into a new, private test place.
5. Inspect the DataModel mapping and script placement.
6. Run Luau lint/type checks and Studio Play Solo.
7. Run a local server with at least two clients.
8. Test touch controls using Studio's device emulator, then on a real Android device.
9. Fix all errors before creating any public release.

## No false validation claims

Until Studio execution has actually occurred, report:
- source authored: yes/no;
- source reviewed: yes/no;
- Luau lint: not run / pass / fail;
- Studio import: not run / pass / fail;
- multiplayer test: not run / pass / fail;
- Android device test: not run / pass / fail.

## Device test record template

- Device/model:
- Android version:
- Roblox app version:
- Place version/build:
- Network type:
- Average observed frame rate (if measured):
- Input issues:
- UI readability:
- Camera issues:
- Network replication issues:
- Reproduction steps:
- Evidence link:
