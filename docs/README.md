# Sia design and implementation specification

This directory is the canonical product, protocol, and implementation specification for Sia. The root
[README](../README.md) is the concise repository entrypoint.

## Reading order

| Document | Purpose |
| --- | --- |
| [Product and principles](product.md) | Product promise, goals, boundaries, and three-layer model |
| [Activation protocol](protocol.md) | Exact opt-in grammar and canonical `.ai/sia.md` behavior |
| [Repository knowledge](repository-knowledge.md) | Documentation structure, evidence, freshness, and maintenance |
| [Extensions and catalogs](extensions.md) | Skills, operations, workflows, indexes, overrides, and creators |
| [Orchestration and workflows](orchestration.md) | Isolation, artifacts, phase contracts, and core workflows |
| [Tool integration and installation](integration.md) | Installed layout, entrypoint bridges, ownership, and upgrades |
| [Source repository layout](source-layout.md) | Source tree, payload classes, fixtures, and ownership mapping |
| [Host validation matrix](host-matrix.md) | Probed versions, harness guarantees, and live semantic status |
| [Implementation and acceptance](implementation.md) | Delivery stages, fixtures, success criteria, and limits |

## Non-negotiable product decisions

- Sia is prompt-based and has no runtime, database, MCP server, or plugin requirement.
- Sia is inactive until the first non-whitespace token is exactly `Sia`. That prefix is an explicit activation attempt;
  `.ai/sia.md` then resolves or rejects the remainder.
- Every recognized Sia invocation loads `.ai/sia.md` before any catalog, definition, or repository document.
- `Sia load docs` and `Sia load skills` augment the host's normal workflow without activating Sia orchestration.
- `Sia reload` rereads the current protocol without restarting the host, stops active Sia orchestration, and preserves
  persisted plans.
- Exact operation names always win; clear free-form action requests may infer one operation, while ambiguous or advisory
  requests stay read-only direct Sia conversations.
- Full operations and resume load project-owned `.ai/RULES.md`; partial docs/skills loading does not.
- `Sia unattended <operation> [request]` pre-authorizes in-scope Sia workflow gates without weakening permissions or
  safety boundaries.
- Operation aliases are resolved only after the explicit `Sia` prefix and never act as always-on trigger keywords.
- Cataloged project definitions directly under a category override same-named definitions under its reserved `sia/`
  directory.
- Operations express user intent; workflows own phases and gates; skills provide reusable expertise.
- Delivery crossing a conversation boundary uses its persisted approved plan. Native workers receive a bounded handoff
  envelope appropriate to their phase.
- `Sia implement` chooses a conservative trivial, lightweight, or standard delivery route; uncertain work promotes to
  standard. Standard delivery is Plan → Approve → Build → Review/Validate → Fix → Ship.
- Documentation changes happen before final review. Ship changes only plan completion state by default and offers
  explicit interactive cleanup of the exact completed plan; unattended runs retain it.
- Sia upgrades never overwrite project documentation, plans, custom catalog sections, or project definitions.

## Design test

Any proposed feature should answer all three questions:

1. Does it improve repository understanding, reusable expertise, or delivery discipline?
2. Can the same semantic behavior work across supported hosts without a Sia runtime?
3. Can a user choose not to activate it?

If not, it is outside Sia's core design.
