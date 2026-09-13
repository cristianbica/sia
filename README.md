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
CUSTOM entries, and project rules below their marker. Managed Sia files and default rules are refreshed.
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

`implement` and `fix` normally inspect the code, make the change, check it, and report the result. They do not require
route labels, receipts, saved plans, or workers. An explicit planning request stops before implementation for approval.
A clear approval of the presented plan authorizes its work. Material scope changes and host permissions still matter.

**Changed default:** earlier versions created approval plans for most source changes. Normal coding now proceeds from
the request. Existing saved plans keep their approval checks; a pending plan is never automatically approved.

Repository docs are pointers to relevant architecture, conventions, and verified commands. `load docs` loads only their
index; `load skills` exposes only the skills catalog. Both augment the host without starting an operation. Source
remains the authority when documentation is stale. `refresh-docs <subject>` updates a requested documentation area.

## Plans and follow-ups

Ask for a plan when you want to review the approach first. Ask to save it when you need to resume later:

```text
Sia resume .ai/plans/2026-09-13-01-subscription-pausing.md
```

Only that exact plan is authorized for reading. Resume preserves its status and approval; it does not approve a draft.
Existing compact and valid legacy formats remain supported. Sia does not search unrelated historical plans.

For a continuous session, `Sia forge on` makes the prefix optional for follow-ups. Forge uses the same coding behavior;
`do:` asks for implementation, while `plan:` or `inline plan` asks for approval first. Clear follow-ups such as “next
one” reuse the conversation. Forge keeps no saved task state and cannot resume in a new conversation.
`Sia forge off` ends it. Reserved directives and explicit `unattended` retain their meaning.

`Sia unattended implement <request>` works within the original request without asking for additional authority.
It blocks if necessary scope, credentials, or permissions are missing. It does not create a plan by default or bypass
an explicit planning-only request, project limits, or host controls. External actions need explicit authorization.

`Sia stop` ends the task and Forge. `Sia reload` rereads the protocol and stops orchestration without deleting plans.
Neither can erase already loaded context. Bare `Sia`, `Sia help`, and `Sia show help` list available commands and
skills.

## Project customization

Installed content lives under `.ai/`: the protocol, default/project rules, docs, skills, operations, workflows, and
optional plans. The root `AGENTS.md` bridge handles activation; Claude receives an import bridge when needed.

Add project constraints below the marker in `.ai/RULES.md`. Custom definitions live directly in their category and
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
