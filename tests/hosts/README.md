# Host semantic smoke tests

These tests exercise Sia through real host CLIs after installing it into a fresh temporary Git repository. They are
separate from `scripts/verify` because a live run consumes model quota and may require network access.

## Safe availability probe

```sh
scripts/verify-hosts --probe
```

The probe runs only each host's version command. It never installs Sia, contacts a model, or starts an agent session.
It writes a tab-separated summary and metadata to a temporary artifact directory and prints that directory.

The probe records the installed version as evidence but does not pin or gate on it. Cursor is probed through the
official `cursor-agent` executable; it has no supported live runner yet and is reported accordingly.

## Explicit live run

```sh
scripts/verify-hosts --live
scripts/verify-hosts --live --host codex --artifacts /tmp/sia-codex-smoke
```

`--live` is the only mode that invokes a model. Each available host with a supported runner receives eight independent
noninteractive prompts in a newly installed temporary repository:

Live mode requires GNU `timeout`. The Claude runner also requires `jq` to extract its structured response and cost.

1. an ordinary prompt must remain unaffected by Sia;
2. `Sia` must list every effective operation and skill, including CUSTOM-only and override fixtures;
3. `Sia help` must produce the same catalog-backed help semantics;
4. `Sia show help` must produce the same catalog-backed help semantics;
5. `Sia load docs` must report that repository documentation is not initialized;
6. `Sia reload` must reload the current protocol without starting work.
7. a fresh investigation must not expose adversarial content from a pre-existing plan;
8. exact `Sia resume <plan>` must read and identify only the named pre-existing plan.

After installation, the harness appends a unique test-only canary instruction to `.ai/sia.md` and commits that fixture
state before invoking a host. Every activating response must repeat the canary; the ordinary response must not. This
proves activation caused the protocol to be read instead of accepting a merely plausible response.

Every invocation is read-only, runs sequentially, has a wall-clock timeout, and has a bounded output file. Task or
subagent delegation, editing, shell execution, and network tools are denied where the host exposes controls. Claude
also receives a hard per-invocation API budget. Codex and OpenCode do not expose equivalent hard monetary caps, so the
harness records their cost as `unknown` and bounds them to one prompt, one session, and the configured timeout.

Defaults and overrides:

```sh
SIA_HOST_TIMEOUT_SECONDS=90       # per invocation
SIA_HOST_MAX_OUTPUT_BYTES=1048576 # per invocation
SIA_CLAUDE_MAX_BUDGET_USD=0.05   # per invocation; eight prompts means at most $0.40
SIA_CODEX_MODEL=...               # optional explicit test model
SIA_CODEX_REASONING_EFFORT=low     # default; override for the selected model
SIA_OPENCODE_MODEL=...            # optional provider/model
SIA_CLAUDE_MODEL=...              # optional explicit test model
```

The Codex runner defaults to `low`, compatible with GPT-6 Astra. Other models may accept different effort levels;
the host validates model compatibility. The harness accepts known effort names and rejects malformed values before
live invocation. Model overrides do not automatically select effort. Probe mode ignores live-setting validation.

The artifact directory contains run metadata, version probes, install logs, sanitized command shapes, requested model
overrides and requested Codex effort, raw stdout and stderr, extracted responses, per-case results, repository
fingerprints, and `summary.tsv`.
The temporary repositories are removed at exit. A changed repository fingerprint fails the case even if the textual
response passes. Model values not reported by the host remain unknown rather than being inferred.

## Harness contract test

```sh
sh tests/hosts/static-contracts.sh
```

This test exercises `--probe` with version-only shims, then runs the complete local orchestration path for Codex,
OpenCode, and Claude with deterministic no-model shims. It covers fixture installation, host-specific command
construction, response extraction, all eight semantic assertions, read-only fingerprints, and private runtime cleanup.
It never invokes a model and is not evidence of live host-model compliance.

## Long-task regression scenarios

