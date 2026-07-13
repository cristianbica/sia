---
name: benchmark
description: Design and evaluate clean-room coding-agent benchmarks against hidden actual implementations.
use_when:
  - comparing Sia with a direct host run or another Sia revision
  - evaluating correctness, code quality, or workflow efficiency
  - preparing benchmark evidence for a repository task
---

# Benchmark

Use this skill to make benchmark evidence comparable and honest. It supplies evaluation expertise; the `benchmark`
workflow owns phases, gates, isolation, and cleanup.

## Method

1. Pin a task manifest with its public task description, base revision, actual/reference revision, evaluator, setup,
   checks, language, and dependency constraints.
2. Prepare identical clean-room target workspaces from the pinned base. Remove later Git objects, remotes, credentials,
   and implementation-equivalent evidence before candidate agents run.
3. Run the current Sia checkout as the primary candidate. Run at most one comparator: direct host (`vanilla`) or a
   separate Sia revision (`sia@<git-ref>`). Hold task, tool, model request, timeout, permissions, and checks constant.
4. Keep the actual implementation hidden until every candidate process exits and its exit state is confirmed.
5. Evaluate behavior against the task contract and actual reference. Never score textual similarity as correctness.

## Scoring

Score correctness and safety before efficiency. Use task-specific weights for behavior and data semantics, integration
and public contracts, tests, authorization or isolation, architecture, and code quality. Report missing behavior,
unsupported assumptions, scope drift, regressions, and unrun checks separately from optional improvements.

## Accounting

Record the candidate source revision and dirty paths, task and base revisions, tool, requested model, actual model,
requested profile, route, route promotions, worker count, isolation mechanism, wait behavior, elapsed time, changed
paths, checks, and host-reported usage. Record input, cached-input, output, and reasoning tokens only when reported;
otherwise use `unknown`. Cache state is an efficiency measurement, not an output-reproducibility guarantee.

Run repeated trials when a conclusion depends on noisy timing or model behavior. Report pass rate, score distribution,
and median or range instead of presenting one run as universal evidence.

## Evidence

Preserve prompts, manifests, workspace fingerprints, process IDs, exit status, timeout results, raw logs, evaluator
results, diffs, and cleanup status under the run-owned evidence path. Separate setup or documentation bootstrap cost
from measured implementation cost. State when a runner, model, token field, or check was unavailable.

Never let a candidate read the actual patch, later commit, evaluator oracle, another candidate workspace, or a sibling
solution. If clean-room separation or task provenance cannot be established, block the run rather than inferring a
score.
