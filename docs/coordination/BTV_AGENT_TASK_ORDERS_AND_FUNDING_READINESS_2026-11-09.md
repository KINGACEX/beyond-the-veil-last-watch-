# BTV — Agent Task Orders and Funding Readiness
**Issued:** 2026-11-09  
**Repository:** KINGACEX/beyond-the-veil-last-watch-  
**Status:** ACTIVE TASK INSTRUCTIONS — planning and review only; creator approval remains required for consequential changes.

## Coordination rules
1. Read this file and the latest repository instructions before starting.
2. Treat GitHub as the shared source of truth. Report the exact branch and commit SHA used.
3. Do not assume a local workspace is identical to GitHub. Compare them and report divergence before editing.
4. Use the status labels CONFIRMED, PROPOSED, UNKNOWN, BLOCKED, and COMPLETED.
5. Keep changes in focused branches and open/update draft PRs for review. Do not merge, release, publish, spend money, change credentials/permissions, or perform destructive actions without explicit creator approval.
6. Never place access tokens, OAuth codes, private keys, passwords, or other credentials in repository files, issues, or chat.
7. Do not claim Android device/emulator validation unless it was actually performed and evidence is supplied.
8. MiniMax and Claude must not edit the same files concurrently. MiniMax owns code/tests; Claude owns visual mockups/specification. Coordinate through issue #3 and PR descriptions.

## Assignment A — MiniMax Code / Mavis (Engineering)
**Priority:** XH-003 same-action input composition and canonical prototype baseline.

1. Read the XH-003 proposal and all November 9 audit addenda under `docs/coordination/xh-002-evidence/addendum-2026-11-09/`.
2. Verify the current branch and commit SHA. Compare the local workspace with the GitHub branch and report every meaningful divergence before modifying anything.
3. Reproduce the same-action defect against the exact current branch: keyboard W + touch joystick in both release orders; keyboard E + touch Interact; focus loss and touch cancellation. Include real key events where applicable.
4. Validate the proposed source-separated action architecture against the actual player controller, InputMap, touch overlay, and existing tests. If the proposal needs changes, explain why before implementation.
5. Implement the smallest maintainable fix on a dedicated XH-003 branch after recording the baseline. Keep keyboard, touch, and any future gamepad source ownership separate; compose movement once in the player controller. Do not add speculative gamepad support without a concrete requirement and test path.
6. Add regression tests for both input orders and Interact, plus relevant lifecycle/focus cases. Update existing tests whose assumptions change.
7. Reconcile all test counts and claims in PR #4 and evidence docs. Clearly separate local headless results, CI results, emulator results, and physical-device results.
8. Propose a safe CI plan that runs every relevant suite. Do not widen token scopes or alter workflow permissions. If CI cannot run, state the exact blocker and provide reproducible commands.
9. Resolve and document the canonical project source: compare local workspace, base branch, XH-002 branch, and default branch. Do not copy or overwrite project trees until the creator approves a reconciliation plan.
10. Produce a prototype engineering milestone plan: (a) stable movement/camera/touch input, (b) one interactable, (c) one small environment, (d) one short objective/mission loop, (e) exportable Android test build. Estimate effort only with explicit assumptions.
11. Deliver: branch + commit SHA, changed-file list, test commands/results, known limitations, CI state, project-source reconciliation report, and next blockers.

**Do not:** merge PR #4 or #5; change canon; create an app ID or signing credentials; publish an APK; add paid dependencies; rotate or edit secrets; change repository permissions; or modify Claude's visual design files.

## Assignment B — Claude (Visual Director / UX)
**Priority:** actual Android HUD mockups and an implementation-ready specification.

1. Read this file, the latest coordination issue #3, PR #4, and the XH-003 audit/proposal. Inspect the actual current HUD and touch-control scene before designing.
2. Report the exact branch/commit SHA inspected and list any files or screens unavailable to you. Do not claim repository access if it is not working.
3. Produce actual visual mockups (not only prose) for:
   - exploration HUD;
   - combat/action HUD;
   - contextual interaction state;
   - pause/navigation overlay.
4. Define a coherent BTV visual system: white foundation, restrained gold, dark neutral surfaces, legible type, restrained cross-centred Covenant symbolism, and no generic cluttered mobile-game HUD.
5. Specify each element's purpose, visibility rules, anchoring, relative sizing, touch target, spacing, safe-area behaviour, responsive rules, and state transitions.
6. Cover Android screen sizes/aspect ratios, cutouts/insets, landscape layout, thumb reach, multi-touch, contrast, text scaling, and accessibility. Flag assumptions requiring device testing.
7. Explicitly preserve BTV canon: no faith/salvation currency or spiritual guidance as a purchasable/rechargeable stat; prayer remains non-transactional; no unsupported spiritual power meters.
8. Map each proposed HUD element to the existing Godot scene/node/script where possible. Identify required new nodes/assets and provide handoff notes for MiniMax without editing game source code.
9. Prepare a visual direction for a truthful prototype capture and crowdfunding presentation. Clearly label concept art/mockups versus actual gameplay footage.
10. Deliver: mockup files or images, design specification, component inventory, interaction/state notes, asset list, accessibility review, implementation handoff, and unresolved questions.

**Do not:** edit game source, merge PRs, change canon, fabricate screenshots of working gameplay, or represent mockups/CGI as implemented functionality.

## Shared funding-readiness research (both agents)
This is preparation only, not permission to launch a campaign or solicit money.

- MiniMax: provide a bottom-up prototype cost/effort estimate with assumptions, staffing, software/hardware, testing, contingency, and milestone dependencies. Do not invent prices; mark estimates as estimates and identify what needs quotes.
- Claude: prepare a clear, honest public-facing explanation of the prototype scope, visual identity, current state, and what a future campaign could fund. Separate completed work, in-progress work, mockups, and future promises.
- Both: identify risks that could cause delays or make rewards impossible to fulfil. Recommend a digital-first, low-fulfilment-risk reward structure; do not promise physical goods, release dates, platforms, or features that are not validated.
- Neither agent may create a live campaign, accept funds, contact potential backers, promise rewards, or publish promotional material.

## Funding and legal gate
The project is Ghana-based. Kickstarter's current creator eligibility list does not include Ghana, and its individual creators must be at least 18. A person under 18 may participate only under the supervision of the eligible project creator. Do not bypass geographic, identity, age, banking, tax, or platform requirements, and do not use another person's identity as a front. Any future campaign must be genuinely owned and controlled by an eligible adult or eligible registered entity, with qualified advice on legal, tax, payment, IP ownership, and fulfilment responsibilities.

No platform is selected yet. First prepare the prototype, budget, audience evidence, honest campaign materials, and a verified list of legally available funding routes for the actual responsible adult/entity.

## Acceptance gate
Return findings and proposed changes first. The creator reviews the reports and explicitly approves implementation scope. No PR is merged and no campaign is launched by these instructions.
