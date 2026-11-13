# BTV — Funding & Partnership Opportunity Scan

**Research date:** 13 November 2026  
**Workstream:** Funding and partnerships, separate from Roblox gameplay implementation  
**Status:** Initial screening; no applications submitted, no agreements accepted, no spending authorised.

## 1. Project position for funders

Beyond the Veil: The Last Watch (BTV) is an original Christian action-adventure RPG project. Roblox is the immediate prototype platform; the existing Godot work and source documentation are preserved as a secondary track. The Roblox implementation targets Android and PC, with multiplayer and server-authoritative progression planned.

### Evidence that can currently be stated

- A public GitHub repository exists and contains a Roblox Luau source foundation, Rojo project mapping, headless test suite and CI workflow.
- The source includes an opening Temple prototype, Ridgeview landscape study, server-owned opening mission state, field-notes interaction loop, and a newly added Ridgeview settlement/NPC dialogue increment.
- Wren's testimony and permission-to-share are distinct server-side session states. Pike's Wren-account dialogue branch is gated on both.
- The new settlement increment is source-committed but has not yet been verified in Roblox Studio.
- No Roblox place has been published. No verified player metrics, revenue, retention, audience size, registered studio status, or completed playable vertical slice are claimed.
- The final Asher/Roblox-player identity decision, production character rigs, full Ember AI, persistent saves, final evidence board, combat, and device testing remain open.

**Funding rule:** Never describe source code, a Rojo build, or headless tests as proof of a working Roblox Studio game. Attach only verified screenshots, videos, build artifacts and test results.

## 2. Current opportunity screening

| Opportunity | Current position (13 Nov 2026) | Fit for BTV now |
|---|---|---|
| OpenAI Codex for Open Source | Rolling applications. Selected maintainers may receive six months of ChatGPT Pro with Codex, optional API credits and conditional Codex Security. | **Low / weak eligibility.** It is designed for maintainers of important open-source software with meaningful usage and active maintenance. BTV's public repository does not by itself establish an open-source licence, ecosystem adoption, downloads or broad usage. |
| Roblox Jumpstart | Rolling applications. Support is primarily in-kind: Roblox expert guidance, Robux-based operational support and visibility, not cash. At least one team member must be 18+; the programme is aimed at novel experiences for 18+ players. | **Conditional / weak fit.** Reassess only if the actual audience and team eligibility genuinely match. Do not change BTV's audience or content merely to fit a programme. |
| Roblox Incubator | Listed as closed on Roblox's public creator-programmes page. | **Not currently open.** Recheck only when Roblox announces a new intake. |
| Supercell Developer Grants — Africa | First cohort closed 9 August 2026. Grants were advertised at USD 20,000–200,000, but applications must represent a legally registered game studio; individuals, hobby projects and unregistered teams are excluded. | **Not eligible in the current state.** A future cohort may be considered only if a genuine eligible studio exists and an adult/legal representative handles the formal process. |
| Google Play Indie Games Fund Africa 2026 | Applications closed 31 July 2026; Google announced the 10 selected studios on 28 October 2026. The first fund required an already launched game. | **Closed and premature.** Revisit a future cohort after BTV has shipped a game and can show traction. |
| MTN DigiFest Game Developer Contest 2026 | Ghana contest closed 19 October 2026; finals and winners were announced on 26 October. The community category was for Ghana-based developers aged 16+; teams could have up to three members. | **Future showcase, not currently open.** Watch for a future edition; confirm age and entry rules at that time. |
| AfriCAN Code Challenge | Youth competition for ages 8–16 in Ghana, with Scratch game/animation submissions. | **Not a funding route and not the Roblox BTV build.** Consider only if a separate Scratch-based educational showcase is worthwhile and age-eligible. |
| Roblox Creator Rewards | Ongoing creator-reward programme for eligible published experiences; not a grant or upfront funding. | **Later-stage only.** Requires a real published game and genuine engagement. No publishing or monetisation is authorised by this scan. |

### Official sources

