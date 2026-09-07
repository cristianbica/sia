# Clear-output and simple-code benchmark

Compare the earlier response rules with the current response and code-simplicity guidance using twelve cases.
The baseline appends the previous response contract; the candidate extracts the current response rules from the
canonical protocol and the simplicity paragraph from delivery. Both run in the same installed Sia environment.
This is a comparison of task-level instructions, not a clean comparison of two complete Sia versions. Shared host
and installed instructions may influence both arms. Record the installed revision when interpreting results.

Validate cases without invoking a model:

```sh
benchmarks/concise-output/run.sh check
```

An explicit live run uses one smoke call, followed by two calls per case only if the smoke response succeeds:

```sh
benchmarks/concise-output/run.sh live /tmp/sia-concise-output
```

With twelve cases, live mode requires separate authorization for 25 model turns. Each call is independent, read-only,
bounded to 120 seconds by default, and receives `/dev/null` as standard input. Override the model, reasoning effort,
or timeout with `SIA_CONCISE_CODEX_MODEL`, `SIA_CONCISE_REASONING_EFFORT`, and `SIA_CONCISE_TIMEOUT_SECONDS`.
Use the same model and settings for both arms; compare separately for each model and repeat before drawing strong
conclusions. Live calls are not part of the ordinary verifier.

The result directory contains raw JSONL, final responses, stderr, exact-string assertions, metadata, and `results.tsv`.
Unknown token telemetry remains `unknown`. String checks are only a first pass, not evidence of semantic correctness.

Review every response using its case's `review` criterion. Fill the four pending columns in `results.tsv`:

- Readability, 1–5: 1 is unusable, 2 difficult to parse, 3 awkward, 4 clear with minor issues, 5 immediately understandable.
- Correctness, PASS/FAIL: required facts and behavior are correct, including necessary validation and safety boundaries.
- Scope, PASS/FAIL: the response completes the request without adding unrelated work or omitting requested detail.
- Simplicity, PASS/FAIL: wording is direct and code uses no unnecessary layers, options, dependencies, or defensive paths.

The three coding cases request code in the response and do not edit the repository. Inspect the returned code against
all stated inputs and failure cases, not merely the required strings. These cases assess proposed code; they do not
measure a model's full repository implementation workflow. Keep any execution of returned code separately sandboxed.

A candidate passes only when every fidelity check passes, every readability score is at least 4, and correctness,
scope, and simplicity pass for every case. Compare paired responses for actual improvement without regressions;
a tie is not evidence of improvement. Visible characters and tokens are diagnostics, not reduction targets. Requested
explanations and necessary error handling must survive. Until live comparisons are run and reviewed, report behavioral
improvement as unverified even when static checks pass.
