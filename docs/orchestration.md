# Orchestration and workflows

Operations select workflows. Workflows coordinate phases and load only the documentation and skills needed for the
current phase. Route triage chooses the smallest safe execution path before writes: planless trivial work, compact
lightweight delivery, or standard delivery. A phase may use an isolated worker, a fresh user-started session, or the
active session.

## Adaptive delivery routes

Sia's `implement` operation uses the following route contract:

- `trivial`: exact-file, non-behavioral wording/formatting/comment correction; no plan, approval artifact, or worker.
- `lightweight`: narrow project-owned definition/documentation change, or one internal source behavior change whose
  exact seam, paths, criteria, and focused test are evidenced. It excludes public/serialization contracts, migrations,
  configuration, permission, security, concurrency, external, compatibility, multi-consumer, broad-refactor,
  managed-Sia, lifecycle, dirty-attribution, and unresolved-assumption risk. Its activating request directly authorizes
  a compact receipt, one bounded Build handoff, and focused validation without a reviewer or Fix loop.
- `standard`: every source change not fully qualifying for lightweight, plus operations/workflows, public contracts,
  migrations, security, external or destructive work, broad scope, unsafe attribution, or uncertainty; use the complete
  delivery lifecycle.

Line count is supporting evidence only. An explicit request for a full/thorough workflow selects `standard`; uncertain
classification promotes to `standard`. Unattended mode selects `trivial` or `lightweight` only when eligibility is
unambiguous, otherwise it selects `standard` or blocks. A route promotion is recorded before newly unauthorized writes.

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
model, price tier, or guaranteed capability. `fast` is a latency hint, not a cost guarantee.

- Plan, synthesis, ambiguous diagnosis, architecture or security work, and standard Review/Validate request `reasoning`.
- Bounded scouts and mechanical Build or Fix work may request `fast`; lightweight work may inherit the host default or
  request `fast` without implying cheaper execution.
- A risky or complex Build/Fix phase may elevate its request to `reasoning`.

An explicit user choice takes precedence, followed by project guidance in `.ai/RULES.md`, then the workflow's profile
and Sia's task assessment. The host always chooses the actual available model. A host that cannot honor or expose the
choice uses its default; this never blocks a phase, alters a gate, expands permissions, or invalidates resumption.

Handoffs record `requested_model_profile` and its selection source. Results record `actual_model` when the host reports
it and `unknown` otherwise. They may record whether the request was honored only when that can be established. Sia does
not install vendor-specific agent files or lock a plan to a model.

## Execution modes

Operations use `interactive` mode by default. The exact form `Sia unattended <operation> [request]` starts an operation
in `unattended` mode. `unattended` is a modifier, not an operation or alias, and protocol 1 does not use it to switch an
existing interactive artifact.

Unattended mode provides standing authorization for Sia-owned workflow gates that remain within the original operation
request. Sia applies the selected route: trivial work stays planless, lightweight work persists and digests a compact
artifact with focused validation, and standard work performs separate Review/Validate and bounded Fix cycles. It does
not ask questions: it uses conservative, reversible assumptions or returns a blocked result when a necessary decision
would expand scope or cannot be made safely. A generated plan accepted this way is automatically approved under standing
authorization, not represented as a plan the user reviewed.

The initial plan stores an immutable authorization ceiling and explicit external-action list. Replans may narrow or
reinterpret implementation details inside that ceiling but cannot edit either authorization field. Workers receive the
same fields and never authorize revisions themselves.

The mode cannot expand host or system permissions, suppress external approval interfaces, override project safety or
dirty-worktree safeguards, or authorize unrequested destructive or external actions. Commit, push, pull request,
release, publish, and deploy remain unavailable unless the initial request explicitly includes them. Host permission,
credential, safety, attribution, or material-scope blockers end unattended work with an exact blocked result.

## Handoff envelope

Every isolated or resumed phase receives only the information needed to execute its assignment:

- `handoff_protocol: 1` and one final task;
- artifact ID or `none`, operation, workflow, execution mode, phase, and next transition;
- immutable authorization ceiling and explicitly authorized external actions;
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

For a fresh worker, put `Sia handoff` on the first line and the envelope immediately after it. This preserves the same
explicit opt-in grammar as a user invocation while allowing planless scouts and reviewers to enter only their assigned
phase. The host may supply hidden context that Sia cannot inspect. Sia promises a bounded explicit handoff, not control
over host internals.

