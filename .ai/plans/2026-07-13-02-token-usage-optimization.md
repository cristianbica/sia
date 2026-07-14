---
id: 2026-07-13-02-token-usage-optimization
operation: implement
workflow: delivery
execution_mode: interactive
authorization_ceiling: [exact-plan-revision]
authorized_external_actions: []
status: complete
execution_route: standard
revision: 2
approved_revision: 2
approved_digest: b454a8cc52107e88877c950ff30bd6058c28433abb20d16bc73737ccd2e894f6
approved_at: 2026-07-14T01:25:01+03:00
base_ref: fb89ebb946cd08195232c08a9762b78010e4ba8e
staged_paths: []
unstaged_paths: []
untracked_paths: [.ai/plans/2026-07-13-02-token-usage-optimization.md]
next_phase: none
blocked_phase:
blocker_attempt: 0
docs: [docs/orchestration.md, docs/implementation.md]
skills: [repository-discovery, testing]
---

# Plan: Reduce steady-state Sia token use

<!-- sia:approval:start -->
id: 2026-07-13-02-token-usage-optimization
operation: implement
workflow: delivery
execution_mode: interactive
authorization_ceiling: [exact-plan-revision]
authorized_external_actions: []
execution_route: standard
revision: 2
base_ref: fb89ebb946cd08195232c08a9762b78010e4ba8e
staged_paths: []
unstaged_paths: []
untracked_paths: [.ai/plans/2026-07-13-02-token-usage-optimization.md]
docs: [docs/orchestration.md, docs/implementation.md]
skills: [repository-discovery, testing]

## Outcome

Reduce Sia's steady-state token use for clear, bounded implementation tasks without weakening approval, safety, or
verification. The latest Rake benchmark used 1,344,305 Sia implementation input tokens versus 878,122 for the
Orchestra lifecycle (1.53x); its documentation bootstrap is explicitly excluded. An earlier run against vanilla showed
the same direction (765,685 versus 377,612 input tokens), so this is an optimization hypothesis worth addressing, not
a pricing or general-performance claim.

## Context, scope, and non-goals

The latest trace attributes the overhead primarily to Sia's standard lifecycle and broad repeated context: 22 completed
shell steps and 11 messages for Sia, versus 16 commands and 11 messages across Orchestra's narrow plan and fresh
implementation handoff. Sia already ran fewer broad checks, so merely removing tests would not explain or safely solve
the difference. The primary changes are safe route selection and context/output discipline, not documentation
bootstrap, model pricing, plugins, or a vendor-specific runtime.

In scope:

- expand the canonical `lightweight` route only for an explicitly bounded, low-risk, repository-source behavior change
  whose exact seam, affected paths, focused test, acceptance criteria, and exclusions are evidenced during Plan; it
  must have no public or serialization contract, migration, configuration, permission, security, concurrency,
  external-action, compatibility, multi-consumer, broad-refactor, managed-Sia, or unresolved-assumption risk;
- make Build and lightweight validation load only exact resolved definitions, the active plan, material documentation,
  and focused repository evidence; prohibit re-reading catalogs, historical plans, broad docs, and prior evidence once
  resolution is complete;
- make handoff command results compact: retain command, outcome, scope, useful failure excerpts, and an evidence path;
  retain full successful output and broad diffs as artifacts instead of replaying them into later active context;
- keep focused tests in the candidate's implementation loop; require broader checks only when risk or the approved plan
  calls for them, while the benchmark coordinator owns uniform manifest checks after candidates exit;
- update the canonical protocol, operation/workflow/skill prompts, supporting design documentation, project benchmark
  workflow, and focused static contracts or fixtures. Keep all existing prompt-size limits by consolidating text.

Out of scope:

- repository documentation bootstrap policy or its cost;
- changing approval artifacts, unattended authority, installer behavior, or host-specific model selection;
- lowering correctness standards, removing regression coverage, or eliminating standard review for risky work;
- adding plugins, a workflow runtime, automatic source indexing, or mandatory subagents;
- running a new paid model benchmark during this change.

## Acceptance criteria and steps

1. Refine `src/managed/.ai/operations/sia/implement.md` and the route-triage and Build/Review portions of
   `src/managed/.ai/workflows/sia/delivery.md`. A source change reaches `lightweight` only if every listed low-risk
   condition is evidenced; ambiguity, managed Sia, or any excluded risk promotes to `standard`. Preserve compact plan,
   explicit approval, bounded Build, and focused validation; do not permit a Fix loop on lightweight work.
2. Tighten the active-context and result-envelope wording in `src/managed/.ai/sia.md` and `delivery.md`: after
   resolution, handoffs use exact paths and a single bounded ask; command results carry concise evidence while complete
   successful output and broad diffs remain artifact-backed. Consolidate existing text so the 230/300-line limits hold.
3. Update `src/managed/.ai/skills/sia/testing/SKILL.md` so validation selects a focused check first, adds a broader
   check only when justified, and reports compactly without hiding relevant failure evidence.
