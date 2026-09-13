# Coding, planning, and saved work

The [delivery workflow](../src/managed/.ai/workflows/sia/delivery.md) owns ordinary coding behavior. It inspects
relevant
code, implements the request, checks the result, and continues through in-scope corrections. There are no ordinary
trivial/lightweight/standard routes, receipts, phase artifacts, or mandatory handoffs.

An implementation request authorizes its local scope. Ask about a missing decision when it would materially change
the outcome, or when permission is needed. Preserve unrelated changes. Host controls and explicit project/user limits
remain authoritative. An explicit planning request is not permission to implement.

## Planning

A useful plan explains the existing behavior, where the change belongs, the proposed approach, important choices, and
how to check it. It need not list every file or follow fixed headings. Do enough repository discovery to ground the
approach, including relevant callers and existing patterns. Do not replace engineering decisions with a restated goal.

Present a requested plan and wait for approval. Once approved, continue within its boundary without repeated prompts.
Routine implementation-detail changes do not invalidate that approval; expanded scope, risk, permissions, or external
actions must be made explicit before proceeding.

## Saved plans

Save only when requested. The optional [saved-plan support](../src/managed/.ai/workflows/sia/delivery/standard.md) owns
naming, approval hashes, states, and resume. New ordinary coding tasks do not load it. Current compact formats and
valid legacy plans remain supported; no migration is required. A pending draft resumes to approval, never Build.
A completed or contradictory artifact is refused. Metadata cannot grant authority absent from the user's request.

Plan content is conversation-isolated. Only exact authorized paths can be read, searched, or inspected in history.
Filename-only inspection may allocate a new name, not discover a related old task. Preserve authorization and pending
work across compaction. If exact authorization is lost, ask for the path rather than guessing.

Saved work keeps its original approval while definitions are updated. Resolve the current effective definitions at
phase boundaries, report changes, and return to approval for material conflicts. New defaults cannot retroactively
authorize edits. Saved-plan Ship requires passing review and writes only completion metadata; retain the plan.

## Forge mode

`Sia forge on` enables conversation follow-ups when no operation is active. It uses the same delivery behavior, with
an optional `Sia` prefix and clear references such as “next one”. `do:` requests implementation; `plan:` or `inline
plan`
requests approval first. There is no separate eligibility table. Read-only requests run directly.

Operation names and aliases stay within Forge. Reserved directives and explicit unattended invocations keep normal
routing. Forge stores no task artifact; off, stop, reload, or a new conversation ends it. For saved work, turn Forge off
and explicitly request a saved plan. Details live in [Forge
support](../src/managed/.ai/workflows/sia/delivery/forge.md).

## Unattended work

Only `Sia unattended <operation> [request]` enables it. The original request and authorized external actions define its
limit; missing authority or credentials blocks work rather than inviting guesses. Ordinary unattended coding is
planless. Explicitly saved work records its mode and ceiling; a planning-only request stays pending. Bound retries to
three failed fix cycles and retry a blocker only after observable change. Custom workflows may narrow this authority.

## Review and workers

Review both the original request and any approved plan. Extra features can be wrong even when the plan proposed them.
Independent review is useful when it adds confidence, but a worker is optional. Use host delegation only for a bounded
useful assignment. The [handoff support](../src/managed/.ai/workflows/sia/delivery/handoff.md) carries exact paths,
permissions, evidence, and approved scope. Existing fuller envelopes remain valid. Model selection and telemetry are
host concerns, not mandatory Sia task records. Never claim isolation the host does not provide.

## Other operations

Investigation and standalone review are read-only. Investigation may save one pending plan only on explicit request.
Documentation writes the requested docs and nearest indexes. Creator operations use one definition workflow for shared
validation while defining their own schema. CUSTOM workflows keep their own rules; shipped support is not appended.
