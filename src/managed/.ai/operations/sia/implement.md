---
name: implement
description: Plan, approve, build, separately review, validate, fix, and ship a repository change.
workflow: delivery
skills:
  - repository-discovery
  - testing
---

# Implement

Turn the user's requested behavior into the smallest complete repository change supported by evidence.

## Intake

- Restate the intended outcome, observable acceptance criteria, scope, and non-goals.
- Discover missing repository facts before committing to an approach.
- Surface assumptions that could materially change the implementation.
- Preserve existing work and current host permissions.

Use the delivery workflow. Do not edit product or source code before the exact plan revision is authorized through the
current execution mode. During Build, stay within scope, update relevant tests and repository documentation, and return
to Plan when a material assumption or required approach changes.

## Outcome

Finish with implemented behavior, proportionate verification, and a separate final review phase. Prefer an isolated
reviewer when the host can provide one; otherwise report the same-context fallback truthfully. Ship with a
product-read-only report containing changed paths, deviations, validation evidence, and remaining risks.
