---
id: 2026-07-13-01-restocking-report
operation: implement
workflow: delivery
execution_mode: unattended
authorization_ceiling: [implement the repository-local restocking report]
authorized_external_actions: []
status: blocked
revision: 2
approved_revision: 2
approved_digest: fixture-digest-revision-2
approved_at: 2026-07-13T12:10:00Z
base_ref: abc123
staged_paths: []
unstaged_paths: []
untracked_paths: []
next_phase: fix
blocked_phase: fix
blocker_attempt: 1
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
revision: 2
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

Implement and verify the report with the corrected repository query boundary.

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

```sia-phase-boundary
sequence: 1
plan_revision: 2
completed_phase: approval
next_phase: build
head_ref: abc123
changed_paths: []
unresolved_material_findings: false
authorization_source: unattended-invocation
```

```sia-phase-boundary
sequence: 2
plan_revision: 2
completed_phase: build
next_phase: review-validate
head_ref: def456
changed_paths: [app/reports/restocking.rb]
unresolved_material_findings: false
```

```sia-phase-boundary
sequence: 3
plan_revision: 2
completed_phase: review-validate
next_phase: fix
head_ref: def456
changed_paths: [app/reports/restocking.rb]
unresolved_material_findings: true
```

```sia-blocker
plan_revision: 2
phase: fix
resume_status: in-progress
attempt: 1
reason: concurrent edits overlap the approved fix and make attribution unsafe
resume_when: overlapping work is resolved without discarding pre-existing changes
```
<!-- sia:evidence:end -->
