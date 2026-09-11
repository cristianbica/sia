---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Restrict writes to the project root

<!-- sia:approval:start -->
## Scope
Update only the installed, project-owned `.ai/RULES.md` with this rule:

- Agents must not create, modify, or delete files outside the project root unless the user has explicitly authorized the specific outside-root action or destination. This includes indirect writes by commands, installers, hooks, and package managers such as apt, dnf, brew, npm, pnpm, Yarn, Bundler, pip, and similar tools. A request to build, test, or install project dependencies does not itself authorize system or global installations, or writes to external caches, configuration, or dependency directories. Configure tools to keep their writes inside the project root when possible; otherwise obtain specific authorization before running them. Resolve symlinks and configured destinations when determining whether writes remain inside the root. Existing explicit authorization remains valid within its stated scope.

No canonical source, installer, or other runtime definition changes. No external actions or package installations.

## Acceptance and checks
The installed rule explicitly covers direct and indirect writes, package managers, external caches, and scoped user exceptions. Inspect the focused diff and run `git diff --check -- .ai/RULES.md`. Review the wording for loopholes and scope. No executable behavior changes; no runtime test suite required.

## Risks
Commands that normally write to home-directory caches may require project-local configuration or explicit authorization.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base b15f3f8e3775393eb89584e1e7dffac9b1f9686d -->

<!-- sia:approved 7118df25f42318b6f05c7e1e91e0652aff6e09a10e48df759c0c0fa41f16b1e3 -->
<!-- sia:progress approval: User approved scope and requested concise equivalent wording. -->
<!-- sia:progress build: Added concise equivalent rule to .ai/RULES.md per user approval and wording correction. -->
<!-- sia:progress review-validate: Same-context review found no issues; inspected git diff -- .ai/RULES.md and git diff --check -- .ai/RULES.md passed (exit 0). Runtime tests skipped for prose-only change. -->
<!-- sia:progress ship: Completed installed-rule update; no external actions. -->
<!-- sia:progress correction: User subsequently requested the rule in src/seed/.ai/RULES.md and installer updates. Implemented default-prefix refresh with byte-preserved custom suffix; removed prior protocol additions and refreshed installation. Original scope above describes the superseded local-only change. -->
<!-- sia:progress validation: TMPDIR="$PWD" sh tests/installer/install/stage1.sh passed 14 checks; bootstrap.sh passed 10; tests/static/source-contracts.sh passed 10; shell syntax, installed-source comparisons, and diff whitespace checks passed. TMPDIR="$PWD" sh scripts/verify reached the known benchmark workspace assertion failure because temporary workspaces are inside the project; later suites did not run through that command. -->
