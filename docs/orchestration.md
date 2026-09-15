# Coding, planning, and saved work

The [delivery workflow](../src/managed/.ai/workflows/sia/delivery.md) owns ordinary coding behavior. It inspects
relevant code, implements the request, checks the result, and continues through in-scope corrections. There are no
ordinary trivial/lightweight/standard routes, receipts, phase artifacts, or mandatory handoffs.

Every change request requires discovery, clarification of material requirements, a saved plan, and approval before
edits. This applies across operations, aliases, inferred requests, and CUSTOM workflows. Explicit unattended mode or
an instruction to skip planning may select another behavior; neither silently approves an existing pending plan.
Read-only requests and session directives need no plan. Preserve unrelated changes and host permissions.

## Planning

A useful plan explains the existing behavior, where the change belongs, the proposed approach, important choices, and
how to check it. It need not list every file or follow fixed headings. Do enough repository discovery to ground the
approach, including relevant callers and existing patterns. Do not replace engineering decisions with a restated goal.

Present a required or requested plan and wait for approval. Once approved, continue within its boundary without
repeated prompts. Routine implementation-detail changes do not invalidate that approval; expanded scope, risk,
permissions, or external actions must be made explicit before proceeding.

## Saved plans

Save for every change request unless the user explicitly selects an exception. The shared [saved-plan
support](../src/managed/.ai/workflows/sia/delivery/standard.md) owns naming, approval hashes, states, and resume for
the actual operation and workflow. Existing compact and valid legacy plans remain supported.

Clarification and resume do not approve a plan. Plans are conversation-isolated: read only exact authorized paths,
including across compaction. Filename inspection is allowed solely to allocate a new name. Never use a plan from a
similar task as inferred authority.

Saved work keeps its original approval while definitions are updated. Resolve the current effective definitions at
phase boundaries, report changes, and return to approval for material conflicts. New defaults cannot retroactively
authorize edits. Saved-plan Ship requires passing review and writes only completion metadata; retain the plan.

## Forge mode

`Sia forge on` enables continuous follow-ups. Change requests, including `do:`, still require saved planning and
approval. Explicit `inline plan` selects an unsaved plan while retaining approval. Saved plans can resume without
turning Forge off; inline-only work cannot resume across sessions. Read-only requests run directly.

Operation names and aliases stay within Forge. Reserved directives and explicit unattended invocations keep their
normal routing. See [Forge support](../src/managed/.ai/workflows/sia/delivery/forge.md).

## Unattended work

Only `Sia unattended <operation> [request]` enables it. The original request and authorized external actions define
its limit; missing authority or credentials blocks work rather than inviting guesses. Ordinary unattended coding is
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
validation while defining their own schema. CUSTOM workflows keep their task rules and preserve the shared planning
boundary.