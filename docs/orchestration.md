# Orchestration and workflows

Operations select workflows. Workflows coordinate phases and load only the documentation and skills needed for the
current phase. Route triage chooses the smallest safe execution path before writes: planless trivial work, compact
lightweight delivery, or standard delivery. A phase may use an isolated worker, a fresh user-started session, or the
active session.

## Adaptive delivery routes

Sia's `implement` operation uses the following route contract:

- `trivial`: exact-file, non-behavioral wording/formatting/comment correction; no plan, approval artifact, or worker.
- `lightweight`: narrow project-owned definition or documentation change; compact plan and approval, one bounded Build
  handoff, focused validation, and no mandatory independent reviewer.
- `standard`: product/source behavior, operations/workflows, public contracts, migrations, security, external or
  destructive work, broad scope, unsafe attribution, or uncertainty; use the complete delivery lifecycle.

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
`do_not_load`. Never paste a complete repository, catalog, or prior plan into a bounded handoff.

Every envelope contains `execution_mode: interactive` or `execution_mode: unattended`. An unattended worker performs
only its assignment and returns `blocked` to the coordinator instead of asking the user for approval or clarification.

When the host reports usage, a handoff result may include `elapsed_ms`, `input_tokens`, `cached_input_tokens`,
`output_tokens`, and `reasoning_output_tokens`. Record `unknown` when a field is unavailable; never estimate
child-worker usage from coordinator counters. These fields are telemetry, not workflow gates.

## Plan artifacts

Persist every non-trivial delivery plan under `.ai/plans/` before approval. This gives same-context work, isolated
workers, fresh conversations, approval, and resume one artifact contract. Planless trivial, investigation, review, and
documentation workers use the bounded handoff envelope but do not create a delivery plan merely because the host can
isolate them.

A persisted plan under `.ai/plans/` includes at least:

```yaml
---
id: 2026-07-12-01-subscription-pausing
operation: implement
workflow: delivery
execution_mode: interactive
authorization_ceiling: [exact-plan-revision]
execution_route: standard
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

The body has exactly one approval-controlled block and one mutable evidence block:

```markdown
<!-- sia:approval:start -->
Approval metadata matching the frontmatter, followed by outcome, context, scope, non-goals, acceptance criteria,
steps, validation, documentation impact, risks, assumptions, and permissions or exclusions.
<!-- sia:approval:end -->

