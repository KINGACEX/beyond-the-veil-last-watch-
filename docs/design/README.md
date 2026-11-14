# BTV Design and QA Package

**Project:** Beyond the Veil: The Last Watch  
**Package date:** 2026-11-14  
**Status:** Approved design direction; implementation and runtime validation remain separate gates.

This directory preserves the approved design and quality-assurance specifications. These documents are planning contracts, not evidence that a feature is implemented, tested in Roblox Studio, or shipped.

## Documents

1. [Ember Command Design Specification](ember-command-design-spec.md)
2. [Gameplay Acceptance Specification](gameplay-acceptance-spec.md)
3. [Android-First Interface Specification](android-first-interface-spec.md)
4. [World Production Specification](world-production-spec.md)
5. [Technical Design and QA Handbook](technical-design-qa-handbook.md)
6. [Mission and Progression Contract](mission-progression-contract.md)
7. [Multiplayer Interaction and Security Test Catalogue](multiplayer-interaction-security-test-catalogue.md)

## Governance and status vocabulary

- **CONFIRMED:** Supported by the project context or an explicitly accepted decision.
- **APPROVED DESIGN:** The user has approved the direction for planning and future implementation.
- **PROPOSED:** A design recommendation that still requires technical validation before implementation.
- **UNKNOWN:** Evidence is not available.
- **BLOCKED:** A dependency or environment limitation prevents verification.
- **COMPLETED:** A task has been carried out and its result is evidenced.

Approval of these documents does not authorize live DataStore use, migrations, public publishing, paid services, canon changes, destructive Git operations, or edits to another agent's active workstream.

## Important implementation boundary

The Roblox persistence gate must remain disabled until Studio, multiplayer, reconnect, and data-safety release gates have passed. The known current Ember implementation scope is **Hold** and **Regroup**; the other five commands described in the specification are not to be represented as implemented.

## Branch note

This documentation package is maintained on `docs/btv-design-qa-package-2026-11-14`, branched from the repository's then-current `main`. It is intentionally isolated from the active local Roblox development branch. Do not merge it into a gameplay branch without reviewing the base-branch relationship and reconciling any newer project documentation.
