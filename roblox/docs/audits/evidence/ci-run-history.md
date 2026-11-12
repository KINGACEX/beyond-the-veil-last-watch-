# GitHub Actions history — roblox-validation.yml on btv/roblox-foundation-001

Read-only snapshot of the workflow run history at audit time.

| Run | Conclusion | Head SHA | Created (UTC) |
|---|---|---|---|
| #88 | success | `56bd1dd` | 2026-11-12T11:09:45Z |
| #87 | success | `d3725cd` | 2026-11-12T11:07:47Z |
| #86 | success | `2fc0e8b` | 2026-11-12T11:07:34Z |
| #85 | success | `5765e1d` | 2026-11-12T11:07:15Z |
| #84 | success | `01e5960` | 2026-11-12T11:01:42Z |
| #83 | cancelled | `38b0891` | 2026-11-12T10:57:33Z |
| #82 | cancelled | `b2fdb53` | 2026-11-12T10:57:32Z |
| #81 | failure | `e535e4d` | 2026-11-12T10:57:05Z |
| #80 | cancelled | `8bbe187` | 2026-11-12T10:57:03Z |
| #79 | cancelled | `d300b3c` | 2026-11-12T10:57:01Z |
| #78 | cancelled | `9062fd3` | 2026-11-12T10:56:46Z |
| #77 | cancelled | `7703b48` | 2026-11-12T10:56:40Z |
| #76 | cancelled | `e85f00d` | 2026-11-12T10:56:29Z |
| #75 | cancelled | `7435979` | 2026-11-12T10:56:27Z |
| #74 | success | `1c2b1c7` | 2026-11-12T10:52:09Z |
| #73 | cancelled | `ed43dfb` | 2026-11-12T10:52:00Z |
| #72 | success | `7a40e3d` | 2026-11-12T10:17:56Z |
| #71 | cancelled | `508b533` | 2026-11-12T10:17:54Z |
| #70 | success | `2310af8` | 2026-11-12T10:16:46Z |
| #69 | cancelled | `5197a3e` | 2026-11-12T10:14:25Z |
| #68 | cancelled | `45af6b3` | 2026-11-12T10:14:21Z |
| #67 | cancelled | `4e65148` | 2026-11-12T10:11:54Z |
| #66 | cancelled | `abb060e` | 2026-11-12T10:11:52Z |
| #65 | success | `22235fd` | 2026-11-12T10:11:35Z |
| #64 | success | `ceb3de6` | 2026-11-12T10:11:05Z |
| #63 | success | `872031b` | 2026-11-12T10:09:52Z |
| #62 | success | `a36c3f8` | 2026-11-12T10:09:12Z |
| #61 | success | `20deddb` | 2026-11-12T10:08:56Z |
| #60 | success | `0f4edb2` | 2026-11-12T10:08:22Z |
| #59 | success | `52dfcd3` | 2026-11-12T10:07:10Z |

Total runs recorded on this branch: **88**.

Observations:

- The latest run (#88) is green on the audited commit `56bd1dd`.
- Runs #82 and #83 were **cancelled** by the workflow's `concurrency` group
  (`cancel-in-progress: true`), not by failure.
- Run #81 **failed at the `selene src tests` step** with two warnings: a deprecated
  `Enum.Font.GothamSemibold` in `src/client/CuriosityArchiveHUD.client.luau:41` and an
  unused `plinth` variable in `src/server/World/CuriosityArchive.server.luau:121`.
  Both were fixed in later commits; the tree is lint-clean today.
- Paired runs (a push run plus its own auto-commit run) show that the workflow's
  formatting auto-commit **re-triggers** the workflow, because the committed files
  match the `roblox/**` path filter.

Raw snapshot: `ci-runs.json` (same folder).
