# Repository knowledge

Repository documentation is concise AI-facing knowledge maintained from current evidence. It should reduce repeated
discovery without becoming a second source tree or a replacement for verification.

## Mature structure

```text
.ai/docs/
  INDEX.md
  overview.md
  architecture.md
  development.md

  areas/
    INDEX.md
    <area>.md

  features/
    INDEX.md
    <feature>.md

  patterns/
    INDEX.md
    <pattern>.md

  decisions/
    INDEX.md
    <decision>.md
```

This is a vocabulary, not a mandatory set of placeholders. On install, only a minimal `.ai/docs/INDEX.md` with
`status: not-initialized` is created. Documenting operations create root documents, directories, and child indexes only
when repository evidence justifies them. The optional `decisions/` directory starts with the first verified decision.

## Root documents

### `overview.md`

- repository purpose and technology;
- domain concepts and terminology;
- major features and areas;
- important cross-cutting invariants;
- pointers to detailed documentation.

### `architecture.md`

- layers, boundaries, and dependency direction;
- important entrypoints and external systems;
- major execution and data flows;
- links to areas and accepted decisions.

### `development.md`

- verified setup, build, lint, test, and development commands;
- repository-specific conventions;
- testing organization and practices;
- important development and operational pitfalls.

Area-specific invariants and hazards belong in area or feature documents rather than growing the root documents.

## Detailed types

- **Areas** describe codebase responsibility and topology: locations, entrypoints, dependencies, invariants, tests, and
  hazards.
- **Features** describe verified current behavior: flows, rules, states, edge cases, and implementation entrypoints.
- **Patterns** describe recurring repository-specific implementation approaches, not generic framework advice or one
  class.
- **Decisions** record why an explicit durable choice was made and its status: proposed, accepted, superseded, or
  rejected.

Never infer historical rationale from code. Create a decision only from explicit user input, an authoritative existing
record, or a decision made during an approved workflow.

## Index contract

`.ai/docs/INDEX.md` is the root router. Each created child directory has a small `INDEX.md`. Entries contain a path,
one-line description, and when-to-load guidance; they do not duplicate document bodies.

A documenting operation treats the target document and its nearest index as one logical change, verifies both, and
reports any partial state accurately.

## Evidence and freshness

Use frontmatter where it adds useful routing or freshness information:

```yaml
---
summary: Billing responsibilities, flows, and invariants.
scope:
  - app/services/billing/**
sources:
  - app/services/billing/renew_subscription.rb
last_verified: 2026-07-12
last_verified_ref: 4d3f...
---
```

Rules:

- Separate observations, inference, and uncertainty.
- Link claims to repository paths rather than copying source.
- Record commands as verified only after inspecting successful results; otherwise label them unverified.
- Verify behavior-changing assumptions against current source even when the docs appear current.
- Treat `last_verified_ref` as a freshness clue, not proof that unrelated later commits invalidated the document.
- Avoid comprehensive class, function, route, schema, or dependency dumps.

## Documenting operations

The `document` operation handles initial repository documentation and target-scoped area, feature, pattern, or decision
work. `refresh-docs` performs targeted refresh, stale-claim audit, and index repair. Neither uses the full delivery gate
unless product/source changes become necessary.

During delivery, documentation impact is handled in Build or Fix before final review. Ship writes only plan completion
state by default, then may offer explicit interactive deletion of the exact completed plan; unattended runs retain it.
The final handed-off diff—including documentation—has been reviewed and validated.

Approved future work belongs in `.ai/plans/`, not `.ai/docs/`.
