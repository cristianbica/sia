---
name: reconcile-catalogs
description: Audit project definitions and CUSTOM entries, then make only targeted, explicitly safe catalog repairs.
workflow: definition
skills: []
---

# Reconcile catalogs

Reconcile one requested category or all of skills, operations, and workflows. Project definitions and CUSTOM entries
are in scope; shipped definitions and managed SIA blocks are read-only evidence.

## Audit

For each category:

1. Parse the index without rewriting it and verify unique, ordered SIA markers plus exactly one CUSTOM section.
2. Enumerate only direct project definitions: skill directories with `SKILL.md`, operation files, and workflow files.
3. Validate normalized names, path/frontmatter agreement, schemas, operation aliases, and logical references.
4. Classify each logical name as valid, unindexed, entry-without-definition, malformed, duplicate, collision, or valid
   custom override of a shipped definition.
5. Separate safe mechanical repairs from ambiguous or destructive choices.

Never treat supporting files inside a skill as separate definitions. Never infer project ownership for content under a
reserved `sia/` directory.

Treat the logical name `sia` as reserved in every category and as unavailable for operation aliases. It identifies the
shipped-definition directory, not a project definition.

In the operations category, also reject `unattended`, `load`, `resume`, `handoff`, and `stop` as definition names or
aliases because the activation protocol reserves them.

## Repair policy

First report a concise proposed repair set. Apply only the requested or explicitly accepted repairs.

Safe targeted repairs may add a missing CUSTOM section when ownership boundaries are clear, add a missing entry for one
valid unindexed project definition, repair an unambiguous path/frontmatter mismatch when the intended name is explicit,
or remove an exact duplicate entry without changing the surviving text. Use a new entry's validated frontmatter
description.

Require exact authorization before removing the only entry for a missing definition, renaming or moving a definition,
changing aliases or behavior, resolving case-folded collisions, or choosing between competing files. Interactive mode
may request it; unattended mode requires the activating request to name the action or returns `blocked`. Malformed
definitions must satisfy their creator contract before registration. When intent is unclear, leave it unchanged.

Preserve every valid CUSTOM description, alias line, comment, order, and surrounding byte not directly involved in an
approved repair. Never regenerate a whole index, edit any SIA marker or block, or write below a reserved `sia/`
directory. A malformed SIA block is an installation-integrity problem to report, not repair here.
Likewise, report SIA entries that do not match shipped definitions and recommend installation checking or update.

## Outcome

Preflight the full repair set, apply the smallest edits, then rerun the audit. If a multi-file repair partially fails,
repair or revert only this operation's writes and report the remaining state. Report changed paths, preserved
descriptions, effective overrides, unresolved conflicts, and exact follow-up actions.
