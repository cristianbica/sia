# Forge

Forge keeps Sia ready for follow-up requests in this conversation. It uses the delivery workflow's ordinary coding
and requested-planning behavior, without saved task artifacts. It cannot resume in a new conversation.

The `Sia` prefix is optional while Forge is on. Exact operation names and aliases stay in Forge; reserved directives
and explicit `unattended` retain normal routing. Resolve terse follow-ups such as “next one” from clear active context.
Ask only if materially different interpretations remain, rather than restarting discovery by default.

Questions and read-only requests run directly. `do:` requests implementation; `plan:` or `inline plan` requests a plan
and approval before edits. Remove the selector before interpreting the task. Neither grants additional permissions.
Use the same evidence and coding criteria as delivery, not a separate size or eligibility classification.

Completion clears the current inline task and leaves Forge ready. Off, stop, reload, or a new conversation ends Forge.
Do not write Forge task state to `.ai/plans/` or offer `Sia resume` for an inline task. Turn Forge off and explicitly
request a saved plan if durable resumption is needed.
