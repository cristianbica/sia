---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Make Sia plans easier to understand

<!-- sia:approval:start -->
Give Sia a clear, human-readable plan format. Start with a short explanation, describe how the
functionality works, list the implementation work, then explain useful details with examples. Keep Orchestra's focus
on concrete steps, existing code, and verification.

## How it works

- Open with a few short sentences explaining the proposed approach.
- Use **How it works** for the behavior the user will get.
- Use **What we will implement** for the work needed to deliver that behavior.
- Use **Implementation details** for important choices, examples, and dependencies.
- Use short sentences and bullets with one main point each.
- Name files and commands where they help explain an action.
- Explain unfamiliar terms when they first appear.
- Keep useful technical detail. Do not force the reader to unpack a paragraph inside each bullet.
- State assumptions, risks, checks, and approval limits where they are easy to find.
- Keep small plans small. Omit sections that would add no useful information.
- Present the same readable structure in the saved plan and its chat presentation.
- Keep approval metadata out of the explanation shown to the user.

## What we will implement

- Replace the current writing guidance in `src/managed/.ai/workflows/sia/delivery/standard.md`.
- Add the default structure and worked examples to that guidance.
- Align `delivery.md` so it points to the same format without competing instructions.
- Remove advice that discourages useful ordering or examples.
- Clarify that preserving requirements does not mean repeating them in every section.
- Update `docs/orchestration.md` and the plan examples in `docs/writing-examples.md`.
- Include invented examples for a larger feature and a small code change.
- Extend the existing benchmark runner with a planning-specific comparison.
- Run local checks and refresh this checkout's installed Sia files through `./install.sh`.

## Implementation details

### Show the format through examples

Use a fictional reading-list application for the larger example:

> Let readers organize saved books into lists. Reuse the existing book catalog and add list membership.

- **How it works:** Readers create lists, add books, and remove books from a list without deleting them from the catalog.
- **What we will implement:** Add list storage, membership actions, an editing screen, and tests.
- **Implementation details:** Show a small membership example and explain how duplicate entries are prevented.

- Use wholly invented requirements and names for all new examples and benchmark fixtures.
- Do not copy another project's architecture, commands, configuration, identifiers, or requirements from conversation.
- A supplied writing example establishes presentation preferences, not permission to publish its project content.
- Mark fictional files and commands as illustrative. Do not imply they exist or were tested.

Examples may include code, configuration, and commands. Include them when they make the design easier to understand.
Do not reproduce an entire runbook inside every plan. Do not invent features just to fill a section.

### Test the guidance that writes plans

The current concise-output benchmark does not load the planning instructions. Adding another prompt to it would not
measure this change.

- Reuse its isolated calls, instruction snapshots, and comparison reports.
- Add a planning mode that loads the actual planning guidance and its examples.
- Preserve the old guidance as the comparison baseline.
- Give both versions the same task facts. Do not put the desired format into only one task prompt.
- Include a fictional multi-part feature and a small change to check that the format scales.
- Review whether readers can understand the behavior, implementation work, and examples.
- Reject dense bullets, vague summaries, missing requirements, invented scope, and needless repetition.
- Check that the runner selects the correct instructions and keeps baseline and candidate separate.

### Verify and deliver

- Run the benchmark's local checks and `sh scripts/verify`.
- Review the examples against their invented task requirements and the requested writing style.
- Check all new plan, documentation, and fixture content for information copied from other projects.
- Refresh the installed files with `./install.sh` and inspect the resulting changes.
- Show the fictional worked example with the completion report.
- Report authored examples and automated checks separately from live model results.

## Scope and approval

- Change Sia's planning prompts, examples, evaluation support, and related documentation.
- Preserve the existing approval and resume rules.
- Do not include or implement work from other projects.
- Preserve unrelated work. No commits or pushes.
- Live comparisons need an agreed provider, model, and budget before execution.
- Do not claim reliable model improvement from local checks alone.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base 19c29f330ae52eebf2e0782c40e9757b72342622 -->
<!-- sia:dirty .ai/plans/2026-09-19-01-complexity-based-model-selection.md -->

<!-- sia:approved 4053eab0599b74b646a6fad1747067b4a280a9692d89ecb9d086b8fac31d008d -->

<!-- sia:progress Implemented and reviewed source guidance, fictional examples, and planning comparison. All 10 benchmark runner tests, planning case validation, full sh scripts/verify, and git diff --check passed. Installer refreshed managed files; installed planning files match source. No live model comparison, commits, or pushes. -->
