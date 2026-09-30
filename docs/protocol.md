# Activation protocol

The installed `.ai/sia.md` is canonical for the agent; [source](../src/managed/.ai/sia.md) is canonical for development.
The global bridge is inert until the user's first non-whitespace token is exactly `Sia`,
followed by whitespace or end.
Wrong casing, `Sia:`, and incidental mentions do not activate it. Require the exact protocol header and a nonempty body;
missing, unreadable, or malformed installations fail without reconstructing instructions from other files.

The protocol defines directive grammar, operation/alias resolution, CUSTOM precedence, and active conversation state.
Read its current definitions rather than maintaining a second exhaustive grammar here. Help reads only operation and
skill indexes; docs/skills loading exposes routes without starting work. Side questions do not cancel an active task.
Stop and reload end orchestration; a new chat has no inferred prior activation.

All change requests create a saved plan and wait for approval before edits. Named operations, aliases, inferred
requests, non-code changes, and Forge share this rule, including CUSTOM workflows. Explicit user exceptions retain
their scope; read-only requests and session directives need no plan. Existing pending approvals remain binding.
Saved-plan and worker support load only when needed. Exact plan-content authorization applies in all modes.

The eight live smoke prompts check activation, help, context loading, reload, and exact-plan isolation. They are
separate from the offline verifier; see [host testing](../tests/hosts/README.md). Plain text instructions are not a
runtime permission boundary, and passing string checks is not evidence of model compliance.
