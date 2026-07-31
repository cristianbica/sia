# Concise-output benchmark

This focused benchmark compares the current Sia response behavior with one concise natural-English contract.

Validate the eight JSONL cases without invoking a model:

```sh
benchmarks/concise-output/run.sh check
```

An explicit live run uses one smoke call. Only a successful, nonempty smoke response starts the sixteen comparison
calls:

```sh
benchmarks/concise-output/run.sh live /tmp/sia-concise-output
```

Live mode requires separate authorization for 17 model turns. Each call is independent, read-only, bounded to 120
seconds by default, and receives `/dev/null` as standard input. Override the model, reasoning effort, or timeout with
`SIA_CONCISE_CODEX_MODEL`, `SIA_CONCISE_REASONING_EFFORT`, and `SIA_CONCISE_TIMEOUT_SECONDS`.

The result directory contains raw JSONL, final responses, stderr, exact-string assertions, metadata, and `results.tsv`.
Unknown token telemetry remains `unknown`.

Review every response and replace `pending` in the final column with a natural-English score:

- 5: clear, natural, and immediately usable;
- 4: natural with a minor wording issue;
- 3: understandable but noticeably awkward;
- 2: difficult to parse;
- 1: caveman, telegram-style, or unusable.

The candidate is eligible for integration only when all fidelity checks pass, every natural-English score is at least
4, median visible characters fall by at least 25%, output tokens decrease when reported, and no extra task turn is
introduced.
