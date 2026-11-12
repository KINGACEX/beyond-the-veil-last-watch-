# BTV Roblox CI and Studio Testing

## Automated CI

The repository workflow is `.github/workflows/roblox-validation.yml`. It runs for changes under `roblox/` on the Roblox feature branch and for pull requests targeting that branch.

The pinned toolchain is defined in `roblox/rokit.toml`:

- Rojo builds the source tree into a Roblox place file.
- StyLua checks Luau formatting without modifying files.
- Selene checks Luau source against Roblox's standard library.
- Lune runs fast, headless Luau regression tests.

The first regression suite is `roblox/tests/foundation.spec.luau`. It checks sequential mission progression, rejection of skipped or repeated phases, player-state cleanup, the eight-animal roster, free equivalents for premium candidates, Ember's seven core commands, and the shared Ember rig/animation import contract.

The workflow uploads the generated `.rbxlx` as a short-lived CI artifact. It does not publish, update, or modify any Roblox experience.

## What CI does not prove

A successful Rojo build proves that the project mapping can be serialized into a place file. Headless tests cover the pure rules they explicitly exercise. Static lint and formatting checks do not prove that runtime services, UI, physics, character rigs, remotes, or mobile controls behave correctly.

## Roblox engine validation

Roblox Open Cloud Luau Execution can run scripts headlessly inside a Roblox place and is a suitable future CI integration-test layer. It requires a dedicated test universe/place and an Open Cloud API key with narrowly scoped permissions. BTV has not yet configured those resources, so the workflow deliberately does not require secrets or contact Roblox Open Cloud.

Roblox Studio remains necessary for hands-on validation of:

- Play Solo and Start Server with multiple clients.
- Touch controls and phone-sized UI.
- Character spawning, proximity prompts and world interactions.
- Lighting, collision, camera framing and performance.

Studio's command-line interface supports scripted runs on a machine with Studio installed. A Roblox-capable self-hosted runner may be considered later; ordinary GitHub-hosted Linux runners do not provide the desktop Studio application.

## Release boundary

This is validation only. No place publishing, production upload, monetisation, asset purchases, or deployment is configured.
