---
name: code-review
description: Review a change for concrete correctness, regression, scope, and maintainability risks.
use_when:
  - a branch or diff needs independent review
  - a delivery workflow reaches Review and Validate
  - remediation needs confirmation against prior findings
---

# Code review

Review the defined diff against the original request, subsequent user changes, and any authorized plan. If the original
request is unavailable, say so. Plan inclusion is not evidence that an extra feature was needed.

Trace affected callers and meaningful failure paths. Prioritize correctness, authorization, data integrity, and
operational failures; examine concurrency, lifecycle, compatibility, and performance when the change has a concrete
trigger. Check that tests detect realistic regressions and command results support the claims.

Challenge unnecessary layers, options, dependencies, fallback behavior, and unrelated cleanup. Prefer established
repository patterns. Suggest a different design when the current one creates a concrete problem, not as a preference.
Do not raise hypothetical hazards without a plausible trigger and impact.

Keep reviewed files unchanged. Each material finding names severity, source location, triggering behavior, impact, and
an actionable correction. Separate optional suggestions. Approve sound work briefly and report meaningful test or
context limits; no findings is not proof of correctness.
