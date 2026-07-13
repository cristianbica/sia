---
name: create-skill
description: Create a project-owned reusable skill and register it in the CUSTOM skills catalog.
workflow: definition
skills: []
---

# Create skill

Create one focused Sia skill for the repository. This creates a Sia prompt package, not a host-native skill, plugin,
agent, or vendor configuration.

## Intake

- Establish concrete requests that should use the skill and the reusable guidance they share.
- Choose a short lowercase kebab-case name and a description that says what the skill does and when it is useful.
- Prefer one concise `SKILL.md`. Add sibling references or examples only when they prevent repeated lengthy guidance.
- Do not create auxiliary README, changelog, installation, or quick-reference files.

## Preflight

Validate all of the following before writing:

- The name matches `[a-z0-9]+(?:-[a-z0-9]+)*`, is not `sia`, and matches the intended directory exactly.
- No case-folded or normalized collision exists in project paths or CUSTOM entries.
- `.ai/skills/<name>/SKILL.md` and the CUSTOM entry do not already exist in a conflicting or partial state.
- A same-named shipped skill is reported as a deliberate override. Require exact authorization: an interactive
  confirmation or an unattended activating request that explicitly asks for the override. Otherwise return `blocked`.
- `.ai/skills/INDEX.md` has one valid CUSTOM section and one untouched, structurally valid SIA managed block.

If an unindexed project definition or an entry without a definition already exists, stop and recommend
`reconcile-catalogs`; never overwrite it as a new skill.

## Definition contract

Create `.ai/skills/<name>/SKILL.md` with frontmatter containing `name`, `description`, and an optional concise
`use_when` list. The body defines only the context, procedure, constraints, validation, and output needed to apply the
expertise. It must not activate an operation, choose a workflow, own lifecycle gates, or widen host permissions.
It must not activate, reinterpret, or broaden unattended mode.

Keep instructions imperative and repository-relevant. Put large conditional detail in a directly linked sibling file
and state when to read it rather than loading it unconditionally.

## Catalog change and outcome

Add exactly one backtick-delimited name entry to CUSTOM using the index's documented format. Use a short catalog summary
when the triggering description is longer; the complete entry must fit within 120 characters. Do not sort, regenerate,
or reword existing entries. Never edit the SIA block or anything under `.ai/skills/sia/`.

Treat the definition and CUSTOM entry as one logical change: preflight both, write both together, then reread and
validate both. If completion fails, repair or revert only writes made by this operation and report any partial state.
Report paths changed, validation performed, and whether the skill overrides a shipped definition.
