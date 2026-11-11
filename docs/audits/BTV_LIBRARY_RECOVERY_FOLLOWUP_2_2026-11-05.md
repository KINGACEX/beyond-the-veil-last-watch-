# BTV Library Recovery — Follow-up Pass 2
Date: 2026-11-05

## Scope
A further read-only inventory and extraction pass was performed against the ChatGPT Library. Original Library items were not modified.

## Additional historical sources successfully preserved

1. `docs/source-of-truth/legacy-extracts/BTV_Vertical_Slice_Part_1_Sunday_at_Logos_Rhema_legacy.extracted.md`
   - Source: `BTV Vertical Slice Spec, Part 1 A Sunday at Logos Rhema Temple.docx`
   - Full extracted text read: 241 lines; 14,061 characters before archive wrapper.
   - Status in source: PROPOSED, not canon until creator approval.
2. `docs/source-of-truth/legacy-extracts/BTV_Vertical_Slice_Part_2_Scout_Report_legacy.extracted.md`
   - Source: `BTV Vertical Slice Spec, Part 2 The Scout Report.docx`
   - Full extracted text read: 132 lines; 10,757 characters before archive wrapper.
   - Status in source: PROPOSED.
   - Both are earlier stage documents; later merged Vertical Slice Specification v1.0 and current explicit creator decisions take precedence.

## Existing Library sources cross-checked

- `BTV_Economy_Progression_and_Production_Readiness_v1.0.md` (16,356 bytes; Library source). This is already part of the previously inventoried source set; do not create a redundant copy.
- `BTV_Investigation_and_Evidence_Bible_v0.1.md` (45,719 bytes; Library source). Already represented in the previously inventoried source set; duplicate source copies should be tracked, not repeatedly imported.
- `BTV_Vertical_Slice_Specification_v1.0.md` (29,931 bytes; Library source). This is the merged later specification and should be treated as the active slice design reference subject to current canon/creator instructions.

## Inventory limitation

The BTV-specific folder and Game Development folder were individually enumerated. The BTV folder currently exposes the Investigation & Evidence Bible; the Game Development folder exposes the Economy/Progression/Production Readiness document. Additional root-level DOCX/PDF/ZIP files were discovered in earlier passes. This pass does not establish that the entire Library has been exhaustively searched, because the full Library contains many unrelated files and some binary materialization attempts were blocked.

## Next archive targets

- Inspect the two vertical-slice part documents against merged v1.0 for any unique material worth preserving in a separate delta note; do not merge obsolete content into active specs automatically.
- Continue root-level targeted inventory for PDF, DOCX, image, video and ZIP items using BTV-specific names and content.
- For original binaries, preserve original bytes only when access is authorized and a GitHub file-size/format policy is checked. Otherwise keep a source inventory and extraction, and leave the original in Library.
- For visual references, identify provenance and canon conflicts before adding them to active asset folders. Avoid uploading large binaries blindly.

## Delivery boundaries

- No game source code, project configuration, scenes or runtime assets were modified.
- No original Library file was deleted or overwritten.
- No old prototype ZIP was merged into the active Godot project.
- No game build, Godot import, automated test, Android export or device test was run.
