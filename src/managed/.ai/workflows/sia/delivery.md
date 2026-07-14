---
name: delivery
description: Deliver authorized changes through planning, review, validation, fixes, and product-read-only shipping.
---

# Delivery workflow

Triage before choosing a path. Standard follows `Plan → Approve → Build → Review/Validate → Fix → Review/Validate →
Ship`; lightweight follows direct authorization → Build → focused Review/Validate → Ship; trivial work is planless.

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

## Plan

- Purpose: produce a readable, executable standard plan; no product/source writes.
- Output: the visible plan states only outcome, scope, non-goals, acceptance, checks, risks, and external actions.
- Filename: every new artifact is `.ai/plans/YYYY-MM-DD-NN-<slug>.md`, using the UTC creation date and a two-digit,
  zero-padded daily sequence. Inspect filenames only (never prior plan contents) to select the next unused `NN` for that
  date; this makes directory order chronological and deterministic.
- Header: exactly `operation`, `workflow`, and declared `skills`; the filename is the plan identity.
- Footer: state is optional one-line `<!-- sia:<name> <value> -->` comments after the approval block. `status` is
  required; all other comments appear only when relevant.
- Model profile: request `reasoning` for ambiguous or risky planning; lightweight may use `fast`.

Persist a compact artifact before Build. Standard starts with `<!-- sia:status pending-approval -->`; interactive and
standard are defaults, so they need no mode or route comment. Record `base` for resume. Add `dirty` only for existing
paths; add `mode`, `route`, `ceiling`, or `external` only when they differ from those defaults or are nonempty.

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
catalog, load `documentation` or `safe-refactoring` only when material, and put exact paths plus `do_not_load` in the
handoff. After resolution, do not reread catalogs, broad docs, historical plans, or prior evidence. Append a short
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
definition paths, evidence, and worker-only state in the handoff envelope, not the plan.
