---
summary: Source layout, installer ownership, and Sia activation flow.
scope:
  - src/**
  - install.sh
  - AGENTS.md
  - .claude/CLAUDE.md
  - .ai/**
  - docs/integration.md
  - docs/source-layout.md
last_verified: 2026-07-13
last_verified_ref: badd7c813250a3413f33c13273c421e3b22c69d2
---

# Architecture

## Source and installed planes

The source tree is canonical. The installed `.ai/` tree is a runtime projection plus project-owned extensions:

| Canonical source | Installed or consumed result | Responsible owner |
| --- | --- | --- |
| `src/managed/.ai/sia.md` | `.ai/sia.md` | Sia installer; replaced on refresh |
| `src/managed/.ai/skills/sia/` | `.ai/skills/sia/` | Sia installer; replaced on refresh |
| `src/managed/.ai/operations/sia/` | `.ai/operations/sia/` | Sia installer; replaced on refresh |
| `src/managed/.ai/workflows/sia/` | `.ai/workflows/sia/` | Sia installer; replaced on refresh |
| `src/managed/catalogs/` | SIA blocks in category `INDEX.md` files | Sia installer; marked block only |
| `src/seed/.ai/RULES.md` | `.ai/RULES.md` | Project; copied only if absent |
| `src/seed/.ai/docs/INDEX.md` | `.ai/docs/INDEX.md` | Project; copied only if absent |
| `src/seed/.ai/*/INDEX.md` | Category indexes and CUSTOM sections | Project outside SIA block |
| `src/bridges/` | Marked blocks in `AGENTS.md` and `.claude/CLAUDE.md` | Sia block; surrounding file is project-owned |

Installed project-owned paths have their own responsibilities:

| Installed path | Responsibility | Who may change it |
| --- | --- | --- |
| `.ai/docs/**` | Evidence-linked repository knowledge | `document`/`refresh-docs`, or an explicit project change |
| `.ai/skills/<name>/` | Custom reusable expertise | `create-skill` or an explicit project change |
| `.ai/operations/<name>.md` | Custom user intent and operation contract | `create-operation` or an explicit
  project change |
| `.ai/workflows/<name>.md` | Custom phases, gates, and transitions | `create-workflow` or an explicit project change |
| `.ai/plans/**` | Delivery artifacts and approval evidence | Delivery workflow only |
| `.ai/RULES.md` | Hard project-specific Sia constraints | Project owner; never Sia refresh |

The reserved `.ai/*/sia/` directories and `.ai/sia.md` are not project extension points. When developing Sia, edit the
left-hand canonical source paths, then rerun `./install.sh`; do not manually edit the installed Sia projection. Custom
definitions belong beside `sia/`, not inside it, and survive upgrades.

## Installation flow

`install.sh` requires a Git repository root, validates the source layout and target markers, acquires a lock under the
Git common directory, then copies managed files and replaces only marked catalog or host blocks. Running it from this
checkout uses the adjacent `src/` tree. The standard-input form shallow-clones the public GitHub source into a
temporary directory and invokes the same installer. There is no distribution payload or uninstall mode.

## Activation flow

The host reads the marked root entrypoint bridge during ordinary startup but must not load `.ai/**`. Sia becomes active
only when `Sia` is the first non-whitespace token of a user message. The protocol then loads `.ai/sia.md`, resolves the
requested operation or direct command, and loads only the relevant docs, workflow, and skills. `Sia reload` rereads
the current protocol without restarting the host.

## Ownership boundary

`AGENTS.md` and `.claude/CLAUDE.md` remain mixed-ownership files: only Sia's marked blocks are managed. `RULES.md`,
documentation, plans, custom definitions, CUSTOM catalog sections, and text outside marked catalog sections are
project-owned. The installer does not infer ownership of unknown historical content.

For this dogfood repository, “change Sia” means changing `src/`, `install.sh`, `scripts/`, `tests/`, `docs/`, or the
root README. “Configure the installed Sia runtime” means changing project-owned `.ai/**` paths. If a task could mean
either, classify the target before writing and stop rather than silently editing the projection.
