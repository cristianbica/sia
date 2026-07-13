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

`--live` is the only mode that invokes a model. Each available host with a supported runner receives four independent
noninteractive prompts in a newly installed temporary repository:

Live mode requires GNU `timeout`. The Claude runner also requires `jq` to extract its structured response and cost.

1. an ordinary prompt must remain unaffected by Sia;
2. `Sia` must activate concise help that includes unattended operations;
3. `Sia load docs` must report that repository documentation is not initialized;
4. an unknown operation must fail explicitly and must not select or run another operation.

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
SIA_CLAUDE_MAX_BUDGET_USD=0.05   # per invocation; four prompts means at most $0.20
SIA_CODEX_MODEL=...               # optional explicit test model
SIA_OPENCODE_MODEL=...            # optional provider/model
SIA_CLAUDE_MODEL=...              # optional explicit test model
```

The artifact directory contains run metadata, version probes, install logs, sanitized command shapes, requested model
overrides, raw stdout and stderr, extracted responses, per-case results, repository fingerprints, and `summary.tsv`.
The temporary repositories are removed at exit. A changed repository fingerprint fails the case even if the textual
response passes. Model values not reported by the host remain unknown rather than being inferred.

## Harness contract test

```sh
sh tests/hosts/static-contracts.sh
```

This test exercises `--probe` with version-only shims, then runs the complete local orchestration path for Codex,
OpenCode, and Claude with deterministic no-model shims. It covers fixture installation, host-specific command
construction, response extraction, all four semantic assertions, read-only fingerprints, and private runtime cleanup.
It never invokes a model and is not evidence of live host-model compliance.
