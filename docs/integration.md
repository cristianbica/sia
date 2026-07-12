# Tool integration and installation

## Target installed layout

```text
AGENTS.md

.claude/
  CLAUDE.md                  # compatibility only; absent when an effective import already exists

.ai/
  sia.md
  RULES.md
  VERSION
  .sia-manifest
  docs/
    INDEX.md
    overview.md              # created later by a documenting operation
    architecture.md          # created later by a documenting operation
    development.md           # created later by a documenting operation
    {areas,features,patterns,decisions}/
  skills/{INDEX.md,sia/,<project-skill>/}
  operations/{INDEX.md,sia/,<project-operation>.md}
  workflows/{INDEX.md,sia/,<project-workflow>.md}
  plans/
```

Documenting and creation operations add project content lazily. The installer does not create speculative root docs,
area/feature/pattern/decision directories, project definitions, or plans.

## Entrypoint purpose

The root `AGENTS.md` Sia block has one purpose: make supported hosts aware that Sia exists and tell them to load
`.ai/sia.md` only when the user invokes Sia. It is not the protocol, a docs index, or an always-on workflow.

The installer injects a uniquely marked Sia block into an existing root `AGENTS.md`, or creates the file when absent. It
preserves all repository-authored instructions outside the block.

For supported Claude Code versions, ensure exactly one effective Claude instruction file imports root `AGENTS.md`,
because Claude reads Claude instruction files rather than `AGENTS.md` directly. Prefer a managed `@../AGENTS.md` import
in `.claude/CLAUDE.md`. If root `CLAUDE.md` or `.claude/CLAUDE.md` already provides an effective import, preserve it and
do not install a compatibility block. Preserve both files' existing content; report pre-existing duplicate imports
rather than deleting user text.

| Host surface | Entrypoint |
| --- | --- |
| Codex CLI | Root `AGENTS.md` managed block |
| OpenCode CLI/TUI | Root `AGENTS.md` managed block |
| Cursor Agent/CLI | Root `AGENTS.md` managed block |
| Claude Code CLI | Existing effective Claude instruction file; otherwise managed `.claude/CLAUDE.md` import |

Maintain a tested-version matrix during implementation. Promise semantic parity for activation, artifacts, and gates,
not identical native worker behavior across every product surface.

## Ownership

The installer owns:

- `.ai/sia.md`, `.ai/VERSION`, and `.ai/.sia-manifest`;
- shipped definitions below reserved `sia/` directories;
- each catalog's uniquely marked SIA block;
- the root `AGENTS.md` Sia block;
- the `.claude/CLAUDE.md` compatibility block, only when Sia installed it.

The project owns:

- `.ai/RULES.md`, created only when absent and never changed by upgrades;
- `.ai/docs/**` immediately after the first-install seed index is created;
- `.ai/plans/**`;
- CUSTOM catalog sections, catalog text outside each marked SIA block, and project definitions;
- every byte surrounding managed entrypoint blocks.

Seed files become project-owned immediately and are never removed by update or uninstall. Catalog indexes have mixed
ownership even when first created by Sia: only the marked SIA block remains installer-owned.

## Manifest

The manifest records install metadata, the installed version, and the last-installed digest for every other owned path
or block. It does not record a digest of itself, avoiding a circular self-digest. Validate the manifest's schema,
version, and release identity directly, and write it last after a successful apply.

Except for the manifest itself, update or remove owned content only when its current digest matches the recorded digest.
For a managed block, markers establish its bounds but the block-body digest must also match; a well-formed block with
edited content is a conflict. Replace a structurally valid manifest only after all recorded ownership checks succeed;
a corrupt manifest requires repair. Preserve and report modified owned content. Never delete unknown files under
reserved directories.

## Repository root and supported installer environment

Install targets the current directory only when it is the detected repository or worktree root. Invocation from a
subdirectory refuses with the detected root and an explicit retry command. Package-local monorepo installation is
deferred until its instruction scope and host behavior are tested.

The v1 installer supports POSIX `sh` on Linux, macOS, and Windows through WSL. Other shells or native Windows require a
separately tested installer path before being documented as supported. Hosts must open or launch from the installed
repository scope for the entrypoint contract to apply.

## Install and update behavior

- Install from an immutable released version with documented pinning and integrity verification.
- Preflight the complete change set and report every conflict before writing anything.
- Reject symlinked targets or parent paths that make ownership ambiguous.
- Preserve CRLF/LF style, BOM, final-newline state, modes, and surrounding bytes where applicable.
- Apply each staged file through a same-filesystem atomic replacement and remain rerunnable after interruption.
- Recheck every destination against its preflight snapshot immediately before replacement; concurrent changes stop the
  apply and preserve user content.
- Refuse malformed, duplicate, nested, reversed, or unbalanced managed markers.
- Detect normalized/case-folded definition collisions before writing.
- Never analyze application source or generate repository documentation during installation.
- Print every created, updated, preserved, removed, and conflicted path.

Install and validate the `.ai` core before exposing it through activation bridges. Update root `AGENTS.md` and the
Claude bridge near the end, then write the manifest last as the successful-apply record.

An interrupted update may leave a mixture of the old installed release and the exact pinned target release before the
new manifest exists. A rerun for that same target is safe only when each previously owned item matches either its old
manifest digest or the exact target digest. Treat exact target items as already applied, replace old items after the
normal concurrency recheck, and write the new manifest last. Any third state is a conflict.

For an interrupted first install without a manifest, a rerun may recognize only exact files and marked blocks from the
same pinned target release as partial installer output. All other pre-existing Sia-looking files, blocks, or reserved
trees remain unowned and conflict; do not infer broader ownership or adoption. Seed files already created are
project-owned and must be preserved. A corrupt manifest requires repair rather than guessed overwrite behavior.

## Check and uninstall

`check` is read-only, uses documented exit codes, and reports version, manifest, marker, digest, reference, and catalog
problems.

Uninstall removes only valid managed blocks and unchanged manifest-owned files. It never removes project-owned seed
files, documentation, plans, CUSTOM content, or project definitions. If an installer-created `AGENTS.md` or
`.claude/CLAUDE.md` later contains user text, remove only the Sia block. Delete directories only when empty.

Test Claude adoption with root `CLAUDE.md`, `.claude/CLAUDE.md`, both files together, an existing correct import, and
pre-existing duplicate imports.

Also test concurrent changes to root `AGENTS.md`, root `CLAUDE.md`, and `.claude/CLAUDE.md` between preflight and apply.

## Installer scope

Support install, update, check, and uninstall in v1. Prefer strict refusal with recovery guidance over a large migration
framework that guesses how to rewrite unknown project content.
