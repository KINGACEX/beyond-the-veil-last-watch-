# BTV AI Coding-Agent Alternatives Research — 6 November 2026

**Status:** Research only; no installation, account connection, purchase, permission change or workflow migration performed.  
**Purpose:** Identify a small number of alternatives that could assist BTV's Godot/GitHub engineering without increasing tool overhead or introducing unapproved costs.

## 1. Scope clarification

This assessment interprets "agents" as AI software-development agents that inspect/edit a repository and run tests. It does not treat an AI coding agent as an in-game NPC, Ember, or the BTV companion actor runtime.

**vidIQ is not a direct coding-agent or game-actor replacement.** It is a creator research and YouTube channel-analytics platform. Its MCP integration exposes creator data and workflows to AI assistants. It may help a separate BTV YouTube/Shorts workstream, but it does not implement Godot code, NLI request lifecycle or NPC/companion runtime behavior.

If "actors" meant in-game NPC/companion actors rather than coding agents, this shortlist is not the correct comparison set; that would require a separate architecture review.

## 2. Shortlist

| Tool | Primary role | Free/cost position checked 6 Nov 2026 | BTV fit | Main caution |
|---|---|---|---|---|
| OpenCode | Open-source coding agent; desktop, mobile, terminal and SDK | App is free; free models are offered, while external provider use may incur cost | **Best candidate for a phone-first feasibility test**; can steer/approve sessions from mobile | Verify how it connects to a repository/remote workspace and what provider/model is actually free before relying on it |
| Kilo Code | Open-source agent for VS Code, JetBrains and CLI | Individual platform is free; Auto Free/local models can avoid hosted inference charges; cloud compute is separately billed | Strong laptop-side alternative for controlled code edits and test loops | Do not enable paid cloud compute or paid inference; keep approval gates |
| Cline | Open-source coding agent for VS Code/CLI | Interface is free; model inference is usage-based; limited free model promotions rotate | Good for transparent, approval-oriented repository changes | Free interface does not mean unlimited free model usage |
| Goose | Open-source general-purpose agent; desktop, CLI and API; MCP extensions | Open source; model/provider costs depend on selected backend | Useful for general workflows and MCP integrations | Desktop/CLI-first; no clear phone-first advantage for this project |
| GitHub Copilot Free | GitHub-integrated coding assistance and limited agent features | Free tier currently lists 2,000 completions/month and limited chat/agent usage | Low-friction GitHub-adjacent fallback | Usage limits and model availability can change; not a replacement for current GitHub repository connector |
| Mistral Vibe | Coding agent CLI and VS Code/web workflows | CLI can use Mistral-hosted models, local models or OpenAI-compatible endpoints; account/API pricing depends on selected route | Already in the user's considered toolset; can be evaluated against existing BTV workflow | Do not assume every provider/model route is free; local execution needs suitable hardware |
| vidIQ | YouTube creator research, analytics and AI content workflows | Free plan lists 150 AI credits/month; MCP is listed as available on all plans, with tool use consuming credits | Useful only for the separate BTV creator/YouTube workstream | Not a coding agent, Godot runtime, NPC actor system or general repository executor |

## 3. Evidence and product references

- OpenCode product and mobile/desktop/terminal overview: https://dev.opencode.ai/
- OpenCode documentation: https://docs.opencode.ai/docs/
- Kilo Code pricing and free/local routes: https://kilo.ai/pricing/
- Kilo Code free usage guide: https://github.com/Kilo-Org/kilocode/blob/main/packages/kilo-docs/pages/getting-started/using-kilo-for-free.md
- Cline pricing and BYOK/inference explanation: https://cline.bot/pricing
- Goose project and provider/MCP overview: https://github.com/aaif-goose/goose
- GitHub Copilot plans: https://github.com/features/copilot/plans
- Mistral Vibe CLI installation and provider options: https://docs.mistral.ai/getting-started/quickstarts/vibe-code/install-cli
- vidIQ feature catalogue and MCP: https://vidiq.com/features/
- vidIQ pricing: https://vidiq.com/plans/

Pricing, model availability, free quotas and supported clients change frequently. Re-check the vendor page immediately before any future setup.

## 4. Evaluation against BTV requirements

A candidate must demonstrate all of the following before it is added to the working stack:

1. **Repository boundary:** can work only on btv/test-first-contracts-001 or a dedicated task branch; main remains untouched.
2. **Read-before-write:** can inspect the current repository state and report intended changes before editing.
3. **Test discipline:** can run the configured Godot 4.7.2 headless checks and report exact logs/results.
4. **Permission discipline:** no automatic merge, deployment, release, public posting, paid usage or broad repository permission changes.
5. **Cost discipline:** no required purchase or paid API route; clearly identify when a free quota is exhausted.
6. **Phone practicality:** can be supervised from Android without pretending that a phone-only environment provides a full local Godot editor.
7. **Context integrity:** can follow BTV canon/status labels and avoid inventing implementation or test evidence.
8. **Data handling:** disclose whether repository content is sent to a hosted model/provider and avoid exposing credentials or secrets.

## 5. Recommendation

**Keep the current ChatGPT + GitHub connector workflow as the primary engineering path.** It has already demonstrated read-only inspection, branch-scoped file changes and CI verification in this repository.

**First alternative to evaluate:** OpenCode, because its published product includes a mobile client and free-model options. The evaluation should be read-only initially: inspect repository connection method, branch selection, approval UX, model route, and whether a no-cost session is genuinely available. Do not grant write access until the read-only trial passes.

**Second alternative:** Kilo Code Auto Free, but only if a laptop/desktop development environment is available. Keep cloud compute disabled and select local/free inference only.

**Conditional alternatives:** Cline or Goose only if a specific missing capability justifies another tool. Avoid installing all candidates; that would increase configuration and context-switching overhead.

**vidIQ placement:** keep it in the creator/YouTube lane. Use its channel research, keyword, outlier and analytics capabilities only when working on BTV's YouTube content. Do not connect it to the game runtime or use it as a substitute for the NLI/companion actor contract.

## 6. Current decision and boundaries

- **CONFIRMED:** This is a tool research comparison only.
- **PROPOSED:** OpenCode as the first read-only mobile feasibility test; Kilo Code Auto Free as a possible desktop backup.
- **NOT APPROVED:** Installation, account connection, repo write permissions, paid inference, cloud compute, or changing the current BTV toolchain.
- **UNCHANGED:** Godot remains the active BTV engine; the Unity evaluation branch remains on hold.
- **UNCHANGED:** The NLI companion handoff remains separate from any external coding agent. A development agent does not become an in-game actor.
