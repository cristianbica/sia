---
name: testing
description: Select, run, and report proportionate verification for a repository change.
use_when:
  - application behavior changes
  - a delivery plan needs validation criteria
  - implementation or documentation claims need verification
---

# Testing

Choose checks from the changed behavior and repository conventions. Prefer tests that reproduce the defect or detect
meaningful regressions over ones that copy the implementation. Cover relevant failure paths; do not add speculative
cases outside the task's contracts.

Run focused checks first and broader checks when scope or risk warrants them. Stop once required checks pass unless a
change, failure, or new concern justifies more work. For runnable changes, run a check that exercises the changed
behavior, such as relevant tests, a build, a type-checker, or the changed command. A syntax-only check cannot establish
runtime behavior. For prompt or documentation changes, use the relevant contract and link checks without claiming
they prove live model behavior. Inspect outcomes; a skipped check, failed-to-start command, or missing dependency is
not a pass. Report an unavailable required check as a blocked requirement. Preserve existing tests and do not weaken
acceptance to obtain green results.

Report meaningful results and unavailable checks. Retain exact commands and outcomes in existing task evidence when
needed; do not create an artifact just for routine test reporting. Review the diff for changes the tests do not cover.
