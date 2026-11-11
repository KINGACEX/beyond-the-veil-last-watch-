# PDF text extraction — BTV_AI_Development_Stack.pdf

> **ARCHIVAL REFERENCE.** Extracted text from the original Library PDF. Treat as historical/proposal material unless current canon or later creator decisions confirm it. The original PDF remains in ChatGPT Library. PDF layout, typography, diagrams and embedded images are not represented by this text extraction.

- Source file: `BTV_AI_Development_Stack.pdf`
- Extraction: complete according to Files read result (`has_more=false`)

---

<PARSED TEXT FOR PAGE: 1 / 9>
Beyond the Veil: The Last Watch • AI Development Stack Page 1
BEYOND THE VEIL: THE LAST WATCH
AI DEVELOPMENT STACK • PRESENTATION & ACTION PLAN
YOU
Creative Director / final
authority
THE STACK
Design  Engineering  Art  Game  Version
Control
A polished PDF version of the BTV development-stack guidance, with the original wording preserved and an
actionable execution layer added at the end.
<b>Navigation:</b> Use the bookmarks in the PDF viewer to jump through the major sections.
<PARSED TEXT FOR PAGE: 2 / 9>
Beyond the Veil: The Last Watch • AI Development Stack Page 2
Yes. If we combine Cursor + MiniMax + Potentially + the tools we previously discussed, the BTV development stack
becomes much stronger. The key is not to make every AI do the same job.
The BTV development stack I'd establish
The important difference: Cursor vs MiniMax
They're not redundant.
Cursor = your main engineering workstation.
Its Agent can inspect the BTV codebase, modify multiple files, use the terminal, debug, test, plan larger features,
and work with different frontier models. Cursor also now supports cloud agents and longer-running autonomous
work.
MiniMax = your additional autonomous engineering team.
MiniMax Code can take a development task, inspect the project, plan, edit files, run commands/tests, review the
result and iterate. It also supports remote follow-up from a phone while the desktop environment remains
running.
So you could theoretically have:
ChatGPT
 *"Design BTV's dynamic companion AI system."*
Cursor
 *Build the architecture into the actual repository.*
MiniMax
 *Review the implementation, find problems, run tests and improve it.*
Godot
 *Run the actual game and verify the feature.*
GitHub
 *Commit/version the result.*
That is much better than asking one AI to do everything.
---
<PARSED TEXT FOR PAGE: 3 / 9>
Beyond the Veil: The Last Watch • AI Development Stack Page 3
 For BTV specifically
I'd organize it into 5 layers:
1.  BTV Brain
ChatGPT
This is where we protect the actual BTV identity:
• Asher Vance
• Ember
• The Covenant
• Chosen system
• HCI
• Veil
• faith mechanics
• Armor of God
• enemies
• missions
• cities/world
• currencies
• progression
• HUD
• dialogue
• story
• character bibles
• mechanics documents
This should remain the source of design decisions, rather than letting a coding agent casually invent canon.
---
2.  BTV Engineering
Cursor + MiniMax
This is where the design becomes software.
Cursor: primary development.
MiniMax: second engineering agent/reviewer.
For example:
> ChatGPT designs the Covenant rank/progression system.
 Cursor implements it.
 MiniMax reviews the implementation.
 Cursor fixes issues.
<PARSED TEXT FOR PAGE: 4 / 9>
Beyond the Veil: The Last Watch • AI Development Stack Page 4
 Godot tests it.
That's a genuinely useful multi-agent workflow.
---
3.  BTV Game Production
Godot + Blender
Godot handles:
• gameplay
• player controller
• combat
• AI
• quests
• inventory
• dialogue
• UI/HUD
• world streaming
• saves
• progression
• scenes
• optimization
• PC/Android builds
Blender handles the 3D side:
concept  model  rig  animation preparation  optimization  Godot
---
4.  BTV Visual Production
Leonardo + Meshy/Tripo + Blender
This is where your recent Renaissance-style idea can fit.
For example:
ChatGPT
 establishes visual direction
Leonardo
 produces concept art
Meshy/Tripo
 converts suitable concepts into 3D starting assets
<PARSED TEXT FOR PAGE: 5 / 9>
Beyond the Veil: The Last Watch • AI Development Stack Page 5
Blender
 cleans/retopologizes/rigs/optimizes
Godot
 puts the asset into BTV
And importantly, the Renaissance Leonardo/Michelangelo references we just discussed would be visual inspiration
for certain educational/artistic materials, not something we'd use to make BTV itself look like a Renaissance game
unless you specifically choose that direction.
---
5.  BTV Mobile/Remote Workflow
This is where your earlier phone limitation matters.
Phone:
ChatGPT
 planning/design
