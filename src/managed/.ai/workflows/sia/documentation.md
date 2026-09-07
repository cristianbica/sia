---
name: documentation
description: Create or update scoped repository knowledge from verified evidence without delivery ceremony.
---

# Documentation workflow

Documentation normally completes in one context. It writes only the requested `.ai/docs/**` scope and the nearest
indexes. The operation defines intake; the effective documentation skill defines knowledge format, evidence,
freshness, and quality checks. This workflow controls phases and permissions.

## Scope

- Use the operation's target and mode: initial documentation, a narrow subject, or refresh.
- Request `reasoning` for synthesis; a bounded discovery scout may request `fast`.
- Load project rules, the docs root index, the operation, declared skills, and only relevant existing docs.
- Establish current repository evidence and mark important uncertainty before writing.

## Discover

Use the effective repository-discovery and documentation skills to establish evidence for the target. This phase is
read-only.

## Write

Apply the documentation skill within the selected scope, updating each target and its nearest index together.
Initial documentation may replace `status: not-initialized` with verified routes. Refresh changes only the selected
subject and routes. Do not edit product, source, plans, or external state.

## Review

Apply the skill's quality checks and inspect the diff for changes outside `.ai/docs/**`. Report changed paths,
meaningful evidence, uncertainty, and required follow-up; in refresh mode report the status of inspected claims.

If product or source changes become necessary, stop and recommend an appropriate delivery operation. Cancellation
leaves repository source unchanged and reports any partial documentation files accurately.
