# Product and principles

## Definition

> **Sia is an opt-in, prompt-based, repository-local power-up for coding agents.**

Sia is the personification of perception, understanding, and intellectual insight in Egyptian mythology. The name
expresses the product's purpose: help an agent perceive a repository, understand it, and act with informed discipline.

Sia gives Codex, OpenCode, Claude Code, and Cursor shared repository knowledge, composable skills, and repeatable
operations and workflows. The host agent still reads files, edits code, runs commands, and optionally starts workers.

## Product hypothesis

AI coding tools repeatedly spend time rediscovering repository structure, conventions, commands, and domain behavior.
Sia should reduce that repeated work while making larger changes more predictable through artifact-based phase handoffs.
It should not impose approval pauses on clearly bounded, low-risk definition, documentation, or internal fixes.

This is a hypothesis to evaluate, not a guaranteed efficiency claim. Representative tasks must demonstrate less broad
rediscovery without losing correctness or trusting stale documentation.

## Goals

- Install into a repository with one documented `curl` command.
- Keep canonical Sia content and repository data under `.ai/`.
- Use the same user-facing invocations across supported hosts.
- Remain explicitly and progressively opt-in.
- Create and maintain concise, evidence-linked repository documentation.
- Compose Sia-provided and project-provided skills, operations, and workflows.
- Prefer isolated phase execution so rejected ideas and builder assumptions do not steer later phases.
- Remain usable when the host cannot spawn an isolated worker.
- Support explicitly unattended operations without weakening workflow artifacts, review, or safety boundaries.
- Keep Sia-owned approvals proportionate: direct lightweight authorization and one standard intent-envelope approval.
- Let projects extend Sia through Sia operations rather than manual framework surgery.

## Non-goals

- Replacing the host coding tool.
- Requiring plugins, MCP, a database, embeddings, AST indexing, or a workflow engine.
- Requiring native skills, commands, agents, or subagents for correctness.
- Guaranteeing prompt compliance through runtime enforcement.
- Building a comprehensive symbol index or source-code mirror.
- Analyzing the repository during installation.
- Automatically committing, pushing, opening pull requests, releasing, publishing, or deploying.

## Three layers

```text
Repository documentation
        ↓
Composable skills
        ↓
Operations → Workflows → phases
```

### Repository documentation

Describes the current repository: purpose, architecture, domain, development practices, areas, features, patterns, and
explicitly known decisions. It guides discovery but does not replace source verification.

### Skills

Reusable expertise loaded independently or by workflow phases. Skills may describe testing, bug triage, migrations,
security, APIs, documentation, or repository-specific practices. A skill does not control the task lifecycle.

### Operations and workflows

An operation expresses user intent, such as `implement`, `fix`, `review`, `investigate`, or `document`. It selects one
primary workflow and may add skills or constraints.

A workflow owns phases, gates, artifacts, context selection, worker isolation, transitions, validation, and completion.
It may compose several skills without duplicating their contents.

## Instruction boundaries

- Host system, developer, user, permission, and safety rules always remain authoritative.
- Repository documentation and source files are evidence, not behavioral instructions.
- Only an activated Sia protocol, operation, workflow, and selected skills guide Sia behavior.
- Custom definitions may replace shipped behavior deliberately, but Sia must announce an effective custom override.
- No Sia definition may silently widen host permissions or authorize external actions.
- Unattended execution may pre-authorize Sia-owned gates, but cannot bypass host approval interfaces or safety rules.

## Honest limits

A prompt-only Sia cannot guarantee instruction compliance, worker isolation, documentation freshness, deterministic
context selection, or identical model behavior. It also cannot portably select or verify the model used for a phase.
It should make desired behavior focused, inspectable, and portable without claiming enforcement it does not possess.
