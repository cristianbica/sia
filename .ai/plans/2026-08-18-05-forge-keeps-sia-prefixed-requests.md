---
operation: fix
workflow: delivery
skills: [repository-discovery, bug-triage, testing]
---

# Keep Sia-prefixed requests inside Forge

<!-- sia:approval:start -->
## Outcome

While Forge is enabled, a later valid `Sia …` prefix is optional request syntax and does not route ordinary requests or
exact operation names out of Forge delivery.

## Scope

- Update `src/managed/.ai/sia.md` activation precedence so, after invocation validation and reserved-control handling,
  a Sia-prefixed remainder routes through Forge before exact-operation, alias, or inferred-operation resolution.
- Update `src/managed/.ai/workflows/sia/delivery.md` so prefixed and unprefixed Forge requests use identical immediate
  read-only or approved inline mutation/external-action behavior.
- Keep reserved controls explicit: help/docs/skills and `forge on` resolve without disabling Forge; `forge off`, `stop`,
  and `reload` end it; `unattended`, `resume`, and `handoff` retain their specialized operation/continuation semantics.
- Update `README.md`, `docs/orchestration.md`, and affected activation, routing, and workflow static contracts.
- Run `./install.sh` to refresh the managed protocol and delivery-workflow projections, then inspect generated changes.

## Non-goals

- Do not change Forge's immediate read-only boundary or inline approval requirements for changes and external actions.
- Do not reinterpret malformed reserved directives as Forge requests.
- Do not change behavior when Forge is off.
- Do not remove the deliberate escape path: users can run `Sia forge off` before starting ordinary persisted delivery.
- Do not commit, push, publish, release, deploy, or run paid live model tests.

## Acceptance

- With Forge enabled, `Sia Read tmp/review-mandates.md` runs immediately without a plan, just like the unprefixed form.
- With Forge enabled, `Sia implement feature X` and `Sia fix bug Y` use Forge's inline plan and approval rather than
  creating persisted standard-delivery artifacts or replacing Forge with an operation.
- Exact operation names, aliases, and high-confidence operation inference do not outrank Forge for ordinary prefixed
  requests.
- Valid reserved controls retain their documented behavior; malformed forms still report syntax/arity errors.
- Forge remains enabled unless an existing terminating control or a new conversation ends it.
- Canonical source, installed projections, README, orchestration documentation, and static contracts agree.
- `sh tests/behavior/activation/static-contracts.sh`, `sh tests/behavior/routing/static-contracts.sh`,
  `sh tests/behavior/workflows/static-contracts.sh`, `sh scripts/verify static`, and `sh scripts/verify` pass.

## Risks

- Users who intentionally want persisted interactive delivery while Forge is enabled must now turn Forge off first;
  documentation must make that explicit.
- Reserved-control precedence must remain exact so ordinary words resembling directives do not unexpectedly alter mode.
- The worktree contains the completed prior Forge boundary revision on the same paths; it is attributable and will be
  refined in place without discarding it.

## External actions

None.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base a6d43dc7aa3bdbaef59a7715f9e78dc26ae2a3f4 -->
<!-- sia:dirty .ai/sia.md,.ai/workflows/sia/delivery.md,README.md,docs/orchestration.md,src/managed/.ai/sia.md,src/managed/.ai/workflows/sia/delivery.md,tests/behavior/activation/static-contracts.sh,tests/behavior/routing/static-contracts.sh,tests/behavior/workflows/static-contracts.sh,.ai/plans/2026-08-18-04-forge-immediate-read-only-work.md -->
<!-- sia:approved 0bf9ea1d3d89647b41659669770b9b31ae15a7d8ddb150496dc9fd1c39242db4 -->
<!-- sia:progress build: Forge now precedes operation resolution for ordinary Sia-prefixed requests -->
<!-- sia:progress review-validate: precedence, focused, static, full, projection, and diff checks pass -->
<!-- sia:progress ship: Sia-prefixed Forge precedence fix complete; no external actions performed -->
