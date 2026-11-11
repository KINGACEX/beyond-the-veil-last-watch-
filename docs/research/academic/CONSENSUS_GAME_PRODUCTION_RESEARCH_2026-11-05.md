# Research brief for Beyond the Veil: The Last Watch (BTV), a small-team/solo-frie

**Question:** Research brief for Beyond the Veil: The Last Watch (BTV), a small-team/solo-friendly Christian action-adventure survival RPG being developed in Godot 4.x, Android-first with later PC scalability. Produce an evidence-based synthesis of peer-reviewed research relevant to professional game development and production, prioritizing work from 2018-2026 where available but retaining seminal foundational work. Cover: (1) game production lifecycle, preproduction, prototypes, first playable, vertical slices, production milestones and scope control; (2) level/mission design, player navigation, pacing, environmental storytelling, player agency and readability; (3) scene composition and staging in real-time games, camera, lighting, mood, transitions, cutscenes vs in-engine sequences; (4) world/level construction, modular environments, procedural techniques, asset pipelines and reuse; (5) character design, rigging, animation, locomotion, combat readability and companion AI; (6) gameplay architecture, state machines, event-driven systems, data-driven design, save/load and testability; (7) audio, UI/UX, accessibility, mobile performance, optimisation and QA; (8) common production failures and risk controls from empirical studies/postmortems. Distinguish strong evidence from practitioner opinion, report limitations and contradictions, cite papers with bibliographic details/DOIs where available, and conclude with practical, low-cost recommendations and a staged research-to-production roadmap suitable for BTV. This is academic evidence only; do not pretend to cover all current industry practice or open-web developer postmortems.

# Synthesis of **Game Production Research** for Small-Scale Action-Adventure Development

