---
name: delivery
description: Deliver authorized changes through planning, review, validation, fixes, and product-read-only shipping.
---

# Delivery workflow

Follow `Plan → Approve → Build → Review/Validate → Fix → Review/Validate → Ship`. Replanning returns to Plan and
authorizes a new exact revision through the current interactive or unattended execution mode.

## Plan

- Purpose: produce an executable, evidence-based delivery plan.
- Gate: none on entry; product and source writes are forbidden.
- Isolation: active session or bounded read-only scout.
- Model profile: request `reasoning` unless the user or project rules choose otherwise.
- Inputs: request, project rules, relevant docs, repository evidence, operation, and declared skills.
- Output: a persisted plan plus a concise user-facing summary of outcome, scope, non-goals, criteria, steps,
  validation, risks, assumptions, external actions, path, and revision. The digest is internal and is not shown as an
  approval token.
- Transition: persist the draft plan under `.ai/plans/`, then enter Approve.

Every delivery plan is persisted before authorization, even when all phases remain in one conversation.
During Plan, record the initial staged, unstaged, and untracked path baseline, execution mode, and base commit in
approval-controlled content. For unattended mode, derive the smallest `authorization_ceiling` from the activating
request and list only its explicit external actions. Preserve both fields byte-for-byte in every later revision. Do not
copy untracked contents into the plan. Discovery may create only that artifact and must not modify product/source files.

## Approve

- Purpose: bind permission to the exact proposed change.
- Gate: exact-revision user approval in interactive mode; activating-request authorization in unattended mode.
- Writes: approval metadata in the plan artifact only.
- Transition: Build after approval; Plan after any material change.

Interactive mode presents the current draft plan summary and asks for plain-language approval. Accept `approve`,
`approved`, `go ahead`, `proceed`, or an equally unambiguous affirmative only for that one current displayed draft.
Never ask the user to copy, repeat, inspect, or compare a digest. After approval, Sia computes and records the digest
itself and verifies it matches the displayed revision before Build. If the plan, baseline, or scope changes—or there is
no one current displayed draft—keep or return it to `draft`, present the revised plan, and request fresh plain approval.

The up-front unattended authorization records `execution_mode: unattended`, verifies the plan is the smallest faithful
interpretation of the activating request, and continues without claiming the user reviewed it. The approval-controlled
outcome, scope, non-goals, criteria, assumptions, and exclusions must all remain within the immutable unattended
authorization ceiling.

Editing approval-controlled content increments the revision, clears approval, and returns to Plan. An unattended
replan may be automatically authorized only inside that ceiling and without changing either authorization field;
otherwise it blocks instead of asking. Neither mode expands host permissions or external actions.

## Build

- Purpose: implement only approved scope, including tests and affected repository documentation.
- Isolation: prefer an isolated worker, then a fresh conversation, then bounded same-context execution.
- Model profile: request `fast` for mechanical work and `reasoning` for risky or complex work.
- Inputs: approved plan, exact resolved definition paths, baseline, relevant docs, rules, and bounded handoff.
- Writes: approved repository scope, relevant tests, `.ai/docs/**`, and plan evidence.
- Transition: Review/Validate when complete; Plan for material scope or approach changes.

Before Build, compare the current commit and changed paths with the approved baseline. Preserve existing changes and
report safely preservable overlap. In unattended mode, unsafe overlap, concurrent edits, or attribution blocks before
writes; do not replan around it or modify, stash, reset, clean, or overwrite the pre-existing work.

Resolve Build skills by logical name through the effective skill catalog. If the approved plan has documentation
impact, load the effective `documentation` skill. Load the effective `safe-refactoring` skill only when the approved
change modifies existing behavior or structure and refactoring guidance is relevant. In both cases, respect a CUSTOM
override and put the exact resolved path in the handoff; do not load either skill when the condition does not apply.

## Review/Validate

