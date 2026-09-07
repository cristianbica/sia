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
already-authorized steps, scope control, and verification stopping. Static contracts check that guidance and scenarios
remain present. These scenarios are not run by the eight-case live smoke suite and require a separate authorized
multi-turn evaluation to certify model behavior.

## Writable approval checks (Codex)

```sh
PYTHONDONTWRITEBYTECODE=1 python3 tests/hosts/approval-contracts.py # no models; included in scripts/verify
scripts/verify-approval --live --artifacts /tmp/sia-approval-check
scripts/verify-approval --live --case standard --model MODEL --timeout 90
```

The separate approval runner uses disposable **writable** Git repositories and private persistent Codex session data.
It leaves the eight read-only smoke cases unchanged. `--live` explicitly invokes models; no live approval results have
been certified. The no-model tests use a local Codex shim and validate orchestration and failure detection only.
Python 3 and a Codex CLI supporting JSON events and exact-session `exec resume` are required for live runs.

Six cases cover a standard public-contract implementation request followed by approval of its exact saved plan;
trivial and lightweight direct work; Forge direct work; Forge inline planning followed by approval; and explicitly
unattended standard delivery. Forge cases first enable Forge in the same session. All six cases require at most ten
model turns, sequentially, each with a default 90-second timeout and 1 MiB stdout/stderr limit. There is no monetary
cap;
cost and unreported actual model identity remain `unknown`. Model and effort flags also accept the existing
`SIA_CODEX_MODEL` and `SIA_CODEX_REASONING_EFFORT` defaults. These calls need a separately authorized budget.

Before approval, the standard case requires one valid pending plan, no approval marker, a response naming that path
with approval wording, and unchanged files outside `.ai/plans/`. Review the recorded response to confirm it actually
asks for approval; a keyword match alone cannot establish that. Approval resumes the exact reported session;
missing session IDs, unsupported continuation, host failures, timeouts, truncated output, or incomplete traces are
`UNAVAILABLE`, never a pass. Completed standard plans must retain the presented envelope and contain its matching
SHA-256 approval digest. The runner normalizes CRLF to LF and hashes all bytes between markers, preserving leading
and trailing whitespace. Unattended plans must include their mode, authorization ceiling, valid digest, and completion.
Planless controls must finish the requested behavior without creating a saved plan.

Trace checks inspect file-change attempts, including attempts that failed or were reverted, and require a prior
route/authorization announcement. Before approval, only recognized read commands and patches targeting plan files
pass automatically. Possible shell writes fail; opaque commands/tools require manual review and return `UNAVAILABLE`.
This conservative check can reject legitimate shell-based plan creation. It is not a general shell interpreter or a
security boundary: arbitrary command intent, hidden host tools, writes outside the fixture, and omitted trace activity
cannot be certified. After approval, command/tool activity requires an announcement; filesystem checks and the greeting
assertion verify the requested result. These checks do not establish semantic completeness of every inline receipt.

Evidence includes command arguments, prompts, JSON traces, responses, pending/final plans, before/after file hashes,
result summaries and requested settings. Repositories and private session/auth files are removed afterward; evidence
remains. Live calls use the workspace-write sandbox with network disabled, no permission escalation, and delegation
disabled. This runner neither expands host permissions nor verifies host sandbox enforcement.
