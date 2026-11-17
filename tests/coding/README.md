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

To measure a change in Sia, use the previous and revised Sia in the two arms instead. Hold client settings and Sia mode
fixed. Start with the short question below, `currency` in Forge, and `sku-plan` outside Forge. Record the host version,
model, effort, Sia revision, and exact prompts for each run.

> What does `format_receipt` return for an order with no currency?

The answer should name `item` and the two-decimal `amount`. Confirm that the question leaves the workspace untouched.

Candidates run `python3 -B -m unittest discover -v` inside their own workspace. After each candidate exits, the
coordinator runs the command below from this Sia checkout. `BASE` is the candidate's commit hash after setup and before
the first prompt, including any seeded changes. Run candidate code only in the same approved disposable environment.
Keep sibling solutions, evaluator, manifests, and later Git history outside candidate access.

```sh
python3 -B tests/coding/evaluate.py TASK /absolute/candidate/path --scope-from BASE
```

The evaluator checks behavior and flags staged, unstaged, and unignored new paths outside the expected fixture paths.
Inspect flagged paths for a concrete need. Inspect allowed hunks for unnecessary helpers, fallbacks, or unrelated edits
within the same file. For `currency`, a new converter is out of scope and regression coverage for missing currency
supports the existing contract. Generated or ignored artifacts that matter to the request need separate inspection.
The approval check covers plan artifacts separately from the path check.

Capture the assistant's task messages, command output, and diff. Score each task using these observations.

- For prose, count words and mark repeated summaries or routine narration across progress, plan, and final messages.
  Record user turns spent correcting scope or asking the assistant to finish. Check that decisions and errors are clear.
- For tool output, record repeated reads and unnecessarily broad commands. Capture command output and, if available,
  what the client displayed.
- For the diff, record changed paths and count unrelated edits and unnecessary mechanisms after reviewing the hunks.
  Record behavior checks, approval timing, and any skipped, repeated, or unavailable checks. Reject a shorter result
  that loses required information, verification, or correctness.

Keep ties and regressions in the comparison. Mid-task steering and background-result scenarios have their own
[continuation evaluation](../behavior/routing/fixtures/model-continuation.md).

## Offline readiness

`python3 -B tests/coding/test_fixtures.py` verifies that each original task fails its new behavior checks and that a
small working change passes those checks and the existing tests. It also verifies that a behavior-passing change
fails the path check when unrelated staged, unstaged, or new files are present. The verifier runs this without models.
Live comparisons are separate and currently unverified; no API calls are authorized by fixture readiness checks.
