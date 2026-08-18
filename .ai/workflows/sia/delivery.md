---
name: delivery
description: Deliver authorized changes through planning, review, validation, fixes, and product-read-only shipping.
---

# Delivery workflow

Forge requests use the immediate or approved inline paths below. Otherwise, triage before choosing a path. Standard
follows `Plan → Approve → Build → Review/Validate → Fix → Review/Validate → Ship`; lightweight follows direct
authorization → Build → focused Review/Validate → Ship; trivial work is planless.

## Forge delivery

Use these paths for unqualified requests or a later valid `Sia …` request while Forge is enabled and no operation is
active. Discard the optional `Sia` prefix before classifying the request. Exact operation names and aliases stay in
Forge; reserved directives and `unattended` use normal resolution instead.

Treat terse follow-ups as commands over active Forge context. Resolve `done`, `next one`, `same`, item numbers,
pronouns, and equivalent shorthand from recent conversation state, loaded content, and the current task when one clear
referent exists. Reuse established findings, decisions, ordering, and verified evidence; do not reopen files or repeat
searches by default. Treat a user-stated completion or transition as current context unless a small relevant check
contradicts it. When multiple material interpretations remain, ask one focused clarification without speculative
discovery.

Questions and non-mutating local requests run immediately without operation resolution, an inline plan, or approval.
This includes reads, searches, listings, diffs, status and history, inspection, review, and safe local diagnostics whose
purpose is evidence rather than an intended durable repository or external-state change. Load only relevant context,
perform the work, report the result, and leave Forge ready for the next request.

Safe diagnostics may create ordinary transient temporary or cache output, but a command known to rewrite durable
repository state is a change. If an immediate diagnostic unexpectedly changes durable state, stop and report the exact
change without silently retaining, reverting, or cleaning it.

Classify a requested change by authorization clarity and boundary predictability, not size. `do:` explicitly requests
direct execution; `plan:` and `inline plan` explicitly request the approval path. Strip a selector before resolving the
request. A selector expresses cadence only and never overrides permissions, safety, or lane eligibility.

A change qualifies for direct execution only when the request is a precise imperative with one clear target and
result, the effect is local and reversible, and discovery is unlikely to expand its boundary. It must have no material
ambiguity, external action, destructive effect, permission or security concern, migration, broad refactor, or
dirty-worktree attribution risk. Active context may supply the target and result. Examples include `mark #4 done`,
`change X to Y`, and a contextually specific `add this assertion`; `do:` makes the preference explicit but cannot make
an ineligible request direct.

The request itself authorizes a qualifying bounded write. Execute only its stated boundary without an inline plan or a
second approval, apply proportionate review and checks, report changed paths and validation, and leave Forge ready for
the next request. If discovery reveals material ambiguity, risk, or expansion, stop before acting beyond the bounded
request and present an inline plan; report any already completed in-bound work accurately.

A vague or outcome-oriented request such as `handle #5`, every request selected by `plan:` or `inline plan`, and every
ineligible direct request uses the approval path. Resolve one fitting effective operation under the normal confidence
and catalog rules, then load its rules, workflow, skills, and material documentation. If the outcome itself is
ambiguous, ask one focused clarification without planning or acting. Do not use normal trivial, lightweight, or
standard artifact handling.

An explicit request for an `inline plan` or equivalent is an output and cadence instruction, not approval. Reuse loaded
context and perform only the minimum safety-critical discovery needed to state outcome, scope, non-goals, acceptance,
checks, risks, and external actions. Stop discovery as soon as that envelope is safe. Defer deeper seam, caller,
analogue, and regression-detail discovery until after approval unless it could materially change the envelope. Present
the plan directly and ask for approval without routine command narration, repeated evidence, or a discovery transcript.

For the approval path, present a concise inline intent envelope with outcome, scope, non-goals, acceptance criteria,
checks, risks, and external actions. Ask for explicit approval before the change or external action. Approval binds
only that visible task; when its outcome, scope, non-goals, criteria, risk, permissions, or external actions change,
show a revised inline plan and ask again. Never write Forge state to `.ai/plans/**`, add a digest or status comment, or
offer `Sia resume`.

