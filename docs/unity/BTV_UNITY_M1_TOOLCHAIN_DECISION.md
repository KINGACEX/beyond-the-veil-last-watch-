# BTV Unity Port — M1 Toolchain Decision Record

**Status:** PARTIALLY COMPLETE — VERSION FAMILY SELECTED; EXACT EDITOR PATCH AND LOCAL VALIDATION BLOCKED  
**Date:** 2026-11-26  
**Branch:** `btv/unity-port-001`  
**Source branch preserved:** `btv/bootstrap-prototype-001`

## Decision

- **Provisional editor line:** Unity 6.3 LTS.
- **Reason:** Unity's official release support page identifies Unity 6.3 LTS as the current LTS line and states support through December 2027. LTS is the conservative baseline for a parallel production port.
- **Exact editor patch:** NOT PINNED. Pin only after the project can be opened on the actual development machine and the chosen patch is confirmed available.
- **Render pipeline:** NOT SELECTED. Do not select URP/HDRP/Built-in before target-device and visual/performance requirements are checked.
- **Android Build Support:** REQUIRED for later Android export; installation and export-template availability are NOT VERIFIED.
- **License route:** Unity Personal is the intended no-cost tier, subject to eligibility. Unity's published threshold for Personal is total finances below US$200,000 over the preceding 12 months. Eligibility must be checked against the actual project owner/operator and current terms; do not assume a sponsor or organization is covered by an individual's eligibility.
- **CI:** DEFERRED. Do not add a Unity CI workflow until a supported, no-cost licensing/activation path is confirmed. No license credentials or activation secrets may be committed.
- **Target device:** NOT VERIFIED. Android device model, Android version, CPU/GPU, RAM and available storage have not been supplied/inspected in this work session.

## Evidence reviewed

1. Unity 6 release support page: https://unity.com/releases/unity-6/support
   - Identifies Unity 6.3 LTS as the latest LTS line.
   - States Unity 6.3 LTS support through December 2027.
   - States LTS is recommended for production projects locking a version.
2. Unity Editor licensing information: https://unity.com/pages/license-compliance
   - States the Unity Personal financial threshold is US$200,000 for the preceding 12 months.
3. Unity Personal product page: https://unity.com/products/unity-personal
   - Describes Unity Personal as the free tier for eligible creators.

## Constraints and unresolved checks

- This work session has GitHub repository access but no demonstrated Unity Editor executable, Unity Hub installation, Android SDK/NDK, Java toolchain or physical Android device access.
- Therefore no claim is made that Unity can currently be launched, licensed, imported, compiled, tested or exported.
- Do not pin a specific editor patch based solely on a web listing. Confirm the patch in Unity Hub on the actual development machine, then commit the matching `ProjectVersion.txt`.
- Do not install a paid Unity plan, paid asset, paid plugin, cloud build or subscription.
- Do not modify the Godot project or its validation workflow.

## M1 acceptance status

| Check | Status |
|---|---|
| Official LTS line researched | PASS — Unity 6.3 LTS |
| Free-tier eligibility criteria researched | PASS — current terms must still be checked by project operator |
| Exact editor patch confirmed on target machine | BLOCKED |
| Android Build Support installed and verified | BLOCKED |
| Actual target Android device profiled | BLOCKED |
| Free/licensing-compatible CI path verified | DEFERRED |
| Final editor patch pinned | BLOCKED |

**M1 is not complete.** The LTS family decision is provisional and documented; remaining environment checks must be performed before M2 is treated as ready for implementation.

## Next safe action

On the development computer, install Unity Hub and the selected Unity 6.3 LTS editor with Android Build Support only if the official free license terms are satisfied. Record the exact editor version shown by Unity Hub. Then open a clean Unity project and verify batchmode/editor startup before creating the BTV project scaffold. If no compatible computer is available, keep M1 blocked and continue with engine-neutral design documentation only.
