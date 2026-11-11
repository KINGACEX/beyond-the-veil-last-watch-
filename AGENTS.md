# BTV Engineering Rules

## Project baseline
- Engine: Godot 4.x, GDScript. Android-first; keep desktop testing possible.
- Preserve established BTV canon. If canon is ambiguous or conflicting, document the uncertainty; do not invent a resolution.
- Keep the prototype small, modular, readable and testable. Prefer native Godot features over new dependencies.
- Use free/local tooling by default. Do not introduce paid APIs, assets, services or credit-consuming tools.

## Workflow
- Read the relevant scene, script and design notes before editing.
- Make one coherent, reviewable change per milestone.
- Keep work on the active feature branch. Do not merge, delete, force-push, publish or deploy without explicit approval.
- Do not overwrite unrelated work. Inspect diffs and preserve existing conventions.
- Add a short implementation note and manual verification steps for each meaningful system.
- Never claim editor, runtime, export or device validation unless it was actually run and observed.

## Architecture
- Prefer composition and small scripts with explicit responsibilities.
- Use signals for decoupled scene communication where useful.
- Keep gameplay rules separate from presentation and input handling.
- Use stable, descriptive names and typed GDScript where it improves clarity.
- Avoid premature frameworks, speculative abstractions and unnecessary agents.

## BTV safeguards
- Do not add spiritual scoring, transactional prayer, purchasable salvation, faith, holiness or divine favour.
- Keep the Covenant distinct from the Church.
- Do not settle unresolved Veil metaphysics or canon conflicts in implementation.
- Defer combat and advanced Ember behaviour until their design gates are reviewed.
