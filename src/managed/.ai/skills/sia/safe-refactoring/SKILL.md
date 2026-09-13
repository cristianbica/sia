---
name: safe-refactoring
description: Improve internal structure while preserving observable behavior through bounded, verified steps.
use_when:
  - approved work changes structure without intending behavior changes
  - duplication or coupling must be reduced before a narrow feature change
  - a risky cleanup needs explicit behavioral safeguards
---

# Safe refactoring

State the intended structural change and behavior that must remain unchanged. Inspect affected callers, contracts,
and existing tests. Choose the smallest structural change that solves the current problem and fits local patterns.

Separate movement/cleanup from behavior changes where practical. Use reviewable steps and focused checks after
meaningful boundaries. Recheck affected lifecycle/error paths, interfaces, and documentation, without expanding into
unrelated cleanup. Report deliberate behavior changes and missing coverage. Refactoring never authorizes extra features
or weaker validation; a necessary scope change must be made explicit before proceeding.
