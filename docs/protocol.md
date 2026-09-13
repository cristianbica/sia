# Activation protocol

The installed `.ai/sia.md` is canonical for the agent; [source](../src/managed/.ai/sia.md) is canonical for development.
The root bridge is inert until the user's first non-whitespace token is exactly `Sia`, followed by whitespace or end.
Wrong casing, `Sia:`, and incidental mentions do not activate it. Require the exact protocol header and a nonempty body;
missing, unreadable, or malformed installations fail without reconstructing instructions from other files.

The protocol defines directive grammar, operation/alias resolution, CUSTOM precedence, and active conversation state.
Read its current definitions rather than maintaining a second exhaustive grammar here. Help reads only operation and
skill indexes; docs/skills loading exposes routes without starting work. Side questions do not cancel an active task.
Stop and reload end orchestration; a new chat has no inferred prior activation.

Normal implementation proceeds within the request. Explicit planning and existing saved approvals retain their gates.
Optional saved-plan and worker formats are loaded only when used. Exact plan-content authorization applies in all
modes, including searches and Git history. Host and explicit user instructions take priority over Sia guidance.

The eight live smoke prompts check activation, help, context loading, reload, and exact-plan isolation. They are
separate from the offline verifier; see [host testing](../tests/hosts/README.md). Plain text instructions are not a
runtime permission boundary, and passing string checks is not evidence of model compliance.
