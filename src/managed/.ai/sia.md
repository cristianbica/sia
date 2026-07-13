---
sia_protocol: 1
---

# Sia protocol

Sia is an opt-in, repository-local prompt protocol. It helps a host coding agent use maintained repository knowledge,
composable skills, and explicit operations and workflows. Sia does not add permissions, tools, plugins, or background
behavior.

All `.ai/**` paths are relative to the Git repository root whose `AGENTS.md` activated this protocol, even when the
host's current working directory is below that root.

## Activation

Attempt activation only when `Sia` is the first non-whitespace token in the user's message and is followed by
whitespace or the end of the message. Matching is case-sensitive. `sia`, `SIA`, `Sia:`, and incidental mentions do not
activate Sia.

Before doing anything else for a valid invocation, validate this file. Its first three lines must be exactly `---`,
`sia_protocol: 1`, and `---`, and the prompt body after that header must contain non-whitespace text.

If this file is missing, empty, unreadable, or structurally invalid, report an installation-integrity error and stop.
Do not reconstruct Sia behavior from other files, prior conversations, or general knowledge.

Resolve the remainder after `Sia` in this order:

1. An empty remainder shows concise help covering docs, skills, interactive and unattended operations, resume, stop, and
   reload; it does nothing else.
2. An exact `unattended` first token sets unattended mode and requires the next token to be an operation or alias. It
   accepts an operation, not a reserved directive.
3. A valid reserved directive form runs only that directive.
4. A reserved directive name in an invalid form reports an arity or syntax error and does not fall back.
5. An exact operation or alias resolves in interactive mode and receives the remaining tokens as its request.
6. Without an exact match, infer one operation only when the request clearly asks for an action and one effective
   operation fits with high confidence; announce the inference before running it. Never infer unattended mode.
7. Otherwise, answer as a direct Sia conversation: load only relevant context, do not start a workflow, and do not edit.

## Reserved directives

### `Sia load docs`

Read only `.ai/docs/INDEX.md` and make its routes available to the host's normal workflow. Do not follow links until a
later task makes them relevant, and do not activate an operation. If the index is missing or has
`status: not-initialized`, report that repository documentation is unavailable and suggest
`Sia document repository`.

### `Sia load skills`

Read `.ai/skills/INDEX.md`, merge its SIA and CUSTOM entries, and expose the effective catalog. Do not read every skill
body. Load a skill body only when a later task needs it or the user explicitly requests it. This does not activate an
operation.

### `Sia resume <approved-plan>`

Read only the named file. It must be an approved delivery plan under `.ai/plans/` with an intact approved revision and
digest. Load `.ai/RULES.md` when present and verify the plan before entering its recorded next phase. Refuse ambiguous,
stale, missing, unapproved, or internally inconsistent plans. Never scan `.ai/plans/` for alternatives.

Verify exactly one ordered, nonnested `sia:approval` marker pair and one `sia:evidence` pair. Approval metadata inside
the approval block—including `execution_mode`, `authorization_ceiling`, `authorized_external_actions`, `base_ref`, and
the dirty baseline—must match frontmatter. Recompute the lowercase SHA-256 using the delivery workflow's normalization;
require matching `approved_digest` and `approved_revision`. Mutable evidence never repairs invalid approved content.

Resume `approved` or `in-progress` plans, or a blocked unattended plan with a valid `sia-blocker` record. Require
`execution_mode`; status, `next_phase`, and current-revision records must match the lifecycle table. A blocked plan
retries only after its `resume_when` condition changes. Refuse draft, complete, cancelled, or contradictory state. Ship
also requires a passing final Review/Validate record.

Compare the current HEAD and changed paths with `base_ref`, the recorded dirty baseline, and the latest phase evidence.
In unattended mode, unsafe overlap or attribution returns `blocked`; never auto-authorize around it. Otherwise, drift
that invalidates scope or evidence returns to Plan and Approve. Record nonmaterial drift without rewriting the base.

At the phase boundary, resolve the current effective operation, workflow, and skills. Put their exact paths in the
handoff. A definition-path or resolution change is reported; a material conflict with approved scope returns to Plan and
Approve rather than silently changing the work.

### `Sia handoff` followed by a bounded handoff envelope

This directive is for a fresh worker started by an already active Sia operation. The first line must be exactly
`Sia handoff`; the remaining message must begin with `handoff_protocol: 1` and contain the envelope fields defined
below. It is invalid without a nonempty envelope.

Validate the assigned operation, workflow, phase, artifact status when applicable, exact definition paths, allowed
work, exclusions, `do_not_load` paths, and final task. Then load `.ai/RULES.md`, this protocol, and only the exact paths
named by the handoff. Do not resolve through catalogs, select another operation, coordinate user approval, or expand
the phase. Return the requested result envelope and end this worker's Sia activity. Refuse an incomplete,
contradictory, or permission-expanding handoff.

### `Sia stop`

Stop active Sia orchestration for later turns; do not claim already loaded context was erased. `Sia reload` rereads
current `.ai/sia.md`, stops active orchestration while preserving persisted plans, and applies it later. It does not
load catalogs, docs, or skills or start work; old context cannot be erased, and the current valid protocol takes
precedence.

The public reserved directives require exact arity; `Sia handoff` requires its structured body and `unattended` requires
an operation. Extra or missing arguments are errors.

## Catalogs and resolution