4. Update `.ai/workflows/benchmark.md` so candidate execution receives focused-validation guidance while the
   coordinator performs the same manifest checks after every candidate exits. Do not change clean-room, approval, or
   Sia-versus-comparator parity rules.
5. Update `docs/orchestration.md` and `docs/implementation.md` to explain the narrow source-change eligibility,
   demand-driven context, artifact-backed output, and the limited interpretation of the benchmark telemetry.
6. Extend routing and workflow static contracts and fixtures for a qualifying lightweight-source case, every promotion
   exclusion, exact-path/compact-output discipline, and coordinator-owned broad benchmark checks. Run focused contracts,
   `sh scripts/verify static`, `git diff --check`, and an approval-scope path audit.

## Validation, documentation impact, risks, assumptions, and exclusions

Validation after approval:

- `tests/behavior/routing/static-contracts.sh`;
- `tests/behavior/workflows/static-contracts.sh`;
- `sh scripts/verify static`;
- focused searches for route exclusions, context/output requirements, and benchmark evaluator ownership;
- `git diff --check` plus an approval-scope path audit.

Documentation changes are intentional because Sia's routing and context contracts are user-facing behavior. The main
risk is over-broad lightweight routing that skips needed review, or an output rule that conceals useful failures. The
route requires every listed low-risk condition, promotes on doubt, and keeps full failures/reports as evidence; only
successful bulk output is summarized. Assume the benchmark's host-reported token counts are directionally useful but
not a general cost guarantee. This plan deliberately excludes documentation bootstrap from its efficiency claim and
does not promise a particular reduction before repeated benchmark evidence exists.
<!-- sia:approval:end -->

<!-- sia:evidence:start -->
Plan phase evidence:

```sia-phase-boundary
sequence: 1
plan_revision: 2
completed_phase: approval
next_phase: build
head_ref: fb89ebb946cd08195232c08a9762b78010e4ba8e
changed_paths: [.ai/plans/2026-07-13-02-token-usage-optimization.md]
unresolved_material_findings: false
authorization_source: explicit-user
```

```sia-phase-boundary
sequence: 2
plan_revision: 2
completed_phase: build
next_phase: review-validate
head_ref: fb89ebb946cd08195232c08a9762b78010e4ba8e
changed_paths:
  - .ai/workflows/benchmark.md
  - docs/implementation.md
  - docs/orchestration.md
  - src/managed/.ai/operations/sia/implement.md
  - src/managed/.ai/sia.md
  - src/managed/.ai/skills/sia/testing/SKILL.md
  - src/managed/.ai/workflows/sia/delivery.md
  - tests/behavior/routing/fixtures/lightweight-source-fix.md
  - tests/behavior/routing/static-contracts.sh
  - tests/behavior/workflows/static-contracts.sh
unresolved_material_findings: false
```

- Resolved operation: `.ai/operations/sia/implement.md`.
- Resolved workflow: `.ai/workflows/sia/delivery.md`.
- Resolved skills: `.ai/skills/sia/repository-discovery/SKILL.md` and `.ai/skills/sia/testing/SKILL.md`.
- Read current routing, context-budget, handoff, testing, and benchmark contracts plus their static tests.
- Latest benchmark evidence: Sia implementation used 1,344,305 input tokens, 1,275,904 cached input tokens, 10,065
  output tokens, and 3,005 reasoning-output tokens; Orchestra plan plus implementation used 878,122, 788,992, 7,409,
  and 2,621 respectively. Both candidates passed the task's full checks; Sia's quality score was 8/10 and Orchestra's
  was 9/10. Cache telemetry is not an exact cost measure.
- Supporting earlier benchmark evidence: Sia implementation used 765,685 input tokens, 651,008 cached input tokens,
  7,911 output tokens, and 1,716 reasoning-output tokens; vanilla used 377,612, 325,376, 3,523, and 1,392.
- The benchmark's documentation bootstrap is explicitly excluded from this change's cost target.
- Baseline at revision 2: HEAD `fb89ebb946cd08195232c08a9762b78010e4ba8e`; staged and unstaged paths are empty. The
  pre-existing untracked path is this draft plan, which this planning phase revised; no other worktree content was read
  into the plan.
- Build validation: `sh scripts/verify static` passed all 48 checks; `git diff --check` passed.

```sia-phase-boundary
sequence: 3
plan_revision: 2
completed_phase: review-validate
next_phase: ship
head_ref: fb89ebb946cd08195232c08a9762b78010e4ba8e
changed_paths: []
unresolved_material_findings: false
```

- Review: approval digest remains valid; the changed paths match approved scope; prompt budgets remain 230 protocol
  lines and 300 delivery-workflow lines; all touched Markdown remains within 120 columns.
- Review: no material correctness, safety, scope, documentation, or validation-evidence finding.

```sia-phase-boundary
sequence: 4
plan_revision: 2
completed_phase: ship
next_phase: none
head_ref: fb89ebb946cd08195232c08a9762b78010e4ba8e
changed_paths: []
unresolved_material_findings: false
```

- Ship: implementation is complete; no commit, push, release, or external action was performed.
<!-- sia:evidence:end -->