GitHub Codespaces
 browser-based coding/Git operations
MiniMax remote control
 monitor/continue desktop coding tasks
PC:
Cursor
 serious codebase work
Godot
 actual game development/testing
Blender
 3D production
GitHub
 version control
That's a much more realistic setup than trying to make an entire AAA-scale game solely from an Android phone.
---
 My ranking for BTV
If I had to prioritize the tools rather than install everything immediately:
<PARSED TEXT FOR PAGE: 6 / 9>
Beyond the Veil: The Last Watch • AI Development Stack Page 6
Tier S — Essential
1. ChatGPT 
2. Cursor 
3. Godot 
4. GitHub 
5. Blender 
Tier A — Extremely useful
6. MiniMax Agent 
7. Leonardo AI 
8. Meshy
9. Tripo3D
Tier B — Useful supporting tools
10. GitHub Codespaces 
11. Potentially 
12. Replit Agent
13. Firebase Studio
The interesting part is that Cursor and MiniMax are becoming more capable of doing large portions of the actual
engineering workflow, rather than merely generating snippets. Cursor explicitly supports planning, codebase
search, file editing, terminal execution, debugging and multi-agent/cloud workflows. MiniMax likewise now
describes a plan  code  test  review workflow around an attached project.
So my recommended BTV pipeline is:
YOU
> Creative Director / final authority
CHATGPT
> BTV architecture + canon + design + documentation
CURSOR
> Primary software engineer
 MINIMAX
> Autonomous implementation/review/testing
<PARSED TEXT FOR PAGE: 7 / 9>
Beyond the Veil: The Last Watch • AI Development Stack Page 7
GITHUB
> Version control
GODOT
> Actual game
 BLENDER
> 3D assets
 LEONARDO / MESHY / TRIPO
> Visual & asset generation
And Potentially sits alongside the creative pipeline as a model experimentation laboratory.
That is the stack I would use for BTV rather than choosing one “best AI.” The strength comes from giving each tool
a clearly defined job.
<PARSED TEXT FOR PAGE: 8 / 9>
Beyond the Veil: The Last Watch • AI Development Stack Page 8
BTV DEVELOPMENT STACK — TOOL MATRIX
Tool Main BTV role Rating
ChatGPT Creative director, systems architect, lore/canon, design docs, problem-solving
Cursor Main coding + codebase engineering
MiniMax Agent/Code Autonomous coding, implementation, testing, review
Godot 4.7.x Actual game engine, scenes, gameplay & testing
GitHub Source control, project history, collaboration
Blender 3D modeling, cleanup, rigging, optimization
Leonardo AI Concept art, environments, characters, visual exploration
Meshy 3D asset generation from concepts
Tripo3D Alternative 3D generation/prototyping
GitHub Codespaces Browser/phone development and Git operations
Replit Agent Quick web/app prototyping
Firebase Studio Browser-based AI development/workspace
Potentially Experiment with many AI models for image/video/audio/creative work ½
BTV ACTION BOARD
These actions are added as a practical companion to the verbatim guidance above.
01
LOCK THE CANON
Keep ChatGPT as the BTV design/canon authority. Maintain a single source of truth for
characters, factions, faith systems, mechanics, visual identity and world rules.
02
CONNECT THE REPOSITORY
Use GitHub as the version-control backbone. Establish a clean project structure before asking
coding agents to make broad changes.
03
BUILD THE FOUNDATION
Use Cursor as the primary engineering workstation. Start with a small, testable vertical slice
rather than attempting the whole semi-open world at once.
04
ADD THE SECOND ENGINEER
Use MiniMax for implementation reviews, debugging, test runs and independent checks. Do not
allow either agent to silently redefine canon.
05
CREATE THE VISUAL PIPELINE
Use Leonardo for concept exploration, Meshy/Tripo for suitable 3D starting points, Blender for
cleanup and optimization, then Godot for integration.
06
TEST ON TARGET DEVICES
Run the actual Godot build on PC and Android as the project develops. Treat performance,
controls, UI scaling and memory as first-class requirements.
<PARSED TEXT FOR PAGE: 9 / 9>
Beyond the Veil: The Last Watch • AI Development Stack Page 9
07
VERSION EVERYTHING IMPORTANT
Commit working milestones frequently. Keep experimental AI-generated assets separate from
approved BTV assets until reviewed.
08
USE AI AS A TEAM, NOT A SINGLE BRAIN
Give each tool a defined responsibility. The strongest workflow is orchestration: design 
implement  review  test  commit  iterate.
FINAL BTV PRINCIPLE
The tools are replaceable; the BTV vision is not. Use AI to accelerate production while keeping the
game's established canon, Christian identity, originality, quality bar and final creative decisions
under human direction.
