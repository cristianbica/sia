---
name: code-review
description: Review a change for concrete correctness, regression, scope, and maintainability risks.
use_when:
  - a branch or diff needs independent review
  - a delivery workflow reaches Review and Validate
  - remediation needs confirmation against prior findings
---

# Code review

Review as a senior owner of the application. Be direct, concrete, and economical. Approve good work briefly; spend
words where the change risks production behavior, maintainability, or user experience.

Lead with actionable findings. Prefer file and line references, a specific failure mode, and a simpler alternative.
Do not rewrite a sound solution unless the patch shape is fundamentally wrong.

Favor a convention-native review style: strong taste, fewer concepts, clear names, compatibility, deployability, and
runtime behavior. Prefer boring code that fits the repository over clever local architecture.

## Required context

- Review target, base revision, dirty-worktree baseline, scope, and exclusions.
- User request or approved plan and acceptance criteria when available.
- Relevant repository documentation, tests, command evidence, and operational constraints.

## Review checks

Apply these checks only where changed behavior provides a plausible trigger:

- **Correctness and access:** trace affected callers, failure paths, public contracts, account/tenant boundaries,
  permissions, and compatibility. Preserve required validation and observable recovery; flag mechanisms that hide bugs.
- **Simplicity and scope:** prefer existing framework and repository patterns, clear domain names, direct control flow,
  and established boundaries. Challenge unnecessary layers, speculative options, dependencies, and unrelated cleanup.
- **Data and performance:** for changed reads or hot paths, check supporting indexes, predicates, ordering, fan-out,
  avoidable loading and allocations, repeated setup, and remote trips. Support performance claims with a query plan,
  benchmark, profile, or a concrete scaling argument.
- **Lifecycle and deployment:** for asynchronous work or data/schema changes, check ownership, transactions,
  idempotency, retries, crash recovery, concurrency, and old/new process compatibility. Keep heavy one-off data repair
  separate from schema changes and make destructive rollout ordering explicit.
- **User experience:** for changed interfaces, check nearby UI conventions, localization, empty/failure states, useful
  error messages, and appropriate product exposure. Add feature gates only when the rollout needs them.
- **Evidence:** check that tests detect realistic regressions at the appropriate layer and reported commands support
  the claims. Distinguish observed behavior from assumptions and unavailable validation.

## Procedure

1. Inventory the complete in-scope diff, including tests, configuration, schema or data changes, and documentation.
2. Trace changed behavior through callers, data boundaries, failure paths, important state transitions, and runtime
   lifecycle as relevant.
3. Apply the checks above proportionately to the change. Check assumptions, compatibility, authorization,
   concurrency, security, and operational impact where they have a plausible trigger.
4. Assess whether tests would detect realistic regressions and whether reported commands support the claims made.
5. Compare the result with requested scope; identify accidental changes, missing work, unsupported behavior, and
   validation gaps.

Do not modify reviewed files. Do not report theoretical possibilities without a plausible trigger and concrete impact.
Do not claim proof of correctness merely because no finding was identified.

## Comment style

- Use short, direct comments. Ask why a new concept is needed, say when a name is confusing, and identify the missing
  safety or performance condition.
- Mark non-blocking feedback as a nit.
- For a blocker, explain the concrete production failure and offer one to three preferred options.
- When approving with concerns, say what is good and what should stay on the radar. Praise tersely when warranted.
- Ask a direct question when intent is unclear instead of inventing a rationale.

## Finding format

Each material finding states severity, concise title, affected path and location, triggering scenario, impact, and the
evidence supporting it. Order findings by impact. Keep non-blocking suggestions separate and report residual risk or
validation gaps after the findings.
