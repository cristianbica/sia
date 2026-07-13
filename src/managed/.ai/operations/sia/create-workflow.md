---
name: create-workflow
description: Create a project-owned workflow with explicit phases, gates, transitions, and a CUSTOM catalog entry.
workflow: definition
skills: []
---

# Create workflow

Create one readable Markdown workflow that coordinates phases for one or more operations. Do not turn it into a
workflow language or require host-native agents for correctness.

## Intake

- Establish the lifecycle, allowed work, user gates, artifacts, completion criteria, cancellation, and failure paths.
- Identify which phases benefit from fresh context and which referenced skills or repository docs are actually needed.
- Choose a short lowercase kebab-case name and a description that states the workflow's purpose.

## Preflight

Validate all of the following before writing:

- The name matches `[a-z0-9]+(?:-[a-z0-9]+)*`, is not `sia`, and matches the intended filename exactly.
- `.ai/workflows/<name>.md`, the CUSTOM entry, and every normalized or case-folded equivalent are absent.
- Every named skill or other logical definition reference resolves through its effective catalog.
- Every phase has a purpose, allowed reads and writes, required input and output, success and failure transitions, and
  a gate when user approval is required.
- Unattended execution may satisfy only in-scope Sia-owned gates; the workflow may narrow it but cannot activate it,
  broaden its authorization ceiling, or treat it as a host permission grant.
- Model requests, when useful, are only advisory `fast` or `reasoning`; fallback never changes gates or correctness.
- The workflow remains usable through persisted artifacts or bounded same-context execution when isolation is absent.
- A same-named shipped workflow is reported as a deliberate override. Require exact authorization: an interactive
  confirmation or an unattended activating request that explicitly asks for the override. Otherwise return `blocked`.
- `.ai/workflows/INDEX.md` has one valid CUSTOM section and an untouched, structurally valid SIA managed block.

If an unindexed definition or an entry without a definition already exists, stop and recommend `reconcile-catalogs`.

## Definition contract

Create `.ai/workflows/<name>.md` with `name` and `description` frontmatter. In readable Markdown, define phases,
transitions, gates, isolation preferences, artifact contracts, context and skill selection, allowed work, validation,
completion, failure recovery, and cancellation. Use exact `do_not_load` guidance when a bounded handoff is needed.

The workflow must preserve host permissions, keep external actions explicit, describe isolation truthfully, and avoid
duplicating referenced skills or operations. It must keep validation and review requirements in unattended mode.

## Catalog change and outcome

Add exactly one CUSTOM entry, kept within 120 characters, without sorting, regenerating, or rewording existing entries.
Never edit the SIA block or anything under `.ai/workflows/sia/`.

Treat the definition and CUSTOM entry as one logical change: preflight both, write both together, then reread and
validate the complete graph. On failure, repair or revert only writes made by this operation and report any partial
state. Report paths changed, references checked, and whether the workflow overrides a shipped definition.
