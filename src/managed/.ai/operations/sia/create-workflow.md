---
name: create-workflow
description: Create a project-owned workflow with explicit phases, gates, transitions, and a CUSTOM catalog entry.
workflow: definition
skills: []
---

# Create workflow

Create one project workflow using the definition workflow. Write `.ai/workflows/<name>.md` with `name` and
`description` frontmatter, then register it in CUSTOM.

Describe the work, allowed changes, any user approval, completion checks, and failure/cancellation handling. Add phases,
artifacts, or delegation only when they serve this workflow. Remain usable without workers; do not create a workflow
language or copy the contents of selected skills. Resolve referenced definitions and preserve host permissions.
Unattended behavior may narrow the original request's authority but cannot activate or expand it.
