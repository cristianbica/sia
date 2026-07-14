---
name: implement
description: Route a repository change to proportionate planning, implementation, validation, and delivery.
workflow: delivery
skills:
  - repository-discovery
  - testing
---

# Implement

Turn the user's request into the smallest complete repository change supported by evidence. Start with delivery route
triage: use the planless trivial path only for an obvious non-behavioral correction, lightweight only for a narrow
project-owned definition, documentation, or fully qualified internal source change, and standard for every other
product/source behavior, policy, public contract, broad scope, or uncertainty. Never classify by line count alone.

## Intake

- Restate the intended outcome, observable acceptance criteria, scope, and non-goals.
- Discover missing repository facts before committing to an approach.
- Surface assumptions that could materially change the implementation.
- Preserve existing work and current host permissions.
- Announce the selected execution route and the evidence supporting it. An explicit request for a full or thorough
  workflow selects standard delivery.

Use the delivery workflow. Trivial work is planless and exact-file scoped. Lightweight work uses a compact approved
plan, one bounded Build handoff, focused coordinator validation, and no mandatory independent review worker. Standard
work keeps the complete lifecycle. Do not edit product/source before approval. During Build, stay in scope, update
relevant tests and docs, and promote immediately when any lightweight condition ceases to be evidenced.

## Outcome

Finish with implemented behavior, proportionate verification, and route-appropriate evidence. Standard delivery keeps a
separate final review phase; lightweight delivery reports focused validation and any explicit skips. Ship with a
product-read-only report containing the route, changed paths, deviations, validation evidence, model/usage telemetry
when available, and remaining risks.
