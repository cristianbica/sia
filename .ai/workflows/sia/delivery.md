---
name: delivery
description: Make the requested code change, check it, and explain the result.
---

# Delivery

Follow the protocol's shared planning boundary: inspect relevant code and callers, resolve material scope questions,
then present a plan in the format selected by the protocol. Wait for approval before implementation edits.

An invocation such as `Sia implement the above` or `Sia fix this` starts this workflow's planning steps, even after an
investigation recommended an approach. Resolve its remaining material decisions and present the finalized plan;
wait for a subsequent approval reply. Do not reinterpret the invocation as approval while preparing that plan.

After approval, use existing patterns where they fit, make the change, run suitable checks, and review the result
against the user's request. Continue through in-scope fixes without another approval. Ask when new evidence materially
changes the agreed scope or an action requires permission. No route classification, receipt, or worker is required.

Add behavior and mechanisms only when the task requires them. Prefer the simpler existing approach; explain a
consequential departure with repository evidence. Fix the cause of a bug rather than adding speculative retries,
fallbacks, or unrelated cleanup. Skills declared by the operation load at entry; load additional
documentation or safe-refactoring skills only when useful, respecting the effective catalogs. Reuse already loaded
skills. Use the testing skill to select checks and decide when verification is sufficient.

## Planning

Planning is read-only except when saving a plan file. Understand the affected code before proposing how to change it.
Ground the approach in repository evidence and resolve material design questions before requesting approval. Load
the shared saved-plan support for writing guidance for both inline and saved plans. Show the concrete use and result,
then the implementation approach; a scope checklist alone is insufficient. Present the plan and wait for approval
before implementation. A clear approval authorizes its work; ask again only if its boundary changes.

Display small, simple plans inline by default; save substantial plans or plans explicitly requested as files.
Inline plans need approval before edits and cannot resume across conversations. Load saved-plan support when saving
a plan for its format and approval state. Existing saved plans keep their approval requirements. Unattended saved
plans use their recorded ceiling. An approved plan's implementation still follows this workflow.

## Review and completion

Before final review, resolve and load the effective `code-review` and `testing` skills through their catalog. Honor
CUSTOM overrides and reuse already loaded skills. Review is required; a separate worker is optional.

Review the diff against the original request, subsequent user changes, and any approved plan. Challenge unnecessary
features even if the plan introduced them. Fix in-scope defects; report any boundary change before acting on it.
Prefer independent review when useful, but do not require a worker. Report the result, meaningful checks, and
remaining issues. Update affected documentation as part of the change. Saved-plan completion follows its support file.

Completion requires the agreed work, required checks, and review to finish. A progress-only response or end of turn
does not establish completion. Collect results from relevant background commands or workers before finishing; their
unfinished work cannot be reported as passed. If a required check cannot run, disclose the missing check and reason,
and report the blocked requirement rather than declaring verified completion. Continue other authorized work that
does not depend on the blocker. Stop once the requested work is done and checked.

## Optional support

Load only what the task needs; these are supporting files, not additional operations or required phases. CUSTOM
workflows own their task support; shared plan support still applies at the protocol boundary.

| Use | Supporting documents |
| --- | --- |
| coding | [saved plans](delivery/standard.md) |
| saved-plan | [saved plans](delivery/standard.md) |
| forge | [Forge](delivery/forge.md) |
| worker | [handoff](delivery/handoff.md) |