- [OpenAI Codex for Open Source application](https://openai.com/form/codex-for-oss/)
- [OpenAI Codex for Open Source programme terms](https://learn.chatgpt.com/docs/codex-for-oss-terms)
- [Roblox Jumpstart](https://create.roblox.com/docs/creator-programs/jumpstart)
- [Roblox public creator programmes](https://create.roblox.com/docs/creator-programs)
- [Supercell Developer Grants — Africa](https://supercell.com/en/news/developer-grants-program/)
- [Google Play Indie Games Fund Africa announcement](https://blog.google/products-and-platforms/platforms/google-play/indie-games-fund-africa/)
- [MTN DigiFest Game Developer Contest terms](https://mtn.com.gh/digifest-game-developer-contest/)
- [AfriCAN Code Challenge](https://www.dreamoval.org/codechallenge/)
- [Roblox Creator Rewards](https://create.roblox.com/docs/creator-rewards)

## 3. Codex for Open Source — terms and suitability

The programme is not a general game-development grant. It is aimed at maintainers of important open-source software. OpenAI may review repository usage, ecosystem importance, active maintenance, maintainer role and permissions. An application does not guarantee selection, funding or access.

The current BTV repository is public, but a public repository alone does not prove that the project is licensed as open source or widely used. The current evidence does not justify claiming broad adoption, downloads, external contributors or ecosystem-critical status.

The programme terms also state:
- benefits are discretionary, limited, personal and non-transferable;
- OpenAI may independently develop or support similar ideas or projects;
- there is no exclusivity obligation;
- application materials are not treated as confidential, so confidential material should not be submitted.

**Recommendation:** Do not inflate BTV's open-source importance or usage metrics. If an application is considered, describe the actual repository status and maintainer role accurately, avoid confidential story/IP material, and have a parent/guardian review the programme terms before any agreement is accepted.

## 4. Realistic prototype budget position

### Current zero-cash build

| Cost area | Current approach | Cash commitment |
|---|---|---:|
| Roblox Studio / Roblox runtime | Free platform tools | GH¢0 |
| Luau, Rojo, Lune, StyLua, Selene | Free/open tooling | GH¢0 |
| Source control and existing CI | Existing GitHub repository/workflow | GH¢0 within available free limits |
| Prototype environment | Scripted blockouts and in-house source | GH¢0 |
| Basic regression tests | Headless tests in CI | GH¢0 within available free limits |
| Initial audio and final character assets | Deferred; no paid assets approved | GH¢0 authorised |
| Public hosting, publishing or promotion | Not authorised | GH¢0 authorised |

This is a **cash-spend snapshot**, not a valuation of development labour. It excludes the value of time, device access, connectivity and any future contractor work.

### Costs that require quotations before a funding request

1. Final Asher/Roblox player-character presentation and Ember rig/animation production.
2. Environment art, props, lighting and optimisation.
3. Original audio, sound design and implementation.
4. QA across Android, PC and multiplayer server/client configurations.
5. Accessibility, moderation, privacy and legal review.
6. Project management and any paid engineering/art/audio contractors.

No reliable cash total should be submitted until the prototype scope, team roles, deliverables, rates and quotations are known. The first funding request should be a costed work package, not an invented headline amount.

## 5. Funding-readiness milestones

1. **Studio verification:** import the Rojo project, run Play Solo, test two clients, verify the Ridgeview settlement and Wren/Pike consent flow.
2. **Playable loop:** complete arrival → settlement exploration → NPC interaction → Ember interaction → initial objective → journal update.
3. **Cross-platform proof:** record actual Android and PC tests, including UI readability, input, replication and performance.
4. **Production proof:** replace temporary blockouts with reviewed character/environment assets and record the provenance/licences.
5. **Private playtest:** gather consent-based feedback and real engagement evidence before any public launch.
6. **Pitch package:** produce a concise project overview, gameplay capture, current build, milestone roadmap, itemised budget, team roles, IP ownership statement and risk register.

## 6. Immediate recommendation

Prioritise a verified Roblox Studio demonstration before spending time on low-fit grant applications. In parallel, retain a lightweight funding pipeline: monitor future MTN/Ghana game contests, Roblox creator-programme updates, and future Africa-focused studio grants. Codex for Open Source should remain a low-priority option unless BTV develops genuine open-source adoption and maintainership evidence.

No application, registration, paid course, paid asset, subscription, public release, monetisation, or financial commitment has been made through this research.
