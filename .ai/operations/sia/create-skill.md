---
name: create-skill
description: Create a project-owned reusable skill and register it in the CUSTOM skills catalog.
workflow: definition
skills: []
---

# Create skill

Create one focused project skill using the definition workflow. Establish concrete requests it should help with.
Prefer a concise `SKILL.md`; add supporting files only for useful conditional detail, not placeholder documentation.
Keep descriptions short and identify concrete triggering tasks rather than broad topic matches. For multiple
workflows, keep shared guidance and routing in `SKILL.md` and move substantial conditional procedures into supporting
files linked with when-to-read guidance.

Write `.ai/skills/<name>/SKILL.md` with `name`, `description`, and optional `use_when` frontmatter. Keep reusable
expertise here, not workflow phases, approvals, or activation behavior. Register it once in the CUSTOM skills index.
This is a Sia prompt package, not a host plugin or native agent configuration.
