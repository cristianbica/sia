---
operation: implement
workflow: delivery
skills:
  - repository-discovery
  - testing
  - code-review
---

<!-- sia:approval:start -->
Update Sia's canonical prompts for GPT-6, GPT-6.1 Sol, and Claude Opus/Sonnet 5.5 while preserving its interactive saved-plan approval boundary. The current definitions already use narrow skill triggers, bounded discovery, optional delegation, and proportionate verification. Refine the remaining behavioral gaps instead of adding model-specific procedural scaffolding to every task.

- In `src/managed/.ai/sia.md` and `src/managed/.ai/workflows/sia/delivery.md`, distinguish preparing and waiting for required approval from continuing approved work. Carry independent authorized work through nonblocking questions, side questions, and progress reports. Stop for a genuine blocker, changed authorization, or completion; stop adding work when the request is fulfilled.
- Clarify completion evidence in the delivery workflow and saved-plan support: a progress report does not complete an operation while required work or relevant background results remain outstanding. An unavailable required check must be disclosed and must not be represented as a passing completion requirement. Keep unattended limits and approval requirements intact.
- In `src/managed/.ai/skills/sia/testing/SKILL.md`, require checks that exercise the changed behavior, distinguish failed-to-start or superficial checks from successful verification, and retain the existing rule against repeated or expanded checking without new evidence. Keep verification proportional to prompt-only and documentation changes.
- Update `docs/orchestration.md`, `docs/integration.md`, `docs/host-matrix.md`, and, where directly relevant, `docs/prompt-caching.md`. Cite official guidance for the named models. Explain effort calibration, Opus 5.5 text-only early stops, Claude progress-block rendering, genuine mid-task user messages, and preserved-thinking history as host responsibilities. Describe bounded unattended continuation as optional integration guidance, without adding a runtime, completion checker, required checklist artifact, or automatic retry implementation.
- Extend `tests/behavior/routing/fixtures/model-continuation.md` and the nearby host/coding evaluation guidance with scenarios for premature progress-only termination, unavailable checks, mid-task corrections, scope expansion, and model/effort comparisons. Use existing textual contract tests only for critical approval, completion, and verification invariants, including weakened variants where useful. These checks and scenarios cannot establish live model compliance.
- Audit shipped skill descriptions and duplicated guidance. Keep already precise triggers unchanged; simplify only redundant instructions directly related to these changes. Do not add mandatory delegation, model selection, unrelated refactors, or exposed chain-of-thought requirements.

Run the focused contract checks and `sh scripts/verify`, inspect the resulting diff against the original request, then run `./install.sh` to refresh the installed dogfood projection and inspect its generated changes separately. Preserve CUSTOM content and project-owned files. Review using the effective code-review and testing skills, address in-scope defects, and record completion evidence in this plan.

This approval covers the canonical prompt/doc/test changes above and installer refresh in this repository. It does not cover live model/API runs, paid evaluation, commits, pushes, publication, or changes to host model defaults. Report live efficacy as unverified until separately authorized comparisons have been run.
<!-- sia:approval:end -->

<!-- sia:approved 3472cdce0900a892290142d8053b10e9cfd15a645d326ee34f2be2e9cacb07e0 -->
<!-- sia:status complete -->
<!-- sia:base aff7ee31729ba03d3e2f14e689f67e63082fcfd2 -->
<!-- sia:progress Canonical prompts, host guidance, and regression scenarios updated; focused contracts passed. Full verifier found Markdown line wrapping issues, corrected before rerun. -->
<!-- sia:progress Review passed against original request and approved scope. Focused contracts: 6 tests passed; sh scripts/verify passed all static, activation, routing, coding fixture, host shim, approval harness, accounting, installer, and bootstrap checks. git diff --check passed. Skill trigger audit required no trigger changes. -->
<!-- sia:progress Local ./install.sh refresh passed after sandbox permission for its temporary Git lock. All managed projection files match source; preservation checks passed for 17 project-owned files/catalog sections. Approval digest remains valid. No live model/API comparison, host default change, commit, push, or publication performed; live efficacy remains unverified. -->
