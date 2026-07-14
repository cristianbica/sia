---
name: delivery
description: Deliver authorized changes through planning, review, validation, fixes, and product-read-only shipping.
---

# Delivery workflow
Triage before choosing a path. Standard follows `Plan → Approve → Build → Review/Validate → Fix → Review/Validate →
Ship`; lightweight follows direct authorization → Build → focused Review/Validate → Ship; trivial work is planless.
Standard implementation-detail replanning stays inside its approved intent envelope; a boundary change returns to Plan.

## Route triage

Record `execution_route` as `trivial`, `lightweight`, or `standard`; missing route metadata on an older plan means
`standard`. Announce the route and its evidence before writes.

- `trivial`: an obvious typo, formatting, comment, or wording-only correction in the requested file, with no behavior,
  policy, permission, schema, command, or public-contract change. It needs no plan or approval artifact; do not create a
  plan or spawn a worker solely because the host supports one. Doubt promotes it to `lightweight` or `standard`.
- `lightweight`: narrow project-owned `.ai/docs/**` or definition paths, or one internal repository-source behavior
  change with an evidenced seam, exact paths, clear criteria, and a focused test. It has no public/serialization
  contract, migration, configuration, permission, security, concurrency, external, compatibility, multi-consumer,
  broad-refactor, managed-Sia, lifecycle, dirty-attribution, or unresolved-assumption risk. The activating request
  directly authorizes a compact receipt, one bounded Build handoff, focused validation, and no independent review worker
  or Fix loop.
- `standard`: every product/source change not fully qualifying for lightweight, plus operations/workflows, public
  contracts, migrations, security, destructive or external work, broad scope, dirty attribution risk, or uncertainty.

Size is supporting evidence, never proof of eligibility. A request saying `full` or `thorough` selects `standard`.

Unattended classification is conservative: select `trivial` or `lightweight` only when request and repository evidence
make eligibility unambiguous; otherwise select `standard` or return `blocked`. Record a route promotion before newly
unauthorized writes.

For trivial work, report diff, check, skips, and route; promote before writing if behavior or policy could change.
Lightweight persists a compact directly authorized receipt with exact paths, non-goals, focused checks, route evidence,
and promotion conditions; omit transcripts. When waiting, use one longest-safe wait; never poll without new evidence.

## Plan

- Purpose: produce an executable, evidence-based delivery plan.
- Gate: none on entry; product and source writes are forbidden.
- Isolation: active session or bounded read-only scout.
- Model profile: request `reasoning` for ambiguous/risky planning; lightweight may inherit the host default or request
  advisory `fast` for latency, not a price guarantee.
- Inputs: request, project rules, relevant docs, repository evidence, operation, and declared skills.
- Output: standard work gets a persisted plan and concise intent-envelope summary: outcome, scope, non-goals, criteria,
  risks, assumptions, external actions, path, and revision. The digest is internal, never an approval token.
- Transition: standard persists a draft then enters Approve; lightweight persists its receipt then enters Build.

Every non-trivial delivery artifact is persisted before Build, even when all phases remain in one conversation.
During Plan, record the initial staged, unstaged, and untracked path baseline, mode, and base commit in
approval-controlled content; lightweight receipt creation records the same fields. For unattended mode, derive the
smallest `authorization_ceiling` from the activating request; list only explicit external actions. Preserve both fields
byte-for-byte in every later revision. Do not copy untracked contents into the plan. Discovery may create only that
artifact and must not modify product/source files.

## Approve

- Purpose: bind permission to a standard intent envelope or record direct lightweight authorization.
- Gate: one interactive approval for a standard intent envelope; activating request authorizes lightweight/unattended.
- Writes: authorization metadata in the delivery artifact only.
- Transition: Build after approval; Plan after any material change.

For standard work, present the current draft's outcome, scope, non-goals, criteria, risks, external actions, and path,
then accept one plain-language approval. The intent envelope covers implementation approach, step order, focused checks,
and in-scope documentation; record those changes as evidence without another prompt. Ask again only when outcome,
scope, non-goals, criteria, risk, permissions, or external actions expand.
Never ask the user to copy, repeat, inspect, or compare a digest.