- Purpose: assess the complete implementation and verification evidence in a separate phase.
- Gate: Build or Fix has produced a reviewable change.
- Isolation: prefer a worker that did not build the change; report the actual isolation mechanism.
- Model profile: request `reasoning`.
- Inputs: approved plan, complete diff, dirty baseline, docs changes, tests, and command evidence.
- Writes: review evidence in the active plan only; do not modify product or source files.
- Transition: Fix for in-scope findings, Plan for material findings, or Ship when acceptance criteria are satisfied.

Inspect correctness, scope, regressions, security and operational risk, documentation, and the truthfulness of command
claims. Do not claim that an uninspected command passed.

For this phase, resolve and load the effective `code-review` and `testing` skills through the skill catalog. Respect
CUSTOM overrides, record the exact resolved paths, and use the selected definitions for both Review and Validate.

## Fix

- Purpose: resolve review findings without broadening approved scope.
- Isolation: use a bounded build/fix worker when available.
- Model profile: request `fast` for mechanical remediation or `reasoning` for complex findings.
- Writes: same scope as Build.
- Transition: always return to the separate Review/Validate phase; return to Plan for material changes.

Allow at most three unattended Review/Validate → Fix cycles per plan revision. If material findings remain, record a
blocker instead of looping or weakening acceptance criteria. Interactive mode may request new direction.

## Ship

- Purpose: hand off the final reviewed result.
- Gate: acceptance criteria satisfied and validation evidence reviewed.
- Model profile: inherit the final review context; no new model capability is required.
- Writes: active plan status and completion evidence only; no product, source, or external state by default.
- Output: behavior, changed paths, verification, isolation used, approved deviations, and remaining risks.

After recording `complete`, interactive Ship offers: “Keep the completed plan for history, or delete this plan file?”
Delete only the exact active plan after explicit affirmative response. Do not infer deletion from approval, completion,
or a general cleanup request. Unattended Ship never asks and always keeps the completed plan. If deletion is declined
or fails, report that the completed plan was retained and still complete the delivery report.

Commit, push, pull request, release, publish, and deploy require explicit user intent. Never infer them from approval of
the implementation plan or from unattended mode.

## Persisted plan

A cross-context delivery plan uses at least this frontmatter:

```yaml
---
id: 2026-07-13-01-short-task-name
operation: implement
workflow: delivery
execution_mode: interactive
authorization_ceiling: [exact-plan-revision]
authorized_external_actions: []
status: draft
revision: 1
approved_revision:
approved_digest:
approved_at:
base_ref: 4d3f...
staged_paths: []
unstaged_paths: []
untracked_paths: []
next_phase: approval
blocked_phase:
blocker_attempt: 0
docs: []
skills: [repository-discovery, testing]
---
```

The body uses exactly these ordered, nonnested marker pairs:

```markdown
<!-- sia:approval:start -->
id: 2026-07-13-01-short-task-name
operation: implement
workflow: delivery
execution_mode: interactive
authorization_ceiling: [exact-plan-revision]
authorized_external_actions: []
revision: 1
base_ref: 4d3f...
staged_paths: []
unstaged_paths: []
untracked_paths: []
docs: []
skills: [repository-discovery, testing]

## Outcome
...

## Context, scope, and non-goals
...

## Acceptance criteria and steps
...

## Validation, documentation impact, risks, assumptions, and exclusions
...
<!-- sia:approval:end -->

<!-- sia:evidence:start -->
Append phase transitions, definition paths, model reporting, command results, findings, and deviations here. Each phase
boundary uses the fenced record defined below.
<!-- sia:evidence:end -->
```

Use one ordered record after Approval and each completed Build, Review/Validate, Fix, or Ship phase:

````markdown
```sia-phase-boundary
sequence: 1
plan_revision: 1
completed_phase: approval
next_phase: build
head_ref: 4d3f...
changed_paths: []
unresolved_material_findings: false
authorization_source: explicit-user
```
````

`sequence` starts at 1 for each `plan_revision` and increases by one. Resume validates only records matching the
approved revision; earlier revisions remain historical evidence. An Approval record requires an authorization source
matching its mode: `explicit-user` for interactive or `unattended-invocation` for unattended. Legal transitions are
Approval → Build, Build → Review/Validate, Review/Validate → Fix, Fix → Review/Validate, Review/Validate → Ship, and
Ship → none. A missing, duplicated, out-of-order, or contradictory current-revision record prevents resume.

