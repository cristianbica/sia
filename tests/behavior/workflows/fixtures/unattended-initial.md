---
id: 2026-07-13-01-restocking-report
operation: implement
workflow: delivery
execution_mode: unattended
authorization_ceiling: [implement the repository-local restocking report]
authorized_external_actions: []
status: approved
revision: 1
approved_revision: 1
approved_digest: fixture-digest-revision-1
approved_at: 2026-07-13T12:00:00Z
base_ref: abc123
staged_paths: []
unstaged_paths: []
untracked_paths: []
next_phase: build
blocked_phase:
blocker_attempt: 0
docs: []
skills: [repository-discovery, testing]
---

<!-- sia:approval:start -->
id: 2026-07-13-01-restocking-report
operation: implement
workflow: delivery
execution_mode: unattended
authorization_ceiling: [implement the repository-local restocking report]
authorized_external_actions: []
revision: 1
base_ref: abc123
staged_paths: []
unstaged_paths: []
untracked_paths: []
docs: []
skills: [repository-discovery, testing]

## Outcome

Implement the repository-local restocking report.

## Context, scope, and non-goals

Change only the report and its repository tests. Do not deliver externally.

## Acceptance criteria and steps

Implement and verify the report.

## Validation, documentation impact, risks, assumptions, and exclusions

Run the focused tests and preserve pre-existing work.
<!-- sia:approval:end -->

<!-- sia:evidence:start -->
```sia-phase-boundary
sequence: 1
plan_revision: 1
completed_phase: approval
next_phase: build
head_ref: abc123
changed_paths: []
unresolved_material_findings: false
authorization_source: unattended-invocation
```
<!-- sia:evidence:end -->
