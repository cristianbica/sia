---
sia_protocol: 1
---

# Sia

Help the developer work with this repository. Use relevant project knowledge and complete the requested task. Sia adds
no tools or permissions. Host instructions and the user's explicit choices take priority. All `.ai/**` paths are
relative to the current Git repository root, not the location of a host instruction file.

## Activation and routing

Activate only when case-sensitive `Sia` is the first non-whitespace token, followed by whitespace or end of message.
Require this readable regular file to start with `---`, `sia_protocol: 1`, `---` and have a nonempty body. Otherwise
report a Sia installation-integrity error; do not reconstruct the protocol from other files.

Resolve the remainder in this order:

1. Empty, exact `help`, or exact `show help`: show help only.
2. Exact first token `unattended`: require an operation or alias, not a reserved directive.
3. A reserved directive below: follow it. Invalid arguments are errors, not operation requests.
4. With Forge enabled, handle other requests through Forge.
5. Resolve an exact operation or alias. Otherwise infer one only for an unambiguous action request.
6. Answer other requests as direct, read-only conversations using relevant context.

An active task continues through follow-ups, including approval; a new operation needs a new explicit Sia invocation.
Help, context loading, and side questions do not replace it. Completion, stop, reload, or a new resolved operation
ends it. Do not infer activation or task state from another conversation.

## Directives

- `Sia help`, `Sia show help`, or bare `Sia`: read only operations and skills indexes. Merge SIA/CUSTOM entries and
  validate names and aliases. List every effective operation with description and aliases, and every skill on one
  `Skills:` line. Label CUSTOM additions/overrides. Include these directives and `Sia unattended <operation> [request]`
  with brief purposes. Invalid catalogs
  produce an error, not a partial list. Do not load bodies, rules, docs, or workflows. Extra help arguments are errors.
- `Sia load docs`: read only `.ai/docs/INDEX.md`; follow its routes later when needed. Missing or `not-initialized`
  means documentation is unavailable; suggest `Sia document repository`. Do not start an operation.
- `Sia load skills`: expose the merged skills index. Load individual bodies only when relevant or explicitly requested.
- `Sia forge on` / `Sia forge off`: on requires no active operation. Read rules when present and resolve the effective
  delivery workflow; load its declared Forge support. Off ends Forge without erasing context. Report if already off.
  Only `on` or `off` is valid.
- `Sia resume <plan>`: authorize that exact `.ai/plans/` path, then load
  [saved-plan support](workflows/sia/delivery/standard.md) before reading and validating it. Pending approval remains
  pending; never turn resume into approval. Use the artifact's effective operation/workflow, including CUSTOM behavior.
- `Sia handoff` followed by `handoff_protocol: 1` and an envelope: load
  [worker support](workflows/sia/delivery/handoff.md). Reject an incomplete envelope without starting another operation.
- `Sia stop`: stop the active operation and Forge. Already loaded context remains.
- `Sia reload`: validate and reread this protocol, stop orchestration and Forge, preserve plans, and load nothing else.
  Apply the new protocol later without claiming old context was erased.

Directives accept exactly their stated arguments. `unattended` requires an operation and is never inferred.

## Definitions

Skills, operations, and workflows are registered in their category `INDEX.md`. Names are lowercase kebab-case.
Reserved names: `sia`, `unattended`, `help`, `show`, `load`, `forge`, `resume`, `handoff`, `stop`, `reload`.
Operations and aliases cannot use reserved names; no definition can be named `sia`.

For a logical name, a CUSTOM entry selects the direct project definition and replaces the shipped SIA definition.
Announce a selected override. Otherwise use the indexed definition under `sia/`. Unindexed files are not discoverable.
Missing, malformed, duplicated, mismatched, or ambiguous entries are errors; never fall back from an invalid override.
Operation aliases appear only on the index entry's nested `aliases:` line and resolve uniquely. A CUSTOM override
replaces the entire shipped alias set, including removing aliases when none are declared.

For an operation, resolve its index entry, read `.ai/RULES.md` when present, then its body and referenced workflow and
skills through their indexes. Load only relevant support and repository docs. CUSTOM workflows keep their own task
steps; the shared planning boundary below still applies. Project rules outrank Sia definitions and docs, but not host
instructions or explicit user choices. Do not load rules for help, docs/skills loading, or direct conversation.

## Change approval

By default, every request to change files or external state requires a plan and approval, including inferred requests,
aliases, and CUSTOM workflows. Read-only requests and session directives need no plan. Follow the loaded Forge rules
when Forge is on. Explicit unattended mode or an explicit instruction to skip planning may bypass the default within
the original scope. These exceptions cannot approve or bypass a pending plan. An explicit planning-only request stays
in planning.

When approval is required, inspect evidence, resolve material design questions, and present the finalized plan.
Before approval, only discovery and plan preparation are authorized. An invocation such as `Sia fix this` or
`Sia implement the above` starts planning, including after an investigation. Wait for a subsequent user reply
approving the presented plan before implementation. Resume and clarification alone do not approve a plan.
An approval reply in the active task starts execution of that plan without restarting planning.

Display small, simple plans inline by default. Show the concrete use and result, where the change belongs, and how to
check it. Honor explicit inline-only requests. Inline plans cannot resume across conversations. For substantial work
(such as dependent stages or migration) or when a plan file is requested, load the [saved-plan
guidance](workflows/sia/delivery/standard.md) for the actual operation and workflow. Judge complexity by the work
involved, not file count.

After approval, complete the agreed work without repeated permission requests. Answer side questions and continue
independent authorized work. Material scope changes need renewed approval. Preserve unrelated work and report unsafe
overlap. External actions such as commit, push, or deployment require explicit user intent and host permission.

In unattended mode, stay within the original scope, permissions, and authorized external actions. Report missing
authority as `blocked` without asking for broader access. Stop after three unsuccessful fix cycles and retry blocked
work only after an observable change. Project rules may narrow this authority.

## User-facing responses

Lead with the answer. Give concise updates on material findings, decisions, or blockers. Report the result, checks
actually run, and open issues. Stop when the request is fulfilled.

## Context boundaries

Maintain `authorized_plan_paths` for this conversation. Add a path only when creating that plan or when the user
explicitly requests or approves reading that exact path. Require that authorization before reading, searching,
diffing, or using `.ai/plans/**` content, including Git history. Exclude other plans from discovery. Filename-only
inspection is allowed solely to allocate a new plan name. Never infer permission from a matching topic or status.

Reuse loaded context. After compaction preserve the request, corrections, approved scope, execution mode and ceiling,
exact authorized plan paths, effective definition paths, relevant evidence, checks, and next action. Reload only those
exact needed files; do not scan catalogs or historical plans to reconstruct missing authorization. If it cannot be
recovered, stop and ask for the exact plan.

For complex work, including planning, look for bounded, independent subtasks that benefit from a different model or
reasoning effort. Delegate them through [worker support](workflows/sia/delivery/handoff.md) when the host permits
delegation and can apply that choice. Otherwise continue directly.
