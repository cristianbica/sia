---
summary: Purpose, boundaries, and concepts of the Sia source repository.
scope:
  - README.md
  - docs/product.md
  - docs/source-layout.md
  - src/**
last_verified: 2026-07-13
last_verified_ref: badd7c813250a3413f33c13273c421e3b22c69d2
---

# Overview

Sia is a prompt-based coding-assistant powerup for repositories. It is portable across Codex, Claude Code, OpenCode,
and Cursor because it has no required runtime, plugin, database, or vendor-specific agent package. A user installs
readable files into a Git repository and explicitly activates Sia with `Sia`; ordinary host conversations remain
unchanged.

## Repository purpose

This repository contains Sia's installer, portable protocol and definitions, project seeds, host bridge fragments,
documentation, and deterministic verification. The root `README.md` is the public installation and usage entrypoint;
`docs/` is the canonical design and implementation specification.

## Core concepts

- **Protocol:** `.ai/sia.md` defines activation, loading, operation resolution, permissions, and result reporting.
- **Operations:** user intents such as `implement`, `fix`, `document`, or `review`.
- **Workflows:** phase and gate contracts used by operations.
- **Skills:** reusable prompt guidance loaded only when relevant; project skills may be added beside Sia's skills.
- **Repository knowledge:** `.ai/docs/` is a concise, evidence-linked routing layer maintained by documentation work.
- **Delivery artifacts:** new standard plans use `.ai/plans/YYYY-MM-DD-NN-<slug>.md`, with a UTC date and daily
  zero-padded sequence so plan directories sort chronologically.
- **Lightweight delivery:** eligible work shows an inline receipt before Build instead of a persisted plan; it cannot be
  resumed with `Sia resume`.
- **Forge mode:** `Sia forge on` enables conversation-scoped direct questions and rapid trivial/lightweight iteration;
  `Sia forge off`, `Sia stop`, `Sia reload`, or a new conversation ends it.
- **Installer ownership:** Sia replaces only its reserved paths and marked blocks; project content survives refreshes.

## Dogfood boundary

The Sia source of truth is `src/`, `install.sh`, `scripts/`, `tests/`, `docs/`, and the root README. The installed
`.ai/` files in this repository let us exercise Sia against itself. They are generated or project-owned runtime
content, not an alternate implementation. Change `src/` when changing Sia; run `./install.sh` to refresh the reserved
`.ai/*/sia` projection.