The up-front unattended authorization records `execution_mode: unattended`, verifies the plan is the smallest faithful
interpretation of the activating request, and continues without claiming the user reviewed it. The approval-controlled
outcome, scope, non-goals, criteria, assumptions, and exclusions must all remain within the immutable unattended
authorization ceiling.

Boundary changes increment the revision, clear approval, and return standard work to Plan. An unattended replan may be
authorized only inside its ceiling; otherwise it blocks instead of asking.
Neither mode expands host permissions or external actions.

## Build

- Purpose: implement only approved scope, including tests and affected repository documentation.
- Isolation: standard prefers an isolated worker, then a fresh conversation, then bounded same-context execution.
  Lightweight uses one bounded Build handoff and no second worker.
- Model profile: standard requests `fast` for mechanical work and `reasoning` for risky work; lightweight may request
  advisory `fast` for latency, never as a cost guarantee.
- Inputs: approved plan or receipt, exact resolved definitions, baseline, material docs, rules, and bounded handoff.
- Writes: approved repository scope, relevant tests, `.ai/docs/**`, and plan evidence.
- Transition: Review/Validate when complete; Plan for material scope or approach changes.

Before Build, compare the current commit and changed paths with the approved baseline. Preserve existing changes and
report safely preservable overlap. In unattended mode, unsafe overlap or attribution is blocked before writes;
concurrent edits follow the same rule. Never alter pre-existing work.

Resolve Build skills by logical name through the effective skill catalog. If the approved plan has documentation impact,
load the effective `documentation` skill. Load `safe-refactoring` only when structural/refactoring guidance is material,
not for a localized behavior fix that does not restructure. Respect a CUSTOM override and put only exact resolved paths
in the handoff. After resolution, do not reread catalogs, broad docs, historical plans, or prior evidence.

## Review/Validate

- Purpose: assess the implementation and evidence. Lightweight uses focused coordinator validation with no independent
  review worker.
- Isolation: standard prefers a worker that did not build the change; lightweight may use the coordinator and must
  report.
- Model profile: standard requests `reasoning`; lightweight does not request a new review model by default.
- Inputs: approved plan, complete diff, dirty baseline, docs changes, tests, and command evidence.
- Writes: review evidence in the active plan only; do not modify product or source files.
- Transition: Fix standard findings, Plan for material findings, or Ship when route-appropriate criteria are satisfied.
  Lightweight material findings promote to standard before Fix or Ship.

Inspect correctness, scope, regressions, security and operational risk, documentation, and the truthfulness of command
claims. Do not claim that an uninspected command passed.

Standard work loads the effective `code-review` and `testing` skills through the skill catalog. Lightweight loads only
`testing` and performs the explicit focused diff/scope check. Respect CUSTOM overrides, record exact resolved paths, and
promote on a material finding.

## Fix

- Purpose: resolve review findings without broadening approved scope.
- Isolation: standard may use a bounded build/fix worker; lightweight has no Fix loop and promotes when remediation is
  material.
- Transition: standard Fix always returns to separate Review/Validate; return to Plan for material changes.

Allow at most three unattended Review/Validate → Fix cycles per plan revision. If material findings remain, record a
blocker instead of looping or weakening acceptance criteria. Interactive mode may request new direction.

## Ship
- Purpose: hand off the final reviewed result.
- Gate: acceptance criteria satisfied and validation evidence reviewed.
- Writes: active plan status and completion evidence only; no product, source, or external state by default.
- Output: behavior, changed paths, verification, isolation used, approved deviations, and remaining risks.

