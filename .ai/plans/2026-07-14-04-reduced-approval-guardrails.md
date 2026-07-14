---
id: 2026-07-14-04-reduced-approval-guardrails
operation: implement
workflow: delivery
execution_mode: interactive
authorization_ceiling: [exact-plan-revision]
authorized_external_actions: []
status: complete
execution_route: standard
revision: 1
approved_revision: 1
approved_digest: b804a94f8dab28cffaa90bb6e39e0e6f91d415a6b25e7e0e457a4c97176f91ae
approved_at: 2026-07-14T06:13:05Z
base_ref: 5851f3e3c5c894c6428c08ee62225a354759a5b2
staged_paths: []
unstaged_paths: []
untracked_paths: []
next_phase: none
blocked_phase:
blocker_attempt: 0
docs: [README.md, docs/product.md, docs/protocol.md, docs/orchestration.md]
skills: [repository-discovery, testing]
---

<!-- sia:approval:start -->
id: 2026-07-14-04-reduced-approval-guardrails
operation: implement
workflow: delivery
execution_mode: interactive
authorization_ceiling: [exact-plan-revision]
authorized_external_actions: []
execution_route: standard
revision: 1
base_ref: 5851f3e3c5c894c6428c08ee62225a354759a5b2
staged_paths: []
unstaged_paths: []
untracked_paths: []
docs: [README.md, docs/product.md, docs/protocol.md, docs/orchestration.md]
skills: [repository-discovery, testing]

## Outcome

Reduce Sia-owned approval interruptions while retaining explicit boundaries for high-risk, scope-expanding, external,
destructive, and host-permission-controlled work.

## Context, scope, and non-goals

Change the canonical delivery workflow so an eligible lightweight request is directly authorized by the activating
interactive request, with a compact receipt and focused validation instead of a Plan-to-Approve pause. For standard
work, make one approved intent envelope authorize in-envelope implementation-detail replans; require a new approval
only when outcome, scope, risk, permissions, or external-action authority expands. Keep completed plans without an
interactive Ship deletion question. Align protocol and public design documentation with the new behavior, and update
routing/workflow contract fixtures and tests. Regenerate the installed managed `.ai` projection.

Do not weaken host approval interfaces, dirty-worktree protection, review/validation, explicit external-action intent,
or the restrictions on commits, pushes, pull requests, releases, publication, deployment, and destructive actions.
Do not add a new invocation mode or change the meaning of `unattended`.

## Acceptance criteria and steps

1. Define direct authorization for the existing lightweight route only when all current eligibility conditions are
   evidenced; record a compact receipt, run focused validation, and promote to standard before a new risk is acted on.
2. Define an intent envelope for standard interactive approval and allow documented in-envelope replans without a
   second prompt; enumerate the conditions that require a revised plan and approval.
3. Retain completed plans by default and require a separate explicit deletion request.
4. Preserve all existing host, external-action, dirty-worktree, validation, and unattended safeguards.
5. Update the managed source, user-facing documentation, contract tests, and routing fixtures; run the installer and
   focused/static verification, followed by the full verifier if it remains proportionate and available.

## Validation, documentation impact, risks, assumptions, and exclusions

Run the routing and workflow static contracts, the source static contracts, and `sh scripts/verify static`; run
`./install.sh` and inspect the generated projection. Run `sh scripts/verify` if the focused checks pass. Documentation
must distinguish Sia-owned authorization from host permission prompts.

The primary risk is accidentally allowing a lightweight change outside its existing bounded eligibility or treating a
scope/risk expansion as an implementation detail. Mitigate it with explicit promotion and reapproval conditions and
fixtures for in-envelope versus out-of-envelope replans. The user-approved design does not authorize external actions.
<!-- sia:approval:end -->

<!-- sia:evidence:start -->
Plan baseline recorded from clean worktree at `5851f3e3c5c894c6428c08ee62225a354759a5b2`.

```sia-phase-boundary
sequence: 1
plan_revision: 1
completed_phase: approval
next_phase: build
head_ref: 5851f3e3c5c894c6428c08ee62225a354759a5b2
changed_paths: [.ai/plans/2026-07-14-04-reduced-approval-guardrails.md]
unresolved_material_findings: false
authorization_source: explicit-user
```

```sia-phase-boundary
sequence: 2
plan_revision: 1
completed_phase: build
next_phase: review-validate
head_ref: 5851f3e3c5c894c6428c08ee62225a354759a5b2
changed_paths: [.ai/operations/sia/implement.md, .ai/sia.md, .ai/workflows/sia/delivery.md, README.md, docs/README.md, docs/orchestration.md, docs/product.md, docs/protocol.md, src/managed/.ai/operations/sia/implement.md, src/managed/.ai/sia.md, src/managed/.ai/workflows/sia/delivery.md, tests/behavior/activation/static-contracts.sh, tests/behavior/routing/fixtures/lightweight-skill.md, tests/behavior/routing/fixtures/lightweight-source-fix.md, tests/behavior/routing/fixtures/standard-boundary-replan.md, tests/behavior/routing/fixtures/standard-in-envelope-replan.md, tests/behavior/routing/static-contracts.sh, tests/behavior/workflows/static-contracts.sh]
unresolved_material_findings: false
```

```sia-phase-boundary
sequence: 3
plan_revision: 1
completed_phase: review-validate
next_phase: ship
head_ref: 5851f3e3c5c894c6428c08ee62225a354759a5b2
changed_paths: []
unresolved_material_findings: false
command_results: ["cmp managed-to-installed projection: passed", "sh scripts/verify: passed"]
review: same-context fallback; no material findings
```

```sia-phase-boundary
sequence: 4
plan_revision: 1
completed_phase: ship
next_phase: none
head_ref: 5851f3e3c5c894c6428c08ee62225a354759a5b2
changed_paths: [.ai/plans/2026-07-14-04-reduced-approval-guardrails.md]
unresolved_material_findings: false
```
<!-- sia:evidence:end -->
