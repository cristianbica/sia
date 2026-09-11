# Standard planning and approval

Supporting guidance for the effective delivery workflow; not a separately invokable workflow.
Load for Plan, Approve, or validating a resumed artifact. After approval, follow the workflow's execution guidance.

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

Write for the person deciding whether to approve the change:

- Start with the proposed behavior. Explain the key decisions and why they matter, using short, concrete sentences.
- Give each point one main idea. Explain necessary technical terms instead of stacking names and mechanisms.
- Keep details that affect understanding or approval. Omit file inventories, repeated safeguards, and speculative steps.
- State observable acceptance checks and material risks. Do not drop scope or safety requirements for brevity.
- Reread for meaning: can the reader tell what will change and why without translating jargon? Shorter text and more
  bullets alone do not pass. Avoid both long prose and cryptic fragments; do not impose a word quota.

Persist a compact artifact before Build and immediately add its exact path to the conversation's
`authorized_plan_paths`. Standard starts with `<!-- sia:status pending-approval -->`; interactive and standard are
defaults, so they need no mode or route comment. Record `base` for resume. Add `dirty` only for existing paths; add
`mode`, `route`, `ceiling`, or `external` only when they differ from those defaults or are nonempty.

## Approve

- Purpose: bind permission to a standard intent envelope or record direct lightweight authorization.
- Gate: one interactive approval for standard work; the activating request authorizes lightweight and unattended work.
- Writes: only footer comments in the delivery artifact.

An interactive standard implementation request authorizes discovery and a saved plan only. Present the plan and wait
for approval of that visible scope before any product/source edit, even when the requested edit is local or reversible.
Generic imperatives such as "implement this" and instructions to work autonomously do not approve a plan that has not
been presented. Approval may be a clear natural-language reply referring to the presented plan; no special token is
required. Approval of an already-presented plan remains valid, so do not restart planning or ask again without a
material boundary change. Do not create an approval record after editing to excuse a skipped gate.

This is the user's selected delivery sequence, not an extra tool-permission prompt. Host instructions retain their
priority; if they prevent following this sequence, report the conflict and the limit of Sia's guarantee. Never claim
the gate was honored when it was skipped. Trivial, lightweight, Forge, and unattended retain their stated rules.

For standard work, present outcome, scope, non-goals, criteria, risks, external actions, and path. The intent envelope
covers implementation approach, step order, focused checks, and in-scope documentation. Ask again only when outcome,
scope, non-goals, criteria, risk, permissions, or external actions expand.

Digest only the visible bytes between `sia:approval` markers. After approval, append `<!-- sia:approved <sha256> -->`
and change status to `build`; never ask users to compare a digest. A change inside the envelope is progress; a boundary
change removes the approval comment, restores `pending-approval`, and presents the updated plan. Unattended may replace
the approval comment only inside its unchanged ceiling; otherwise it blocks instead of asking. Neither mode expands host
permissions or external actions.

## Compact plan artifact

New plans use this shape (for example, `.ai/plans/2026-07-14-06-short-outcome.md`):

```markdown
---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Prevent duplicate webhook processing

<!-- sia:approval:start -->
Record each webhook's event ID so a repeated delivery does not apply the same update twice.

## Changes

- Save the event ID and its update in one database transaction. If the update fails, a retry can still process it.
- Enforce unique event IDs in the database so simultaneous deliveries cannot both apply the update.
- Add an event-ID table. Leave existing webhook authentication and payload validation unchanged.

## Checks and limits

- Test repeated and simultaneous deliveries: one update per event ID.
- Test a failed update followed by a successful retry: the event must not be lost.
- Run the webhook tests and apply the migration to an isolated test database.
- Existing events have no recorded IDs; this only prevents duplicates processed after the change is installed.
- No production migration, deployment, or live webhook calls.
<!-- sia:approval:end -->

<!-- sia:status pending-approval -->
<!-- sia:base 4d3f... -->
```

The frontmatter has no ID, status, revision, digest, baseline, route, permission, or external-action fields. Do not
write empty comments. Valid optional comments are `approved`, `base`, `dirty`, `mode`, `route`, `ceiling`, `external`,
`progress`, and `blocker`; comments are one line and remain after the approval block. `status` is exactly one of
`pending-approval`, `build`, `review-validate`, `fix`, `ship`, `blocked`, `complete`, or `cancelled`.

`approved` uses lowercase SHA-256 and the UTF-8/LF convention in `.ai/sia.md`; preserve whitespace between markers.
`base` is the initial commit; `dirty` lists only pre-existing paths. `mode: unattended` makes `ceiling` immutable and
requires an `external` comment for each explicit external action. Omit them for default interactive standard work.
`progress` records a concise completed phase,
check, finding, or deviation. `blocker` names an observable resume condition.

Resume accepts a compact artifact only when it has exactly one nonnested approval marker pair, one status comment, and a
matching approval digest whenever status is beyond `pending-approval`. A pending draft enters Approve, never Build.
It derives the next action from status, checks base/dirty comments when present, and refuses contradictory or
complete/cancelled artifacts. It accepts existing valid legacy artifacts unchanged; never rewrite them merely to
compact them.

Changing approval-block bytes removes the approval comment and returns to `pending-approval`; progress comments never
repair invalid approval content. Load only the named active plan and exact current definitions. At phase boundaries put
definition paths, authorized plan paths, evidence, and worker-only state in the handoff envelope, not the plan.
