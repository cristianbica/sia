---
name: review
description: Review a defined change for correctness, regressions, scope, and validation evidence without fixing it.
workflow: review
skills:
  - repository-discovery
  - code-review
  - testing
---

# Review

Assess the requested change in a separate read-only review and report actionable findings without modifying it.

## Intake

- Establish the review target, base revision, dirty-worktree baseline, and explicit focus areas.
- Locate the governing request, plan, acceptance criteria, or issue when supplied.
- Separate the target diff from pre-existing and unrelated repository changes.

Use the review workflow. Inspect the complete relevant diff, affected behavior, tests, documentation, and validation
evidence. Keep repository and external state read-only. A finding must identify concrete impact and file evidence; do
not inflate style preferences into correctness issues.

## Outcome

Report prioritized findings first, followed by validation assessed or run, assumptions, and residual risk. If no
material findings remain, say so directly without claiming proof of correctness. Recommend a fixing operation for
changes; do not apply fixes inside this operation.
