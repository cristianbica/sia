# Extensions and catalogs

Skills, operations, and workflows share the same ownership, naming, indexing, and override model.

## Storage

```text
.ai/
  skills/
    INDEX.md
    sia/<name>/SKILL.md
    <name>/SKILL.md

  operations/
    INDEX.md
    sia/<name>.md
    <name>.md

  workflows/
    INDEX.md
    sia/<name>.md
    <name>.md
```

The `sia/` directory is reserved for installer-managed definitions. Project definitions live directly under the
category.

## Logical names

- Names use normalized lowercase kebab-case: `[a-z0-9]+(?:-[a-z0-9]+)*`.
- The frontmatter `name` must equal the directory or file basename.
- Names are unqualified: consumers use `testing`, never `sia/testing`.
- Case-folding or normalized-name collisions are errors on every platform.
- The logical name `sia` is reserved for shipped-definition directories in every category.
- Operation names and aliases `load`, `resume`, `handoff`, `stop`, and `unattended` are reserved by the protocol and
  cannot be created or cataloged.

## Index contract

Each category index follows this form:

```markdown
# Skills

<!-- sia:skills:start -->
## SIA

- `testing` — Select and execute proportionate verification.
<!-- sia:skills:end -->

## CUSTOM

- `testing` — Repository-specific testing guidance; overrides Sia.
```

Use distinct managed marker IDs for skills, operations, and workflows. The installer replaces only the SIA block. It
never changes CUSTOM or project definitions.

Operation index aliases use an optional nested metadata line immediately after their entry:

```markdown
- `fix` — Diagnose and fix a defect with regression evidence.
  - aliases: `bug`, `fix-bug`
```

The literal `aliases:` key and comma-separated code spans are the machine-readable syntax; other nested text is not
alias metadata. Alias matching occurs only after the explicit `Sia` prefix. Aliases use the same normalized naming
rules, cannot use `sia` or reserved protocol names, and must resolve to exactly one effective operation. Creation and
reconciliation operations validate alias collisions.

If CUSTOM overrides an operation, alias metadata attached to that CUSTOM entry replaces the shipped aliases for the
same logical name. Aliases are not inherited or merged: only aliases declared by the effective CUSTOM entry remain
available, and declaring no aliases removes every shipped alias for that operation. This keeps the operation's custom
invocation surface deliberate and makes catalog inspection sufficient to explain resolution.

Indexes are the discovery registry; definition files are authoritative for behavior. An unindexed manual definition is
not invokable until reconciliation. Creation operations create the definition and CUSTOM entry as one logical change.

Project rules and definitions may narrow unattended execution or reject it for a task. They cannot activate it without
the exact user modifier, broaden its authorization ceiling, skip required review, or treat it as a host permission.

## Override resolution

The effective catalog is the union of logical names registered in SIA and CUSTOM. A project definition is eligible only
when its logical name is registered in CUSTOM; merely creating a same-named path does not shadow Sia.

For an effective catalog name:

1. If CUSTOM registers the name, resolve a valid project definition directly under the category.
2. Otherwise resolve the shipped definition under `sia/`.

A valid cataloged project definition shadows the shipped definition. Sia announces the override when it is selected. A
malformed, missing, duplicated, or mismatched custom definition is an error and never silently falls back to Sia. An
unindexed project definition is unavailable until a creation or reconciliation operation registers it in CUSTOM.

## Skill contract

A skill is a reusable prompt package whose main file is `SKILL.md`.

```yaml
---
name: testing
description: Select and execute proportionate verification.
use_when:
  - application behavior changes
---
```

The body defines required context, procedure, constraints, validation, and output. Supporting examples or references
live beside `SKILL.md` and load only when needed. Skills cannot activate operations or own lifecycle gates.

## Operation contract

An operation expresses user intent and selects exactly one primary workflow.

```yaml
---
name: fix
description: Diagnose and fix a defect with regression evidence.
workflow: delivery
skills:
  - bug-triage
  - testing
---
```

The body defines intake, operation-specific constraints, and expected outcome. The workflow owns phases and gates.
Operation trigger keywords are aliases in the operations index, not free-form rules or always-on semantic matching.

## Workflow contract

A workflow defines phases and transitions. Each phase specifies:

- name and purpose;
- gate, if any;
- isolation preference;
- optional advisory model profile, `fast` or `reasoning`;
- input and output artifact requirements;
- documentation and skills to resolve;
- allowed work and writes;
- success, failure, and replanning transitions.

The workflow body also defines completion criteria and cancellation behavior. The minimal schema should remain readable
Markdown rather than becoming a workflow language.

## Creation and reconciliation

Sia ships `create-skill`, `create-operation`, and `create-workflow`. Each validates the name and reserved-name rules,
reports override behavior, creates a project definition, updates CUSTOM, validates references, and reports changed
paths.

`reconcile-catalogs` compares CUSTOM entries with project definitions and proposes targeted additions, removals, or
repairs. It preserves valid custom descriptions and never rewrites SIA blocks.

## Shipped definitions

- Operations: `implement`, `fix`, `review`, `investigate`, `document`, `refresh-docs`, the three creators, and
  `reconcile-catalogs`.
- Workflows: `delivery`, `review`, `investigation`, `documentation`, and `definition`.
- Initial skills: `repository-discovery`, `testing`, `bug-triage`, `code-review`, `documentation`, and
  `safe-refactoring`.
