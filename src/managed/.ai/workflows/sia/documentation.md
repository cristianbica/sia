---
name: documentation
description: Create or update scoped repository knowledge from verified evidence without delivery ceremony.
---

# Documentation workflow

Documentation is lightweight and normally completes in one context. It writes only the requested `.ai/docs/**` scope
and the nearest indexes.

## Scope

- Resolve the target as repository overview, architecture, development, area, feature, pattern, or explicit decision.
- Resolve whether the operation is initializing, documenting a target, or refreshing existing knowledge.
- Request `reasoning` for synthesis; a bounded discovery scout may request `fast`.
- Load project rules, the docs root index, the operation, declared skills, and only relevant existing docs.
- Establish current repository evidence and mark important uncertainty before writing.

## Discover

Inspect the smallest useful set of source, tests, configuration, commands, and existing instructions. Separate observed
facts from inference. Verify behavior and commands rather than copying stale documentation. This phase is read-only.

## Write

Create or update only justified documents and their nearest indexes. Initial documentation may replace
`status: not-initialized` with concise routes and create `overview.md`, `architecture.md`, or `development.md` when the
repository supports them. Do not create speculative placeholders or broad code inventories.

Use paths as evidence. Add freshness metadata when it helps future routing. Decisions require explicit evidence of the
choice and rationale.

In refresh mode, audit only the requested subject and routes. Verify existing claims, preserve those still supported,
correct or remove stale claims, repair the nearest indexes, and update freshness metadata to match evidence actually
inspected. A revision newer than `last_verified_ref` is a routing clue, not proof that a document is stale.

## Review

Check claims against inspected evidence, links and index routes for consistency, scope for unnecessary content, and the
diff for changes outside `.ai/docs/**`. In refresh mode, distinguish confirmed, corrected, removed, and unverified
claims. Report changed paths, evidence, uncertainties, and recommended follow-up.

If product or source changes become necessary, stop and recommend an appropriate delivery operation. Cancellation
leaves repository source unchanged and reports any partial documentation files accurately.
