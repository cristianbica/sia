# Activation protocol

`.ai/sia.md` is Sia's canonical prompt protocol. The root entrypoint bridge only makes the host aware of Sia and tells
it when to load this file. It must not duplicate catalog resolution, workflow rules, or repository knowledge.

Every `.ai/**` path is relative to the Git repository root containing the activating `AGENTS.md`, even when the host
starts from a subdirectory.

Activation fails closed. If `.ai/sia.md` is missing, empty, unreadable, or structurally invalid, report an
installation-integrity error and do not infer or improvise Sia behavior from indexes, definitions, documentation, or
prior conversations.

The managed file begins with this source-controlled frontmatter:

```yaml
---
sia_protocol: 1
---
```

Structural validation requires the exact three-line header above and a nonempty prompt body. Protocol 1 does not allow
additional frontmatter fields; a later protocol can define a different trusted header deliberately.

The bridge contains the minimum trusted check: the first three lines must be exactly the header above and the file must
have a nonempty body. This lets activation fail closed without relying on instructions inside an unvalidated file.

## Exact activation grammar

Sia activation is attempted only when `Sia` is the first non-whitespace token and is followed by whitespace or the end
of the message. The token is case-sensitive. `sia`, `SIA`, `Sia:`, and a sentence that merely mentions Sia do not
attempt activation. Every other remainder is an explicit Sia request; it may select an operation or become a direct,
read-only conversation.

After reading `.ai/sia.md`, resolve the remainder in this order:

1. Empty remainder: show concise help covering docs, skills, interactive/unattended operations, resume, and stop.
2. Exact `unattended` modifier: resolve the following logical operation in unattended mode.
3. Reserved directive: execute its narrowly defined behavior.
4. Reserved directive name with invalid arity or syntax: report an error and do not use conversational fallback.
5. Logical operation name: resolve and activate that operation in interactive mode.
6. No exact match: infer an operation only when the request clearly asks for a change and one effective operation fits
   with high confidence. Announce the inferred operation; never infer unattended mode.
7. Otherwise: answer directly as Sia, loading only relevant context and making no edits or workflow transition.

Free-form action cues such as “work on”, “fix this”, or “adjust” may select the best matching operation when the request
and effective catalog make the choice clear. “What do you think”, “explain”, and other advisory wording remain direct
conversation unless the user explicitly asks for a change.

## Reserved directives

### `Sia load docs`

Read `.ai/docs/INDEX.md` only. Make its routing information available to the host's normal workflow, following links
only when a later task makes them relevant. This does not activate an operation or workflow.

The installer creates the initial index with `status: not-initialized` and then relinquishes ownership. If that status
or a missing index is encountered, report that repository documentation is unavailable and suggest
`Sia document repository`.

### `Sia load skills`

Read `.ai/skills/INDEX.md`, merge its SIA and CUSTOM entries, and expose the effective catalog. Do not load every skill
body. Load a skill only when a later task makes it relevant or the user requests it explicitly.

### `Sia resume <approved-plan>`

Read a persisted delivery plan and verify its visible approval digest plus compact status comments. New plans keep only
`operation`, `workflow`, and `skills` in frontmatter; optional one-line footer comments carry base, dirty paths,
unattended authority, and concise progress when needed. Existing valid legacy plans remain resumable. Refuse stale,
unapproved, ambiguous, or inconsistent plans. Other artifact kinds need an envelope.

### `Sia handoff` followed by an envelope

This internal directive activates one bounded phase in a fresh worker created by an already active Sia operation. The
worker message begins with an exact `Sia handoff` line, followed by `handoff_protocol: 1` and the envelope defined in
[orchestration.md](orchestration.md). It fails closed when required fields conflict or are missing, loads exact
definition paths instead of catalogs, performs only the assigned phase, returns its result, and ends.

The managed protocol contains the canonical YAML-shaped serialization. Every key is required, absent values are
explicit, exact definition paths are labeled by kind, `final_task` is the last field, and the worker returns the
documented `handoff_result: 1` shape. Hosts must not invent a looser envelope.

### `Sia stop`

Stop active Sia orchestration for subsequent turns in the conversation. This cannot remove text the host has already put
in model context; it means Sia no longer deliberately loads definitions or applies workflow behavior.

### `Sia reload`

Validate and reread the current `.ai/sia.md` without restarting the host. Stop active Sia orchestration for subsequent
turns while preserving any persisted plan. Do not load catalogs, docs, or skills or start work. Reload cannot erase old
model context; the current valid protocol takes precedence.

Public reserved directives require exact arity. `Sia load docs extra`, `Sia load skills extra`, `Sia resume`, `Sia stop
extra`, and `Sia reload extra` are errors rather than operation invocations. `Sia handoff` instead requires its
structured body.

## Unattended operation invocation

`Sia unattended <operation> [request]` is the only unattended invocation form. The modifier is case-sensitive and must
appear immediately after `Sia`. It requires a valid operation and cannot wrap help, `load`, `resume`, `handoff`, `stop`,
or `reload`. Protocol 1 does not switch an existing interactive plan to unattended mode.