After approval, implement only the inline envelope. Preserve pre-existing work and apply the normal permission,
external-action, security, and dirty-worktree gates. Use proportionate Build, Review/Validate, and bounded Fix cycles;
load the effective testing and code-review skills when material. Task size and risk scale plan detail, isolation,
review depth, and validation, but never promote Forge work to a persisted artifact solely because it is large.

Report checks, findings, fixes, skips, and residual risk. Completion clears the inline task and leaves Forge ready for
the next request. A new conversation loses the task; use an explicit operation when resumability is desired. Genuine
scope, permission, credential, external-action, safety, attribution, or validation blockers still stop the task.

## Route triage

Announce `trivial`, `lightweight`, or `standard` and the evidence before writes.

- `trivial`: an obvious requested typo, formatting, comment, or wording correction with no behavior, policy, permission,
  schema, command, or public-contract change. It needs no artifact or approval. Doubt promotes it.
- `lightweight`: one narrow project documentation/definition change, or one internal source change with an evidenced
  seam, exact paths, clear criteria, and focused test. No public, migration, configuration, permission, security,
  concurrency, external, compatibility, multi-consumer, broad-refactor, managed-Sia, lifecycle, dirty, or unresolved
  risk. The activating request directly authorizes a compact receipt, one Build handoff, focused validation, and no
  independent review worker.
- `standard`: every change not fully qualifying for lightweight, including operations/workflows, public contracts,
  migrations, security, destructive or external work, broad scope, dirty attribution risk, or uncertainty.

Size is supporting evidence, never proof. `full` or `thorough` selects standard. Unattended mode selects trivial or
lightweight only when eligibility is unambiguous; otherwise select standard or return `blocked`. Promote before a new
risk is acted on. For trivial work, report the diff, check, skips, and route.
When waiting, use one longest-safe wait; never poll without new evidence.

Before Build, every lightweight delivery shows an inline compact receipt with its outcome, exact paths or bounded area,
acceptance checks, documentation impact, and external actions. The activating request remains its authorization: the
receipt does not ask for another approval. It does not write `.ai/plans/` or become a `Sia resume` target.
A correction that changes scope or any material risk promotes the work to standard delivery and its persisted approval
plan.

## Plan

- Purpose: produce a readable, executable standard plan; no product/source writes.
- Output: the visible plan states only outcome, scope, non-goals, acceptance, checks, risks, and external actions.
- Filename: every new artifact is `.ai/plans/YYYY-MM-DD-NN-<slug>.md`, using the UTC creation date and a two-digit,
  zero-padded daily sequence. Inspect filenames only (never unauthorized plan contents) to select the next unused `NN`
  for that date; this makes directory order chronological and deterministic.
- Header: exactly `operation`, `workflow`, and declared `skills`; the filename is the plan identity.
- Footer: state is optional one-line `<!-- sia:<name> <value> -->` comments after the approval block. `status` is
  required; all other comments appear only when relevant.
- Model profile: request `reasoning` for ambiguous or risky planning; lightweight may use `fast`.

Persist a compact artifact before Build and immediately add its exact path to the conversation's
`authorized_plan_paths`. Standard starts with `<!-- sia:status pending-approval -->`; interactive and standard are
defaults, so they need no mode or route comment. Record `base` for resume. Add `dirty` only for existing paths; add
`mode`, `route`, `ceiling`, or `external` only when they differ from those defaults or are nonempty.

## Approve

- Purpose: bind permission to a standard intent envelope or record direct lightweight authorization.
- Gate: one interactive approval for standard work; the activating request authorizes lightweight and unattended work.
- Writes: only footer comments in the delivery artifact.

For standard work, present outcome, scope, non-goals, criteria, risks, external actions, and path. The intent envelope
covers implementation approach, step order, focused checks, and in-scope documentation. Ask again only when outcome,
scope, non-goals, criteria, risk, permissions, or external actions expand.

