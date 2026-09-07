# Clear-output and simple-code benchmark

Compare a fixed earlier response contract (`baseline.txt`) with the current canonical response and code-simplicity
paragraphs using twelve cases. Each independent call runs in a fresh neutral directory outside the repository.
Neither arm loads the installed Sia projection. Both receive the same explicit facts from `context.txt`; the candidate
cannot silently influence the baseline through shared Sia instructions. This measures response-contract changes,
not two full Sia releases or repository implementation behavior.

Validate cases and runner behavior without invoking a model:

```sh
benchmarks/concise-output/run.sh check
python3 benchmarks/concise-output/test_runner.py
```

Explicit live examples (each requires its own provider/model/access/cost authorization):

```sh
benchmarks/concise-output/run.sh live /tmp/sia-codex-comparison --host codex --model gpt-6-astra --effort high --repetitions 3
benchmarks/concise-output/run.sh live /tmp/sia-claude-comparison --host claude --model claude-fable-5-1 --effort high --repetitions 3
```

Model names are requested identifiers, not a claim of account availability. Specify both model and effort; effort
labels are not comparable across providers. Compare baseline/candidate within each model/effort setting first.
A run makes at most `24 × repetitions` independent calls, stopping at the first unavailable result. There is no extra
smoke call. Calls have a 120-second timeout (`--timeout` overrides it), receive `/dev/null` as stdin, and alternate arm
order by repetition. Captured output is capped at 4 MiB per call; overflow (125) and timeout (124) stop the
process group and produce an unavailable result. Live calls are never part of the ordinary verifier.

Codex uses its read-only sandbox, a private temporary CODEX_HOME containing only an authentication-file copy when
present, and ignores user configuration/rules. Claude uses safe mode, no tools or skills, no session persistence, and
explicit empty settings/MCP configuration. Neither changes the real user HOME. Required CLI flags are checked using
local help; unsupported flags, absent credentials, provider failures, or missing final responses produce
`UNAVAILABLE` (exit 2), with evidence retained. Host built-in instructions and administrator policies still apply;
these are CLI evaluations, not bare API model comparisons. Codex tool capability is not disabled by its read-only
sandbox; tasks explicitly forbid tool use, and reviewers should inspect traces for violations.

Artifacts preserve exact instruction snapshots and SHA-256 hashes, source revision, requested model/effort, host
version, commands, prompts, raw output, stderr, per-call metadata, assertions, `results.tsv`, and paired links in
`review.md`. Actual model identity and token usage remain `unknown` unless explicitly reported. The revision alone
does not identify uncommitted instruction changes; use the snapshots and hashes. Failed runs are incomplete comparisons.

Review every response against its case criterion. Fill the pending readability (1–5), correctness, scope, and simplicity
columns. A candidate passes only when all fidelity checks pass, every readability score is at least 4, and correctness,
scope, and simplicity all pass. Readability 1 means unusable, 2 difficult, 3 awkward, 4 clear with minor issues, and 5
immediately understandable. Check required facts, validation, safeguards, task completion, and unnecessary code layers.
Mark each pair improved, tied, or regressed with a reason; ties do not demonstrate improvement. Length/token counts
are diagnostics rather than reduction targets. Exact strings alone cannot establish semantic correctness.

The three coding cases produce proposed code only. Inspect their full input and failure requirements, including very
long input for port parsing. Use `scripts/verify-approval` and its documented implementation/continuation cases for
actual repository edits, authorization, repeated checks, and tool-trace evidence; this benchmark does not duplicate
that infrastructure. Until budgeted live comparisons are completed and reviewed, behavioral improvement is unverified.
