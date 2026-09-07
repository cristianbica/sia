---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Improve engineering usefulness and total task efficiency

<!-- sia:approval:start -->
## Outcome
Implement all seven recommendations from the whole-system review: consistent rules, selective context loading, stronger engineering guidance, clear instruction ownership, useful quality evaluations, total-effort accounting, and less test coupling to prose. Preserve opt-in activation, user-selected approval, source verification, review, and host portability.

## Scope and approach
1. Correct stale Ship/deletion and Forge descriptions. Make reserved operation names and aliases consistent across protocol, creators, reconciliation, documentation, and validators, including help/show/forge. Add negative collision coverage.
2. Keep activation, authority, and resolution in the core protocol. Separate substantial route-specific delivery detail into a small number of managed supporting documents, with exact conditional loading instructions for Forge, standard delivery, and phase-specific needs. Preserve effective CUSTOM resolution and resumed-plan compatibility. Update installers or file-discovery checks only where supporting files require it. Record before/after loaded text size for representative routes; do not equate line counts with paid token savings.
3. Retain the consolidated code-review structure while restoring explicit cache invalidation, long transactions, data backfills, batching/preloading/joins/projections, and priority for correctness/security/operational failures. Replace unclear style language with direct instructions. Preserve causal diagnosis, behavior characterization, proportional tests, and evidence-based findings.
4. Consolidate documentation guidance by responsibility: operation intake, workflow phases/permissions, skill methods and knowledge format, repository facts in docs. Add a bounded rule to update an invalidated loaded claim within authorized scope or identify that exact claim for later refresh. Avoid broad automatic documentation refreshes.
5. Extend the existing custom benchmark and corpus rather than creating another evaluation framework. Validate the pinned globalid-per-class-app task's setup, reference checks, and task evaluator in isolated temporary workspaces; distinguish expected base failures from setup failure. Add small public fixtures with private scoring rubrics for ownership/pattern discovery, causal diagnosis, stale-document correction, review defect detection/false positives, and follow-up knowledge reuse. Extend the existing benchmark contract to support read-only answer evaluation without requiring implementation patches. Keep task answers and hidden actual revisions out of candidate context. Leave other public corpus tasks pending unless actually validated.
6. Extend benchmark reporting with correctness/understanding/usefulness/user-effort/efficiency criteria, explicit reviewed quality verdicts, total task cost and time, cold-start/bootstrap/implementation/review/retry breakdowns, and amortized repeated-task cost. Require equivalent bootstrap for Sia revision comparisons and honest vanilla setup. Record host-reported input/output/cached/reasoning tokens and unavailable values without estimates; add offline accounting fixtures for totals and missing telemetry.
7. Update affected tests to assert structure, authority boundaries, selection, and meaningful failure cases. Remove redundant exact-prose assertions only in the touched areas; retain important negative cases and existing installer/host coverage. Add a repeatable route-loading size report without introducing a tokenizer or runtime dependency solely for this purpose.

Work is bounded to affected src/managed definitions and supporting resources, scripts/tests/benchmarks, product docs, the stale .ai/docs/overview.md claim, and the custom .ai/operations/benchmark.md, .ai/workflows/benchmark.md, .ai/skills/benchmark, and .ai/benchmarks corpus. Refresh installer-managed .ai files through ./install.sh after canonical edits. Do not read or modify other plan artifacts.

## Acceptance
- Reserved names and stale knowledge agree with the canonical protocol.
- Standard/Forge/phase loading reads only required guidance without losing authority, review, CUSTOM overrides, or resumability; required route text is measurably smaller where detail was moved.
- Concrete engineering checks remain explicit; no blanket review-depth reduction is accepted as efficiency evidence.
- Documentation instructions have clear owners and preserve verification/freshness requirements.
- The selected public benchmark task has inspected setup/check/evaluator evidence, or an exact environmental limitation; pending tasks never become certified by implication.
- New quality fixtures have explicit expected evidence, disallowed unsupported conclusions, and review precision/recall criteria where appropriate.
- Reports include total and amortized effort with honest unknown telemetry; offline tests detect faulty accounting and missing evidence.
- Full repository verification and independent final review pass; installed managed files match canonical source.

## Checks
Run focused routing, reserved-name, documentation, benchmark/accounting, and host regressions; existing benchmark fixture checks; then sh scripts/verify. Validate the selected public task in isolated temporary workspaces with bounded commands and inspected output. Run ./install.sh and inspect scoped source/projection diffs. Perform separate review, fix in-scope findings, and rerun affected checks. Do not claim live model improvement from these checks.

## Non-goals and risks
No new Sia runtime, plugin requirement, provider-specific protocol fork, wholesale test rewrite, broad corpus expansion, commits, pushes, or publishing. Moving instructions can create broken links or missing phase context; test every affected route. Benchmarks can leak answers or hide preparation cost; keep candidates separated and score the complete task. Actual model comparison and adoption claims remain pending until a model/access/cost budget is separately approved.

## External actions
Included: read public rails/globalid GitHub source at the manifest's pinned base and actual revisions, and install only its required development/test dependencies from their declared public sources into run-owned temporary storage. Use /tmp/sia-benchmark for isolated setup/evaluator evidence and dependencies; no production services, user-level package installation, credential changes, or external writes. Installer refresh is included. No live model calls are authorized by this plan. Retain evidence; remove only transient paths created by this work when needed for test cleanup.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base 68e4dfaa21ef4d31159a0dcdfc71ab292a16d8b0 -->
<!-- sia:approved e0bce274981513089d73ef3d912030a548919e9bb6c9a6b82aa4aa4d23b695da -->

<!-- sia:progress build: Implemented all seven scope items, including route support, restored engineering checks, documentation ownership, quality fixtures, and total-effort accounting. -->
<!-- sia:progress review-validate: Independent reviewers found three bounded gaps: ordinary discovery stale-claim reporting, GlobalID public setter specification, and local fixture intake/fingerprint defaults. -->
<!-- sia:progress fix: Resolved all three findings; both independent reviewers returned no remaining material findings. -->
<!-- sia:progress ship: Full verifier passed; final benchmark wording received six passing offline checks; installer refreshed and all 25 managed files match canonical source. -->

Validation: `sh scripts/verify` passed with source/behavior/approval/host/concise-output/benchmark and installer suites.
`git diff --check` passed. Final logs: `/tmp/sia-purpose-final-verify.log`. The public GlobalID base suite passed
166 tests/329 assertions; the reference suite passed 169/335. Its independent evaluator failed on the base for expected
missing task behavior and passed the reference with 6 tests/22 assertions. Durable evidence is retained in
`.ai/benchmarks/private/globalid-per-class-app/validation.json` and adjacent logs. Other corpus tasks remain pending.

`scripts/report-context --baseline-ref 68e4dfaa21ef4d31159a0dcdfc71ab292a16d8b0` reports a 6,198-word baseline common
definition bundle. Current words by route: trivial 4,371; lightweight 4,907; standard-plan/resume 5,181;
standard-execute 4,907; Forge intake 5,208; Forge execution 5,744. These static bundles exclude host/project/task context
and accumulated phases; they are not billed-token measurements or evidence of model improvement.

Standard route; approved external actions used only for the pinned public GlobalID validation and installer refresh.
No live model comparisons, commits, pushes, or publishing. Worker profile requested: reasoning; actual model, whether
the host honored that profile, and usage are unknown. Total public-task setup time was not instrumented and is unknown.
