# Sia

> Perception, understanding, and disciplined work for coding agents.

Sia is the personification of perception, understanding, and intellectual insight in Egyptian mythology. The name fits
the job: help coding agents perceive a repository, understand how it works, and carry out changes through explicit,
reviewable workflows.

Sia is an opt-in, prompt-based, repository-local power-up designed for Codex, OpenCode, Claude Code, and Cursor. It
provides:

- concise, maintained repository documentation;
- composable Sia and project skills;
- repeatable operations and workflows such as Plan → Approve → Build → Review/Validate → Fix → Ship.

It requires no plugin, MCP server, database, or Sia runtime. The host coding agent still reads files, edits code, runs
commands, and starts isolated workers when it supports them.

> [!IMPORTANT]
> Sia is currently a design and implementation specification. The installer and managed payload are not implemented
> yet. Commands below define the intended interface and will become runnable as part of the first implementation stage.

## Why Sia

Coding agents repeatedly rediscover the same architecture, conventions, commands, and domain rules. That consumes
context and still leaves larger changes vulnerable to planning drift and self-review bias. Sia keeps compact repository
knowledge close to the code and gives different host tools the same explicit vocabulary for using it.

Adoption is progressive: load only the docs index, load only the skills catalog, or invoke a complete operation. Normal
host sessions remain normal until the user asks for Sia.

## Installation (planned)

The first release will provide one pinned command to run from the root of the repository Sia should support:

```sh
# Planned command shape — OWNER and VERSION are not runnable values.
curl -fsSL https://github.com/OWNER/sia/releases/download/VERSION/install | sh -s -- install
```

`OWNER` is a temporary placeholder because this checkout has no public repository remote configured. Before the first
release, the project will replace both placeholders with the canonical immutable release URL. The bootstrap will verify
the pinned payload's published integrity metadata before changing the repository.

The installer will target POSIX `sh` on Linux, macOS, and Windows through WSL. It will refuse installation from a
repository subdirectory, preserve existing instructions and project-owned `.ai` content, and report every changed or
conflicted path.

The completed installer interface will also expose lifecycle commands:

```sh
# Inspect the installation without changing it.
curl -fsSL https://github.com/OWNER/sia/releases/download/VERSION/install | sh -s -- check

# Update to the explicitly selected release.
curl -fsSL https://github.com/OWNER/sia/releases/download/NEW_VERSION/install | sh -s -- update

# Remove only unchanged Sia-owned files and managed blocks.
curl -fsSL https://github.com/OWNER/sia/releases/download/VERSION/install | sh -s -- uninstall
```

The installer will not inspect application source or generate repository documentation.

## Quick start

Sia is inactive during ordinary use of the host tool. Activate only the part you want by making `Sia` the exact first
non-whitespace token of the prompt.

### Make repository documentation available

```text
Sia load docs
```

This loads only `.ai/docs/INDEX.md`. The host can follow a documented route later when it becomes relevant to normal
work; it does not start a Sia workflow.

For a repository that has not been documented yet:

```text
Sia document repository
```

### Make skills discoverable

```text
Sia load skills
```

This loads the skill catalog, not every skill body. The host selects a skill only when a later task needs it.

### Run an operation

```text
Sia implement subscription pausing
Sia fix duplicate renewal charges
Sia review the current branch
Sia investigate intermittent webhook failures
Sia document the billing area
```

An operation selects a workflow and the relevant skills. The delivery workflow plans first, stops for approval, builds
the approved scope, independently reviews and validates it, fixes findings, and reports a read-only Ship result.

If delivery continues in a fresh conversation or isolated worker, Sia persists the approved plan:

```text
Sia resume .ai/plans/2026-07-13-01-subscription-pausing.md
```

Stop active orchestration without pretending already loaded context can be erased:

```text
Sia stop
```

## How Sia is organized

| Layer | Purpose | Examples |
| --- | --- | --- |
| Repository documentation | Current, evidence-linked understanding of the repository | Architecture, areas, features |
| Skills | Reusable expertise loaded only when relevant | Testing, bug triage, safe refactoring |
| Operations and workflows | User intent, phases, gates, artifacts, and completion | Implement, fix, review, document |

After installation, Sia keeps its repository-local state under `.ai/`:

```text
.ai/
  sia.md                 # canonical activation protocol
  RULES.md               # project-owned Sia constraints
  docs/                  # maintained repository knowledge
  skills/                # Sia and project skills
  operations/            # Sia and project operations
  workflows/             # Sia and project workflows
  plans/                 # approved resumable delivery plans
```

The installer also adds a bounded activation block to root `AGENTS.md`. When necessary, it adds a Claude compatibility
import. These bridges only tell the host that Sia exists and when to read `.ai/sia.md`; they do not activate Sia or load
`.ai/**` during ordinary startup.

## Project customization

Projects can extend Sia without changing shipped definitions:

- put hard Sia-specific constraints in `.ai/RULES.md`;
- create skills directly under `.ai/skills/<name>/`;
- create operations directly under `.ai/operations/<name>.md`;
- create workflows directly under `.ai/workflows/<name>.md`;
- register project definitions in the `CUSTOM` section of the relevant `INDEX.md`.

Sia will ship `create-skill`, `create-operation`, and `create-workflow` operations so definitions and catalog entries
are created consistently. A valid project definition overrides a same-named shipped definition and Sia announces the
override when it is selected.

## Portability and model routing

Sia uses the same prompt vocabulary and workflow semantics across target hosts. Native worker isolation and model
selection remain host capabilities, not Sia requirements.

Codex, OpenCode, Claude Code, and Cursor are v1 target hosts, not currently tested support claims. A versioned support
matrix will name the exact host versions that pass activation, artifact, and gate fixtures.

Workflows may request the advisory profiles `fast` or `reasoning`. The host chooses the actual model it can provide, and
Sia records that model when the host reports it. An unavailable profile never changes approval gates, permissions, or
correctness requirements.

## Safety and ownership

- Sia fails closed when its activation protocol is missing, invalid, or incompatible.
- Installation preflights the full change set and refuses ambiguous ownership or concurrent changes.
- Upgrades replace only unchanged Sia-owned files and marked blocks.
- Repository docs, rules, plans, project definitions, and `CUSTOM` catalog content remain project-owned.
- Ship is read-only unless the user explicitly requests a commit, push, pull request, release, publish, or deploy
  action.
- Host system, developer, user, permission, and safety rules always remain authoritative.

## Project status and documentation

The repository currently contains the design contracts that guide implementation:

- [Design and implementation index](docs/README.md)
- [Product and principles](docs/product.md)
- [Activation protocol](docs/protocol.md)
- [Repository knowledge](docs/repository-knowledge.md)
- [Extensions and catalogs](docs/extensions.md)
- [Orchestration and workflows](docs/orchestration.md)
- [Tool integration and installation](docs/integration.md)
- [Source repository layout](docs/source-layout.md)
- [Implementation and acceptance](docs/implementation.md)

The first milestone is a small end-to-end slice: safe install, explicit activation, selective docs and skills, one
documenting operation, and one approved delivery workflow that can resume in a fresh conversation.
