---
name: create-operation
description: Create a project-owned operation and register its intent, workflow, skills, and aliases in CUSTOM.
workflow: definition
skills: []
---

# Create operation

Create one project operation using the definition workflow. Establish the user request it handles and select one
existing workflow plus only the skills it needs. Keep lifecycle instructions in that workflow.

Write `.ai/operations/<name>.md` with `name`, `description`, `workflow`, and `skills` frontmatter. Register the name in
CUSTOM. Optional aliases belong only in one nested `aliases:` line immediately after its index entry; validate them
against every effective name/alias and the protocol's reserved list. An override replaces, rather than inherits,
shipped aliases. Explain the effective invocation in the result.
