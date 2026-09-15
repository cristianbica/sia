---
name: documentation
description: Create and refresh concise repository knowledge that is routed, evidence-linked, and honest about age.
use_when:
  - initializing or updating repository documentation
  - a feature, area, pattern, or explicit decision needs durable context
  - checking potentially stale documentation for the area in the current task
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
- Create `decisions/` only from an authoritative record, explicit user input, or a decision made in an approved
  workflow; never infer historical intent from code.

Create a child directory and its `INDEX.md` only when evidence justifies the first document. Index entries contain a
path, one-line description, and when-to-load guidance rather than duplicating document content.

## Evidence and freshness

Use current source, tests, configuration, verified commands, and authoritative project records. Link claims to paths,
separate observation from inference, and state uncertainty. Useful frontmatter may record summary, scope, sources,
`last_verified`, and `last_verified_ref`; those fields guide later review but never prove current correctness.

During refresh, follow only relevant routes. Confirm still-valid claims, correct or remove stale claims, repair nearest
index routes, and update freshness metadata to match evidence actually inspected. Avoid broad rewrites that erase useful
project language or extend beyond the requested scope.

When current evidence invalidates a loaded claim, update that claim only if the current phase and authorized scope
permit it. Otherwise report the exact document, claim, and contradicting evidence for targeted refresh. Do not expand
into an automatic repository-wide documentation audit. A newer revision alone does not show that a claim is stale.

## Quality checks

- Prefer stable concepts, invariants, flows, and verified commands over symbol or dependency inventories.
- Keep detailed hazards with their feature or area instead of growing root documents indefinitely.
- Update the target document and nearest index together.
- Do not record a command as verified unless it ran successfully and its output was inspected.
- Do not put proposed future work in repository knowledge; resumable approved work belongs in `.ai/plans/`.

For review, distinguish confirmed, corrected, removed, and unverified claims; retain the evidence and uncertainty.
