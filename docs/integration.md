# Tool integration and installation

## Installed layout

```text
AGENTS.md

.claude/
  CLAUDE.md                  # only when no existing Claude file imports AGENTS.md

.ai/
  sia.md                     # Sia-owned activation protocol
  RULES.md                   # project-owned after first creation
  docs/INDEX.md              # project-owned after first creation
  skills/{INDEX.md,sia/,<project-skill>/}
  operations/{INDEX.md,sia/,<project-operation>.md}
  workflows/{INDEX.md,sia/,<project-workflow>.md}
  plans/                      # created lazily when a delivery plan is persisted
```

Documenting and creation operations add project content lazily. The installer does not inspect application source or
generate repository documentation, plans, or project definitions.

## Entrypoint purpose

The root `AGENTS.md` Sia block makes a supported host aware that Sia exists and tells it to read `.ai/sia.md` only when
the user explicitly invokes `Sia`. It does not activate Sia, load the docs index, or start a workflow during ordinary
work.

Claude Code uses Claude instruction files rather than `AGENTS.md` directly. If neither root `CLAUDE.md` nor
`.claude/CLAUDE.md` already imports root `AGENTS.md`, Sia adds a marked `@../AGENTS.md` block to
`.claude/CLAUDE.md`. Existing imports and surrounding user instructions are left alone.

Installation does not detect or install host CLIs. It writes the portable repository entrypoints for all supported
hosts regardless of what is installed on the current machine. This is why `.claude/CLAUDE.md` may be created in a
repository whose installer was run from Codex; the bridge remains inert unless Claude Code reads it.

| Host surface | Entrypoint |
| --- | --- |
| Codex CLI | Marked block in root `AGENTS.md` |
| OpenCode CLI/TUI | Marked block in root `AGENTS.md` |
| Cursor Agent/CLI | Marked block in root `AGENTS.md` |
| Claude Code CLI | Existing import, or marked `.claude/CLAUDE.md` block |

## Ownership model

Managed refreshes have only two write modes.

| Target | Replace the complete file or directory | Replace only a marked Sia block |
| --- | --- | --- |
| `.ai/` | `.ai/sia.md`; `.ai/{skills,operations,workflows}/sia/` | Each category `INDEX.md` SIA section |
| Host instruction files | None | Root `AGENTS.md`; optional `.claude/CLAUDE.md` |

The intentionally empty host-file/full-replacement cell is important: Sia never takes ownership of a user's whole
instruction file.

Create-once seeds are outside that replacement matrix. `RULES.md`, `docs/INDEX.md`, and new category indexes are copied
only when missing, then become project-owned; later installs never refresh them as whole files. Project definitions,
plans, documentation, text outside Sia markers, and each `CUSTOM` section are also project-owned. The reserved `sia/`
directories are Sia-owned; projects place their own definitions beside them, not inside them.

There is no manifest, file digest database, version-pinned release, migration engine, or attempt to infer ownership of
unknown content. Re-running install deliberately replaces the known Sia-owned paths and marker blocks.

## Install and refresh

Run the public command from a Git repository root:

```sh
curl -fsSL https://raw.githubusercontent.com/cristianbica/sia/HEAD/install.sh | sh
```

The small bootstrap script shallow-clones the current default branch of `https://github.com/cristianbica/sia.git` into
a temporary directory, invokes the same installer against its readable `src/` tree, and removes the clone. Local
checkout use and standard-input use therefore apply the same source layout.

Run the same `install.sh` command again to refresh Sia. Set `SIA_REF` to an advertised branch or tag when standard-input
installation should fetch a particular remote revision. A local source checkout installs its current files; do not ask
the installer to switch that checkout's Git revision. There is deliberately no uninstall command: the installer is a
small one-way synchronizer, not a lifecycle manager. Remove Sia only through an explicit project change when needed.

For local development, run the checkout's `install.sh` script from a target repository root. It reads the adjacent
`src/` tree. `SIA_SOURCE_DIR` can explicitly supply such a source tree when the script is read from standard input.

## Small, explicit safety boundary

The installer requires POSIX `sh`, `git`, and a Git repository root. It rejects symlinked directories it writes under
`.ai/`, invalid create-once seed paths, malformed or duplicated Sia marker pairs, and a concurrent Sia installer. A
shared catalog must contain `## CUSTOM` before Sia can insert its section. Before replacing an existing shared file, it
checks that the content used to prepare the replacement has not changed. This narrows accidental races but cannot lock
arbitrary editors, so do not edit shared targets while installation is running.

An interrupted process can leave `<git-common-dir>/sia-install.lock`. If no installer is running, remove that empty
directory and retry.

It is intentionally not a transactional package manager: it does not hash files, track a manifest, recover every
interruption shape, preserve every byte-level formatting detail, or migrate unknown historical layouts. Those concerns
would obscure the two ownership rules above. If a repository has an ambiguous old layout, resolve it deliberately
before installing rather than asking the installer to guess.