When a coordinator waits for a worker, prefer one event-driven or longest-safe host wait. Do not poll every few seconds
or emit progress turns while no new evidence exists; each polling turn may resend the full conversation context. If the
host exposes only polling, use its longest safe interval and report the actual wait behavior.

## Context budget

Keep the stable, cacheable prefix byte-for-byte stable: project rules, route contract, and durable documentation
pointers come first. Put the variable suffix last: the active plan, focused diff, current evidence, constraints, and one
final ask.
Reference canonical files by path, load only the current phase's excerpts, and name broad or historical paths in
`do_not_load`. Never paste a complete repository, catalog, prior plan, successful bulk output, or broad diff into a
bounded handoff; preserve that material as evidence and return its path plus a concise outcome instead.

Every envelope contains `execution_mode: interactive` or `execution_mode: unattended`. An unattended worker performs
only its assignment and returns `blocked` to the coordinator instead of asking the user for approval or clarification.

When the host reports usage, a handoff result may include `elapsed_ms`, `input_tokens`, `cached_input_tokens`,
`output_tokens`, and `reasoning_output_tokens`. Record `unknown` when a field is unavailable; never estimate
child-worker usage from coordinator counters. These fields are telemetry, not workflow gates.

## Plan artifacts

Persist every non-trivial delivery artifact under `.ai/plans/` before Build. Planless trivial, investigation, review,
and documentation workers use the bounded handoff envelope but do not create an artifact merely for isolation.

New plans keep only the information a reader needs in their header and visible body:

```markdown
---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Outcome

<!-- sia:approval:start -->
## Scope and acceptance
...
<!-- sia:approval:end -->

<!-- sia:status pending-approval -->
<!-- sia:base 4d3f... -->
```

The filename is the identity. Frontmatter has no ID, revision, route, status, digest, baseline, permissions, or empty
lists. Only `status` is required after the approval block. Optional one-line comments appear only when relevant:
`approved`, `base`, `dirty`, `mode`, `route`, `ceiling`, `external`, `progress`, and `blocker`.

The digest is lowercase SHA-256 over normalized bytes between approval markers. An approved standard plan adds
`<!-- sia:approved <sha256> -->`; changing approved bytes removes that comment and restores
`<!-- sia:status pending-approval -->`. Progress comments never repair an invalid digest.

The status comment determines resume: `pending-approval`, `build`, `review-validate`, `fix`, `ship`, `blocked`,
`complete`, or `cancelled`. A blocked unattended plan adds one concise blocker comment with an observable resume
condition. Resume reads only the named artifact, rejects contradictory/complete/cancelled state, and preserves legacy
artifacts without migration. Base and dirty comments protect attribution when present; unattended ceiling and external
comments are immutable. Handoff-only details stay in the handoff envelope, not the plan.

Avoid a report directory. Persist only the visible authorization and the few comments needed to resume safely.

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

Eligible lightweight work records direct activating-request authorization. Standard work stops once for a
plain-language intent-envelope approval. In-envelope implementation details become evidence; scope, risk, permission,
or external-action expansion requires a revised plan. Unattended mode auto-authorizes only inside its original outcome.
Authorization never expands host permissions or unrelated external actions.

### Build

Prefer an isolated worker using the approved handoff. After exact definitions resolve, do not reread catalogs, broad
docs, historical plans, or prior evidence. Implement only approved scope, add or update tests, preserve pre-existing
changes, and stop for replanning when material assumptions fail.

### Review and validate

Use a separate review phase and prefer an isolated worker that did not build the change. Compare the complete
diff—including documentation—with the approved plan and baseline. Lightweight instead uses a focused coordinator
diff/scope check and testing; a material finding promotes it to standard. Inspect correctness, scope, regressions,
risks, and command evidence. Report the actual isolation mechanism and never claim an uninspected command passed.

### Fix

A build/fix worker addresses findings within approved scope and updates tests or docs. Then the separate review and
validation phase reruns, isolated when the host supports it. Material remediation returns to Plan and Approve.
Allow at most three unattended Fix cycles per plan revision; then return a blocker rather than weakening acceptance.

### Ship

Ship writes only plan completion status and evidence by default, then retains the completed artifact without prompting.
Deletion requires a separate explicit request and is never inferred from completion or cleanup language. Product,
source, and external delivery state remain read-only. Confirm the final reviewed artifact and report behavior, files,
verification, deviations, and risks. Commit, push, pull request, release, publish, and deploy need explicit intent.

In unattended mode, continue through in-scope Fix and Review/Validate cycles without asking questions. Use conservative,
reversible assumptions or return a blocked result when no safe in-scope path remains.

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
