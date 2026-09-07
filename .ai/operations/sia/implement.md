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
- Announce the selected execution route and authorization basis before the first write, including a plan write.
  An explicit request for a full or thorough workflow selects standard delivery.

Use the delivery workflow. Trivial work is planless and exact-file scoped. Lightweight work is directly authorized by
the request, uses a compact receipt, one bounded Build handoff, and focused coordinator validation. Standard work gets
one intent-envelope approval and keeps the complete lifecycle. Do not edit product/source before authorization. During
Build, stay in scope, update relevant tests/docs, and promote immediately when lightweight eligibility ends.

For interactive standard delivery, the implementation request authorizes discovery and a saved plan, not Build.
Present that plan and wait for its approval before product/source edits. Instructions to implement, work autonomously,
or avoid unnecessary questions do not approve an unseen plan. Continue within an already-approved plan without asking
again. Trivial, lightweight, Forge, and explicit unattended authorization still follow their own workflow rules.

## Outcome

Finish with implemented behavior, proportionate verification, and route-appropriate evidence. Standard delivery keeps a
separate final review phase; lightweight delivery reports focused validation and any explicit skips. Follow delivery's
Ship reporting guidance: lead with the result, meaningful checks, and unresolved issues. Preserve required internal
evidence without repeating routine details in the user-facing report.
