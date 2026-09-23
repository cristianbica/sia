---
name: delivery
description: Make the requested code change, check it, and explain the result.
---

# Delivery

Follow the protocol's shared planning boundary: inspect relevant code and callers, resolve material scope questions,
then create and present a saved plan using saved-plan support. Wait for approval before implementation edits.

After approval, use existing patterns where they fit, make the change, run suitable checks, and review the result
against the user's request. Continue through in-scope fixes without another approval. Ask when new evidence materially
changes the agreed scope or an action requires permission. No route classification, receipt, or worker is required.

Add behavior and mechanisms only when the task requires them. Prefer the simpler existing approach; explain a
consequential departure with repository evidence. Fix the cause of a bug rather than adding speculative retries,
fallbacks, or unrelated cleanup. Skills declared by the operation load at entry; load additional
documentation or safe-refactoring skills only when useful, respecting the effective catalogs. Reuse already loaded
skills. Stop checking after suitable checks pass unless new evidence justifies more work.

## Planning

Planning is read-only except for the plan file. Understand the affected code before proposing how to change it.
Ground the approach in repository evidence and resolve or name material unknowns. Use the shared saved-plan support
for writing guidance. Present the plan and wait for approval before implementation. A clear approval authorizes its
work; ask again only if its boundary changes.

Save a plan for every change request unless the user explicitly selects an exception. Load saved-plan support for its
format and approval state. Existing saved plans keep their approval requirements. Unattended saved plans use their
recorded ceiling. An approved plan's implementation still follows this workflow.

## Review and completion

Before final review, resolve and load the effective `code-review` and `testing` skills through their catalog. Honor
CUSTOM overrides and reuse already loaded skills. Review is required; a separate worker is optional.

Review the diff against the original request, subsequent user changes, and any approved plan. Challenge unnecessary
features even if the plan introduced them. Fix in-scope defects; report any boundary change before acting on it.
Prefer independent review when useful, but do not require a worker. Report the result, meaningful checks, and
remaining issues. Update affected documentation as part of the change. Saved-plan completion follows its support file.

## Optional support

Load only what the task needs; these are supporting files, not additional operations or required phases. CUSTOM
workflows own their task support; shared plan support still applies at the protocol boundary.

| Use | Supporting documents |
| --- | --- |
| coding | [saved plans](delivery/standard.md) |
| saved-plan | [saved plans](delivery/standard.md) |
| forge | [Forge](delivery/forge.md) |
| worker | [handoff](delivery/handoff.md) |
