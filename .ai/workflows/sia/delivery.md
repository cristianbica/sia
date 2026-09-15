---
name: delivery
description: Make the requested code change, check it, and explain the result.
---

# Delivery

A clear implementation request authorizes local work within its scope. Inspect relevant code and callers, use existing
patterns where they fit, make the change, run suitable checks, and review the result against the user's request.
Continue through in-scope fixes without another approval. Ask when a missing decision would materially change the
result or an action requires permission. No route classification, receipt, saved artifact, or worker is required.

Add behavior and mechanisms only when the task requires them. Prefer the simpler existing approach; explain a
consequential departure with repository evidence. Fix the cause of a bug rather than adding speculative retries,
fallbacks, or unrelated cleanup. Skills declared by the operation load at entry; load additional testing, code-review,
documentation, or safe-refactoring skills only when useful, respecting the effective catalogs. Reuse already loaded
skills. Stop checking after suitable checks pass unless new evidence justifies more work.

## Requested plans

An explicit request to plan is read-only except for a requested plan file. Understand the affected code before
proposing how to change it. Explain the approach, important decisions, and how success will be checked; name material
unknowns instead of concealing them in a broad goal. Simple changes need only a short explanation. Do not require a
fixed template or invent alternatives for obvious edits. Present the plan and wait for approval before implementation.
A clear approval of that presented plan authorizes its work; ask again only if its boundary changes.

Save a plan only when requested. Load saved-plan support for its format and approval state. Existing saved plans keep
their approval requirements even though ordinary coding no longer creates them automatically. Unattended saved plans
use their recorded ceiling. An approved plan's implementation still follows this workflow.

## Review and completion

Review the diff against the original request, subsequent user changes, and any approved plan. Challenge unnecessary
features even if the plan introduced them. Fix in-scope defects; report any boundary change before acting on it.
Prefer independent review when useful, but do not require a worker. Report the result, meaningful checks, and remaining
issues. Update affected documentation as part of the change. Saved-plan completion follows its support file.

## Optional support

Load only what the task needs; these are supporting files, not additional operations or required phases.
A CUSTOM workflow owns its own supporting references.

| Use | Supporting documents |
| --- | --- |
| coding | none |
| saved-plan | [saved plans](delivery/standard.md) |
| forge | [Forge](delivery/forge.md) |
| worker | [handoff](delivery/handoff.md) |
