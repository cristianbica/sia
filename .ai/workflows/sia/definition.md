---
name: definition
description: Safely create or reconcile project definitions and their CUSTOM catalog registrations.
---

# Project definitions

Use for creator operations and catalog reconciliation. The operation supplies the target schema and requested change;
this workflow owns shared validation and writes. Shipped `sia/` definitions and SIA blocks are not project edit targets.

Follow the protocol's shared saved-plan and approval boundary before writing definitions or catalog entries. Use
[shared plan support](delivery/standard.md) with this workflow and the actual operation. Perform the checks below
read-only to prepare the plan, then apply and validate approved changes.

Before writing, resolve the requested category and check its index and direct project paths:

- Names match `[a-z0-9]+(?:-[a-z0-9]+)*`, agree with path/frontmatter, and have no normalized or case-folded collision.
  No definition is named `sia`; operations and aliases also exclude the protocol's reserved names.
- The index has one valid CUSTOM section and one ordered managed marker pair. References resolve through effective
  catalogs; missing or ambiguous definitions are errors.
- Creation does not overwrite an existing or partially registered definition. Use reconciliation for partial state.
  Report a deliberate shipped override and require explicit authorization for that override, including unattended work.
- The candidate preserves host permissions and the selected workflow's user gates. It cannot activate itself or
  broaden unattended authority. Validate any declared phases, artifacts, and recovery rules before writing.

Write only the requested direct project definition, necessary support, and its CUSTOM entry. Preserve other entries,
order, comments, SIA blocks, and shipped content. Keep catalog entries within 120 characters. Recheck the written
schema, references, and effective override together; a definition and its registration form one logical change.
If writing fails partway, repair or revert only this operation's changes. Report actual changed paths and any partial
state; do not claim the definition works until both files validate. Cancellation before writes changes nothing.
