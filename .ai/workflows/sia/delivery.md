---
name: delivery
description: Make the requested code change, check it, and explain the result.
---

# Delivery

Follow the protocol's change approval rules, using its inline plan guidance or loading saved-plan support as directed.
Once authorized, implement, check, and review the change. No route classification, receipt, or worker is required.

Before editing, identify the code path to change, the caller behavior to preserve, and the check that will exercise
the change. Note paths already changed and inspect any pre-existing hunks that overlap your work. Reuse the existing
code path when it fits. Fix the cause of a bug and add behavior only when the task requires it. Declared skills load
at entry. Load additional documentation or safe-refactoring skills only when useful, respecting the effective
catalogs. Reuse loaded skills. Use the testing skill to select checks and decide when verification is sufficient.

Add or change tests when requested, required by the repository, or needed to cover changed behavior or a specific
regression that existing checks miss. Change docs when requested, required, or made inaccurate by the change.

## Review and completion

Review is required. Use the effective `testing` skill and reuse it if already loaded. Resolve `code-review` through
the skills catalog. Load it for concrete risks that warrant deeper review, when the user requests deeper review, or
when a CUSTOM override is selected. Reuse it if already loaded.

Review the diff against the request, later user changes, and any approved plan. Compare staged, unstaged, and untracked
paths with their initial state, excluding unauthorized plans, then inspect relevant hunks. For each new file,
abstraction, or fallback, identify the requirement or concrete failure that needs it. Remove incidental edits you
introduced, preserve edits you cannot attribute to yourself, and rerun checks affected by any cleanup. Follow the
protocol's approval rule if scope must expand. Saved-plan completion follows its support file.

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
| coding | none |
| saved-plan | [saved plans](delivery/standard.md) |
| forge | [Forge](delivery/forge.md) |
| worker | [handoff](delivery/handoff.md) |
