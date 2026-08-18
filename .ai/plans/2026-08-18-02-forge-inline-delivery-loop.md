---
operation: fix
workflow: delivery
skills: [repository-discovery, bug-triage, testing]
---

# Make Forge an approved inline delivery loop

<!-- sia:approval:start -->
## Outcome

Forge supports a rapid series of implementation tasks of any size through a repeating conversation-scoped loop:
request, inline plan, explicit approval, build, review/validation, fixes when needed, completion, then the next request.

## Scope

- Update `src/managed/.ai/sia.md` to define one active inline Forge task at a time, explicit approval for every Forge
  action, no Forge plan artifact, no size-based promotion to persisted delivery, and continued Forge availability after
  task completion.
- Update `src/managed/.ai/workflows/sia/delivery.md` with a dedicated Forge delivery path that presents an inline intent
  envelope, binds approval in conversation, runs proportionate Build and Review/Validate/Fix phases, and re-plans only
  when the approved boundary changes.
- Update `README.md` and `docs/orchestration.md` to explain the request-to-completion loop, its artifact-free and
  non-resumable tradeoff, and explicit operations as the opt-in persisted alternative.
- Update affected activation, routing, and workflow static contracts to require the Forge inline loop and reject
  persisted-plan or size-promotion behavior for Forge tasks.
- Run `./install.sh` to refresh the managed protocol and delivery-workflow projections, then inspect generated changes.

## Non-goals

- Do not weaken permission, external-action, security, dirty-worktree, scope-expansion, testing, review, or Fix gates.
- Do not make Forge resumable across conversations or write Forge task state under `.ai/plans/**` or elsewhere.
- Do not change explicit operations, unattended delivery, persisted standard plans, resume, or directive syntax except
  to distinguish them clearly from Forge delivery.
- Do not commit, push, publish, release, deploy, run destructive actions, or run paid live model tests.

## Acceptance

- Every unqualified action request while Forge is enabled receives a concise inline plan containing outcome, scope,
  non-goals, acceptance criteria, checks, risks, and external actions, followed by an explicit approval gate.
- Approval authorizes exactly that inline Forge task; a boundary expansion presents a revised inline plan and asks for
  approval again.
- After approval, Sia performs proportionate implementation, review, validation, and bounded fixes without creating a
  plan artifact. Larger tasks receive deeper plans and validation but are not promoted solely because of size.
- Forge remains enabled after each completed task so the next action starts another inline-plan loop.
- Questions still receive direct answers, and explicit operations or `unattended` continue to use normal Sia routing.
- Canonical source, installed projections, README, orchestration documentation, and static contracts agree.
- `sh tests/behavior/routing/static-contracts.sh`, `sh tests/behavior/workflows/static-contracts.sh`,
  `sh scripts/verify static`, and `sh scripts/verify` pass.

## Risks

- Large Forge tasks are intentionally not resumable after a new conversation; documentation must state this clearly
  without using size alone as a reason to refuse or persist the task.
- Ambiguous approval language could accidentally authorize multiple queued tasks; the contract must bind approval to
  one visible inline envelope and require a fresh envelope for the next action.
- The worktree contains the completed prior Forge revision. Changes to those same paths are attributable and must be
  refined in place; unrelated paths must remain untouched.

## External actions

None.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base 280ed2e9b8c84b6614fbd8494d40b7a467ddb9f7 -->
<!-- sia:dirty .ai/sia.md,README.md,docs/orchestration.md,src/managed/.ai/sia.md,tests/behavior/activation/static-contracts.sh,tests/behavior/routing/static-contracts.sh,.ai/plans/2026-08-18-01-forge-standard-delivery.md -->
<!-- sia:approved aa60ae19ebc1dadcac24a770553d0ec878774906db7594f6dda5c9f7732df996 -->
<!-- sia:progress build: added dedicated Forge inline delivery loop, docs, contracts, and managed projections -->
<!-- sia:progress review-validate: focused, static, full, projection, and diff checks pass; stale dogfood overview noted -->
<!-- sia:progress ship: Forge inline-loop delivery complete; no external actions performed -->
