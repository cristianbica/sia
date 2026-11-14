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

Outside Forge, all change requests present an inline or saved plan and wait for approval before edits.
Small, simple plans are inline by default; substantial plans and plans explicitly requested as files are saved. Named
operations, aliases, inferred requests, and non-code changes share this rule, including CUSTOM workflows. In Forge,
imperative change requests implement directly without a plan or separate approval; planning is opt-in. Explicit
planning requests retain approval, questions stay read-only, and pending plans cannot be silently bypassed.
Explicit user exceptions retain their scope; read-only requests and session directives need no plan. Existing
pending approvals remain binding.
Saved-plan and worker support load only when needed. Exact plan-content authorization applies in all modes.

Outside Forge, `Sia implement ...`, `Sia fix ...`, and their aliases start discovery and planning. For example,
`Sia implement the above` after an investigation uses its recommendations to prepare the delivery plan. Present the
finalized plan and
wait for a subsequent user approval before implementation; the invocation cannot approve a plan finalized afterward.
An approval reply in the active delivery task proceeds with the presented plan without restarting planning.

The eight live smoke prompts check activation, help, context loading, reload, and exact-plan isolation. They are
separate from the offline verifier; see [host testing](../tests/hosts/README.md). Plain text instructions are not a
runtime permission boundary, and passing string checks is not evidence of model compliance.
