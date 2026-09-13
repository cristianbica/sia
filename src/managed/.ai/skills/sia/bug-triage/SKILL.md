---
name: bug-triage
description: Turn defect symptoms into a tested root-cause explanation and bounded remediation scope.
use_when:
  - a reported behavior differs from expected behavior
  - a failure is intermittent or poorly localized
  - a fix plan needs root-cause evidence
---

# Bug triage

Make the observed and expected behavior precise. Reproduce safely when practical, or identify the strongest available
evidence and its limits. Trace the failing path, compare a working case, and test competing explanations rather than
confirming the first guess. Find where actual behavior first diverges from the intended behavior.

Explain the causal chain and a focused regression check. Label an unconfirmed cause as a hypothesis. Do not conceal
uncertainty behind retries, broad rescue, or unrelated refactoring. Diagnosis gathers evidence; implementation follows
the task's authorization. Report the cause, supporting evidence, and material unknowns without a fixed report template.
