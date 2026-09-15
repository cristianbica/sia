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

## Relevant checks

Use the checks triggered by the change; explain concrete failures rather than listing hypothetical hazards.

- Access and contracts: verify account/tenant scoping, permissions, validation, and compatibility through callers.
- Data access: check supporting indexes, query fan-out, unnecessary loading, repeated remote calls, and cache
  invalidation. Back performance claims with a query plan, measurement, or a concrete scaling argument.
- Asynchronous work: check idempotency, retries, transactions, concurrency, and crash recovery.
- Deployment: check old/new process compatibility, migration order, and lock duration. Keep heavy data backfills
  separate from schema changes; make interruption and recovery behavior explicit.
- Interfaces: check localization, empty/error states, useful error messages, and consistency with nearby UI.
- Scope and evidence: compare with the original request and approved plan. Check real regression coverage and actual
  command outcomes; an approved plan does not justify unnecessary features.

Challenge unnecessary layers, options, dependencies, fallback behavior, and unrelated cleanup. Prefer established
repository patterns. Suggest a different design when the current one creates a concrete problem, not as a preference.
Do not raise hypothetical hazards without a plausible trigger and impact.

Keep reviewed files unchanged during the review itself. In a delivery task, continue afterward with authorized
in-scope fixes and suitable checks; a standalone review ends with findings. Each material finding names severity,
source location, triggering behavior, impact, and an actionable correction. Separate optional suggestions. Approve
sound work briefly and report meaningful test or context limits; no findings is not proof of correctness.
