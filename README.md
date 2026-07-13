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
> Sia is an early release. Its source, prompt packages, installer, and deterministic verification are implemented.
> Live host-model certification remains separate and is reported without treating an installed CLI as proof.

## Why Sia

Coding agents repeatedly rediscover the same architecture, conventions, commands, and domain rules. That consumes
context and still leaves larger changes vulnerable to planning drift and self-review bias. Sia keeps compact repository
knowledge close to the code and gives different host tools the same explicit vocabulary for using it.

Adoption is progressive: load only the docs index, load only the skills catalog, or invoke a complete operation. Normal
host sessions remain normal until the user asks for Sia.

## Installation

Run the readable installer from the root of the repository Sia should support:

```sh
curl -fsSL https://raw.githubusercontent.com/cristianbica/sia/HEAD/install | sh -s -- install
```

When read from standard input, `install` makes a shallow temporary clone of the current
`https://github.com/cristianbica/sia.git` default branch, runs the same readable installer against its plain `src/`
files, and removes the clone. Review the script at the URL above before executing it. `curl`, `git`, and POSIX `sh`
are required.

The installer does not detect or install Codex, OpenCode, Claude Code, or Cursor. It installs the small repository
entrypoints for every supported host: root `AGENTS.md` serves Codex, OpenCode, and Cursor, while a Claude import bridge
is added when needed. Unused entrypoints are inert.

### Install from a source checkout

To install from a local Sia checkout, run its installer from the target repository root:

```sh
/absolute/path/to/sia/install install
```

The installer targets POSIX `sh` on Linux and macOS. The verification workflow is configured for both platforms. WSL
is an intended compatible environment but remains uncertified until the same suite is run there. Run it from the Git
repository root. Re-run `install` to refresh Sia from current GitHub source:

```sh
curl -fsSL https://raw.githubusercontent.com/cristianbica/sia/HEAD/install | sh -s -- install
```

The installer does not inspect application source or generate repository documentation.

After installation, review `git diff` and commit the intended `.ai/`, `AGENTS.md`, and Claude bridge changes so the
team receives the same Sia behavior. Decide separately whether `.ai/plans/` should be committed for shared handoffs or
ignored as local task state.

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
Sia refresh-docs billing
```

An operation selects a workflow and the relevant skills. Interactive delivery plans first, stops for approval, builds
the approved scope, reviews and validates it in a separate phase, fixes findings, and reports a product-read-only Ship
result.
The review uses an isolated worker when the host can provide one and reports a same-context fallback truthfully.

### Run an operation unattended

```text
Sia unattended implement the restocking report
```

`unattended` is an exact modifier before the operation name. It gives upfront authorization for Sia workflow gates
within the original request, so Sia persists and digests the plan, records automatic approval, and continues through
Build, separate Review/Validate, and in-scope Fix cycles without asking questions. It uses conservative, reversible
assumptions or returns a blocked result when it cannot proceed safely. It does not claim that the user reviewed the
generated plan.

The plan preserves an immutable authorization ceiling and explicit external-action list across replans and resume.
A blocked resume retries only after its recorded condition changes; identical failures and Fix cycles are bounded.

Unattended mode does not bypass host or system permissions, external approval interfaces, project rules, safety checks,
or dirty-worktree safeguards. It does not imply permission to commit, push, open a pull request, release, publish,
deploy, perform destructive work, or take other external actions unless the initial request explicitly includes them.

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
  sia.md                 # canonical activation protocol; replaced by Sia installs
  RULES.md               # project-owned Sia constraints
  docs/                  # maintained repository knowledge
  skills/                # Sia and project skills
  operations/            # Sia and project operations
  workflows/             # Sia and project workflows
  plans/                 # approved or pre-authorized resumable delivery plans
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

Sia ships `create-skill`, `create-operation`, `create-workflow`, and `reconcile-catalogs` so definitions and catalog
entries are created consistently. A valid project definition overrides a same-named shipped definition and Sia
announces the override when selected.

## Portability and model routing

Sia uses the same prompt vocabulary and workflow semantics across target hosts. Native worker isolation and model
selection remain host capabilities, not Sia requirements.

The dated [host matrix](docs/host-matrix.md) distinguishes CLI availability, no-model harness validation, and live
semantic certification. Never interpret an installed CLI or passing shim as proof of model behavior.

Workflows may request the advisory profiles `fast` or `reasoning`. The host chooses the actual model it can provide, and
Sia records that model when the host reports it. An unavailable profile never changes approval gates, permissions, or
correctness requirements.

## Safety and ownership

- Sia fails closed when its activation protocol is missing, invalid, or incompatible.
- Re-running install replaces `.ai/sia.md` and the reserved `sia/` definition directories.
- It replaces only marked Sia blocks in catalog indexes, `AGENTS.md`, and Claude compatibility instructions.
- Repository docs, rules, plans, project definitions, and `CUSTOM` catalog content remain project-owned.
- Unattended mode pre-authorizes only in-scope Sia gates, preserves its original ceiling, and bounds automatic retries.
- Ship may close the active plan; product, source, and external state remain read-only unless the user explicitly
  requests another delivery action.
- Host system, developer, user, permission, and safety rules always remain authoritative.

## Project status and documentation

The repository contains the first usable implementation and its design contracts:

- [Design and implementation index](docs/README.md)
- [Product and principles](docs/product.md)
- [Activation protocol](docs/protocol.md)
- [Repository knowledge](docs/repository-knowledge.md)
- [Extensions and catalogs](docs/extensions.md)
- [Orchestration and workflows](docs/orchestration.md)
- [Tool integration and installation](docs/integration.md)
- [Source repository layout](docs/source-layout.md)
- [Host validation matrix](docs/host-matrix.md)
- [Implementation and acceptance](docs/implementation.md)

Run source, prompt-contract, installer ownership, GitHub-download, and no-model host-harness verification with:

```sh
scripts/verify
```

Probe installed host versions without invoking a model:

```sh
scripts/verify-hosts --probe
```

Live host tests are deliberately separate because they send the installed fixture and prompts to external model
services. Explicitly authorized live host certification remains external evidence and is not claimed by the local
deterministic suite.

## License

[MIT](LICENSE) © 2026 Cristian Bica.
