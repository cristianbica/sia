---
name: delivery
description: Deliver authorized changes through proportionate planning, review, validation, and completion.
---

# Delivery workflow

First select the route below. Standard follows Plan → Approve → Build → Review/Validate → Fix → Review/Validate → Ship;
lightweight follows direct authorization → Build → focused Review/Validate → Ship; trivial work is planless.
Forge follows its direct or approved inline lane. Keep the protocol's authority and permission rules in every route.

## Engineering decisions

Ground the approach in the existing behavior, affected callers, and relevant repository patterns. Prefer extending
an existing mechanism when it meets the request. Each added feature, abstraction, dependency, option, or fallback
must serve an explicit requirement or a demonstrated necessity for the requested behavior; otherwise omit it.
For consequential choices, explain why the simpler existing approach is insufficient. Do not invent alternatives
for obvious edits or expand discovery beyond what could change the decision. Apply these criteria during planning
as well as implementation; approval of a broad outcome does not justify unrelated capabilities.

## Load only the current route and phase

Read only the matching row's supporting documents. Paths are relative to this workflow file. Reuse already-loaded
unchanged guidance; do not read other rows, supporting siblings, or future phases just to complete a context bundle.
For standard resume, validate the artifact with standard guidance, then use its status to select the next phase.

| Route/phase | Required supporting documents |
| --- | --- |
| trivial | none |
| lightweight | [execution](delivery/execution.md) |
| standard-plan | [standard](delivery/standard.md) |
| standard-execute | [execution](delivery/execution.md) |
| standard-resume | [standard](delivery/standard.md) |
| forge-intake | [forge](delivery/forge.md) |
| forge-execute | [forge](delivery/forge.md), [execution](delivery/execution.md) |

`standard-plan` covers Plan and Approve; `standard-execute` covers Build, Review/Validate, Fix, and Ship after approval.
`forge-intake` covers read-only work, direct-write eligibility, and inline planning/approval; `forge-execute` starts
only after the selected lane authorizes writes. After resume validation, pending approval stays in `standard-plan`;
later statuses load `standard-execute` only when their approval is valid. Complete/cancelled artifacts stay refused.

These documents belong to this shipped workflow. A CUSTOM workflow owns its own supporting references; never append
shipped guidance to an override automatically. Put exact selected support paths in `definition_paths.support` for a
worker, alongside the effective workflow. Missing required support is a handoff error, not permission to scan siblings.
Supporting files are not catalog entries or standalone workflows.

## Route triage

Announce `trivial`, `lightweight`, or `standard` and the evidence before writes. State the authorization basis too:
the qualifying request for trivial/lightweight, the request for standard Plan, user approval of the presented plan
for interactive standard Build, or the explicit unattended request. A plan write is not permission for source writes.

- `trivial`: an obvious requested typo, formatting, comment, or wording correction with no behavior, policy, permission,
  schema, command, or public-contract change. It needs no artifact or approval. Doubt promotes it.
- `lightweight`: one narrow project documentation/definition change, or one internal source change with an evidenced
  seam, exact paths, clear criteria, and focused test. No public, migration, configuration, permission, security,
  concurrency, external, compatibility, multi-consumer, broad-refactor, managed-Sia, lifecycle, dirty, or unresolved
  risk. The activating request directly authorizes a compact receipt, one Build handoff, focused validation, and no
  independent review worker.
- `standard`: every change not fully qualifying for lightweight, including operations/workflows, public contracts,
  migrations, security, destructive or external work, broad scope, dirty attribution risk, or uncertainty.

Size is supporting evidence, never proof. `full` or `thorough` selects standard. Unattended mode selects trivial or
lightweight only when eligibility is unambiguous; otherwise select standard or return `blocked`. Promote before a new
risk is acted on. For trivial work, report the diff, check, skips, and route.
When waiting, use one longest-safe wait; never poll without new evidence.

Before Build, every lightweight delivery shows an inline compact receipt with its outcome, exact paths or bounded area,
acceptance checks, documentation impact, and external actions. The activating request remains its authorization: the
receipt does not ask for another approval. It does not write `.ai/plans/` or become a `Sia resume` target.
A correction that changes scope or any material risk promotes the work to standard delivery and its persisted approval
plan.
