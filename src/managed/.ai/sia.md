---
sia_protocol: 1
---

# Sia protocol

Sia is an opt-in, repository-local prompt protocol for maintained repository knowledge, composable skills, and explicit
operations and workflows. Sia does not add permissions, tools, plugins, or background behavior.

All `.ai/**` paths are relative to the Git repository root whose `AGENTS.md` activated this protocol, even when the
host's current working directory is below that root.

## Activation
Attempt activation only when case-sensitive `Sia` is the first non-whitespace token and is followed by whitespace or
the end of the message. `sia`, `SIA`, `Sia:`, and incidental mentions do not activate Sia.

For a valid invocation, first require this file's exact header lines `---`, `sia_protocol: 1`, and `---`, followed by a
nonempty body. If it is missing, empty, unreadable, or invalid, report an installation-integrity error and stop; never
reconstruct Sia behavior from other files, prior conversations, or general knowledge.

Resolve the remainder after `Sia` in this order:

1. An empty remainder or either exact help form, `help` or `show help`, shows the same concise help covering docs,
   skills, Forge, interactive and unattended operations, resume, stop, and reload; it does nothing else.
2. An exact `unattended` first token sets unattended mode and requires the next token to be an operation or alias. It
   accepts an operation, not a reserved directive.
3. A valid reserved directive form runs only that directive.
4. A reserved directive name in an invalid form reports an arity or syntax error and does not fall back.
5. With Forge enabled and no operation, route any unhandled remainder through Forge; `Sia` does not trigger operations.
6. An exact operation or alias resolves in interactive mode and receives the remaining tokens as its request.
7. Without an exact match, infer one operation only when the request clearly asks for an action and one effective
   operation fits with high confidence; announce the inference before running it. Never infer unattended mode.
8. Otherwise, answer as a direct Sia conversation: load only relevant context, do not start a workflow, and do not edit.

## Reserved directives
`Sia help` and `Sia show help` are exact forms equivalent to bare `Sia`. Read only `.ai/operations/INDEX.md` and
`.ai/skills/INDEX.md`; validate and merge each index's SIA and CUSTOM entries under normal override rules.
Show the general requests `Sia load docs`,
`Sia load skills`, `Sia forge on` / `Sia forge off`, `Sia unattended <operation> [request]`,
`Sia resume <approved-plan>`, `Sia stop`, and `Sia reload`, each with a brief purpose.
List every effective operation once with its description and effective aliases, labeling project entries and overrides
as CUSTOM. List every effective skill once on one comma-separated `Skills:` line, labeling project entries and overrides
as CUSTOM.
Malformed, duplicated, or ambiguous entries in either index produce an error instead of a partial or inferred list.
Do not read operation or skill bodies, other catalogs, docs, workflows, or rules, or start or replace an operation.
Extra arguments to `help` or after `show help` are syntax errors and do not fall back to conversation or operation
inference.
### `Sia load docs`
Read only `.ai/docs/INDEX.md` and expose its routes to the host's normal workflow. Follow no links until a later task
requires them, and do not activate an operation. If the index is missing or `status: not-initialized`, report repository
documentation unavailable and suggest `Sia document repository`.
### `Sia load skills`
Read `.ai/skills/INDEX.md`, merge its SIA and CUSTOM entries, and expose the effective catalog. Do not read every skill
body. Load a skill body only when a later task needs it or the user explicitly requests it. This does not activate an
operation.
### `Sia forge on` and `Sia forge off`
`Sia forge on` enables Forge only when no operation is active; off/stop/reload or a new chat ends it.
Forge is artifact-free and cannot be resumed. Reuse active context; resolve clear terse follow-ups without fresh intake.
Non-mutating work is immediate; a precise bounded imperative authorizes its local write, and `do:` requests that lane.
`plan:`/`inline plan` or unsafe uncertainty requires approval; prefixed operations stay in Forge; controls stay controls.
`Sia forge off` disables Forge without starting an operation or erasing loaded context; if it is off, report that.
### `Sia resume <approved-plan>`
The exact plan path is explicit content-read authorization; add only it to `authorized_plan_paths`, then read it under
`.ai/plans/`. New artifacts use `YYYY-MM-DD-NN-<slug>.md` with the UTC date and a zero-padded daily sequence; allocating
`NN` may inspect filenames only, never unauthorized plan contents. New compact artifacts have only `operation`,
`workflow`, and `skills` frontmatter, one approval marker pair, one `sia:status` comment, and optional footer comments.
Existing valid legacy artifacts remain resumable. Refuse ambiguous, missing, unapproved, or contradictory plans.