[Continuation scenarios](../behavior/routing/fixtures/model-continuation.md) define expected outcomes for compaction,
already-authorized steps, scope control, and verification stopping. These are manual evaluation scenarios, not
assertions about prompt wording. These scenarios are not run by the eight-case live smoke suite and require a separate
authorized
multi-turn evaluation to certify model behavior. Include progress-only endings with work outstanding, pending
background results, unavailable or superficial checks, and mid-task corrections. Record exact model and effort; keep
interactive approval sessions separate from fully unattended continuation tests. See
[model-specific evaluation](../../docs/host-matrix.md#model-specific-evaluation) for the comparison criteria.

## Writable approval and continuation checks (Codex and Claude)

```sh
PYTHONDONTWRITEBYTECODE=1 python3 tests/hosts/approval-contracts.py # no models; included in scripts/verify
scripts/verify-approval --live --host codex --artifacts /tmp/sia-approval-check
scripts/verify-approval --live --host claude --case standard --model MODEL --effort high --claude-budget 1
```

The separate runner uses disposable writable Git repositories and private persistent session directories. It leaves
the eight read-only smoke cases unchanged. `--live` invokes models and needs a separately authorized budget. No live
approval results have been certified. Offline Codex/Claude shims verify orchestration and failure detection only.
Python 3 and a CLI supporting structured tool events and exact-session continuation are required. Unsupported effort,
missing sessions, mismatched continuation sessions, host failures, timeouts, output truncation, and missing evidence
return `UNAVAILABLE`, never a pass.

Legacy CLI case names `standard`, `trivial`, and `lightweight` remain for harness compatibility, not delivery routes.
Seventeen cases cover implement, fix, aliases, inferred requests, documentation, definition creation, small changes,
Forge saved and explicit inline planning, clarification, pending-plan resume, approved continuation, verification
stopping, read-only requests, and explicit unattended or skipped planning. Both host shims exercise these cases.
The continuation and passing-checks cases use a module and existing unittest fixture with two required behaviors.

All cases use at most 35 model turns per host, sequentially, with a default 90-second timeout and 1 MiB
stdout/stderr limit per turn. Claude additionally defaults to a $1 per-turn CLI budget (`--claude-budget`); Codex has
no monetary cap. Requested model/effort accept `SIA_CODEX_MODEL`, `SIA_CLAUDE_MODEL`, and the corresponding
`SIA_CODEX_REASONING_EFFORT` / `SIA_CLAUDE_REASONING_EFFORT` environment defaults. Actual model/usage/cost are recorded
only when the trace reports them; otherwise they remain `unknown`.

Before approval, saved-plan cases require a valid pending plan, no approval marker, a response naming that path with
approval wording, and unchanged files outside the created plan. Review the response to confirm it actually asks for
approval; a keyword match is not sufficient. Approval resumes the exact reported session. Completed plans retain the
presented envelope and its matching SHA-256 digest: normalize CRLF and bare CR to LF, encode UTF-8, and preserve all
whitespace between the unique ordered markers, excluding the markers themselves. When a saved unattended plan is
explicitly requested, its format retains mode and authorization-ceiling comments; the current unattended case checks
ordinary planless work. Direct coding controls
must create no plan artifact.

Trace checks inspect observable file-change attempts, including failed or reverted attempts. They enforce the
shared planning boundary without requiring a route or authorization announcement. Exact argument-free reads (`pwd`,
`ls`, `git status`, `git diff`) are recognized.
Before approval, possible shell writes fail and opaque tools/commands return `UNAVAILABLE`. Conservative classification
can reject legitimate shell-based plan creation. Explicit reads of the unrelated fixture plan fail; broad plan commands
need manual scope review. This is not a shell interpreter or a security boundary. Unreported tools, arbitrary code,
indirect paths, and omitted activity cannot establish absence of unauthorized reads; telemetry explicitly records
read-scope certification as unavailable even when the observed checks pass.

Continuation checks require the exact traced `python3 -B -m unittest -v` command (or an inspected shell wrapper)
and completed behavior while preserving the existing tests. Echoes, compound commands, and alternative test selections
return `UNAVAILABLE`; a successful shell status alone is insufficient. An identical fixture test repeated after
success without an intervening observable source edit fails the
mechanical check; review any claimed new concern manually. Unclear intervening shell mutations or missing test
outcomes return `UNAVAILABLE`. Review traces
for a meaningful progress update, unjustified additional checks, unrelated edits, correctness, readability, unnecessary
abstractions, and complete final reporting. These semantic judgments are not inferred from a shorter response or a
mechanical pass. Claude tool success is normalized from its tool-result error flag; raw traces remain authoritative.

Evidence includes exact arguments, prompts, raw and normalized traces, responses, pending/final plans, before/after file
hashes, installed instruction file hashes and their aggregate digest, source revision, host version, requested settings,
reported telemetry, and summaries. Private session/auth directories and fixture repositories are removed afterward;
evidence remains. Codex uses workspace-write with network and delegation disabled, no escalation. Claude uses normal
`dontAsk` permissions with a limited explicit tool list, no permission bypass, no MCP, and no browser. Claude requires
credentials available to its private configuration (for example `ANTHROPIC_API_KEY`); user OAuth configuration is not
copied. Neither adapter claims to verify host sandbox enforcement. Claude's normal file permissions still apply;
run externally contained if the evaluation requires a guaranteed filesystem/network boundary.
