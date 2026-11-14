# Forge

Forge keeps Sia ready for follow-up requests in this conversation. The `Sia` prefix is optional while Forge is on.
Exact operation names and aliases stay in Forge; reserved directives and explicit `unattended` retain normal routing.
Resolve terse follow-ups from clear active context; ask when materially different interpretations remain.

Imperative change requests authorize implementation within their scope without a plan or separate approval. This
includes ordinary prompts such as `do this`, `implement that`, and `change that`, operation names and aliases, and
`do:`. Strip the `do:` selector before interpreting its request. Inspect relevant evidence, resolve material
requirements, implement, review, and run suitable checks using the actual operation and workflow. Do not create a
plan or require approval merely because a change is substantial.
Enabling Forge alone authorizes no edits. Questions and read-only requests run directly without changing files;
questions about feasibility, alternatives, or earlier choices do not authorize implementation.

Planning is opt-in. An explicit planning request, including `plan:` or `inline plan`, requests a plan and waits for
approval before implementation. Remove the selector before interpreting the request. Small, simple requested plans
are inline by default; substantial requested plans or plans explicitly requested as files are saved. `inline plan`
explicitly selects an unsaved plan. Use the actual operation and workflow and shared plan support for requested plans.

Saved plans can be resumed without turning Forge off. Resume does not approve a pending plan, and an imperative
request does not silently approve or bypass an existing pending plan. Complete approved work without repeated
approval. Inline-only tasks cannot resume in a new conversation. A new change request implements directly unless
the user requests planning.

Forge does not grant broader scope, credentials, host permissions, or authorization for external actions. Honor
explicit project or CUSTOM requirements for additional gates. Completion clears the active task and leaves Forge
ready. Off, stop, reload, or a new conversation ends Forge; saved plans retain their status. Do not create extra
Forge session artifacts.
