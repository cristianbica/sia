---
name: safe-refactoring
description: Improve internal structure while preserving observable behavior through bounded, verified steps.
use_when:
  - approved work changes structure without intending behavior changes
  - duplication or coupling must be reduced before a narrow feature change
  - a risky cleanup needs explicit behavioral safeguards
---

# Safe refactoring

Make structural intent and preserved behavior explicit. Refactoring does not justify unrelated cleanup or weaker
validation.

## Required context

- Approved scope, non-goals, and the behavior that must remain unchanged.
- Current callers, boundaries, tests, public interfaces, data formats, and operational constraints.
- Pre-existing dirty paths and verified repository commands.

## Procedure

1. Characterize observable behavior and identify gaps where tests or other evidence are too weak to detect regressions.
2. Find the smallest structural change that achieves the approved objective and preserves repository conventions.
3. Separate behavior changes from movement or cleanup; return to planning if separation is not possible.
4. Prefer incremental, reviewable steps with focused validation after each meaningful boundary change.
5. Recheck callers, lifecycle and error paths, compatibility surfaces, generated artifacts, and documentation impact.
6. Review the final diff for accidental behavior, expanded scope, stale names, dead compatibility paths, and weak tests.

Do not preserve a bug merely by calling it behavior when the approved plan explicitly changes it. Conversely, do not
smuggle behavior changes into a refactor. Apply edits only in a workflow phase that permits them.

## Output

Report the structural change, behavior-preservation evidence, tests or commands run, any deliberate behavior changes,
scope deviations, and residual risk.