Developing a solo-friendly or small-team action-adventure survival RPG requires balancing production life cycles, architectural readability, and systemic player agency within constrained technical budgets [[1.1]](https://consensus.app/papers/applying-scrum-in-a-game-development-life-cycle-for-small-siahaan-widyani/4ccf11a07adf51c7bed0dcf7458496b5/) [[2.1]](https://consensus.app/papers/level-design-processes-and-challenges-a-cross-section-of-karlsson-brusk/9ae60c5bf6085fc183a98b12df18ab0b/). Empirical software engineering and game studies show that small teams thrive by adopting hybrid linear-agile frameworks, rapid multi-material prototyping, and explicit architectural orchestration [[1.2]](https://consensus.app/papers/applying-scrum-in-a-game-development-life-cycle-for-small-siahaan-widyani/4ccf11a07adf51c7bed0dcf7458496b5/) [[3.1]](https://consensus.app/papers/lego-prototyping-in-an-introductory-game-development-horn/42df2158b5d75acebfc1caacf1010e85/) [[4.1]](https://consensus.app/papers/orchestrating-game-generation-liapis-yannakakis/c29f6cb63fe4530a8b9072718bb041a1/).

## Production Lifecycles and Scope Management

Empirical research on game development project management indicates that standard software engineering models cannot be applied without adaptation [[2.2]](https://consensus.app/papers/level-design-processes-and-challenges-a-cross-section-of-karlsson-brusk/9ae60c5bf6085fc183a98b12df18ab0b/) [[5.1]](https://consensus.app/papers/what-are-the-project-management-practices-in-the-digital-pieva-pillat/0d86f8f600bc517dac84c8c4fa5334b0/). For small teams, a **semi-agile lifecycle model** combines linear macro-phases—Pre-Production, Production, Testing, and Release—with sprint-based agile sub-stages [[1.2]](https://consensus.app/papers/applying-scrum-in-a-game-development-life-cycle-for-small-siahaan-widyani/4ccf11a07adf51c7bed0dcf7458496b5/) [[1.3]](https://consensus.app/papers/applying-scrum-in-a-game-development-life-cycle-for-small-siahaan-widyani/4ccf11a07adf51c7bed0dcf7458496b5/) [[1.4]](https://consensus.app/papers/applying-scrum-in-a-game-development-life-cycle-for-small-siahaan-widyani/4ccf11a07adf51c7bed0dcf7458496b5/). Industry surveys confirm that Scrum and Kanban boards dominate project organization, paired with core design documentation to prevent coordination breakdowns [[5.2]](https://consensus.app/papers/what-are-the-project-management-practices-in-the-digital-pieva-pillat/0d86f8f600bc517dac84c8c4fa5334b0/) [[5.3]](https://consensus.app/papers/what-are-the-project-management-practices-in-the-digital-pieva-pillat/0d86f8f600bc517dac84c8c4fa5334b0/).

**Figure 7.** Production Stage of The Study Case. [[1]](https://consensus.app/papers/applying-scrum-in-a-game-development-life-cycle-for-small-siahaan-widyani/4ccf11a07adf51c7bed0dcf7458496b5/)

*How to read: The diagram depicts the iterative sub-stages of a game production cycle, flowing from sprint planning through development tasks to review and retrospective.*

Early pre-production demands physical or rapid digital prototypes before expanding into full production assets [[3.2]](https://consensus.app/papers/lego-prototyping-in-an-introductory-game-development-horn/42df2158b5d75acebfc1caacf1010e85/) [[3.3]](https://consensus.app/papers/lego-prototyping-in-an-introductory-game-development-horn/42df2158b5d75acebfc1caacf1010e85/). Physical modular materials like LEGO bricks paired with parameter spreadsheets accelerate economy balance and design communication faster than paper alone [[3.4]](https://consensus.app/papers/lego-prototyping-in-an-introductory-game-development-horn/42df2158b5d75acebfc1caacf1010e85/) [[3.5]](https://consensus.app/papers/lego-prototyping-in-an-introductory-game-development-horn/42df2158b5d75acebfc1caacf1010e85/). However, accelerated prototype generation does not guarantee a shipped commercial game if scope transitions are unmonitored; longitudinal ethnographies show accelerators producing dozens of prototypes with zero releases at 12 months due to misjudged product scales [[6.1]](https://consensus.app/papers/the-impact-of-video-game-prototyping-in-an-accelerator-as-gidley-palmer/e5d5f94007455f068cff7f4953d85e55/) [[6.2]](https://consensus.app/papers/the-impact-of-video-game-prototyping-in-an-accelerator-as-gidley-palmer/e5d5f94007455f068cff7f4953d85e55/) [[6.3]](https://consensus.app/papers/the-impact-of-video-game-prototyping-in-an-accelerator-as-gidley-palmer/e5d5f94007455f068cff7f4953d85e55/). A vertical slice milestone requires a dedicated integration step to smooth out aesthetic and mechanical dissonance across generated modules [[4.2]](https://consensus.app/papers/orchestrating-game-generation-liapis-yannakakis/c29f6cb63fe4530a8b9072718bb041a1/) [[4.3]](https://consensus.app/papers/orchestrating-game-generation-liapis-yannakakis/c29f6cb63fe4530a8b9072718bb041a1/).

## Architectural Systems and Level Design

Designing readable environments and coherent gameplay systems relies on decoupled modular architectures and structured visual wayfinding [[7.1]](https://consensus.app/papers/effects-of-environment-design-on-player-decision-making-guldur/57bee81d4c5e51a59953f83b722097a6/) [[7.2]](https://consensus.app/papers/effects-of-environment-design-on-player-decision-making-guldur/57bee81d4c5e51a59953f83b722097a6/). Level design functions as an interdisciplinary cross-section connecting spatial layout, narrative beats, and tooling [[2.3]](https://consensus.app/papers/level-design-processes-and-challenges-a-cross-section-of-karlsson-brusk/9ae60c5bf6085fc183a98b12df18ab0b/) [[8.1]](https://consensus.app/papers/video-game-level-design-salmond/76dba0f0fc7552229b75c06759f7d472/).

| Design Dimension | Empirical Finding | Production Implication | Source |
| :--- | :--- | :--- | :--- |
| **Visual Navigation** | Architectural visual clues **enhance mental mapping** without navigational aids | Blockout with composition lines; drop minimaps | [[7.2]](https://consensus.app/papers/effects-of-environment-design-on-player-decision-making-guldur/57bee81d4c5e51a59953f83b722097a6/) [[7.3]](https://consensus.app/papers/effects-of-environment-design-on-player-decision-making-guldur/57bee81d4c5e51a59953f83b722097a6/) [[7.4]](https://consensus.app/papers/effects-of-environment-design-on-player-decision-making-guldur/57bee81d4c5e51a59953f83b722097a6/) |
| **Mission Pacing** | Action block sequences balance **combat intensity and recovery** | Map rhythm using structured MAQV timelines | [[9.1]](https://consensus.app/papers/deconstructing-openworld-game-mission-design-formula-a-xu-zhang/9a85953d170e5441b563bdd619c51444/) [[9.2]](https://consensus.app/papers/deconstructing-openworld-game-mission-design-formula-a-xu-zhang/9a85953d170e5441b563bdd619c51444/) [[9.3]](https://consensus.app/papers/deconstructing-openworld-game-mission-design-formula-a-xu-zhang/9a85953d170e5441b563bdd619c51444/) |
| **Environmental Story** | Spatial semiotics communicate narrative **without explicit dialogue** | Embed static lore props into greybox levels | [[10.1]](https://consensus.app/papers/the-art-of-the-environment-in-interactive-walking-klobucar/3091d719b9a0525893c9e684d6a639a4/) [[10.2]](https://consensus.app/papers/the-art-of-the-environment-in-interactive-walking-klobucar/3091d719b9a0525893c9e684d6a639a4/) [[7.5]](https://consensus.app/papers/effects-of-environment-design-on-player-decision-making-guldur/57bee81d4c5e51a59953f83b722097a6/) |
| **System Prototyping** | Live programming environments enable **continuous feedback loops** | Script data-driven feedback inside Godot tools | [[11.1]](https://consensus.app/papers/live-game-design-prototyping-at-the-speed-of-play-rozen/68771141103f544b8a1573f66a84f452/) [[11.2]](https://consensus.app/papers/live-game-design-prototyping-at-the-speed-of-play-rozen/68771141103f544b8a1573f66a84f452/) [[11.3]](https://consensus.app/papers/live-game-design-prototyping-at-the-speed-of-play-rozen/68771141103f544b8a1573f66a84f452/) |
| **Agency Dynamics** | Player agency functions as a **structured design effect** | Implement meaningful constraints and role-play | [[12.1]](https://consensus.app/papers/dramatic-design-mechanisms-in-video-games-a-systematic-masoud-muhanna/1c7e9906c0625386b5e604a9e48b652b/) [[13.1]](https://consensus.app/papers/narrative-and-challenge-in-singleplayer-rpgs-a-19902025-antunes-carvalho/d9ca4dd988ac512e8b78d4f11d010165/) [[14.1]](https://consensus.app/papers/exploring-player-agency-in-educational-video-games-joshi-mousas/541d2df12bee5377814dcfcbbadec7f5/) |

**Figure 1:** Synthesis of empirical architectural and level design findings across evaluated game development frameworks.

Blockmesh geometry allows rapid iteration based on playtest feedback without wasting visual art labor [[7.6]](https://consensus.app/papers/effects-of-environment-design-on-player-decision-making-guldur/57bee81d4c5e51a59953f83b722097a6/). Visual clues derived from classical photography and painting significantly enhance wayfinding and spatial retention over artificial HUD markers [[7.7]](https://consensus.app/papers/effects-of-environment-design-on-player-decision-making-guldur/57bee81d4c5e51a59953f83b722097a6/) [[7.4]](https://consensus.app/papers/effects-of-environment-design-on-player-decision-making-guldur/57bee81d4c5e51a59953f83b722097a6/). In engine architectures like Godot, pairing rapid prototyping tools with visual state feedback prevents slow recompilation cycles [[11.4]](https://consensus.app/papers/live-game-design-prototyping-at-the-speed-of-play-rozen/68771141103f544b8a1573f66a84f452/) [[11.2]](https://consensus.app/papers/live-game-design-prototyping-at-the-speed-of-play-rozen/68771141103f544b8a1573f66a84f452/) [[11.5]](https://consensus.app/papers/live-game-design-prototyping-at-the-speed-of-play-rozen/68771141103f544b8a1573f66a84f452/). Data-oriented scaling paradigms, such as Entity Component Systems, successfully maintain computational performance under high entity counts [[3.6]](https://consensus.app/papers/lego-prototyping-in-an-introductory-game-development-horn/42df2158b5d75acebfc1caacf1010e85/).

## Risk Controls and Production Roadmap

Empirical postmortems and studio studies demonstrate that common project failures arise from suboptimal interdisciplinary communication, under-prototyping, and unvalidated narrative-ludic friction [[2.4]](https://consensus.app/papers/level-design-processes-and-challenges-a-cross-section-of-karlsson-brusk/9ae60c5bf6085fc183a98b12df18ab0b/) [[13.2]](https://consensus.app/papers/narrative-and-challenge-in-singleplayer-rpgs-a-19902025-antunes-carvalho/d9ca4dd988ac512e8b78d4f11d010165/) [[3.7]](https://consensus.app/papers/lego-prototyping-in-an-introductory-game-development-horn/42df2158b5d75acebfc1caacf1010e85/). Small projects benefit from structured risk gates and a phased roadmap:

* **Pre-Production Phase**: Construct physical prototypes or Godot greybox blockouts to test core survival loops before art production [[7.6]](https://consensus.app/papers/effects-of-environment-design-on-player-decision-making-guldur/57bee81d4c5e51a59953f83b722097a6/) [[3.7]](https://consensus.app/papers/lego-prototyping-in-an-introductory-game-development-horn/42df2158b5d75acebfc1caacf1010e85/).
* **Vertical Slice Phase**: Build one contained quest loop using action-block pacing analysis to validate combat readability and emotional valleys [[9.1]](https://consensus.app/papers/deconstructing-openworld-game-mission-design-formula-a-xu-zhang/9a85953d170e5441b563bdd619c51444/) [[9.4]](https://consensus.app/papers/deconstructing-openworld-game-mission-design-formula-a-xu-zhang/9a85953d170e5441b563bdd619c51444/).
* **Production Sprints**: Implement semi-agile Kanban iterations to finalize documentation, prune uncompleted features, and refine character-driven narrative coherence [[1.3]](https://consensus.app/papers/applying-scrum-in-a-game-development-life-cycle-for-small-siahaan-widyani/4ccf11a07adf51c7bed0dcf7458496b5/) [[1.5]](https://consensus.app/papers/applying-scrum-in-a-game-development-life-cycle-for-small-siahaan-widyani/4ccf11a07adf51c7bed0dcf7458496b5/) [[15.1]](https://consensus.app/papers/characterdriven-storytelling-design-for-digital-games-a-zaini-fowler/0f37e0d92b0c585e99b6872f097b26df/).
* **Pre-Alpha Testing**: Conduct structured post-production reviews to audit dropped mechanics, profile mobile draw calls, and lock final release builds [[1.6]](https://consensus.app/papers/applying-scrum-in-a-game-development-life-cycle-for-small-siahaan-widyani/4ccf11a07adf51c7bed0dcf7458496b5/) [[1.7]](https://consensus.app/papers/applying-scrum-in-a-game-development-life-cycle-for-small-siahaan-widyani/4ccf11a07adf51c7bed0dcf7458496b5/) [[1.5]](https://consensus.app/papers/applying-scrum-in-a-game-development-life-cycle-for-small-siahaan-widyani/4ccf11a07adf51c7bed0dcf7458496b5/).
 
_These search results were found and analyzed using Consensus, an AI-powered search engine for research. Try it at https://consensus.app. © 2026 Consensus NLP, Inc. Personal, non-commercial use only; redistribution requires copyright holders’ consent._
 
## References
 
`1.` Siahaan YYP, Widyani Y, Candra M. Applying Scrum in A Game Development Life Cycle For Small Scale Game Project. *International Journal of Information Technology, Research and Applications.* 2023. doi:10.59461/ijitra.v2i4.73
 
> [1.1] The final version of the proposed GDLC is intended to answer the research question: is there any GLDC that is suitable for a small video game project that is being developed by a small team (consisting of only 4 core divisions or roles: production, game design, programmer, and artists), abnormal way of working (like remote working for example), and short development timeframe (less than 1 year)? (Body)
 
> [1.2] Again, like the previous version, this GLDC works in a semi-agile approach . (Body)
 
> [1.3] What that means (as stated previously) is that the 4 main stages are being done linearly like a waterfall, but each sub-stage (in the production and testing phase) is being done in a scrum-like agile manner . (Body)
 
> [1.4] This GDLC proposal consists of 4 stages, namely Pre-Production, Production, Testing, and Release. (Abstract)
 
> [1.5] It is done by reviewing which tasks are completed or dropped , which features have been changed from the initial design or being done exactly from it, and the overall design change of the video game. (Body)
 
> [1.6] If there is a need for improvement to the MVP build, it must be done in a quick and simple manner, to not break the already existing features. (Body)
 
> [1.7] The team then will do a pre-alpha review . (Body)
 
`2.` Karlsson T, Brusk J, Engström H. Level Design Processes and Challenges: A Cross Section of Game Development. *Games and Culture.* 2022;18:821 - 849. doi:10.1177/15554120221139229
 
> [2.1] Furthermore, this interdisciplinary collaboration requires management to maintain both creativity and efficient pipelines, by distributing ownership and facilitating communication and planning. (Abstract)
 
> [2.2] The complex interdisciplinary process in game development, the demand for specialized tools and systems, and the need to maintain creativity show the need for researching game development in the wild (Engström, 2020). (Body)
 
> [2.3] Thematic analysis of data, recorded through field studies and semi-structured interviews, identify four key themes: level design as an interdisciplinary effort; who is the level designer; the role of narrative in level design; and challenges of managing creativity in the level design process. (Abstract)
 
> [2.4] The level design process seems particularly vulnerable to suboptimal interdisciplinary communication and planning, due to significant reliance on narrative design, game design, art, sound design, and tool development. (Abstract)
 
`3.` Horn B. LEGO Prototyping in an Introductory Game Development Course. *Proceedings of the 20th International Conference on the Foundations of Digital Games.* 2025. doi:10.1145/3723498.3723710
 
> [3.1] This work collects student data from two undergraduate introductory game development courses (n=40) in which students physically prototype game ideas with both traditional materials and LEGOs. (Abstract)
 
> [3.2] Approximately half of the semester is dedicated to this project, with about four weeks spent on physical and digital prototypes prior to full-scale development. (Body)
 
> [3.3] Traditional physical prototyping makes use of common office supplies to allow both technical and non-technical designers to quickly test and share design ideas. (Abstract)
 
> [3.4] The group used LEGO bricks throughout their physical prototyping process and paired it with spreadsheets to refine tower costs and damage/hit point values. (Body)
 
> [3.5] Self-assessments show that participants enjoyed the inclusion of LEGO sets, found them to help communicate ideas faster and more clearly, and were easier to produce than traditional paper prototypes. (Abstract)
 
> [3.6] Developed with Unity ECS (or Entity Component System), it leverages a data-oriented framework to scale processing performance. (Body)
 
> [3.7] Student postmortems reveal that they find paper prototyping to be particularly valuable and report that they did not do enough prototyping. (Body)
 
`4.` Liapis A, Yannakakis GN, Nelson M, Preuss M, Bidarra R. Orchestrating Game Generation. *IEEE Transactions on Games.* 2019;11:48-68. doi:10.1109/tg.2018.2870876
 
> [4.1] To address these questions, this paper identifies game facet orchestration as the central challenge for artificial-intelligence-based game generation, discusses its dimensions, and reviews research in automated game generation that has aimed to tackle it. (Abstract)
 
> [4.2] Iterative generation through vertical slices would also require a post-production step when the iteration is deemed successful and its changes need to be integrated with the game created so far. (Body)
 
> [4.3] In short, a high-quality post-production step which can identify and smoothen dissonance between generated content is a core element of orchestration, and in certain cases could be considered the main method for orchestration itself. (Body)
 
`5.` Pieva L, Pillat RM, Mossmann J, Bernardino M. What are the Project Management Practices in the Digital Games Industry? A Survey Study. *J. Interact. Syst..* 2025;16:427-440. doi:10.5753/jis.2025.5638
 
> [5.1] This knowledge is crucial for contextualizing current practices and evaluating how well these approaches meet the specific demands of game development projects. (Body)
 
> [5.2] Results: The findings reveal Scrum and Kanban as the most widely used methodologies, with artifacts such as the Game Design Document (GDD), prototypes, and Kanban boards frequently supporting project activities. (Abstract)
 
> [5.3] Artifacts such as the Game Design Document (GDD), prototypes, and Kanban boards play a key role in organizing, communicating, and managing development workflows. (Body)
 
`6.` Gidley D, Palmer M. The impact of video game prototyping in an accelerator as viewed via spatial, temporal, and product scales. *International Journal of Innovation.* 2022. doi:10.5585/iji.v10i3.20745
 
> [6.1] At the end of week six, the companies had produced 42 prototypes. (Body)
 
> [6.2] As we noted in Figure 5, our findings showed zero games were released by the one year deadline. (Body)
 
> [6.3] The accelerator may rapidly generate ideas or prototypes, but this does not guarantee a quicker final product release. (Abstract)
 
`7.` Guldur A. Effects of environment design on player decision making process and
 motivation. 2020. doi:10.17760/d20420750
 
> [7.1] The game level is constructed in the Unity game engine using third-person shooter mechanics. (Body)
 
> [7.2] This thesis explores the properties of the visual clues that already exist in the current 3D single-player action-adventure games and how they could be enhanced to let players form an effective mental map of the environment. (Abstract)
 
> [7.3] The visual clues help players to build a mental map of the environments, so the game world becomes more immersive while players feel they have agency over their journey. (Abstract)
 
> [7.4] The data indicates that there is an increase in the performance of wayfinding and mentally mapping significant areas of the level. (Abstract)
 
> [7.5] Finally, environmental storytelling was implemented for an immersive experience. (Body)
 
> [7.6] 3. Building the level with simple geometry blocks, also known as blockmesh among designers in the video game industry, increases effectiveness in terms of iterating the level design because blockmesh does not rely on photorealistic textures and high-quality assets as designers could adjust the level layout quickly after gathering player feedback during playtests. (Body)
 
> [7.7] To make the visual clues more effective, techniques from paintings and photography were utilized to enhance the common visual clues. (Abstract)
 
`8.` Salmond M. Video Game Level Design. 2021. doi:10.5040/9781501380907
 
> [8.1] The increasingly complex role of the level designer requires technical and creative skill as it brings together architecture, art, player psychology, interaction design, usability, and experience design. (Abstract)
 
`9.` Xu K, Zhang Y, Yang B, Verbrugge C. Deconstructing Open-World Game Mission Design Formula: A Thematic Analysis Using an Action-Block Framework. *Proceedings of the 2026 CHI Conference on Human Factors in Computing Systems.* 2026. doi:10.1145/3772318.3790625
 
> [9.1] We build on these threads by shifting the analytic unit from player traces to the designer's plan: a grammar of action blocks and a sixdimensional experiential lens that makes authored mission flow visible and comparable. (Body)
 
> [9.2] As codes accumulated, we clustered them into candidate themes reflecting recurring conceptual patterns in mission design (e.g., 'trade-off between narrative and combat intensity' or 'repeated traversal-dialogue-combat block motifs'). (Body)
 
> [9.3] We introduce the Mission Action Quality Vector (MAQV), a six-dimensional framework—covering combat, exploration, narrative, emotion, problem-solving, and uniqueness—paired with an action block grammar representing missions as gameplay sequences. (Abstract)
 
> [9.4] | Q10 | Core & flavoring ingredients of a good mission | | Q11 | Mapping dimensions to player motives (examples) | | Q12 | Peaks/valleys as emotional climaxes or recovery buffers | of developer materials and community walkthroughs. (Body)
 
`10.` Klobucar A. The Art of the Environment in Interactive Walking Simulation Narratives: How GenAI Might Change the “Game”. *Humanities.* 2026. doi:10.3390/h15010013
 
> [10.1] Expanding co-creativity in new interactive art and storytelling with GenAI, both Gone Home and Firewatch will increasingly represent a late print culture moment, when environmental storytelling still assumes stable authorship and hermeneutic reading. (Body)
 
> [10.2] For example, an early 2016 article by John Barber for the Cogent Arts and Humanities, “Digital storytelling: New opportunities for humanities scholarship and pedagogy” was one of the first essays to explore how Fullbright’s well-known game Gone Home utilizes spatial design, object placement, and ambient details to convey stories without explicit narration. (Body)
 
`11.` Van Rozen R. Live Game Design: Prototyping at the Speed of Play. *Proceedings of the 20th International Conference on the Foundations of Digital Games.* 2025. doi:10.1145/3723498.3723726
 
> [11.1] Existing prototyping tools lack suitable input and feedback mechanisms for making gradual changes, perceiving behavioral effects, and evaluating their impact on running game prototypes. (Body)
 
> [11.2] It builds on a prior evaluation of Godot for creating visual live programming environments [47]. (Body)
 
> [11.3] Our results show Vie is accessible to novices and Live Game Design enables prototyping at the speed of play. (Body)
 
> [11.4] Modifying rules typically requires recompiling and restarting the game, resulting in the loss of valuable game states. (Body)
 
> [11.5] We have introduced Vie, a visual programming environment that enables quickly creating simple 2D games using Machinations. (Body)
 
`12.` Masoud A, Muhanna MA. Dramatic Design Mechanisms in Video Games: A Systematic Review and Taxonomy of Player Roles, Interaction Structures, and Experience Outcomes. *IEEE Access.* 2026;14:121226-121254. doi:10.1109/access.2026.3720919
 
> [12.1] The findings show that dramatic experience is commonly produced through agency, conflict, character identification, moral choice, emotional tension, role-play, environmental storytelling, and branching or emergent interaction structures. (Abstract)
 
`13.` Antunes J, Carvalho VH, Domingues JM. Narrative and Challenge in Single-Player RPGs: A 1990-2025 Player-Centered Systematic Review. *Digit..* 2026;6. doi:10.3390/digital6020033
 
> [13.1] (i) a predominance of work on narrative and agency, where agency is framed as a design effect rather than merely the presence of explicit branching choices; (Abstract)
 
> [13.2] Single-player role-playing games (RPGs) combine two promises that do not always align: delivering a compelling narrative experience (world, characters, choices, and consequences) while sustaining a demanding ludic trajectory in which players face obstacles, master systems, and progress over time. (Abstract)
 
`14.` Joshi A, Mousas C, Tokey SS, Kao D. Exploring player agency in educational video games. *Entertain. Comput..* 2024;52:100754. doi:10.1016/j.entcom.2024.100754
 
> [14.1] Game designers shape player agency by including alternative storylines, optional objectives, and developing a range of mechanics thereby enriching player experience with novelty and variety during gameplay. (Abstract)
 
`15.` Zaini A, Fowler A, Amor R, Wünsche B. Character-Driven Storytelling Design for Digital Games: A Scoping Review. *Games and Culture.* 2025;21:1882 - 1916. doi:10.1177/15554120251380423
 
> [15.1] The review highlights key character design factors, emphasizing the importance of believable, relatable, and emotionally engaging characters in fostering immersive narratives. (Abstract)
