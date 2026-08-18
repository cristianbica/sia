---
operation: fix
workflow: delivery
skills: [repository-discovery, bug-triage, testing]
---

# Let Forge handle standard delivery

<!-- sia:approval:start -->
## Outcome

Forge accepts unqualified action requests that require standard delivery and runs the normal standard workflow without
requiring `Sia forge off` or asking the user to restate the request as an explicit operation.

## Scope

- Update the canonical Forge protocol in `src/managed/.ai/sia.md` so standard actions enter normal standard delivery,
  including its plan and approval gate, while Forge remains available after the operation completes.
- Update the Forge contract in `docs/orchestration.md` and the user guidance in `README.md` to describe the same
  lifecycle and safeguards.
- Update `tests/behavior/routing/static-contracts.sh` with regression assertions that reject the old
  switch-or-narrow dead end and require standard delivery from Forge.
- Run the installer to refresh the managed `.ai/sia.md` projection, then inspect its diff.

## Non-goals

- Do not weaken standard delivery approval, review, validation, permission, external-action, or dirty-worktree gates.
- Do not change explicit operation, unattended, directive, resume, or Forge activation syntax.
- Do not make Forge resumable or persist Forge state itself; only the normal standard delivery plan is persisted.
- Do not run live host/model tests or perform commits, pushes, releases, or other external actions.

## Acceptance

- A request such as `let's handle #1` while Forge is enabled no longer instructs the user to turn Forge off or narrow
  the work solely because the request routes to standard delivery.
- Standard work initiated through Forge uses the existing `Plan → Approve → Build → Review/Validate → Fix →
  Ship` gates and may create the normal standard plan artifact.
- Forge remains conversation-scoped and is available again after the standard operation completes unless explicitly
  disabled by an existing terminating directive or a new conversation.
- Canonical source, installed projection, README, orchestration documentation, and routing contract agree.
- `sh tests/behavior/routing/static-contracts.sh`, `sh scripts/verify static`, and `sh scripts/verify` pass.

## Risks

- Ambiguous lifecycle wording could make Forge appear to bypass operation approval or imply that Forge state itself is
  resumable; the protocol and regression assertions must preserve those distinctions.
- Refreshing the installed projection can expose unrelated source/projection drift; any unexpected diff stops delivery
  for attribution review.

## External actions

None.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base 280ed2e9b8c84b6614fbd8494d40b7a467ddb9f7 -->
<!-- sia:approved cc17e6d7c1cf47c5c12c0cb6a0964d61034199221b51063adb7cd496a0a0870f -->
<!-- sia:progress build: updated Forge routing contract, docs, regression assertions, and installed protocol projection -->
<!-- sia:progress review-validate: fixed context-budget and stale activation assertions; focused, static, and full checks pass -->
<!-- sia:progress ship: delivery complete; no external actions performed -->
