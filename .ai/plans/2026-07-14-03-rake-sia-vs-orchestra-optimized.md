---
id: 2026-07-14-03-rake-sia-vs-orchestra-optimized
operation: benchmark
workflow: benchmark
execution_mode: interactive
status: complete
tool: codex
model: gpt-5.6-terra
reasoning_effort: medium
task: rake-direct-loader-options
comparator: sia@next (Orchestra)
run_id: 20260714-rake-direct-loader-options-codex-terra-orchestra-next-optimized
base_ref: fb89ebb946cd08195232c08a9762b78010e4ba8e
staged_paths: []
unstaged_paths:
  - .ai/workflows/benchmark.md
  - docs/implementation.md
  - docs/orchestration.md
  - src/managed/.ai/operations/sia/implement.md
  - src/managed/.ai/sia.md
  - src/managed/.ai/skills/sia/testing/SKILL.md
  - src/managed/.ai/workflows/sia/delivery.md
  - tests/behavior/routing/static-contracts.sh
  - tests/behavior/workflows/static-contracts.sh
untracked_paths:
  - .ai/plans/2026-07-13-02-token-usage-optimization.md
  - tests/behavior/routing/fixtures/lightweight-source-fix.md
authorized_external_actions:
  - GitHub network access for pinned Rake and Orchestra sources
  - dependency installation below the run-owned workspace
  - four Codex model runs using gpt-5.6-terra at medium reasoning effort
  - run-owned workspace and temporary credential-home cleanup
next_phase: none
---

# Benchmark plan: optimized Sia versus Orchestra next

## Outcome

Benchmark the current dirty Sia checkout against Orchestra branch `next` on the Rake direct-loader-options task. The
actual implementation remains hidden from candidates until both terminate. Report correctness and quality before token
telemetry; documentation bootstrap remains separate from implementation usage.

## Candidate contract

- Primary: current Sia checkout at `fb89ebb946cd08195232c08a9762b78010e4ba8e` plus the listed dirty changes.
- Comparator: Orchestra `next`, pinned from its remote at run time and recorded in evidence.
- Host: `codex`, model `gpt-5.6-terra`, medium reasoning effort, 1,200-second timeout per model process.
- Both candidates receive the same task and validation instruction: run proportionate focused checks only; the
  coordinator runs broad manifest checks after candidate exit.
- Sia first runs `Sia document repository`; its model usage and elapsed evidence are reported separately.

## Exact command plan and effects

All paths below are under `/tmp/sia-benchmark/` with the run ID
`20260714-rake-direct-loader-options-codex-terra-orchestra-next-optimized`.

1. Create run-owned evidence, prompt, temporary Codex-home, and candidate-workspace directories; copy the existing
   Codex authentication file into the temporary 0700 home. This writes only the run directory.
2. Query and clone Orchestra `next`; initialize detached Rake workspaces at base
   `f7e9df5ac0ebae1c4c46383ead9d963dfec1b57f`; remove remotes and run Git integrity checks. This uses GitHub network
   access and writes only run-owned workspaces.
3. Run `bundle install` and baseline `bundle exec rake test` in each candidate workspace; install current Sia locally
   into its candidate and Orchestra locally into its comparator. These install dependencies only below the run root.
4. Run four model commands, each as
   `timeout --signal=TERM --kill-after=20 1200s codex exec --ephemeral --ignore-user-config --sandbox workspace-write
   --config approval_policy=never --config model_reasoning_effort=medium --model gpt-5.6-terra --color never --json`:
   Sia documentation bootstrap, Sia implementation, Orchestra plan, and Orchestra implementation with the produced
   approved plan. Model prompts remain inside the target workspace and exclude the actual revision, patch, evaluator,
   comparator identity, sibling paths, and coordinator manifest.
5. After all candidates exit, capture their diffs and run the full Rake test suite; materialize the hidden actual at
   `3ec8c35c64187501c01c85e8980d74caea62546e`, run its dependency install and full test suite, then evaluate task
   contract, tests, scope, and code quality. The actual patch is never supplied to candidates.
6. Write the report and evidence under the run root. Remove only candidate workspaces, cloned Orchestra source, and the
   temporary Codex home; retain logs, prompts, diffs, telemetry, report, and cleanup receipt.

## Approval required

This plan requires explicit approval for GitHub network access, dependency installation, four paid model runs, and the
listed run-owned cleanup. It authorizes no repository mutation, credential change, commit, push, or action outside the
run root.

## Failure handling

Stop and preserve evidence if setup, clean-room isolation, a model process, evaluator, or cleanup fails. Do not reveal
the actual implementation early, retry with a changed model, or remove non-run-owned paths.

## Approval evidence

- The user approved this exact displayed plan for the listed network, dependency, model, and cleanup actions.

## Completion evidence

- All four model processes exited successfully before actual reveal; both candidate full suites and the hidden actual
  full suite passed.
- Report and raw evidence are under `/tmp/sia-benchmark/` with run ID
  `20260714-rake-direct-loader-options-codex-terra-orchestra-next-optimized`.
- The initial sandbox launcher ended during comparator dependency installation before any model call. The persistent
  runner resumed the preserved root and completed candidate and actual evaluation; it then exited nonzero before its
  scripted cleanup, so cleanup was separately completed and verified within the same approved run root.
- Candidate workspaces, temporary Sia source snapshot, cloned Orchestra source, and temporary Codex home were removed;
  evidence, prompts, runner scripts, report, and cleanup receipt were retained.