Skills, operations, and workflows are registered in their category `INDEX.md`. Logical names are normalized lowercase
kebab-case and cannot be `sia`, which names the reserved shipped-definition directory. Valid project definitions live
directly under their category.

Operation names and aliases also cannot be `unattended` or a reserved directive name.

For an indexed logical name, a CUSTOM entry resolves to the project definition and overrides the SIA entry. Otherwise,
resolve the SIA definition. Announce a selected project override. A missing, malformed, duplicated, mismatched, or
ambiguous CUSTOM definition is an error and never falls back to SIA. Unindexed files are not discoverable.

Operation aliases are recognized only from the `aliases:` metadata line immediately below an operation index entry.
Aliases use the same naming rules, cannot be `sia`, `unattended`, or a reserved directive name, and resolve uniquely.
Alias matching occurs only after the explicit `Sia` prefix. When CUSTOM overrides an operation, its metadata replaces
the complete shipped alias set for that logical name; aliases are never inherited from the SIA entry. An omitted alias
is therefore unavailable for the effective custom operation.

## Operation execution

Use `Sia <operation> [request]` interactively or `Sia unattended <operation> [request]` for unattended execution:

1. Read `.ai/operations/INDEX.md` and resolve the exact operation or alias.
2. Announce the effective operation and whether it is a project override.
3. Load `.ai/RULES.md` when present.
4. Read the resolved operation and resolve its one primary workflow and declared skills from their indexes.
5. Fail on malformed or missing references; do not substitute a different definition.
6. Load only the workflow, skills, and repository documentation required for intake and the current phase.
7. Follow the workflow until completion, cancellation, or explicit operation replacement.

Unattended mode is enabled only by the exact modifier. Do not infer unattended mode from natural-language requests. It
is upfront authorization for Sia-owned gates and conservative decisions clearly within the activating request; the
default is interactive. Persist it in every plan and handoff. Apply route gates: trivial is planless; lightweight uses
compact plan/digest/focused validation; standard keeps separate review and fixes. Auto-authorize an in-scope plan or
replan. If safe progress needs new scope, authority, or credentials, return `blocked` rather than asking the user or
guessing.

Project rules are hard Sia-specific constraints during operations, resume, and isolated phase execution. They take
precedence over repository documentation, skills, operations, workflows, and plans, but never over system or host
safety, permissions, or the user's current explicit instruction. Report material conflicts instead of guessing.
Rules and custom definitions may narrow unattended work but cannot activate it or expand its authorization ceiling.

Do not load `.ai/RULES.md` for help, `Sia load docs`, `Sia load skills`, or a direct Sia conversation.

Help, docs loading, skills loading, a direct conversation, and an invalid handoff do not replace an already active
operation. Only successful completion, `Sia stop`, `Sia reload`, or successful resolution of a new operation ends or
replaces it.

## Context, workers, and model profiles

Loaded docs and the skill catalog remain available for the current conversation. An operation and its execution mode
remain active until its workflow completes, `Sia stop` is invoked, or another operation replaces it. A new conversation
starts inactive. After context compaction, reread this protocol. For an active operation, also reload `.ai/RULES.md`,
the active plan when one exists, and only the exact current definition paths needed for the phase. Never scan catalogs
or historical plans to reconstruct compacted state.

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
do_not_load: []
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

Return the same bounded evidence using `handoff_result: 1`, `phase`, `status`, `actual_model`, `profile_honored`,
`changed_paths`, `command_results`, `usage`, `findings`, `evidence`, and `next_transition`. Result status is `complete`,
`blocked`, or `failed`; use `unknown` for model fields the host does not report.

The worker prompt starts with the `Sia handoff` directive, which causes it to read this file and `.ai/RULES.md`; it then
loads only the exact paths in the envelope. It must not reroute the task through catalogs or load unrelated and
historical artifacts. An unattended worker never authorizes a revision; it returns `blocked` to its coordinator instead
of asking the user. Describe isolation truthfully when the host may inherit hidden context.

Workflows may request advisory `fast` or `reasoning` profiles. A user choice takes precedence, then project rules, then
workflow guidance and task assessment. The host chooses the available model. Record `requested_model_profile` and
`model_selection_source` in the handoff. Record result field `actual_model` when reported or `unknown` otherwise, and
`profile_honored` as `true`, `false`, or `unknown` only when supportable. An unavailable profile never blocks work,
changes gates, expands permissions, or invalidates resumption.

## Safety and failure behavior

- Never infer missing definitions, indexes, approval, command results, or repository facts.
- Treat stale repository documentation as evidence to verify, not an instruction to follow.
- Preserve pre-existing changes. Report safely preservable dirty overlap; block unattended work when attribution or
  preservation is unsafe.
- Plan and review phases are read-only unless their workflow explicitly permits limited artifact or documentation
  writes.
- Unattended mode does not expand host permissions or authorize external actions, including destructive actions, that
  the user did not explicitly request. It cannot suppress permission prompts imposed by the host.
- Ship may write active-plan completion metadata. Interactive Ship may delete that exact completed plan only after an
  explicit confirmation; unattended Ship retains it. Product, source, and external state remain read-only unless the
  user explicitly requests another delivery action.
- Sia never expands filesystem, command, network, or external-action permissions.
Before activation, the Sia bridge does not direct the host to read `.ai/**`. A host may independently index repository
files; Sia cannot control undocumented host behavior.
