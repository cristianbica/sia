---
name: bug-triage
description: Turn defect symptoms into a tested root-cause explanation and bounded remediation scope.
use_when:
  - a reported behavior differs from expected behavior
  - a failure is intermittent or poorly localized
  - a fix plan needs root-cause evidence
---

# Bug triage

Treat reports and error messages as evidence, not as proof of cause. Narrow the failure before choosing remediation.

## Required context

- Observed and expected behavior, impact, frequency, and relevant inputs or environment.
- Available reproduction steps, logs, traces, tests, and recent related changes.
- Repository instructions, affected documentation, and the current workflow's write permissions.

## Procedure

1. Make the symptom precise and identify what is directly observed versus inferred.
2. Reproduce safely when practical, or identify the strongest available proxy when it is not.
3. Trace the failing path across boundaries and compare a working case when one exists.
4. Form competing hypotheses and seek discriminating evidence instead of confirming the first explanation.
5. Identify the earliest verified divergence and explain the causal chain to the visible symptom.
6. Define the smallest remediation scope and regression checks that would fail before the fix and pass after it.

Diagnosis is read-only. Apply remediation only in a workflow phase that permits writes and only within approved scope.
Do not hide uncertainty behind broad defensive code, retries, rescues, or unrelated refactoring.

## Output

Report reproduction status, observations, ruled-out hypotheses, root cause with confidence, affected scope, regression
strategy, and remaining unknowns. When root cause is unconfirmed, label the best-supported hypothesis accurately.