Digest only the visible bytes between `sia:approval` markers. After approval, append `<!-- sia:approved <sha256> -->`
and change status to `build`; never ask users to compare a digest. A change inside the envelope is progress; a boundary
change removes the approval comment, restores `pending-approval`, and presents the updated plan. Unattended may replace
the approval comment only inside its unchanged ceiling; otherwise it blocks instead of asking. Neither mode expands host
permissions or external actions.

## Build

Implement only approved scope, including tests and affected documentation. Standard prefers an isolated worker, then a
fresh conversation, then same-context execution; lightweight uses one bounded Build handoff. Compare the worktree with
optional `base` and `dirty` comments. Preserve pre-existing work; unsafe overlap or attribution is blocked before
unattended writes. Do not stash, reset, clean, or overwrite it.

Request `fast` for mechanical work and `reasoning` for risky work. Resolve required skills through the effective
catalog, load `documentation` or `safe-refactoring` only when material, and put exact paths,
`authorized_plan_paths`, and every other `.ai/plans/**` path in `do_not_load` in the handoff.
After resolution, do not reread catalogs, broad docs, unauthorized plans, or prior evidence. Append a short
`<!-- sia:progress build: <summary> -->` comment and set status to `review-validate` when complete.

## Review/Validate

Inspect correctness, scope, regressions, security/operational risk, documentation, and command claims. Standard prefers
a reviewer who did not build; lightweight uses focused coordinator testing and a focused diff/scope check. A
material lightweight finding promotes to standard before Fix or Ship. Append one short progress comment; set status to
`fix`, `ship`, or `pending-approval` as appropriate.

Standard resolves effective `code-review` and `testing` skills; lightweight loads only `testing`. Respect CUSTOM
overrides and record exact definition paths in the handoff. Never claim an uninspected command passed.

## Fix

Fix only in-scope standard findings, then return to Review/Validate. A material change returns to Plan. Unattended work
may make at most three Fix cycles; then append one `<!-- sia:blocker <reason>; resume when <condition> -->` comment and
set status to `blocked` rather than weakening acceptance criteria.

## Ship

Ship requires passing review evidence. It writes only `<!-- sia:status complete -->` and a final short progress comment;
retain the plan for history without asking. Delete an exact completed plan only after a separate explicit user request.
Commit, push, pull request, release, publish, and deploy require explicit user intent.

## Compact plan artifact

New plans use this shape (for example, `.ai/plans/2026-07-14-06-short-outcome.md`):

```markdown
---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Short outcome

<!-- sia:approval:start -->
## Scope
...

## Acceptance
...
<!-- sia:approval:end -->

<!-- sia:status pending-approval -->
<!-- sia:base 4d3f... -->
```

The frontmatter has no ID, status, revision, digest, baseline, route, permission, or external-action fields. Do not
write empty comments. Valid optional comments are `approved`, `base`, `dirty`, `mode`, `route`, `ceiling`, `external`,
`progress`, and `blocker`; comments are one line and remain after the approval block. `status` is exactly one of
`pending-approval`, `build`, `review-validate`, `fix`, `ship`, `blocked`, `complete`, or `cancelled`.

`approved` contains the lowercase SHA-256 of normalized approval-block bytes. `base` is the initial commit; `dirty`
lists only pre-existing paths. `mode: unattended` makes `ceiling` immutable and requires an `external` comment for each
explicit external action. Omit them for default interactive standard work. `progress` records a concise completed phase,
check, finding, or deviation. `blocker` names an observable resume condition.

Resume accepts a compact artifact only when it has exactly one nonnested approval marker pair, one status comment, and a
matching approval digest whenever status is beyond `pending-approval`. It derives the next action from status, checks
base/dirty comments when present, and refuses contradictory or complete/cancelled artifacts. It accepts existing valid
legacy artifacts unchanged; never rewrite them merely to compact them.

Changing approval-block bytes removes the approval comment and returns to `pending-approval`; progress comments never
repair invalid approval content. Load only the named active plan and exact current definitions. At phase boundaries put
definition paths, authorized plan paths, evidence, and worker-only state in the handoff envelope, not the plan.
