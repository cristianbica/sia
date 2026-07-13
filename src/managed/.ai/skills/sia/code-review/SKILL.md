---
name: code-review
description: Review a change for concrete correctness, regression, scope, and maintainability risks.
use_when:
  - a branch or diff needs independent review
  - a delivery workflow reaches Review and Validate
  - remediation needs confirmation against prior findings
---

# Code review

Prioritize behavior and risk over stylistic preference. Review the complete relevant change in repository context.

## Required context

- Review target, base revision, dirty-worktree baseline, scope, and exclusions.
- User request or approved plan and acceptance criteria when available.
- Relevant repository documentation, tests, command evidence, and operational constraints.

## Procedure

1. Inventory the complete in-scope diff, including tests, configuration, migrations, and documentation.
2. Trace changed behavior through callers, data boundaries, failure paths, and important state transitions.
3. Check assumptions, edge cases, compatibility, authorization, concurrency, security, and operational impact as
   relevant to the change.
4. Assess whether tests would detect realistic regressions and whether reported commands support the claims made.
5. Compare the result with the requested scope and identify accidental changes, missing work, or unsupported behavior.

Do not modify reviewed files. Do not report theoretical possibilities without a plausible trigger and concrete impact.
Do not claim proof of correctness merely because no finding was identified.

## Finding format

Each material finding states severity, concise title, affected path and location, triggering scenario, impact, and the
evidence supporting it. Order findings by impact. Keep non-blocking suggestions separate and report residual risk or
validation gaps after the findings.
