# BTV_Static_Website_Review_v1_2.md

> **ARCHIVAL REFERENCE.** Historical website review. Website prototype is not the playable Godot game. Original Library source remains untouched.

# BTV Static Website Review — v1.2 Local Pass

**Status:** COMPLETED (local review and targeted edits only)
**Scope:** `index.html`, `js/app.js`, README and package structure in the uploaded static-site ZIP.
**Not reviewed:** full Master Canon, all specialist Bibles, final artwork, deployment in a browser/device, external links (none were present), trailer content/licensing, or a playable Godot build.

## Changes made

1. **Faith section wording:** clarified that the Holy Spirit is not a character, stat, or controllable gameplay resource. Ember’s Spirit Guidance is described narrowly and explicitly does not replace the Holy Spirit or provide direct answers.
2. **Ember codex preview:** removed “Spiritual Awakening,” which was not supported by the vertical-slice specification. Replaced the entry with the five listed abilities and seven official commands: Attack, Protect, Scout, Track, Retrieve, Hold, Regroup. Added the constraint that Ember provides local observations/warnings rather than automatic answers.
3. **Versioning:** README updated to v1.2 and notes local-only scope.

## Findings still open

- **Enemy taxonomy — UNKNOWN:** the website lists “Destroyers · Persuaders · Deceivers.” The supplied vertical-slice specification does not validate that as the current complete enemy taxonomy. Do not treat this display as fully verified until checked against the current Veil/Enemy Bible and canon changelog.
- **Broad feature claims — PROPOSED/UNVERIFIED:** “equipment & progression,” “relationships,” “teamwork,” and broad world-scale claims may describe the intended full game, but are not implemented evidence and exceed the current vertical-slice scope. If this is public marketing, add a visible pre-production/prototype disclosure.
- **Armor of God wording — REVIEW REQUIRED:** the page describes the Armor of God as “meaningful equipment and story systems.” Keep this only if it is consistent with the dedicated Faith/Prayer/Armor Bible and does not imply spiritual worth, salvation, or divine favor can be earned or equipped.
- **Project status disclosure:** the website currently calls itself a prototype in the Codex section, but does not clearly state that no playable game/build is verified. Add that disclosure before public release.
- **Accessibility QA:** menu behavior and keyboard/screen-reader navigation have not been tested in a browser; static source inspection is not an accessibility pass.

## Checks performed

- ZIP opens and expected `index.html`, `css/styles.css`, `js/app.js` files exist.
- Internal section links checked by static HTML parsing in the previous pass; no missing anchor targets were found in that check.
- Current HTML/JS wording checked for the prior dual-Chosen phrase and the removed “Spiritual Awakening” wording.
- No browser execution, mobile device testing, deployment, or GitHub write was performed.

## Next recommended action

Resolve enemy taxonomy and public prototype disclosure against current canon, then run browser/mobile accessibility checks. Separately, Phase 0 of the Godot project remains blocked on creating/opening an actual project and confirming a target device/toolchain; this website is not an Android game.
