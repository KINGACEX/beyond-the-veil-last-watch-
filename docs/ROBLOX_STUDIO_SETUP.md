# Build and play the Roblox prototype

This repository also contains a Godot project. The Roblox Studio project is a separate starter and does not replace the Godot files.

## What the Roblox starter includes

The Rojo project builds a small playable blockout: a spawn point, a ruined path, an objective HUD, and a watch bell players can activate with a ProximityPrompt. It uses only Roblox-built parts, so no asset imports are required.

## One-time setup

1. Install Roblox Studio from the official Roblox website and sign in.
2. Install the Rojo command-line tool and the Rojo Studio plugin, following the instructions at [rojo.space](https://rojo.space/).
3. Clone this repository to your computer and open a terminal in the repository folder.

## Option A: open a place file in Studio

From the repository root, run:

```sh
rojo build -o LastWatch.rbxlx
```

Open `LastWatch.rbxlx` in Roblox Studio. Press **Play** to run the game locally. Walk down the path to the bell and use the on-screen prompt to ring it. Use **Stop** to end the test session; use **Play** again to reset the level.

## Option B: sync edits live while Studio is open

1. Open a Baseplate place in Studio.
2. From the repository root, run `rojo serve` in a terminal.
3. In Studio, open the Rojo plugin and connect to the local Rojo server.
4. Press **Play**. Changes made to the Luau files can be synced into Studio through Rojo.

## Create and publish your own Roblox experience

In Studio, use **File → Publish to Roblox** (or **Publish to Roblox As…**) and follow the prompts to create an experience under your Roblox account. Publishing is optional for local testing. After publishing, continue building in Studio or edit the mapped Luau files in this repository and sync them with Rojo.

## Project map

- `default.project.json` — Rojo mapping.
- `src/ServerScriptService/` — server startup and generated blockout world.
- `src/ReplicatedStorage/Shared/` — shared game configuration.
- `src/StarterPlayer/StarterPlayerScripts/` — client HUD and objective feedback.

Roblox Studio itself is a desktop application and cannot be installed or launched by a GitHub commit. The setup above creates the project files and lets you run and test them on a computer with Studio installed.