<!-- sia:evidence:start -->
Phase transitions, baseline, resolved definition paths, model reporting, command results, findings, and deviations.
<!-- sia:evidence:end -->
```

After Approval and each completed Build, Review/Validate, Fix, or Ship phase, append one ordered fenced
`sia-phase-boundary` record. It contains `sequence`, `plan_revision`, `completed_phase`, `next_phase`, `head_ref`,
`changed_paths`, and `unresolved_material_findings`. An Approval record also contains `authorization_source`, matching
its execution mode: `explicit-user` or `unattended-invocation`. Sequence starts at 1 for each plan revision; invalid
current-revision records prevent resume.

The approval block starts with `id`, `operation`, `workflow`, `execution_mode`, `execution_route`, and `revision`,
followed by `base_ref`, `staged_paths`, `unstaged_paths`, `untracked_paths`, `docs`, and `skills`. Those values must
match frontmatter. An older plan may omit `execution_route` and is treated as `standard`. The route is `lightweight` or
`standard` in planned artifacts; `trivial` is planless. The `status`, approval fields, and `next_phase` are mutable
routing fields and are excluded from the digest. Evidence may be appended without invalidating approval. A material
deviation, including route promotion, changes the approval block and therefore requires a revised plan and renewed
approval or unattended authorization. Prior-revision records remain historical evidence; the new revision starts its
boundary sequence at 1.

For unattended mode, `authorization_ceiling` and `authorized_external_actions` occur in frontmatter and the approval
block and remain byte-for-byte unchanged across revisions. Any mismatch prevents resume.

The delivery state table is canonical: Plan is `draft/approval`, authorization is `approved/build`, active phases are
`in-progress/<phase>`, an unattended blocker is `blocked/<current-phase>`, successful Ship is `complete/none`, and
cancellation is `cancelled/none`. Lightweight uses the same artifact states but focused Review/Validate may transition
directly to Ship; trivial uses no delivery artifact.

Compute `approved_digest` as lowercase SHA-256 over only the bytes between the approval marker lines after converting
CRLF to LF, excluding a UTF-8 BOM, and ensuring exactly one final LF. The marker lines are not part of the digest.
Refuse missing, duplicate, nested, reversed, or malformed marker pairs. Changing approved content resets status to
`draft`, clears approval, increments the revision in frontmatter and the approval block, and returns to approval.

In interactive mode, Sia presents the current draft's outcome, scope, non-goals, criteria, validation, risks, and plan
path/revision, then accepts a plain-language approval such as `approved` or `go ahead`. The digest is an internal
integrity check: Sia computes, records, and verifies it; it never asks the user to copy, repeat, inspect, or compare
one. An affirmative applies only to the one current displayed draft. If it changed or no such draft is unambiguous,
Sia presents the current draft and asks again. In unattended mode, Sia may record automatic approval immediately after
persisting and verifying the plan. A material replan may be revised, digested, and automatically approved only when it
remains within the original requested outcome. Otherwise, return `blocked`.

A blocked plan appends a `sia-blocker` record with the revision, phase, prior status, attempt, reason, and an observable
`resume_when` condition. Resume does no phase work while that condition is unchanged. If the same phase
blocks again, increment its persisted attempt. Clear the blocked phase only when continuing, reset attempts after phase
completion or a new revision, and require new user instruction after three attempts in one phase/revision.

`Sia resume` verifies the plan's approval-controlled revision and digest and inherits its stored `execution_mode`. A Sia
refresh alone does not invalidate an approved plan. At each phase boundary, resolve the current effective definitions
and put their exact paths in the handoff; the receiving worker loads those paths without rerouting. Announce a changed
resolution. If current rules or definitions conflict materially with approved scope, return to Plan and Approve rather
than silently changing the work.

Resume accepts `approved` or `in-progress`, plus `blocked` for unattended plans with a valid latest blocker. Status and
`next_phase` must match the approved revision's records. Legal phase transitions remain Approval → Build, Build →
Review/Validate, Review/Validate → Fix, Fix → Review/Validate, Review/Validate → Ship, and Ship → none. Ship requires
passing final review evidence. Refuse draft, complete, cancelled, or contradictory artifacts.

On resume, compare current HEAD and changed paths with the approved `base_ref`, initial dirty baseline, and latest phase
evidence. Record nonmaterial drift without changing approved content. Drift that overlaps approved scope, invalidates
evidence, or makes attribution unsafe returns interactive work to Plan and Approve. Unattended unsafe overlap or
attribution is blocked and cannot be auto-replanned.

Capture the base commit and initial staged, unstaged, and untracked path baseline during Plan and include it in the
approval-controlled artifact before approval. Do not copy patches or untracked contents into the artifact. If Sia
later touches a path that was already dirty, report the attribution as ambiguous rather than claiming the complete
change.

Avoid a five-report task directory. Persist only artifacts needed for approval, resumption, or durable evidence.

The current protocol implements `Sia resume` only for delivery plans. Lightweight investigation, review,
documentation, and definition workflows should normally finish in one context; if interrupted, persist their current
report or scope and restart the operation explicitly until that workflow defines its own resumable envelope.

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

Interactive mode stops for a plain-language approval of its one current displayed plan. Sia binds that approval to the
current stored revision and digest itself. Unattended mode verifies and automatically approves the exact revision under
the original request's standing authorization. Material scope or approach changes require a revised plan; unattended
mode may auto-approve it only when it remains within the original outcome. Approval never expands host permissions or
authorizes unrelated external actions.

### Build

Prefer an isolated worker using the approved handoff. Implement only approved scope, add or update tests, update
affected repository documentation, preserve pre-existing changes, and stop for replanning when material assumptions
fail.

### Review and validate

Use a separate review phase and prefer an isolated worker that did not build the change. Compare the complete
diff—including documentation—with the approved plan and baseline. Inspect correctness, scope, regressions, risks, and
command evidence. Report the actual isolation mechanism and never claim an uninspected command passed.

### Fix

A build/fix worker addresses findings within approved scope and updates tests or docs. Then the separate review and
validation phase reruns, isolated when the host supports it. Material remediation returns to Plan and Approve.
Allow at most three unattended Fix cycles per plan revision; then return a blocker rather than weakening acceptance.

### Ship

Ship writes only plan completion status and evidence by default. After recording `complete`, interactive Ship offers to
keep the exact plan for history or delete it. Deletion requires an explicit affirmative response and is never inferred
from completion or a general cleanup request; unattended Ship always retains the plan. Product, source, and external
delivery state remain read-only. Confirm the final reviewed artifact and report behavior, files, verification,
deviations, and remaining risks. Commit, push, pull request, release, publish, and deploy actions require explicit user
intent.

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
