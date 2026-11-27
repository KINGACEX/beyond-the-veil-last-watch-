# Roblox Studio starter project

This repository currently contains a Godot project. The Roblox starter is an additional project scaffold; it does not replace the existing Godot files.

## Requirements

- Roblox Studio, installed from the official Roblox Creator Hub / Roblox website.
- [Rojo](https://rojo.space/) to sync the Luau source in this repository into Studio.
- The Rojo Studio plugin, installed from the official Rojo documentation/plugin instructions.

Roblox Studio is a desktop application, so it cannot be installed by a GitHub commit or from this repository. Install it on your computer, then follow these steps to open the starter:

1. Install Roblox Studio and sign in.
2. Install the Rojo command-line tool and Rojo plugin for Studio.
3. Clone this repository and open a terminal in its root directory.
4. Run `rojo serve`.
5. In Roblox Studio, open a new Baseplate place, open the Rojo plugin, and connect it to the local server.
6. Press **Play** to test the starter HUD and server bootstrap.

The Rojo mapping is in `default.project.json`. Luau source lives in `src/` and maps to `ReplicatedStorage`, `ServerScriptService`, and `StarterPlayerScripts` in the Roblox data model. The current scaffold provides a title/objective HUD and a minimal server join hook; build out the world, interactions, and gameplay systems in Studio.

The existing Godot files remain unchanged.
