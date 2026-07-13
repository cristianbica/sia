---
name: benchmark
description: Compare a current Sia checkout with a hidden actual implementation and one optional comparator.
---

# Benchmark workflow

This workflow evaluates a repository task without exposing the actual implementation to candidate agents. It is
development tooling for this repository, not a shipped Sia workflow.

## Inputs and invariants

The task manifest is required and must provide a public task description, pinned base revision, hidden actual
revision or artifact, evaluator, setup and check commands, dependency constraints, and a bounded task scope. A
missing actual or evaluator blocks before any candidate command.

Required runtime input:

- `tool`: exactly `codex` or `claude`.

Optional runtime inputs:

- `model`: an exact host model identifier when the selected host supports one;
- `comparator`: omitted, `vanilla`, or exactly one `sia@<git-ref>` value;
- `run_id`: a unique safe identifier, generated when omitted.

The current Sia checkout is always the primary candidate. The actual implementation is always the oracle. A comparator
is optional but never more than one. Sia's internal `fast` and `reasoning` requests remain advisory; the host chooses
what it supports. Record the requested profile, requested model, and actual model separately.

Every run uses `/tmp/sia-benchmark/<run-id>/` for run-owned workspaces, logs, manifests, and evidence. The current
checkout is never used as a candidate target and is never modified by this workflow. Snapshot its HEAD, staged paths,
unstaged paths, and untracked paths before preparation; report the snapshot and preserve it through the run.

## Approval and safety gates

The `benchmark` operation is `explicit-only`. Before any workspace, install, dependency, network, model, evaluator,
or cleanup command, the coordinator presents the exact command, working directory, timeout, expected writes, external
systems, and run-owned paths for approval. A user selecting an exact model does not approve external access by itself.

Unattended mode can satisfy only gates explicitly included in its activating request. It cannot add network access,
credentials, paid services, production access, destructive actions, or broader cleanup. If an action needs authority
outside that ceiling, return `blocked` without asking the host to guess.

## Context and skill selection

Load the project-owned `.ai/skills/benchmark/SKILL.md` for scoring, evidence, and accounting guidance. Load only the
selected task manifest and the repository documentation needed to understand its setup and checks. Do not load an
actual patch, another candidate's artifacts, historical benchmark reports, or unrelated task manifests into a
candidate context.

The initial project-owned corpus is `.ai/benchmarks/MANIFEST.yml`; its public task prompts are under
`.ai/benchmarks/tasks/`. The manifest is coordinator input, not candidate context. In particular, never copy or load
its `source_url`, `actual_revision`, or `evaluator` fields into a candidate workspace.

## Select task

Read only the selected task manifest and the minimum repository metadata needed to validate it. Confirm the public task,
base revision, actual reference, evaluator, setup, checks, timeout, and supported environment. Reject private or
production-derived data, secrets, unsafe install scripts, unbounded services, or a task that requires an external
service the approved run cannot provide.

For the initial corpus, enforce one task per repository and SQLite for Rails applications. Treat setup and check
commands as proposed until the coordinator has run them in an isolated validation workspace; record that status in the
manifest evidence.

Record the task identifier, source URL, base revision, actual reference, task prompt, expected checks, and clean-room
exclusions. Do not inspect the actual patch, changed files, later commits, or another solution during selection.

## Prepare isolated workspaces

Create only run-owned paths below `/tmp/sia-benchmark/<run-id>/`. Materialize a detached target checkout from the pinned
base for each candidate. Strip remotes, later Git objects, credentials, host-agent files, Sia definitions, sibling
workspaces, and any implementation-equivalent evidence. The current Sia source snapshot is copied or referenced only
as the installer source for the primary candidate.

Install dependencies only when the approved task manifest and command plan name them. Run setup before candidate
prompts, record its output separately, and stop if setup crosses the clean-room boundary or requires an unapproved
service. Do not bootstrap or install Sia into the vanilla candidate.

## Run current Sia

Use a fresh supported host process for the primary candidate. Give it only the task prompt, clean-room instructions,
approved permissions, selected tool, selected model when supplied, and its isolated target workspace. The prompt must
not contain the actual revision, evaluator oracle, comparator identity, or sibling paths.

Before asking Sia to implement the task, bootstrap its repository documentation with the Sia `document repository`
operation. Run that bootstrap in the candidate target, record its elapsed time and evidence separately, and do not
include documentation work in the measured implementation time. If documentation bootstrap needs an unapproved action,
fails, or times out, stop or return `blocked` rather than silently continuing with an unrecorded context.

If Sia is installed in the target, use the current checkout snapshot and record its HEAD and dirty paths. Preserve the
normal Sia workflow and record selected route, route promotions, phase profiles, worker count, isolation mechanism,
wait behavior, process ID, exit status, timeout, changed paths, and host-reported usage.

## Run optional comparator

When `comparator` is omitted, skip this phase. For `vanilla`, run the same task directly through the selected host
without Sia. For `sia@<git-ref>`, install only that requested Sia revision into a separate target. Hold task, base,
tool, model request, permissions, timeout, setup, and checks constant. Never let the comparator read the actual or the
other candidate's workspace.

Wait for every candidate process to exit or reach its approved timeout, then confirm it is no longer running. Progress
events, JSONL output, and partial responses are evidence only; they never establish completion.

## Reveal and evaluate

Only after every candidate has exited, materialize the actual implementation in a separate run-owned workspace. Run the
approved evaluator and project checks against each candidate and the actual. Keep the actual patch and evaluator oracle
outside all candidate workspaces and never include them in candidate prompts.

Evaluate correctness and safety before efficiency. Use the `benchmark` skill's task-specific rubric. Distinguish
behavioral failures, missing tests, scope drift, unsupported claims, environment failures, and unavailable checks.
Record cache state as telemetry, not as a determinism guarantee. Unknown model or token fields remain `unknown`.

## Report

Write a report under the approved run-owned evidence path. Include task and revision metadata; candidate variants;
tool, requested model, actual model, and requested profiles; prompts and permissions; process and timeout evidence;
changed paths and checks; route, worker, wait, isolation, elapsed, and usage telemetry; correctness and code-quality
scores; failures; residual risk; and cleanup status. Separate setup or documentation bootstrap time from measured
implementation time. Do not claim a general conclusion from one task or one stochastic run.

## Cleanup and terminal states

After the report, perform only the exact approved cleanup of run-owned workspaces and processes. Preserve logs and
partial evidence on failure. Never delete current-repository files, unrelated temporary paths, or another run.

Return `complete` only when all required candidate processes and checks have terminal evidence, the actual was revealed
only afterward, the report is complete, and cleanup is verified. Return `blocked` for missing inputs, approvals,
environment support, or clean-room separation. Return `failed` for a non-successful runner, evaluator, or required
cleanup after preserving evidence. Cancellation stops run-owned processes, performs only approved cleanup, and reports
residual paths; it does not claim a score.

If the host cannot provide isolated workers, use separate fresh processes or bounded same-context execution only when
the command plan permits it, and report the actual isolation mechanism. Native delegation is never required for
benchmark correctness.
