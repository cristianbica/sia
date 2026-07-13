---
name: create-operation
description: Create a project-owned operation and register its intent, workflow, skills, and aliases in CUSTOM.
workflow: definition
skills: []
---

# Create operation

Create one user-facing Sia operation that expresses intent and selects an existing workflow. Keep lifecycle phases and
gates in the workflow rather than duplicating them here.

## Intake

- Establish the operation's request shape, constraints, expected outcome, primary workflow, required skills, and
  optional aliases.
- Choose a short lowercase kebab-case name and a description that distinguishes this intent from existing operations.
- Resolve logical workflow and skill names through their effective catalogs before drafting.

## Preflight

Validate all of the following before writing:

- The name matches `[a-z0-9]+(?:-[a-z0-9]+)*`, is not `sia`, and is not reserved as `unattended`, `load`, `resume`,
  `handoff`, `stop`, or `reload`.
- `.ai/operations/<name>.md`, the CUSTOM entry, and every normalized or case-folded equivalent are absent.
- Exactly one primary workflow resolves to a valid effective definition.
- Every declared skill resolves to a valid effective definition; omit skills that the operation does not need.
- Each alias is normalized lowercase kebab-case, is not reserved, and collides with no effective operation name or
  alias.
- A same-named shipped operation is reported as a deliberate override. Require exact authorization: an interactive
  confirmation or an unattended activating request that explicitly asks for the override. Otherwise return `blocked`.
- `.ai/operations/INDEX.md` has one valid CUSTOM section and an untouched, structurally valid SIA managed block.

If an unindexed definition or an entry without a definition exists, stop and recommend `reconcile-catalogs`; do not
overwrite or silently complete an ambiguous state.

## Definition contract

Create `.ai/operations/<name>.md` with `name`, `description`, `workflow`, and a `skills` list in frontmatter. The body
defines intake, operation-specific constraints, and expected outcome. It must not duplicate workflow phases, bypass
workflow gates, activate itself or unattended mode, or widen host permissions.

Register aliases only in the operations index, using one optional nested line immediately after the operation entry:

```markdown
- `name` — Description.
  - aliases: `first-alias`, `second-alias`
```

## Catalog change and outcome

Add the operation and optional alias metadata to CUSTOM without sorting, regenerating, or rewording existing entries.
Keep each entry and alias metadata line within 120 characters. Never edit the SIA block or anything under
`.ai/operations/sia/`.

Treat the definition and CUSTOM entry as one logical change: preflight both, write both together, then reread and
validate names, schema, references, aliases, and effective override behavior. On failure, repair or revert only writes
made by this operation and report any partial state. Report changed paths and the effective operation resolution.
