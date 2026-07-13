---
name: benchmark
description: Compare the current Sia checkout with a hidden actual implementation and one optional comparator.
workflow: benchmark
skills:
  - benchmark
---

# Benchmark

Run an explicit, clean-room benchmark of the current Sia checkout. This operation is development tooling for this
repository; it does not change Sia's shipped source or install benchmark behavior into other repositories.

## Invocation policy

- Mode: `explicit-only`.
- Allowed roles: `builder`.
- Requires approval before execution: yes.
- Requires separate approval for network access, dependency installation, model runs, and cleanup.
- Enclosing route/plan requirement: an approved benchmark run command plan; no product or source mutation is authorized.

## Inputs

Required:

- `tool`: exactly `codex` or `claude`;
- `task`: a curated task identifier or manifest containing a pinned base, hidden actual implementation, evaluator,
  setup, and project checks.

Optional:

- `model`: an exact model identifier supported by the selected host;
- `comparator`: omitted, `vanilla`, or one `sia@<git-ref>` value;
- `run_id`: a unique safe run identifier.

The actual implementation is mandatory for every run and is always evaluated, even when no comparator is selected. The
current working tree is the primary Sia candidate. A comparator is never allowed to exceed one value. Sia's internal
`fast` and `reasoning` profile requests remain advisory and are recorded separately from the actual model.

The initial project-owned corpus is `.ai/benchmarks/MANIFEST.yml`. Its task prompts are under
`.ai/benchmarks/tasks/`. The manifest's `source_url`, `actual_revision`, and `evaluator` fields are coordinator-only;
they must never be passed into a candidate workspace or prompt.

## Intake and validation

Resolve the task manifest before execution. Reject missing or ambiguous actual references, evaluators, base revisions,
checks, unsafe setup, private or production-derived data, unsupported services, invalid tools, malformed models, or a
comparator that is neither `vanilla` nor `sia@<git-ref>`. Snapshot the current Sia HEAD, staged paths, unstaged paths,
and untracked paths; do not silently discard or clean them.

The project corpus currently enforces one task per repository and no external runtime services. Rails application tasks
must use SQLite. A task remains pending until its pinned setup and checks have been validated by the coordinator; do not
present pending commands as already verified.

Use the `benchmark` workflow for all preparation, candidate execution, actual reveal, evaluation, reporting, and
cleanup. Do not run a benchmark, model, dependency install, network command, or external repository command during
input validation. Do not expose the actual patch, evaluator oracle, or comparator workspace to a candidate.
For the current Sia candidate, the workflow must run `document repository` before the implementation prompt and report
that bootstrap separately from implementation time.

## Outcome

Report the run-owned evidence path, task and revision metadata, candidate variants, requested and actual model fields,
route and worker telemetry, process and timeout evidence, changed paths, checks, correctness and code-quality scores,
usage and cache state, failures, residual risks, and cleanup status. Use `unknown` for unavailable host telemetry and
never infer a score when clean-room separation or required evidence failed.

If a required input, approval, environment capability, or clean-room guarantee is missing, return `blocked` before
external execution. Preserve partial evidence and return `failed` for a runner, evaluator, or required-cleanup failure.
