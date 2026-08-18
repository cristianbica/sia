---
operation: fix
workflow: delivery
skills: [repository-discovery, bug-triage, testing]
---

# Make Forge read-only work immediate

<!-- sia:approval:start -->
## Outcome

Forge executes read-only inspection and safe local diagnostics immediately, without an inline plan or approval, while
retaining its approved inline loop for requested changes and external actions.

## Scope

- Update `src/managed/.ai/sia.md` to distinguish immediate non-mutating Forge work from planned mutations and external
  actions.
- Update `src/managed/.ai/workflows/sia/delivery.md` so questions, reads, searches, listings, diffs, inspection, review,
  and safe local diagnostics run directly; only requested durable changes or external actions enter the inline-plan
  approval loop.
- Define safe diagnostics as evidence-gathering local commands with no intended durable repository or external-state
  change; unexpected durable changes stop the task and are reported without cleanup.
- Update `README.md`, `docs/orchestration.md`, and affected activation, routing, and workflow static contracts.
- Run `./install.sh` to refresh the managed protocol and delivery-workflow projections, then inspect generated changes.

## Non-goals

- Do not remove inline planning or explicit approval for requested repository changes or external actions.
- Do not bypass host permission prompts or treat network/external actions as read-only diagnostics.
- Do not authorize cleanup or retention of unexpected diagnostic changes.
- Do not alter explicit operations, unattended delivery, persisted plans, resume, or directive syntax.
- Do not commit, push, publish, release, deploy, or run paid live model tests.

## Acceptance

- `Read tmp/review-mandates.md` while Forge is enabled reads the file immediately and returns its result without showing
  a plan or asking for approval.
- Read, search, list, inspect, diff, status/history, review, and safe local diagnostic requests follow the same immediate
  path.
- Requests to edit files, change repository state, or perform external actions still receive one inline intent envelope
  and explicit approval before action.
- A diagnostic that unexpectedly changes durable state stops and reports the change without silently keeping or
  removing it.
- Forge remains ready for the next request after either immediate read-only work or completed approved delivery.
- Canonical source, installed projections, README, orchestration documentation, and static contracts agree.
- `sh tests/behavior/routing/static-contracts.sh`, `sh tests/behavior/workflows/static-contracts.sh`,
  `sh scripts/verify static`, and `sh scripts/verify` pass.

## Risks

- Some test and build commands create caches or temporary files; the contract must distinguish incidental transient
  output from intended durable repository changes without pretending unexpected tracked or durable output is harmless.
- Over-broad wording could misclassify network queries as diagnostics; external actions remain on the approved path.

## External actions

None.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base a6d43dc7aa3bdbaef59a7715f9e78dc26ae2a3f4 -->
<!-- sia:approved 9a795fe782cf7f32a773e913c37b8ac8be21e8218d6e62d5cc3687135df981d7 -->
<!-- sia:progress build: split Forge into immediate evidence work and approved change/external-action delivery -->
<!-- sia:progress review-validate: focused, static, full, projection, stale-contract, and diff checks pass -->
<!-- sia:progress ship: Forge read-only boundary fix complete; no external actions performed -->
