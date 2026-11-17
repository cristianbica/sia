# Coding, planning, and saved work

The [delivery workflow](../src/managed/.ai/workflows/sia/delivery.md) owns ordinary coding behavior. It inspects
relevant code, implements the request, checks the result, and continues through in-scope corrections. There are no
ordinary trivial/lightweight/standard routes, receipts, phase artifacts, or mandatory handoffs.

Outside Forge, change requests require discovery, clarification of material requirements, an inline or saved plan,
and approval before edits. This applies across operations, aliases, inferred requests, and CUSTOM workflows.
Explicit unattended mode or
an instruction to skip planning may select another behavior; neither silently approves an existing pending plan.
Read-only requests and session directives need no plan. Preserve unrelated changes and host permissions.

## Planning

Outside Forge, starting a change operation starts planning, including `Sia implement the above` after an investigation.
Investigation
recommendations supply evidence and possible approaches; they do not authorize implementation. Resolve material
decisions, present the finalized delivery plan, and wait for a subsequent approval reply. New interactive saved plans
start pending approval without an approval marker. Do not retroactively approve them using the operation invocation.

A plan explains the approach, the concrete work, and how success will be checked. Choose the organization to suit the
task and the user's preferences. A short fix may need one explanation; a migration may need ordered stages. There
are no prescribed section names. The protocol gives the inline guidance. Saved plans use the full writing guide.

Show the concrete use and result before explaining the implementation. For changed configuration, commands, APIs,
or output, include representative examples of the affected interfaces and explain their consequences. Carry useful
examples and settled decisions from chat into the saved plan; it must be understandable without the conversation.
Resolve material design questions before asking for implementation approval. A scope checklist cannot substitute
for the proposal. These requirements apply to inline and saved plans without prescribing section names.

Use short sentences and focused bullets. Connect decisions to their reasons and preserve important requirements
without repeating them. See [writing examples](writing-examples.md) for
different ways to explain different tasks. Reusable examples must be fictional; information from another project
shared in conversation is not permission to publish it.

Present a required or requested plan and wait for approval. Once approved, continue within its boundary without
repeated prompts. Routine implementation-detail changes do not invalidate that approval; expanded scope, risk,
permissions, or external actions must be made explicit before proceeding. Side questions and nonblocking decisions
do not end approved work; continue the authorized steps that do not depend on their answers. Stop when the request
is fulfilled, without adding unrequested work.

## Saved plans

Display small, simple plans inline by default: bounded work with a clear approach, no unresolved material decisions,
and straightforward verification. Save substantial plans or plans explicitly requested as files. Multiple dependent
stages, consequential design choices, or migration and recovery steps call for a saved plan; file count alone does not
determine the format. Honor explicit inline-only requests. Both formats require approval before edits. The shared
[saved-plan support](../src/managed/.ai/workflows/sia/delivery/standard.md) owns naming, approval hashes, states, and
resume for the actual operation and workflow. Existing compact and valid legacy plans remain supported.

Clarification and resume do not approve a plan. Plans are conversation-isolated: read only exact authorized paths,
including across compaction. Filename inspection is allowed solely to allocate a new name. Never use a plan from a
similar task as inferred authority.

Saved work keeps its original approval while definitions are updated. Resolve the current effective definitions at
phase boundaries, report changes, and return to approval for material conflicts. New defaults cannot retroactively
authorize edits. Saved-plan Ship requires passing review and writes only completion metadata; retain the plan.
Progress reports and
text-only turn endings do not establish completion. Collect relevant background results and finish required checks.
An unavailable required check leaves a blocked requirement; report it rather than marking the plan complete.

## Forge mode

`Sia forge on` enables continuous follow-ups. Imperative requests, including `do:`, implement directly without a plan
or separate approval. Planning is opt-in through an explicit request, `plan:`, or `inline plan`; requested plans wait
for approval. Questions remain read-only, and pending plans cannot be silently approved or bypassed. Saved plans
can resume without turning Forge off; inline-only work cannot resume across sessions. Read-only requests run directly.

Operation names and aliases stay within Forge. Reserved directives and explicit unattended invocations keep their
normal routing. See [Forge support](../src/managed/.ai/workflows/sia/delivery/forge.md).

## Unattended work

Only `Sia unattended <operation> [request]` enables it. The original request and authorized external actions define
its limit; missing authority or credentials blocks work rather than inviting guesses. Ordinary unattended coding is
planless. Explicitly saved work records its mode and ceiling; a planning-only request stays pending. Bound retries to
three failed fix cycles and retry a blocker only after observable change. Custom workflows may narrow this authority.

## Review and workers

Review both the original request and any approved plan. Extra features can be wrong even when the plan proposed them.
Delivery always reviews the diff and uses the effective testing skill. Load the full code-review skill for concrete
risks that warrant deeper review, when the user requests deeper review, or when a CUSTOM override is selected.
For complex work, look for bounded, independent assignments that benefit from a different model or reasoning effort.
For example, during planning a higher-effort worker can assess a migration and its rollback while the coordinator
drafts the plan. The coordinator verifies the findings and presents one plan for approval. Continue directly if the
host cannot delegate with the chosen model or effort.

The [handoff support](../src/managed/.ai/workflows/sia/delivery/handoff.md) carries exact paths, permissions, evidence,
and approved scope. Existing fuller envelopes remain valid. Hosts apply model or effort selection at spawn time.
Telemetry is optional. Never claim isolation the host does not provide.

## Other operations

Investigation and standalone review are read-only. Investigation may save one pending plan only on explicit request.
Documentation writes the requested docs and nearest indexes. Creator operations use one definition workflow for shared
validation while defining their own schema. CUSTOM workflows keep their task rules and preserve the shared planning
boundary.
