---
name: definition
description: Safely create or reconcile project definitions and their CUSTOM catalog registrations.
---

# Definition workflow

Use this lightweight workflow for project skills, operations, workflows, and catalog reconciliation. It normally
finishes in one context and never edits shipped definitions or managed SIA catalog blocks.

## Inspect

- Purpose: establish the requested definition kind, intended behavior, target name, current catalog state, and
  effective references.
- Model profile: request `reasoning` for schema or lifecycle design; use `fast` only for mechanical catalog inspection.
- Reads: project rules, the selected operation, this workflow, relevant category indexes, referenced definitions, and
  the exact project paths needed for collision checks.
- Writes: none.
- Transition: Draft when intent and ownership are clear; stop with exact conflicts otherwise.

Resolve project-over-Sia behavior before drafting. A planned same-name override, destructive reconciliation, rename,
or ambiguous repair requires exact authorization before Write. In unattended mode, proceed only when the activating
request already names that action; otherwise return `blocked` rather than asking or inferring consent.

## Draft

- Purpose: prepare the complete definition and exact CUSTOM edit as one candidate change.
- Inputs: validated name, requested behavior, schema contract, resolved references, existing descriptions, and override
  status.
- Writes: none outside temporary host-managed scratch space; do not stage candidates under `.ai/**`.
- Transition: Validate with the complete candidate.

Keep the candidate concise and preserve unrelated CUSTOM text exactly. Do not copy operation lifecycle into skills or
workflow detail into operations.

## Validate

- Purpose: reject invalid candidates before repository writes.
- Checks: normalized and reserved names, case-folded collisions, path/frontmatter agreement, required fields, aliases,
  effective workflow and skill references, lifecycle boundaries, permissions, marker structure, and override behavior.
- Writes: none.
- Transition: Write when all checks pass and required authorization exists; otherwise return to Draft or stop.

## Write

- Purpose: commit the project definition and CUSTOM registration as one logical change.
- Allowed writes: the exact direct project definition path, justified sibling skill resources, and only the relevant
  lines inside the category's CUSTOM section.
- Forbidden writes: any path below a category's `sia/` directory, any SIA marker or block, `.ai/sia.md`, repository
  docs, plans, product source, or unrelated catalog text.
- Transition: Verify after both sides are written.

Preflight all destinations immediately before writing. Prefer one bounded edit batch. If a later write or verification
fails, repair or revert only changes made by this operation; never discard pre-existing project work.

## Verify

- Purpose: prove the resulting definition and catalog resolve consistently.
- Checks: reread changed files, rerun schema and collision checks, resolve effective references, confirm exactly one
  CUSTOM registration, confirm SIA content is unchanged, and inspect the complete diff.
- Writes: only a targeted repair of this operation's own incomplete change.
- Output: changed paths, validation evidence, override status, preserved text, and any partial or unresolved state.

Cancellation before Write changes nothing. Cancellation or failure after a partial Write reports the exact state and
must not claim the definition is usable until both the file and CUSTOM entry validate.
