# Host validation matrix

Sia separates CLI availability from semantic certification. A version probe never invokes a model. A live test installs
Sia into a temporary repository, adds an activation canary, invokes four read-only prompts, and records exact evidence.
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

The four cases verify that an ordinary prompt does not load the protocol, `Sia` returns help including unattended mode,
`Sia load docs` reports the seed router as uninitialized, and `Sia reload` rereads the protocol without starting work.
Detailed artifacts contain versions, commands, prompts, raw output, normalized responses, timing, reported cost,
repository fingerprints, and the semantic result.
