# Sia project rules

This project owns this file. Add hard Sia-specific constraints that should apply to operations, resumed delivery plans,
and isolated workflow phases. Sia upgrades do not modify or remove it.

Rules here take precedence over repository documentation, skills, operations, workflows, and plans. They cannot
override system or host safety, permissions, or the user's current explicit instruction. Keep rules concrete,
repository-specific, and testable. Put operation aliases in `.ai/operations/INDEX.md`, not here.

## Rules

- Preserve pre-existing work and report when change attribution is ambiguous.
- Verify repository-specific commands and conventions before relying on them.
- Never claim that an unrun or uninspected command passed.
- During Ship, allow only active-plan completion metadata unless the user explicitly requests another delivery action.

<!-- Add project-specific rules below this line. -->
