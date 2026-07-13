---
name: documentation
description: Create and refresh concise repository knowledge that is routed, evidence-linked, and honest about age.
use_when:
  - repository documentation is initialized
  - a feature, area, pattern, or explicit decision needs durable context
  - existing repository documentation may be stale
---

# Documentation

Repository documentation should reduce rediscovery without becoming a second source tree or an unverified authority.

## Structure and routing

- Use `.ai/docs/INDEX.md` as the root router.
- Keep verified repository purpose, domain, features, and invariants in `overview.md`.
- Keep layers, boundaries, entrypoints, external systems, and major flows in `architecture.md`.
- Keep verified setup, commands, conventions, testing practices, and pitfalls in `development.md`.
- Put detailed responsibility and topology in `areas/`, current behavior in `features/`, and recurring
  repository-specific approaches in `patterns/`.
- Create `decisions/` only for explicit, evidenced choices and rationale; never infer historical intent from code.

Create a child directory and its `INDEX.md` only when evidence justifies the first document. Index entries contain a
path, one-line description, and when-to-load guidance rather than duplicating document content.

## Evidence and freshness

Use current source, tests, configuration, verified commands, and authoritative project records. Link claims to paths,
separate observation from inference, and state uncertainty. Useful frontmatter may record summary, scope, sources,
`last_verified`, and `last_verified_ref`; those fields guide later review but never prove current correctness.

During refresh, follow only relevant routes. Confirm still-valid claims, correct or remove stale claims, repair nearest
index routes, and update freshness metadata to match evidence actually inspected. Avoid broad rewrites that erase useful
project language or extend beyond the requested scope.

## Quality checks

- Prefer stable concepts, invariants, flows, and verified commands over symbol or dependency inventories.
- Keep detailed hazards with their feature or area instead of growing root documents indefinitely.
- Update the target document and nearest index together.
- Do not record a command as verified unless it ran successfully and its output was inspected.
- Do not put proposed future work in repository knowledge; resumable approved work belongs in `.ai/plans/`.

Report changed routes, evidence, uncertainty, and any source changes required before the documentation can be accurate.