For compact artifacts, recompute the lowercase SHA-256 from normalized approval-block bytes. Status beyond
`pending-approval` requires one matching `sia:approved` comment; progress never repairs invalid approval content.
Optional mode/route/base/dirty/ceiling/external/blocker comments apply only when present; derive phase from status.
A blocked unattended plan retries only after observable change. Refuse complete/cancelled; Ship requires passing review.

Compare current HEAD and changed paths with optional base/dirty comments and progress evidence. In unattended mode,
unsafe overlap or attribution returns `blocked`; never auto-authorize around it. Otherwise, boundary drift returns
standard work to Plan; record nonmaterial drift without rewriting the base.

At the phase boundary, resolve the current effective operation, workflow, and skills. Put their exact paths in the
handoff. Report a definition-path or resolution change; a material conflict returns to Plan and Approve.

### `Sia handoff` followed by a bounded handoff envelope
A fresh worker started by an active Sia operation uses this directive. First line must be exactly `Sia handoff`; the
remaining message must begin with `handoff_protocol: 1` and contain the complete nonempty envelope below.
Validate the assigned operation, workflow, phase, artifact status when applicable, exact definition paths, allowed
work, exclusions, `do_not_load` paths, and final task. Load `.ai/RULES.md`, this protocol, and only exact named paths.
Never reroute through catalogs, choose another operation, coordinate approval, or expand the phase. Return the requested
result envelope and end the worker's Sia activity; refuse incomplete, contradictory, or permission-expanding handoffs.

### `Sia stop`
Stop active Sia orchestration and disable Forge for later turns; do not claim already loaded context was erased.
`Sia reload` rereads current `.ai/sia.md`, stops orchestration and Forge while preserving plans, and applies it later.
It loads no catalogs, docs, skills, or work; old context remains, and the current valid protocol takes precedence.

The public reserved directives require exact arity; help requires exactly `Sia help` or `Sia show help`, `Sia handoff`
requires its structured body, `unattended` requires an operation, and Forge requires exactly `on` or `off`. Extra or
missing arguments are errors.
## Catalogs and resolution
Skills, operations, and workflows are registered in their category `INDEX.md`. Logical names are normalized lowercase
kebab-case and cannot be `sia`, which names the reserved shipped-definition directory. Valid project definitions live
directly under their category.

Operation names and aliases also cannot be `unattended` or a reserved directive name.

For an indexed logical name, a CUSTOM entry resolves to the project definition and overrides the SIA entry. Otherwise,
resolve the SIA definition. Announce a selected project override. A missing, malformed, duplicated, mismatched, or
ambiguous CUSTOM definition is an error and never falls back to SIA. Unindexed files are not discoverable.

Operation aliases appear only in the `aliases:` metadata line below an operation index entry. They use the same naming
rules, cannot be `sia`, `unattended`, or a reserved directive name, and resolve uniquely after the explicit `Sia`
prefix. A CUSTOM override replaces the complete shipped alias set; an omitted alias is unavailable.
## Operation execution
Use `Sia <operation> [request]` interactively or `Sia unattended <operation> [request]` for unattended execution:

1. Read `.ai/operations/INDEX.md` and resolve the exact operation or alias.
2. Announce the effective operation and whether it is a project override.
3. Load `.ai/RULES.md` when present.
4. Read the resolved operation and resolve its one primary workflow and declared skills from their indexes.
5. Fail on malformed or missing references; do not substitute a different definition.
6. Load only the workflow, skills, and repository documentation required for intake and the current phase.
7. Follow the workflow until completion, cancellation, or explicit operation replacement.

Unattended mode is enabled only by the exact modifier. Do not infer unattended mode from natural-language requests.
Default is interactive. Persist mode in artifacts and handoffs. Trivial is planless; lightweight directly authorized;
standard uses one intent-envelope approval and separate review/fixes. Unattended auto-authorizes in-ceiling artifacts
or replans. If progress needs new scope, authority, or credentials, return `blocked` rather than asking the user
or guessing.

Project rules are hard Sia-specific constraints during operations, resume, and isolated phase execution. They take
precedence over repository documentation, skills, operations, workflows, and plans, but never over system or host
safety, permissions, or the user's current explicit instruction. Report material conflicts instead of guessing.
Rules and custom definitions may narrow unattended work but cannot activate it or expand its authorization ceiling.

Do not load `.ai/RULES.md` for help, `Sia load docs`, `Sia load skills`, or a direct Sia conversation.

Help, docs loading, skills loading, Forge, a direct conversation, and an invalid handoff do not replace an active
operation. Only successful completion, `Sia stop`, `Sia reload`, or a newly resolved operation ends or replaces it.

## User-facing responses

