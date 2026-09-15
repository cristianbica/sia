# Sia

Sia helps coding agents understand a repository and make the changes a developer asks for. It provides repository
knowledge, reusable skills, and a few explicit operations. It works through readable files with Codex, Claude Code,
OpenCode, and Cursor; it requires no runtime, plugin, database, or MCP server.

Sia is opt-in. Ordinary host sessions remain ordinary until you start a message with the exact token `Sia`.

## Install

From the repository root:

```sh
curl -fsSL https://raw.githubusercontent.com/cristianbica/sia/HEAD/install.sh | sh
```

Review the installer before running it. It requires Git, curl, and POSIX sh; it clones the current public source into a
temporary directory, installs its files, and removes that clone. To pin a revision, set `REF` for the `sh` invocation.
To install from a local Sia checkout, run `/path/to/sia/install.sh` from the target repository root. Re-run to refresh.
Local checkout installation uses its current `src/` files and does not download or switch revisions.

Review and commit the intended installed files for your team. Updates preserve project docs, custom definitions,
CUSTOM entries, and entire existing project rule files. Only managed Sia files and marked Sia blocks are refreshed.
Use `Sia reload` in an existing conversation after updating.

## Use it

```text
Sia document repository
Sia load docs
Sia implement subscription pausing
Sia fix duplicate renewal charges
Sia review the current branch
Sia investigate intermittent webhook failures
Sia investigate the checkout design and save an implementation plan
```

Every change request follows the same sequence: inspect, clarify, save a plan, wait for your approval, then change and
verify. This includes `implement`, `fix`, aliases, natural-language requests, docs, definitions, and one-line edits.
Read-only questions and session directives need no plan. Explicit unattended mode or an instruction to skip planning
can select another behavior; existing pending approvals remain binding.

Repository docs are pointers to relevant architecture, conventions, and verified commands. `load docs` loads only their
index; `load skills` exposes only the skills catalog. Both augment the host without starting an operation. Source
remains the authority when documentation is stale. `refresh-docs <subject>` updates a requested documentation area.

## Plans and follow-ups

Plans are saved automatically for change requests. Resume one by its exact path:

```text
Sia resume .ai/plans/2026-09-13-01-subscription-pausing.md
```

Only that exact plan is authorized for reading. Resume preserves its status and approval; it does not approve a draft.
Existing compact and valid legacy formats remain supported. Sia does not search unrelated historical plans.

For a continuous session, `Sia forge on` makes the prefix optional for follow-ups. Change requests, including `do:`,
still require saved planning and approval. `inline plan` explicitly selects an unsaved plan, also requiring approval.
Saved plans can resume across sessions; inline-only tasks cannot. `Sia forge off` ends the continuous session.

`Sia unattended implement <request>` works within the original request without asking for additional authority.
It blocks if necessary scope, credentials, or permissions are missing. It does not create a plan by default or bypass
an explicit planning-only request, project limits, or host controls. External actions need explicit authorization.

`Sia stop` ends the task and Forge. `Sia reload` rereads the protocol and stops orchestration without deleting plans.
Neither can erase already loaded context. Bare `Sia`, `Sia help`, and `Sia show help` list available commands and
skills.

## Project customization

Installed content lives under `.ai/`: the protocol, default/project rules, docs, skills, operations, workflows, and
saved plans. The root `AGENTS.md` bridge handles activation; Claude receives an import bridge when needed.

Edit project constraints in `.ai/RULES.md`; installation preserves the entire existing file. Custom definitions live
directly in their category and
are registered in the index's CUSTOM section. They override same-named shipped definitions deliberately; upgrades
preserve them. Use `create-skill`, `create-operation`, `create-workflow`, or `reconcile-catalogs` when useful.
Custom workflows keep their own chosen behavior. See [extensions](docs/extensions.md).

## Development and evidence

Canonical source lives under `src/`; `.ai/` in this checkout is the installed copy plus project content. After source
changes run `./install.sh`. See [source layout](docs/source-layout.md) and [design docs](docs/README.md).

```sh
sh scripts/verify
scripts/report-context
scripts/verify-hosts --probe
```

The verifier checks package structure, installation, and offline host harnesses. It does not prove that prompts produce
better code. Live comparisons require explicit model access and a run limit. The simplified workflow's practical
benefit remains unverified until actual outputs are reviewed; see [evaluation](docs/implementation.md).

[MIT](LICENSE) © 2026 Cristian Bica.
