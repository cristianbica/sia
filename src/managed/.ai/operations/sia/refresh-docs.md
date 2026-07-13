---
name: refresh-docs
description: Audit and refresh targeted repository documentation against current evidence.
workflow: documentation
skills:
  - repository-discovery
  - documentation
---

# Refresh docs

Reverify existing repository knowledge, repair stale claims, and keep its routing indexes useful.

## Intake

- Resolve the requested document, subject, path scope, or stale-claim concern.
- Read the root router and follow only routes relevant to that target.
- Use freshness metadata as a clue, not as proof that a document is current or stale.

Use the documentation workflow in refresh mode. Compare claims and routes with current source, tests, configuration,
and verified commands. Correct unsupported or obsolete content, preserve still-valid knowledge, and update only the
target documents and nearest indexes. Do not perform a repository-wide rewrite unless the user explicitly requests and
scopes one.

## Outcome

Report refreshed and repaired paths, important claims confirmed or changed, evidence used, unresolved uncertainty, and
documentation that was deliberately left outside scope. Recommend a delivery operation if source changes are needed.
