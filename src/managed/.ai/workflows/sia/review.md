---
name: review
description: Independently review a defined change and its evidence without modifying repository content.
---

# Review workflow

Review is read-only and normally planless. It evaluates a defined target, reports prioritized findings, and never
turns review findings into unapproved edits.

## Establish scope

- Identify the target and base revision, including staged, unstaged, and untracked paths in scope.
- Record pre-existing dirty paths so attribution remains accurate.
- Load project rules, the resolved operation and skills, relevant docs, acceptance criteria, and supplied evidence.
- State focus areas, exclusions, environmental limits, and whether context is isolated, new-conversation, or shared.
- Request `reasoning` unless the user or project rules choose otherwise.

Refuse an ambiguous target rather than reviewing an arbitrary nearby diff. Do not scan historical plans for a likely
match; load a plan only when the request names it.

## Inspect

Review the complete relevant diff and trace affected behavior far enough to assess correctness. Check scope,
regressions, boundary conditions, security and operational risks, error handling, compatibility, tests, and repository
documentation. Compare command claims with inspected results and never claim an unrun check passed.

Independent, non-overlapping areas may be assigned to bounded workers. Workers receive exact scope, evidence,
exclusions, `do_not_load` paths, and one findings format. The coordinating session verifies and deduplicates their
results and owns the final severity judgment.

## Report

List findings by severity and impact. Each finding includes a concise title, affected path and location, failure
scenario, and why it matters. Avoid speculative findings without a plausible trigger or evidence. Keep optional
improvements separate from defects.

Then report validation run or assessed, assumptions, residual risks, and the review isolation mechanism. If no material
findings remain, state that explicitly while noting meaningful test or environment gaps. Recommend `Sia fix` when edits
are warranted; never make those edits inside review.

If interrupted, restart the bounded review explicitly; this workflow has no resumable artifact. Cancellation leaves
repository and external state unchanged apart from read-only evidence gathering.
