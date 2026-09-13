# Coding comparison tasks

Three independent tasks use this small Python repository. They test changing an existing formatter, fixing duplicate
processing, and explaining then implementing a change across two modules. No network, services, or dependencies are
needed. No historical user outputs are required.

`tasks.json` contains the developer requests. `workspace/` is the only candidate repository content. The evaluator
and fixture tests stay outside candidate access: they contain private checks and example solutions. These examples
verify that the tasks are solvable, not that one patch is the only correct answer.

## Prepare and run

After agreeing to model access and a run limit, copy `workspace/` into separate disposable Git repositories for Sia
and the host alone. Start both from that same content. Install the candidate Sia source only into its arm. Give each
the same request, prefixing Sia's request with `Sia implement`. Use the same host, model, effort, permissions, and
check instruction. Use fresh sessions for each task; for `sku-plan`, deliver its approval in the same session only
once its plan has been inspected and captured. A plan response must explain the affected code and approach, not just
repeat the goal. Verify no source edits happened before approval.

Candidates run `python3 -B -m unittest discover -v` inside their own workspace. After each candidate exits, the
coordinator runs `python3 -B tests/coding/evaluate.py TASK /absolute/candidate/path` from this Sia checkout. Run
candidate
code only in the same approved disposable environment. Keep sibling solutions, evaluator, manifests, and later Git
history outside candidate access. This document is instructions for the evaluator, not candidate context.

Keep exact prompts/settings, source revision and dirty patch, outputs, diffs, test results, and corrective user turns.
Record whether requested behavior works, whether unrelated behavior changed, and whether new files, abstractions,
options, or features were necessary. Each task is solvable by editing existing functions; additional machinery needs
a task-specific reason. Count corrections and manual edits rather than awarding points for Sia terminology or brevity.
Inspect both results, including ties and regressions. These small tasks can reveal problems, not certify all coding.

## Offline readiness

`python3 -B tests/coding/test_fixtures.py` verifies that each original task fails its new behavior checks and that a
small working change passes those checks and the existing tests. It invokes no model. The full verifier includes it.
Live comparisons are separate and currently unverified; no API calls are authorized by fixture readiness checks.
