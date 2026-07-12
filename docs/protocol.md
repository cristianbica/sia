# Activation protocol

`.ai/sia.md` is Sia's canonical prompt protocol. The root entrypoint bridge only makes the host aware of Sia and tells
it when to load this file. It must not duplicate catalog resolution, workflow rules, or repository knowledge.

Activation fails closed. If `.ai/sia.md` is missing, empty, unreadable, structurally invalid, or incompatible with the
installed `.ai/VERSION`, report an installation-integrity error and do not infer or improvise Sia behavior from
indexes, definitions, documentation, or prior conversations.

The managed file begins with this release-populated frontmatter:

```yaml
---
sia_protocol: 1
sia_version: 0.1.0
---
```

Structural validation requires frontmatter at the start, exactly one integer `sia_protocol`, exactly one normalized
`sia_version`, and a nonempty prompt body. The protocol value must be supported by the entrypoint contract, and the
version must equal the trimmed value in `.ai/VERSION`. Unknown fields are allowed for forward-compatible metadata.

## Exact activation grammar

Sia activation is attempted only when `Sia` is the first non-whitespace token and is followed by whitespace or the end
of the message. The token is case-sensitive. `sia`, `SIA`, `Sia:`, and a sentence that merely mentions Sia do not
attempt activation. An unknown remainder is still an explicit attempt: load `.ai/sia.md`, report the resolution error,
and do not activate an operation.

After reading `.ai/sia.md`, resolve the remainder in this order:

1. Empty remainder: show concise help and remain otherwise inactive.
2. Reserved directive: execute its narrowly defined behavior.
3. Logical operation name: resolve and activate that operation.
4. No match: report the unknown name and suggest catalog matches without choosing a materially different operation.

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

Read a persisted delivery plan, verify its approved revision and digest, and enter the recorded next phase. Refuse
ambiguous, stale, missing, unapproved, or internally inconsistent plans. V1 resume semantics apply only to delivery
plans; add other resumable artifact kinds only when their workflow defines a concrete envelope.

### `Sia stop`

Stop active Sia orchestration for subsequent turns in the conversation. This cannot remove text the host has already put
in model context; it means Sia no longer deliberately loads definitions or applies workflow behavior.

Reserved directives require exact arity. `Sia load docs extra`, `Sia load skills extra`, `Sia resume`, and
`Sia stop extra` are errors rather than operation invocations.

## Operation invocation

`Sia <operation> [request]` resolves `<operation>` from `.ai/operations/INDEX.md`. Resolution uses normalized lowercase
kebab-case names and the custom-over-Sia rules in [extensions.md](extensions.md).

After resolution:

1. Announce the effective operation and whether it is a custom override.
2. Load `.ai/RULES.md` when present.
3. Resolve its primary workflow and declared skills.
4. Report malformed or missing references rather than silently substituting another definition.
5. Load only the workflow, skills, and documentation required for intake and the current phase.
6. Follow the workflow until completion, cancellation, or an explicit operation replacement.

## Project rules

`.ai/RULES.md` is project-owned and contains hard Sia-specific constraints. Load it for operation execution, delivery
resume, and any isolated phase execution. Do not load it for `Sia load docs`, `Sia load skills`, help, or an unresolved
activation attempt, because those paths intentionally leave the host's normal workflow in control.

Within an active Sia operation, project rules take precedence over documentation, skills, operations, workflows, and
plans. They cannot override host/system safety, permissions, or the user's current explicit instruction. When those
sources conflict materially, report the conflict and request direction instead of silently choosing.

Operation keywords do not belong in `RULES.md`. They are cataloged aliases and activate only after the explicit `Sia`
prefix, preserving opt-in behavior.

## Activation duration

- Loaded docs and skill catalogs remain available for the current conversation.
- An operation remains active until its workflow completes, the user invokes `Sia stop`, or another operation replaces
  it.
- A new conversation starts with Sia inactive unless it begins with a recognized Sia invocation.
- After compaction, the entrypoint and `.ai/sia.md` should be re-read when needed before continuing an active artifact.

## Worker startup

An isolated worker receives the handoff envelope defined in [orchestration.md](orchestration.md) and starts by reading
`.ai/sia.md` and `.ai/RULES.md`. It loads the exact definition paths in the handoff rather than re-resolving catalogs,
does not independently reroute the task, and executes only the assigned workflow phase.

Call a worker isolated only when the host can start it without the earlier conversation. If hidden or inherited context
cannot be ruled out, describe the mechanism accurately and rely on the bounded artifact rather than claiming freshness.

## Failure behavior

- A malformed custom override is an error; never silently fall back to the shipped definition.
- Duplicate logical names in the same catalog section are an error.
- Missing indexes or definitions produce a repair suggestion, not speculative behavior.
- Documentation that appears stale is evidence to verify, not an instruction to follow.
- Sia never expands the host's filesystem, command, network, or external-action permissions.

## Opt-in promise

Before activation, Sia's bridge does not instruct the model to read `.ai/**`, and no `.ai/**` body is deliberately added
to context by Sia. A host may independently index repository files; Sia cannot promise control over undocumented host
internals.