Unattended mode is the user's upfront authorization for Sia-owned workflow gates within the original operation request.
Sia does not ask approval or clarification questions: it makes conservative, reversible assumptions and records them,
or returns a blocked result when a necessary choice cannot safely be inferred. Material replanning is automatically
approved only while it remains a faithful interpretation of the original outcome. Separate review, validation, and Fix
cycles remain required. Interactive lightweight work is directly authorized by its activating request; interactive
standard work pauses once for an intent envelope and re-prompts only at a boundary expansion.

For delivery, an unattended plan adds immutable one-line `mode`, `ceiling`, and `external` comments only when needed.
Sia computes and verifies the approval digest before Build; an interactive user approves the displayed draft in plain
language and never supplies a digest. Automatic approval identifies accepted plan bytes; it does not prove user review.
Handoffs retain their own complete fields, and `Sia resume <approved-plan>` inherits unattended authority.

Unattended mode never expands host permissions, bypasses system or external approval interfaces, weakens project rules
or dirty-worktree safeguards, or authorizes work outside the initial request. Commit, push, pull request, release,
publish, deploy, destructive actions, and other external actions require explicit intent in that request. When a host
permission, credential, material ambiguity, unsafe attribution, or scope expansion prevents safe progress, write a
structured blocker and return instead of waiting. Do not retry an unchanged blocker or auto-replan unsafe dirty overlap.

## Operation invocation

`Sia <operation> [request]` and its unattended form resolve `<operation>` from `.ai/operations/INDEX.md`. Resolution
uses normalized lowercase kebab-case names and the custom-over-Sia rules in [extensions.md](extensions.md).

After resolution:

1. Announce the effective operation and whether it is a custom override.
2. Load `.ai/RULES.md` when present.
3. Resolve its primary workflow and declared skills.
4. Report malformed or missing references rather than silently substituting another definition.
5. Load only the workflow, skills, and documentation required for intake and the current phase.
6. Let the workflow triage the smallest safe execution route before writes; eligible lightweight work is directly
   authorized, while standard work requires one intent-envelope approval. Do not infer low risk from size alone.
7. Follow the selected workflow route until completion, cancellation, or an explicit operation replacement.

## Project rules

`.ai/RULES.md` is project-owned and contains hard Sia-specific constraints. Load it for operation execution, delivery
resume, and any isolated phase execution. Do not load it for `Sia load docs`, `Sia load skills`, `Sia reload`, help, or
a direct conversation, because those paths intentionally leave the host's normal workflow in control.

Within an active Sia operation, project rules take precedence over documentation, skills, operations, workflows, and
plans. They cannot override host/system safety, permissions, or the user's current explicit instruction. When those
sources conflict materially, report the conflict instead of silently choosing. Interactive execution requests direction;
unattended execution returns a blocked result.

Operation keywords do not belong in `RULES.md`. They are cataloged aliases and activate only after the explicit `Sia`
prefix, preserving opt-in behavior.

Help, docs loading, skills loading, a direct conversation, and an invalid handoff do not replace an active operation.
Only successful completion, `Sia stop`, `Sia reload`, or a successfully resolved new operation ends or replaces it.

## Activation duration

- Loaded docs and skill catalogs remain available for the current conversation.
- An operation remains active until its workflow completes, the user invokes `Sia stop` or `Sia reload`, or another
  operation replaces it.
- A new conversation starts with Sia inactive unless it begins with a recognized Sia invocation.
- After compaction, reread the entrypoint and `.ai/sia.md`. For an active operation, also reload `.ai/RULES.md`, the
  named active plan when one exists, and only the exact current definition paths needed for the phase. Never scan
  catalogs or historical plans to reconstruct compacted state.

## Worker startup

An isolated worker receives the handoff envelope defined in [orchestration.md](orchestration.md), including its mode,
authorization ceiling, and external-action list. Its prompt starts with `Sia handoff`, activating `.ai/sia.md`.
It reads `.ai/RULES.md`, loads exact definition paths instead of re-resolving catalogs, and executes only the assigned
workflow phase. An unattended worker returns a blocked result to its coordinator rather than asking the user a
question.

Call a worker isolated only when the host can start it without the earlier conversation. If hidden or inherited context
cannot be ruled out, describe the mechanism accurately and rely on the bounded artifact rather than claiming freshness.

## Failure behavior

- A malformed custom override is an error; never silently fall back to the shipped definition.
- Duplicate logical names in the same catalog section are an error.
- Missing indexes or definitions produce a repair suggestion, not speculative behavior.
- Documentation that appears stale is evidence to verify, not an instruction to follow.
- Sia never expands the host's filesystem, command, network, or external-action permissions.
- Unattended mode cannot suppress permission prompts or approval interfaces enforced by the host.

## Opt-in promise

Before activation, Sia's bridge does not instruct the model to read `.ai/**`, and no `.ai/**` body is deliberately added
to context by Sia. A host may independently index repository files; Sia cannot promise control over undocumented host
internals.
