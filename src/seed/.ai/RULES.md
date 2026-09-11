# Sia project rules

Sia refreshes the defaults above the project-specific marker on every install. Add project constraints below that
marker; upgrades preserve that content. These rules apply to operations, resumed plans, and isolated workflow phases.

Rules here take precedence over repository documentation, skills, operations, workflows, and plans. They cannot
override system or host safety, permissions, or the user's current explicit instruction. Keep rules concrete,
repository-specific, and testable. Put operation aliases in `.ai/operations/INDEX.md`, not here.

## Rules

- Do not create, modify, or delete files outside the project root, directly or through tools (including package
  managers, installers, caches, and symlinks), unless the user specifically authorizes those external writes.
  General build, test, or dependency-install requests do not grant that permission.
- Preserve pre-existing work and report when change attribution is ambiguous.
- Verify repository-specific commands and conventions before relying on them.
- Never claim that an unrun or uninspected command passed.
- During Ship, allow only active-plan completion metadata unless the user explicitly requests another delivery action.

<!-- Add project-specific rules below this line. -->