An unattended blocker appends this separate record without pretending the phase completed:

````markdown
```sia-blocker
plan_revision: 1
phase: build
resume_status: in-progress
attempt: 1
reason: <specific blocker>
resume_when: <observable changed condition>
```
````

## Lifecycle state

Update frontmatter and append the required phase-boundary record as one logical artifact change:

| Event | `status` | `next_phase` | Required record |
| --- | --- | --- | --- |
| Plan persisted or materially revised | `draft` | `approval` | None; clear approval fields |
| Interactive approval or unattended authorization | `approved` | `build` | Approval → Build |
| Build starts | `in-progress` | `build` | Latest record remains Approval → Build |
| Build completes | `in-progress` | `review-validate` | Build → Review/Validate |
| Review finds in-scope issues | `in-progress` | `fix` | Review/Validate → Fix |
| Fix completes | `in-progress` | `review-validate` | Fix → Review/Validate |
| Review passes | `in-progress` | `ship` | Review/Validate → Ship |
| Unattended phase blocks | `blocked` | Keep current phase | `sia-blocker` outside phase boundaries |
| Ship report completes | `complete` | `none` | Ship → none |
| User cancels | `cancelled` | `none` | Record the reason outside a phase-boundary record |

Ship closes the plan artifact as shown above. By default it remains available as history and evidence. Interactive
cleanup may delete only that exact completed plan after explicit confirmation. Unattended execution always retains it.
Product,
source, and external delivery state remain read-only unless the user explicitly requests and authorizes another action.

The approval metadata must match frontmatter, and `execution_mode` must be exactly `interactive` or `unattended`.
For unattended plans, `authorization_ceiling` and `authorized_external_actions` are immutable across revisions and
resume; any mismatch is an integrity error.
Compute the lowercase SHA-256 digest over only the bytes between the approval marker lines after converting CRLF to LF,
excluding a UTF-8 BOM, and ensuring exactly one final LF. Marker lines are excluded. The approval-block `revision` must
equal frontmatter `revision`, and frontmatter `approved_revision` must equal it. Refuse malformed or mismatched content.

Status, approval fields, `next_phase`, and evidence may change without invalidating approval. Evidence must not alter
approved scope. A material deviation edits the approval block, increments both revisions, clears approval, and returns
to Plan and Approve. Retain old records as prior-revision evidence and restart the new revision's sequence at 1.
Interactive mode waits; unattended mode auto-authorizes only an in-ceiling revision.

At every phase boundary, place the exact current definition paths in the handoff. Load only the named active plan and
honor explicit `do_not_load` paths.

Cancellation sets `status: cancelled`, sets `next_phase: none`, records the reason, and preserves the artifact as
non-active evidence. A cancelled artifact cannot resume; later work starts a new operation and plan.

Continue an interrupted approved or in-progress artifact only with `Sia resume <approved-plan>`.

Resume accepts `approved` or `in-progress`, plus `blocked` only for an unattended plan with a valid latest blocker.
Approved and in-progress state must match the latest current-revision boundary. Blocked frontmatter must match the
blocker's phase and attempt and retain the prior status as `resume_status`. Ship requires passing final review evidence.

Resume inherits the approval-controlled mode and immutable authorization fields; it never switches them from
conversation text. If `resume_when` is unchanged, return the same blocker without running the phase or incrementing its
attempt. When it changes, restore `resume_status`, continue, and increment the attempt only if that phase blocks again.
Clear `blocked_phase` on continuation, retain the attempt count until the phase completes, then reset it to 0. A new
revision also resets it. After three attempts in one phase/revision, require new user instruction instead of resuming.

On resume, compare current HEAD and changed paths with `base_ref`, the initial dirty baseline, and the latest evidence.
Nonmaterial drift is recorded without changing approved content. In unattended mode, unsafe overlap or attribution is
blocked and cannot be auto-replanned. Other material drift returns to Plan and Approve. Refuse contradictory artifacts.
