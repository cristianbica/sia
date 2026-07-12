# Orchestration and workflows

Operations select workflows. Workflows coordinate phases and load only the documentation and skills needed for the
current phase. A phase may use an isolated worker, a fresh user-started session, or the active session.

## Isolation model

Phase isolation reduces steering from rejected planning ideas and builder self-justification. The portable mechanism is
an explicit handoff artifact, not native subagent support.

Preferred execution order:

1. Start an isolated native worker when the host can avoid passing the earlier conversation.
2. Continue in a new user-started host conversation with `Sia resume <artifact>`.
3. Fall back to a same-conversation phase transition using the bounded handoff, without claiming a context reset.

Native spawning is an optimization. Every required workflow must remain semantically usable through persisted artifacts.

## Advisory model routing

Sia uses only two logical model profiles: `fast` and `reasoning`. They express the kind of work, not a vendor, concrete
model, or guaranteed capability.

- Plan, synthesis, ambiguous diagnosis, architecture or security work, and Review/Validate request `reasoning`.
- Bounded scouts and mechanical Build or Fix work may request `fast`.
- A risky or complex Build/Fix phase may elevate its request to `reasoning`.

An explicit user choice takes precedence, followed by project guidance in `.ai/RULES.md`, then the workflow's profile
and Sia's task assessment. The host always chooses the actual available model. A host that cannot honor or expose the
choice uses its default; this never blocks a phase, alters a gate, expands permissions, or invalidates resumption.

Handoffs record `requested_model_profile` and its selection source. Results record `actual_model` when the host reports
it and `unknown` otherwise. They may record whether the request was honored only when that can be established. Sia does
not install vendor-specific agent files or lock a plan to a model.

## Handoff envelope

Every isolated or resumed phase receives only the information needed to execute its assignment:

- artifact ID, operation, workflow, phase, and next transition;
- artifact status and approved revision when approval applies;
- requested outcome, approved scope, non-goals, and acceptance criteria;
- repository root, base revision, and pre-existing dirty-worktree baseline;
- relevant documentation paths and exact resolved operation, workflow, and skill paths;
- requested model profile and whether it came from the user, project rules, workflow, or task assessment;
- allowed work, exclusions, and unchanged host permissions;
- explicit `do_not_load` paths, including unrelated docs, broad trees, and stale artifacts;
- current evidence, findings, command results, and approved deviations.

Load only the named active plan; never scan `.ai/plans/` for similar historical work. Put the phase's exact ask after
the selected docs, evidence, constraints, exclusions, and recovery information so the worker receives one clear task.

The host may supply hidden context that Sia cannot inspect. Sia promises a bounded explicit handoff, not control over
host internals.

## Plan artifacts

Persist a delivery plan whenever delivery crosses into another context, including an isolated native worker. Inline
delivery plans are allowed only when planning, approval, implementation, and review all remain in one conversation.
Planless investigation, review, and documentation workers use the bounded handoff envelope but do not create a delivery
plan merely because the host can isolate them.

A persisted plan under `.ai/plans/` includes at least:

```yaml
---
id: 2026-07-12-01-subscription-pausing
operation: implement
workflow: delivery
status: draft
revision: 1
approved_revision:
approved_digest:
approved_at:
base_ref: 4d3f...
sia_version_at_planning: 0.1.0
next_phase: approval
docs: []
skills: [repository-discovery, testing]
---
```

The body holds outcome, context, scope, non-goals, acceptance criteria, steps, validation, documentation impact, risks,
assumptions, and permissions or exclusions. Approval records the exact revision plus a digest of all approval-controlled
metadata and body content. Changing approved content resets the status to `draft`, clears approval, increments the
revision, and returns to approval.

`Sia resume` verifies the plan's approval-controlled revision and digest. A Sia upgrade alone does not invalidate an
approved plan. At each phase boundary, resolve the current effective definitions and put their exact paths in the
handoff; the receiving worker loads those paths without rerouting. Announce changed resolution or version. If current
rules or definitions conflict materially with approved scope, return to Plan and Approve rather than silently changing
the work.

Before Build, record the base commit and initial changed-path status, including staged, unstaged, and untracked paths.
Do not copy patches or untracked contents into the artifact. If Sia later touches a path that was already dirty, report
the attribution as ambiguous rather than claiming the complete change.

Avoid a five-report task directory. Persist only artifacts needed for approval, resumption, or durable evidence.

V1 implements `Sia resume` only for delivery plans. Lightweight investigation, review, documentation, and definition
workflows should normally finish in one context; if interrupted, persist their current report or scope and restart the
operation explicitly until that workflow defines its own resumable envelope.

## Delivery workflow

```text
Plan → Approve → Build → Review + Validate → Fix ─┐
                              ↑                   │
                              └───────────────────┘
                                      ↓
                                     Ship
```

### Plan

Load the smallest relevant docs and skills, perform focused read-only discovery, inspect analogous code and tests, and
produce an executable plan. Do not edit product/source code.

### Approve

Stop for explicit approval of the exact plan revision. Material scope or approach changes require a revised plan and
renewed approval. Approval never expands host permissions or authorizes unrelated external actions.

### Build

Prefer an isolated worker using the approved handoff. Implement only approved scope, add or update tests, update
affected repository documentation, preserve pre-existing changes, and stop for replanning when material assumptions
fail.

### Review and validate

Prefer an independent isolated worker. Compare the complete diff—including documentation—with the approved plan and
baseline. Inspect correctness, scope, regressions, risks, and command evidence. Never claim an uninspected command
passed.

### Fix

A build/fix worker addresses findings within approved scope and updates tests or docs. Then an independent review and
validation phase reruns. Material remediation returns to Plan and Approve.

### Ship

Ship is read-only by default. Confirm the final reviewed artifact and report behavior, files, verification, deviations,
and remaining risks. Commit, push, pull request, release, publish, and deploy actions require explicit user intent.

## Lightweight workflows

### Investigation

Read-only and normally planless. Timebox the question, inspect the smallest useful evidence set, separate observations
from inference, report confidence and unknowns, and recommend a next operation. An investigation report never approves
implementation.

### Review

Read-only unless the user separately invokes a fixing operation. Establish the requested scope and baseline, report
prioritized findings with file evidence, run or assess relevant validation, and distinguish pre-existing changes.

### Documentation

Writes only the requested `.ai/docs/**` scope and its nearest indexes. It verifies claims against current evidence and
does not require delivery ceremony unless product/source changes become necessary.

### Definition

Creates or updates project skills, operations, workflows, and CUSTOM entries. It validates naming, schema, references,
override behavior, and catalog consistency without touching shipped definitions.

## Parallel work

Investigation and review workflows may partition independent areas among bounded workers. Partitions must not overlap,
must be useful independently, and must return the same handoff/result shape. The coordinating Sia session synthesizes
results and owns user-visible gates and completion. Scouts normally request `fast`; synthesis and final review request
`reasoning`, subject to host availability.
