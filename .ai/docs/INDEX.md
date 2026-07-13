---
status: initialized
last_verified: 2026-07-13
last_verified_ref: badd7c813250a3413f33c13273c421e3b22c69d2
---

# Repository documentation

Sia is a prompt-based, opt-in coding assistant distributed as readable repository files. The canonical source is under
`src/`; the installed `.ai/` tree in this repository is a dogfood runtime projection and is not the Sia implementation.

## Routes

- [Overview](overview.md) — purpose, repository boundaries, and the main concepts; load for general orientation.
- [Architecture](architecture.md) — source-to-install mapping, ownership, and activation flow; load before source
  changes.
- [Development](development.md) — verified commands, change procedure, and operational pitfalls; load before editing or
  validating the repository.

Root product and protocol specifications remain in [`docs/`](../../docs/README.md). These AI-facing documents are a
compact routing layer, not a second specification or a substitute for tests.
