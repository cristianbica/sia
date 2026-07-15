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

## Priorities

1. **Production safety first.** Check expensive data access, missing supporting indexes where relevant, long
   transactions, duplicate asynchronous work, retries, deploy ordering, and data backfills. Call out recurring setup,
   boot, query, or allocation cost that scales with traffic, data volume, workers, or CI.
2. **Existing patterns over new concepts.** Challenge unnecessary abstractions, parallel domain models, custom guards
   or services, wrapper methods, and one-off naming. Prefer the framework's built-ins and established repository
   query, validation, helper, and UI patterns.
3. **Simplicity and scope.** Push for the smallest change that meets the requirement. Flag broad presentation or
   transport churn, speculative future support, unrequested flags or options, and obsolete paths retained after a
   product decision changed.
4. **Clear domain naming.** Question names that hide business meaning, mean different things across layers, or create
   unclear domain objects. Ask what an object is for when its purpose is not evident.
5. **Performance and data access.** For new queries or equivalent reads, verify indexes and access paths match actual
   predicates and ordering. Reject per-item unindexed work on list paths, needless record loading, avoidable memory
   growth, repeated remote or database trips, and loop work that batching, preloading, joins, projections, or bulk
   operations would simplify.
6. **User-facing completeness.** Check localization, placeholders, fallback and empty states, UI placement, feature
   exposure when useful, and whether users, administrators, and operators understand the result. Error text should be
   helpful to its audience, not programmer-facing.
7. **Data and deployment hygiene.** Prefer an operational task for one-off data repair. Avoid heavy data work in schema
   changes. Require a deploy-safe rollout for destructive changes when old processes can still run.
8. **Boundary hygiene.** Keep behavior in the repository's established domain, validation, transport, and presentation
   boundaries. Do not move domain behavior into views, helpers, initialization, globals, or broad shared objects only
   because it is convenient.
9. **Product and access correctness.** Check account or tenant scoping, external compatibility, permissions, feature
   availability, and whether an administrator or operator could accidentally trigger destructive behavior.
10. **Evidence over intuition.** For performance claims, ask for a query plan, benchmark, profile, or production-sized
    reasoning. Distinguish graceful, observable recovery from mechanisms that conceal the underlying failure.

## Framework and runtime taste

- Prefer convention, integrated systems, expressive names, and fewer layers. Push back on ceremony, stack
  substitutions, and speculative architecture.
- Respect public contracts and compatibility. Check object boundaries, extension points, ecosystem integration, and
  whether tests exercise behavior where it actually runs.
- Check lifecycle, association or ownership semantics, adapter behavior, transactions, deploy order, and relevant
  process, thread, or concurrency safety.
- Care about the hot path with evidence: allocations, object loading, data-access shape, cache invalidation, setup
  cost, correctness parity, and simple code that runs fast.

## Procedure

1. Inventory the complete in-scope diff, including tests, configuration, schema or data changes, and documentation.
2. Trace changed behavior through callers, data boundaries, failure paths, important state transitions, and runtime
   lifecycle as relevant.
3. Apply the priorities above proportionately to the change. Check assumptions, compatibility, authorization,
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

## Practical checklist

- Does an existing framework or repository pattern fit better than this new abstraction?
- Does each new data-access path have the supporting index or equivalent access strategy and avoid list-path fan-out?
- Does loop work load records, make requests, or allocate data that a join, projection, preload, batch, or bulk action
  would avoid?
- Is asynchronous work idempotent and safe across crashes, retries, deploys, and concurrency limits?
- Are schema and data changes deploy-safe and free of unnecessary heavy data work?
- Are destructive changes separated from their code rollout when old processes may still execute?
- Are guardrails observable recovery mechanisms, or do they hide a bug that should remain visible?
- Is a performance claim backed by a plan, benchmark, profile, or production-sized argument?
- Is risky or incomplete product exposure gated when useful, and ungated when a flag would only add complexity?
- Are user-visible strings localized through the appropriate mechanism and UI patterns consistent with nearby screens?
- Does the change preserve external contracts and respect account, tenant, and permission boundaries?
- Are edge cases handled proportionately without complicating the main flow?

## Finding format

Each material finding states severity, concise title, affected path and location, triggering scenario, impact, and the
evidence supporting it. Order findings by impact. Keep non-blocking suggestions separate and report residual risk or
validation gaps after the findings.
