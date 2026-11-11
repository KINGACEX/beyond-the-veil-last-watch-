# BTV CHARACTER RIGGING AND GAME-ANIMATION CASE STUDY — DOGWALK
**Date:** 5 November 2026  
**Status:** PRIMARY PRACTITIONER SOURCES + GODOT 4.7 TECHNICAL CROSS-CHECK  
**Project:** Beyond the Veil: The Last Watch

## 1. Source set

- Blender Studio, “Character Rigging for Project DogWalk,” Hjalti Hjalmarsson, Animator & Rigger: https://studio.blender.org/blog/character-rigging-for-project-dogwalk/
- Blender Studio, “Animating for Project DogWalk,” Rik Schutte, Project Coordinator & Animator: https://studio.blender.org/blog/animations-for-dogwalk/
- Blender Studio, “Playable Stop Motion in Godot”: https://studio.blender.org/blog/playable-stop-motion-in-godot/
- Blender Conference 2025, “Making of DOGWALK”: https://www.youtube.com/watch?v=cbFwv-7HJlw
- Godot 4.7 retargeting documentation: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/retargeting_3d_skeletons.html
- Godot 4.7 AnimationTree documentation: https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html

## 2. Rigging lessons from the DOGWALK case

The rigger describes creating lightweight layout rigs for pre-production before the final character designs and production rigs were complete. The layout rigs worked well enough that the final rigs could be based on them, allowing some preliminary animation to be reused. The author notes the trade-off: early rig decisions can save time later, but may constrain later design choices.

The article records explicit Godot-facing constraints:
- Bendy bones were avoided because the target Godot workflow did not support them.
- Additional engine-side bones were used for specific runtime adjustments, such as swivelling an arm to follow a leash.
- Engine-side helper bones were intended to be hidden from animators and not receive authored animation.
- Camera-dependent mouth orientation required a special camera/rig relationship and a limit so the mouth could not rotate all the way around the head.
- A paper-like skirt needed to follow the body while retaining animator-adjustable parts.

### Production implication
A rig should be designed against both the animation-authoring workflow and the runtime requirements. Do not add bones, controls or constraints merely because the DCC tool supports them. Confirm the engine can import and drive them as intended.

## 3. Game animation versus film animation

The animation lead identifies interactivity as the central difference:
- In games, players can trigger actions in unpredictable orders and at arbitrary times.
- Animations must respond to input and transition into other states.
- Animators need to work with gameplay programmers to ensure loops, actions and transitions blend correctly.
- Game animation must remain readable from more than one camera angle where the player can move the camera.
- Film animation is more linear, with a predetermined camera and narrative sequence; animators can sometimes cheat toward the camera.
- Gameplay loops (idle, walk, run, interaction) and cinematics have different timing and transition needs.

This is directly relevant to BTV's planned third-person camera: character performance cannot be validated from a single fixed cinematic angle alone.

## 4. Godot 4.7 retargeting implications

Godot's documentation explains that sharing animations between skeletons requires more than matching bone names:
- Bone Rest transforms matter.
- Exported rigs can have different bone-rest orientations depending on the DCC tool.
- Godot 4 animation transforms include Bone Rest in their transform values.
- Retargeting uses BoneMap and SkeletonProfile; the Humanoid profile can auto-map common bone names, but incorrect or incomplete mappings must be reviewed.
- Import options that remove non-bone tracks may break animated accessories if used indiscriminately.

### Acceptance requirement
A retargeted clip must be visually inspected for deformation and motion quality. Import success and an automatically populated BoneMap do not prove that the animation is correct.

## 5. Godot AnimationTree implications

Godot's documentation confirms that AnimationTree does not contain animation data itself. It references an AnimationPlayer and controls advanced transitions/blending. The tree can use:
- BlendTree nodes for mixing;
- BlendSpace1D/2D for parameterised locomotion blending;
- StateMachine for named states and transitions;
- OneShot for transient actions that return to the previous animation;
- filters to limit which tracks participate in a blend.

### BTV implementation rule proposed
Start with a small AnimationPlayer set and direct playback. Add AnimationTree only when the required transitions justify the extra graph and test surface. A complex state machine should not be introduced before the character's real movement and interaction requirements are known.

## 6. Character pipeline risk register

| Risk | Control | Acceptance test |
|---|---|---|
| Layout rig blocks final design | Keep rig constraints documented and review them at model approval | Final model fits approved proportions and rig controls |
| Engine does not support a DCC feature | Check Godot 4.7 import support before rig design is locked | Test export/import with representative deformation |
| Engine helper bones confuse animators | Separate DCC animator controls from runtime-only bones | Authoring rig and runtime rig produce matching intended poses |
| Camera-facing cheat breaks gameplay camera | Test from all gameplay camera angles | No visual break under camera orbit |
| Film animation assumptions fail in gameplay | Design loops and transitions around arbitrary player input | Interrupt/restart transition matrix passes |
| Bone Rest mismatch | Establish skeleton profile and import settings | Retargeted clips preserve intended rest pose and body shape |
| Accessories stop animating | Preserve required non-bone tracks | Accessory motion survives import and retargeting |
| AnimationTree becomes overcomplicated | Start with minimum states; justify each transition | Every state/transition has a named test |
| Gameplay becomes tied to animation frame rate | Separate gameplay transform/input from visual update rate | Input response remains stable under varied frame rates |

## 7. BTV-specific safeguards
- Asher's visual baseline and age conflict remain unresolved. No rig or appearance choice is made here.
- Ember's quadruped rig and locomotion require a separate specification; humanoid retargeting assumptions do not apply.
- The DOGWALK paper-craft look and stepped animation style are case-study details, not BTV visual direction.
- Do not imply spiritual status or supernatural guidance through animation state.
- No existing BTV character asset has been modified or reimported.

## 8. Limitations
DOGWALK is a short stylized game with a small team and a deliberately constrained production schedule. Its solutions should be treated as useful examples, not a direct estimate or blueprint for a larger third-person RPG. Blender Studio's rigging/animation pages include embedded media and some project files behind membership access; this review used the accessible article content and public technical documentation only.
