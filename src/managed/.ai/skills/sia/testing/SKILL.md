---
name: testing
description: Select, run, and report proportionate verification for a repository change.
use_when:
  - application behavior changes
  - a delivery plan needs validation criteria
  - implementation or documentation claims need verification
---

# Testing

Choose validation from the change's behavior, risk, and repository evidence rather than from a fixed universal command.

## Required context

- Changed and affected behavior, including documented acceptance criteria.
- Verified repository commands and relevant test locations.
- The base and pre-existing dirty-worktree baseline.
- Host permissions and environmental limitations.

## Procedure

1. Identify the smallest tests that directly exercise the changed behavior and its important failure modes.
2. Add or update regression coverage when behavior changes and the repository has an appropriate test layer.
3. Run focused validation first, then broader checks when risk and cost justify them.
4. Inspect exit status and useful output; distinguish test failure from unavailable dependencies or environment.
5. Review the final diff for untested branches, documentation impact, and accidental scope.

Use the repository's own commands and conventions when verified. Do not invent a generic test stack or silently replace
an unavailable check with a weaker one.

## Reporting

For every claimed check, report the exact command, outcome, and relevant scope. Label commands that were not run and
explain why. Record residual risk and missing evidence. Never imply that skipped, interrupted, or uninspected commands
passed.
