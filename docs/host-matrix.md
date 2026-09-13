# Host validation matrix

Sia separates CLI availability from semantic certification. A version probe never invokes a model. A live test installs
Sia into a temporary repository, adds an activation canary, invokes eight read-only prompts, and records exact evidence.
Observed versions are dated evidence, not required or pinned versions; a host update does not disable live validation.

## Current environment

Probed on 2026-07-13:

| Host | Version | CLI probe | No-model harness | Live semantics |
| --- | --- | --- | --- | --- |
| Codex CLI | 0.144.2 | Available | Passing | Pending explicit external-service authorization |
| OpenCode | 1.17.18 | Available | Passing | Pending explicit external-service authorization |
| Claude Code | 2.1.207 | Available | Passing | Pending explicit external-service authorization |
| Cursor Agent (`cursor-agent`) | Not installed | Absent | Runner unavailable | Not tested |

`Passing` in the no-model column means version parsing, fixture installation, command construction, read-only
fingerprinting, canary assertions, artifact recording, and result evaluation pass against local shims. Timeout and
output safeguards are statically checked; fault injection is not yet part of this harness. None of this claims that a
host model followed Sia.

## Commands

Availability only, with no model invocation:

```sh
scripts/verify-hosts --probe
```

Explicit live validation:

```sh
scripts/verify-hosts --live
scripts/verify-hosts --live --host codex
```

Live validation requires GNU `timeout`; Claude validation also requires `jq`.

Live mode is sequential and uses independent sessions. It limits each prompt to 90 seconds and 1 MiB output, makes
the fixture repository read-only to the host, disables delegation and external tools where exposed, and gives Claude a
hard USD 0.05 per-invocation limit. Codex and OpenCode do not expose a portable hard monetary cap, so their cost is
recorded as `unknown`.

The eight cases verify ordinary prompts remain unaffected; bare `Sia`, `Sia help`, and `Sia show help` expose every
effective operation and skill, including CUSTOM-only and override fixtures; docs loading and reload behave narrowly;
pre-existing plan content stays isolated until an exact resume request authorizes it. Detailed artifacts contain
versions, commands, prompts, raw output, normalized responses, timing, reported cost, repository fingerprints, and the
semantic result.

The Codex runner uses `SIA_CODEX_REASONING_EFFORT` (default `low`) independently of `SIA_CODEX_MODEL` and records both
requested settings. Local shims cover default and overridden arguments; the dated live-certification status above
remains unchanged. See [host tests](../tests/hosts/README.md) for long-task scenario limitations.

## Approval-boundary coverage

A separate Codex/Claude runner, `scripts/verify-approval --live --host codex|claude`, exercises writable disposable
fixtures and exact-session continuation. It checks explicit saved planning before source edits, approval of the
presented
plan, pending-plan resume, remaining approved work, verification stopping, and the existing planless and unattended
controls.
It records file snapshots and tool traces; missing
continuation or unclassifiable preapproval activity is unavailable, never a pass. It does not change the read-only
smoke suite or the live-certification status above.

`python3 tests/hosts/approval-contracts.py` runs deterministic no-model shims and is included in `scripts/verify`.
It covers successful coding and planning requests, premature writes and reverted attempts, invalid/missing plans,
invalid digests, host
failure, missing/unsupported continuation, opaque commands, and timeout. These results validate the harness only.
Live approval checks remain unrun and need an explicit call budget; see
[host tests](../tests/hosts/README.md#writable-approval-and-continuation-checks-codex-and-claude) for invocation,
bounded execution, evidence, and conservative trace-check limitations.

## Model-specific evaluation

Keep the portable approval, scope, and completion rules independent of model tuning. Evaluate the same tasks with
explicit model and effort settings; advisory `fast`/`reasoning` profiles do not establish equivalent effort or cost
across providers. Record host versions and instruction hashes alongside responses and traces. Offline harness checks
validate the measurement machinery, not live model compliance.

[Astra guidance](https://developers.openai.com/api/docs/guides/latest-model) identifies detailed recurring prose,
sensitivity to skills, and over-broad verification as behaviors to check. Audit conflicting loaded instructions before
adding more rules. Generic autonomy advice must respect the user's selected interactive approval boundary.

[Claude 5.1
guidance](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1)
recommends measuring effort settings again and adjusting observed dense prose, premature stopping, or extra work.
Prefer readable paragraphs and useful lists over blanket formatting bans. Missing progress updates may be a host display
issue: API clients must request and render the appropriate progress blocks. Sia cannot configure that through Markdown.
See [prompt caching](prompt-caching.md) for history and preserved-thinking compatibility; host-owned conversation edits
and API settings require integration checks, not extra Sia instructions.

Use the opt-in approval runner for repository changes and continuation, and the concise-output benchmark for paired
language-contract comparisons. Review correctness and scope before readability or token counts. A host that cannot
expose the needed session, permissions, or trace evidence is unavailable for that assertion; do not report it as
passing.
Live comparisons require a separately approved model/access/cost budget and must remain outside ordinary verification.