After recording `complete`, retain the plan for history without asking. Delete only the exact completed plan after a
separate explicit user request; never infer deletion from approval, completion, or general cleanup language.

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
authorization_ceiling: [approved-intent-envelope]
authorized_external_actions: []
status: draft
execution_route: standard
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
authorization_ceiling: [approved-intent-envelope]
authorized_external_actions: []
execution_route: standard
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
approved revision; earlier revisions remain historical evidence. An Approval record uses `explicit-user` for standard
interactive work, `activating-request` for lightweight interactive work, or `unattended-invocation` for unattended.
Legal transitions are
Approval → Build, Build → Review/Validate, Review/Validate → Fix, Fix → Review/Validate, Review/Validate → Ship, and
Ship → none. Lightweight Review/Validate may go directly to Ship after focused validation. A missing, duplicated,
out-of-order, or contradictory current-revision record prevents resume.

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
| Standard plan persisted or boundary revised | `draft` | `approval` | None; clear approval fields |
| Lightweight receipt or unattended/interactive authorization | `approved` | `build` | Approval → Build |
| Build starts | `in-progress` | `build` | Latest record remains Approval → Build |
| Build completes | `in-progress` | `review-validate` | Build → Review/Validate |
| Review finds in-scope issues | `in-progress` | `fix` | Review/Validate → Fix |
| Fix completes | `in-progress` | `review-validate` | Fix → Review/Validate |
| Review passes | `in-progress` | `ship` | Review/Validate → Ship |
| Unattended phase blocks | `blocked` | Keep current phase | `sia-blocker` outside phase boundaries |
| Ship report completes | `complete` | `none` | Ship → none |
| User cancels | `cancelled` | `none` | Record the reason outside a phase-boundary record |

Ship closes the artifact as shown above and retains it as history and evidence. Unattended execution always retains it;
interactive Ship does too. A separate explicit request may delete that exact completed plan. Product, source, and
external delivery state remain read-only unless explicitly authorized.

The approval metadata must match frontmatter, and `execution_mode` must be exactly `interactive` or `unattended`.
`execution_route` is optional for backward compatibility and, when present, must be `lightweight` or `standard` in an
artifact. `trivial` never creates one. Lightweight promotion creates a standard draft; route changes require a revision.
For unattended plans, `authorization_ceiling` and `authorized_external_actions` are immutable across revisions and
resume; any mismatch is an integrity error.
Compute the lowercase SHA-256 digest over only the bytes between the approval marker lines after converting CRLF to LF,
excluding a UTF-8 BOM, and ensuring exactly one final LF. Marker lines are excluded. The approval-block `revision` must
equal frontmatter `revision`, and frontmatter `approved_revision` must equal it. Refuse malformed or mismatched content.

Status, approval fields, `next_phase`, and evidence may change without invalidating approval. Evidence may record
standard implementation details only inside the intent envelope. A boundary deviation increments both revisions, clears
approval, and returns to Plan. Retain old records as prior-revision evidence and restart its sequence at 1. Unattended
mode auto-authorizes only an in-ceiling revision.

At every phase boundary, place the exact current definition paths in the handoff. Load only the named active plan and
honor explicit `do_not_load` paths.

Cancellation sets `status: cancelled`, sets `next_phase: none`, records the reason, and preserves the artifact as
non-active evidence. A cancelled artifact cannot resume; later work starts a new operation and plan.

Continue an interrupted approved or in-progress artifact only with `Sia resume <approved-plan>`.

Resume accepts `approved` or `in-progress`, plus `blocked` only for an unattended plan with a valid latest blocker.
Approved and in-progress state must match the latest current-revision boundary. Blocked frontmatter must match the
blocker's phase and attempt and retain the prior status as `resume_status`. Ship requires passing final review evidence.

Resume inherits the recorded mode and authorization fields; it never switches them from conversation text. If
`resume_when` is unchanged, return the same blocker without running the phase or incrementing its attempt. When it
changes, restore `resume_status`, continue, and increment the attempt only if that phase blocks again. Clear
`blocked_phase` on continuation, reset it after completion or a new revision, and require instruction after three tries.

On resume, compare current HEAD and changed paths with `base_ref`, the initial dirty baseline, and latest evidence.
Nonmaterial drift is recorded without changing approved content. Unsafe unattended overlap or attribution is blocked;
other boundary drift returns standard work to Plan. Refuse contradictory artifacts.
