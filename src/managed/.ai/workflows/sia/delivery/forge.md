# Forge delivery guidance

Supporting guidance for the effective delivery workflow; not a separately invokable workflow.

## Forge delivery

Use these paths for unqualified requests or a later valid `Sia …` request while Forge is enabled and no operation is
active. Discard the optional `Sia` prefix before classifying the request. Exact operation names and aliases stay in
Forge; reserved directives and `unattended` use normal resolution instead.

Treat terse follow-ups as commands over active Forge context. Resolve `done`, `next one`, `same`, item numbers,
pronouns, and equivalent shorthand from recent conversation state, loaded content, and the current task when one clear
referent exists. Reuse established findings, decisions, ordering, and verified evidence; do not reopen files or repeat
searches by default. Treat a user-stated completion or transition as current context unless a small relevant check
contradicts it. When multiple material interpretations remain, ask one focused clarification without speculative
discovery.

Questions and non-mutating local requests run immediately without operation resolution, an inline plan, or approval.
This includes reads, searches, listings, diffs, status and history, inspection, review, and safe local diagnostics whose
purpose is evidence rather than an intended durable repository or external-state change. Load only relevant context,
perform the work, report the result, and leave Forge ready for the next request.

Safe diagnostics may create ordinary transient temporary or cache output, but a command known to rewrite durable
repository state is a change. If an immediate diagnostic unexpectedly changes durable state, stop and report the exact
change without silently retaining, reverting, or cleaning it.

Classify a requested change by authorization clarity and boundary predictability, not size. `do:` explicitly requests
direct execution; `plan:` and `inline plan` explicitly request the approval path. Strip a selector before resolving the
request. A selector expresses cadence only and never overrides permissions, safety, or lane eligibility.

A change qualifies for direct execution only when the request is a precise imperative with one clear target and
result, the effect is local and reversible, and discovery is unlikely to expand its boundary. It must have no material
ambiguity, external action, destructive effect, permission or security concern, migration, broad refactor, or
dirty-worktree attribution risk. Active context may supply the target and result. Examples include `mark #4 done`,
`change X to Y`, and a contextually specific `add this assertion`; `do:` makes the preference explicit but cannot make
an ineligible request direct.

Before a Forge write, state its lane and authorization basis: the qualifying request or the approved inline plan.
The request itself authorizes a qualifying bounded write. Execute only its stated boundary without an inline plan or a
second approval, apply proportionate review and checks, report changed paths and validation, and leave Forge ready for
the next request. If discovery reveals material ambiguity, risk, or expansion, stop before acting beyond the bounded
request and present an inline plan; report any already completed in-bound work accurately.

A vague or outcome-oriented request such as `handle #5`, every request selected by `plan:` or `inline plan`, and every
ineligible direct request uses the approval path. Resolve one fitting effective operation under the normal confidence
and catalog rules, then load its rules, workflow, skills, and material documentation. If the outcome itself is
ambiguous, ask one focused clarification without planning or acting. Do not use normal trivial, lightweight, or
standard artifact handling.

An explicit request for an `inline plan` or equivalent is an output and cadence instruction, not approval. Reuse loaded
context and perform only the minimum safety-critical discovery needed to state outcome, scope, non-goals, acceptance,
checks, risks, and external actions. Stop discovery as soon as that envelope is safe. Defer deeper seam, caller,
analogue, and regression-detail discovery until after approval unless it could materially change the envelope. Present
the plan directly and ask for approval without routine command narration, repeated evidence, or a discovery transcript.

For the approval path, present a concise inline intent envelope with outcome, scope, non-goals, acceptance criteria,
checks, risks, and external actions. Ask for explicit approval before the change or external action. Approval binds
only that visible task; when its outcome, scope, non-goals, criteria, risk, permissions, or external actions change,
show a revised inline plan and ask again. Never write Forge state to `.ai/plans/**`, add a digest or status comment, or
offer `Sia resume`.

After approval, implement only the inline envelope. Preserve pre-existing work and apply the normal permission,
external-action, security, and dirty-worktree gates. Use proportionate Build, Review/Validate, and bounded Fix cycles;
load the effective testing and code-review skills when material. Task size and risk scale plan detail, isolation,
review depth, and validation, but never promote Forge work to a persisted artifact solely because it is large.

Report checks, findings, fixes, skips, and residual risk. Completion clears the inline task and leaves Forge ready for
the next request. A new conversation loses the task; use an explicit operation when resumability is desired. Genuine
scope, permission, credential, external-action, safety, attribution, or validation blockers still stop the task.

Before an authorized write, load the shared execution guidance linked by the effective delivery workflow.
Its plan status/progress instructions apply only to standard delivery, never Forge.
