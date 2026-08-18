---
operation: fix
workflow: delivery
skills: [repository-discovery, bug-triage, testing]
---

# Make Forge responsive to contextual follow-ups

<!-- sia:approval:start -->
## Outcome

Forge treats terse follow-ups as commands over active conversation context, reuses established evidence, minimizes
rediscovery, and presents an inline plan promptly whenever the user asks for one.

## Scope

- Update `src/managed/.ai/sia.md` with a compact Forge invariant for contextual shorthand, context reuse, and plan-first
  handling of explicit inline-plan requests.
- Update `src/managed/.ai/workflows/sia/delivery.md` to resolve shorthand such as `done`, `next one`, `same`, item
  numbers, and pronouns from recent Forge state when the referent is clear.
- Treat user-stated task transitions as current context unless observable evidence contradicts them; verify only the
  smallest fact required for scope, safety, or acceptance.
- Make `inline plan` an output/cadence instruction: reuse existing evidence, perform only minimum safety-critical
  discovery, present the approval envelope without routine discovery narration, and defer deeper implementation
  discovery until after approval unless it could materially change the envelope.
- Update `README.md`, `docs/orchestration.md`, and affected routing/workflow static contracts.
- Run `./install.sh` to refresh the managed protocol and delivery-workflow projections, then inspect generated changes.

## Non-goals

- Do not weaken inline approval, scope-expansion, permission, external-action, dirty-worktree, review, or testing gates.
- Do not guess when a terse referent or material boundary genuinely has multiple plausible meanings; ask one focused
  clarification instead.
- Do not treat `inline plan` as approval or begin writes before the user approves the visible envelope.
- Do not change behavior outside Forge, reserved controls, operation catalogs, or persisted delivery.
- Do not commit, push, publish, release, deploy, or run paid live model tests.

## Acceptance

- After completing one tracked item, `done and move to next one. inline plan` resolves the next item from loaded context
  and promptly presents one concise inline plan without broad rediscovery.
- Forge reuses already loaded tracker content, findings, prior decisions, and verified evidence instead of reopening or
  re-searching them by default.
- A user-stated completion or transition is accepted unless a small, relevant check reveals a contradiction.
- Pre-plan discovery stops as soon as outcome, scope, non-goals, acceptance, checks, risks, and external actions can be
  stated safely; deeper seam and regression discovery may occur after approval inside that envelope.
- Routine command narration and evidence dumps do not precede an explicitly requested inline plan.
- Ambiguous shorthand produces at most one focused clarification rather than broad speculative investigation.
- Canonical source, installed projections, README, orchestration documentation, and static contracts agree.
- `sh tests/behavior/routing/static-contracts.sh`, `sh tests/behavior/workflows/static-contracts.sh`,
  `sh scripts/verify static`, and `sh scripts/verify` pass.

## Risks

- Excessive trust in stale context could produce an incorrect plan; contradiction, material-boundary, and freshness
  checks remain available but must be narrow.
- Deferring implementation discovery can reveal an in-envelope approach change after approval; only outcome, scope,
  criteria, risk, permissions, or external-action expansion requires a revised plan and approval.
- The worktree contains the completed prior Forge revisions on the same paths; they are attributable and will be
  refined in place without discarding them.

## External actions

None.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base a6d43dc7aa3bdbaef59a7715f9e78dc26ae2a3f4 -->
<!-- sia:dirty .ai/sia.md,.ai/workflows/sia/delivery.md,README.md,docs/orchestration.md,src/managed/.ai/sia.md,src/managed/.ai/workflows/sia/delivery.md,tests/behavior/activation/static-contracts.sh,tests/behavior/routing/static-contracts.sh,tests/behavior/workflows/static-contracts.sh,.ai/plans/2026-08-18-04-forge-immediate-read-only-work.md,.ai/plans/2026-08-18-05-forge-keeps-sia-prefixed-requests.md -->
<!-- sia:approved d31ca9f0c523b79d700b53b99083efa9052769212d492a5d1cef6937f26d0716 -->

## Progress

- Build: added context-first shorthand resolution, narrow contradiction checks, explicit inline-plan cadence, and
  regression contracts across the managed protocol, delivery workflow, README, and orchestration guide.
- Projection: `./install.sh` completed and the installed protocol and delivery workflow exactly match managed sources.
- Focused validation: activation (8), routing (8), and workflow (9) behavior contracts pass; the managed protocol is
  230 lines and changed Markdown contains no lines over 120 characters.
- Review/Validate: no material findings; `git diff --check`, `sh scripts/verify static`, and `sh scripts/verify` pass.
- Ship: managed/runtime projections are exact, the approved scope is complete, and no commit or external action was
  performed.
