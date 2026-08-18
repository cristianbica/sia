---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Let Forge execute bounded writes directly

<!-- sia:approval:start -->
## Outcome

Forge treats a precise, safely bounded imperative as authorization for its stated local write, while open-ended,
ambiguous, risky, destructive, external, or explicitly planned work continues through inline plan approval.

## Scope

- Add a third Forge path for direct bounded writes alongside immediate non-mutating work and approved planned work.
- Qualify direct writes by clarity and predictability: explicit target and result, local reversible effect, no material
  ambiguity, and no external, destructive, permission, security, migration, broad-refactor, or scope-expansion risk.
- Support `do:` as an explicit preference for direct execution and `plan:` / `inline plan` as explicit plan-first
  instructions; selectors do not override safety or eligibility gates.
- Treat a qualifying natural-language imperative such as `mark #4 done` or `change X to Y` as direct authorization.
- If discovery reveals material ambiguity or expansion, stop before acting beyond the bounded request and present an
  inline plan; report any already completed in-bound work accurately.
- Update managed/runtime protocol and delivery workflow text, README, orchestration documentation, and behavior
  contracts. Run the installer to refresh projections.

## Non-goals

- Do not make vague outcome requests such as `handle #5` directly writable.
- Do not let `do:` bypass permissions, destructive-action safeguards, external-action authorization, security gates,
  dirty-worktree protection, review, testing, or material scope-change approval.
- Do not change persisted non-Forge delivery routing, operation catalogs, reserved directives, or unattended behavior.
- Do not commit, push, publish, release, deploy, or run paid live-model tests.

## Acceptance

- `mark #4 done`, when its target and edit are clear from active context, writes directly without an inline plan or a
  second approval and then reports the change and checks.
- `do: change this label to Completed` takes the direct path only when the bounded-write criteria are satisfied.
- `handle #5`, `plan: handle #5`, and `handle #5 — inline plan` present an inline plan and await approval.
- A direct request that becomes materially ambiguous, risky, or broader stops before expansion and switches to an
  inline plan.
- External and destructive actions never become direct writes through wording alone.
- Canonical sources, installed projections, documentation, and static behavior contracts agree.
- Focused Forge contracts, `sh scripts/verify static`, `git diff --check`, and `sh scripts/verify` pass.

## Risks

- Over-broad natural-language classification could execute an unintended edit; every direct-write criterion must hold,
  and doubt selects the plan-first path.
- Overly conservative classification could preserve unnecessary plans; tests must cover exact bounded examples and
  explicit selectors.
- Existing Forge revisions touch the same files; they are attributable to this conversation and will be refined in
  place without discarding them.

## External actions

None.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base a6d43dc7aa3bdbaef59a7715f9e78dc26ae2a3f4 -->
<!-- sia:dirty .ai/sia.md,.ai/workflows/sia/delivery.md,README.md,docs/orchestration.md,src/managed/.ai/sia.md,src/managed/.ai/workflows/sia/delivery.md,tests/behavior/activation/static-contracts.sh,tests/behavior/routing/static-contracts.sh,tests/behavior/workflows/static-contracts.sh,.ai/plans/2026-08-18-04-forge-immediate-read-only-work.md,.ai/plans/2026-08-18-05-forge-keeps-sia-prefixed-requests.md,.ai/plans/2026-08-18-06-forge-contextual-follow-ups.md -->
<!-- sia:approved 12d02e3e3860a26cfbab375001e5239791a8203b0b3e9b100a0b956eca859d59 -->
<!-- sia:progress build: added bounded writes, selectors, fallbacks, docs, contracts, and refreshed projections -->
<!-- sia:progress drift: HEAD advanced to c5929ed with in-scope work; remaining changes were reviewed against it -->
<!-- sia:progress review: no findings; focused, static, full, and diff checks pass -->
<!-- sia:progress ship: managed/runtime projections match; approved scope is complete -->
