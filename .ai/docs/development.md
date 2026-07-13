---
summary: Verified Sia development, installation, and validation commands.
scope:
  - install.sh
  - scripts/**
  - tests/**
  - src/**
  - docs/**
last_verified: 2026-07-13
last_verified_ref: badd7c813250a3413f33c13273c421e3b22c69d2
---

# Development

## Source changes

1. Inspect the relevant canonical files under `src/`, `docs/`, `tests/`, `scripts/`, or the root entrypoints.
2. Preserve unrelated dirty paths and determine whether the change affects managed content, seeds, bridges, catalogs, or
   installer behavior.
3. Decide whether the requested change is to Sia's canonical source or to this repository's installed runtime config.
   Do not edit `.ai/*/sia` to implement Sia.
4. Edit the canonical source for Sia changes, or the responsible project-owned `.ai/**` path for runtime configuration.
5. Run focused static checks, then the complete verifier when the change is broad or installer-facing.
6. Run `./install.sh` from this repository after canonical source changes and inspect the generated `.ai` diff
   separately.

## Verified commands

```sh
./install.sh
sh scripts/verify static
sh scripts/verify
scripts/verify-hosts --probe
```

`sh scripts/verify` runs source contracts, activation, routing, model, definition, documentation, host harness, and
installer suites. The host probe checks CLI availability and versions without invoking a model. Live host tests are
separate, explicit, bounded, and may incur external model cost; they are not implied by the normal verifier.

## Important pitfalls

- Sia is opt-in: a message that merely mentions Sia does not activate it; the exact first-token grammar matters.
- The installer must run from the target repository root and may refuse a concurrent or malformed installation.
- `.git/sia-install.lock` is a short-lived empty directory; remove it only after confirming no installer is running.
- Host availability does not change the portable installed payload; Sia does not install host CLIs or plugins.
- Host-reported model and token telemetry may be unavailable; record `unknown` rather than estimating it.
- Do not treat generated `.ai` documentation as authoritative over source, tests, or the canonical `docs/`
  specification.