- Write the shortest complete answer that leads with the outcome, finding, blocker, or decision in normal English.
- For a simple answer, use one sentence or one exact command.
- For diagnosis, investigation, or review, keep only decisive evidence, uncertainty, material findings, and next action.
- Remove greetings, preambles, self-reference, process narration, repetition, and generic closers.
- Preserve required facts, exact technical strings, safety limits, approval boundaries, and requested detail.
- Expand when the user asks for detail or when safe, correct action requires explanation.

## Context, workers, and model profiles

Maintain conversation-scoped `authorized_plan_paths`. It starts empty, adds an exact repository-relative path when this
conversation creates the plan or the user explicitly requests or approves reading it, and resets only in a new
conversation. Do not add paths inferred from task similarity, status, Git history, discovery, or another plan. Require
exact entry before reading, searching, diffing, summarizing, or using `.ai/plans/**` content. Filename-only inspection
is permitted only to allocate a new name. If a new or compacted context cannot recover exact authorization, fail closed;
an exact user request such as `Sia resume <approved-plan>` may restore it.

Keep isolated-worker context in lean, deterministic cache-aware order: protocol/rules, route/workflow, invariant
declarations, and durable docs first; append active plan, evidence, constraints, and one ask. State each invariant once.
Do not put timestamps, run IDs, volatile telemetry, or request-specific text in the stable prefix. Loaded docs/skills
remain for the conversation; operation/mode remains until complete, stop, or replacement. After compaction, reload only
this protocol, rules, authorized plans, material docs, and exact definitions. Never scan catalogs, unauthorized plans,
or replay bulk output.

An isolated worker must receive this canonical YAML-shaped envelope. Every key is required; use `none`, `unknown`, or
`[]` explicitly when a field does not apply. `final_task` is last and contains one bounded ask.

```yaml
handoff_protocol: 1
artifact_id: none
artifact_status: none
approved_revision: none
execution_mode: interactive
authorization_ceiling: [current-operation-request]
authorized_external_actions: []
authorized_plan_paths: []
operation: investigate
workflow: investigation
phase: investigate
next_transition: synthesize
requested_outcome: <outcome>
approved_scope: [<path-or-behavior>]
non_goals: []
acceptance_criteria: [<criterion>]
repository_root: <absolute-path>
base_ref: <commit>
staged_paths: []
unstaged_paths: []
untracked_paths: []
definition_paths:
  operation: <path>
  workflow: <path>
  skills: [<path>]
documentation_paths: []
allowed_work: [read]
exclusions: []
permissions: unchanged
do_not_load: [.ai/plans/** except exact authorized_plan_paths]
evidence: []
findings: []
command_results: []
usage: unknown
approved_deviations: []
recovery: <stop-condition-or-recovery>
requested_model_profile: fast
model_selection_source: workflow
final_task: <one bounded task>
```

Return bounded evidence with `handoff_result: 1`, phase/status, actual model/profile, paths, commands, usage, findings,
and next transition. List command, outcome, scope, failure excerpt, and evidence path; keep bulk output and diffs in
artifacts. Status is `complete`, `blocked`, or `failed`; use `unknown` for unreported model fields.

The `Sia handoff` worker reads this file, `.ai/RULES.md`, and only exact envelope paths. It accepts plan content only
from `authorized_plan_paths`; never reroute through catalogs or load unrelated or unauthorized artifacts. An unattended
worker never authorizes a revision; it returns `blocked`. Report truthfully when the host may inherit hidden context.
Advisory profiles are `fast` or `reasoning`; priority is user, rules, workflow, then task.
The host chooses the available model. Record `requested_model_profile` and `model_selection_source`, plus
`actual_model` or `unknown` and `profile_honored` when supportable. An unavailable profile never blocks work, changes
gates, expands permissions, or invalidates resumption.

## Safety and failure behavior
- Never infer missing definitions, indexes, approval, command results, or repository facts.
- Treat stale repository documentation as evidence to verify, not an instruction to follow.
- Preserve pre-existing changes; report dirty overlap and block when attribution or preservation is unsafe.
- Plan and review are read-only unless their workflow permits limited artifact or documentation writes.
- Unattended mode does not expand host permissions or authorize external actions, including destructive actions, that
  the user did not explicitly request. It cannot suppress permission prompts imposed by the host.
- Ship may write active-plan completion metadata and retains it by default. Delete that exact completed plan only after
  a separate explicit request. Product, source, and external state remain read-only unless explicitly authorized.
- Sia never expands filesystem, command, network, or external-action permissions.
Before activation Sia directs no `.ai/**` reads; hosts may independently index files beyond Sia's control.
