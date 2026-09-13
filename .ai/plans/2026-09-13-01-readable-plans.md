---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Make plans easy to understand and scan

<!-- sia:approval:start -->
Make Sia plans explain the intent briefly, then show what will change in short, readable points. A reader should be
able to assess the proposal without working through a technical specification.

## Changes

- Open with one or two plain-language sentences explaining the intended result and why it matters.
- Describe proposed behavior in short points. Split independent requirements; use small groups when they help scanning.
- Choose bullets, short descriptions, or subheadings to suit the content. Do not prescribe bold labels or a fixed layout.
- Keep implementation detail only when it explains an important decision, risk, or scope boundary. Keep routine execution
  notes in worker handoffs and progress evidence.
- State the main acceptance checks and limits briefly. Avoid repeating the scope as delivery steps and again as tests.
- Preserve required behavior, permissions, exceptions, and material risks. Simplification must not silently remove them.

## Examples and checks

- Rewrite the planning template and the existing long writing example to demonstrate this approach.
- Add a worked example based on the supplied workspace/dashboard proposal, preserving its requirements.
- Review both small and complex examples: can a reader quickly find the intent, changes, success checks, and limits?
- Compare rewritten examples with their originals for missing or changed requirements. Do not use bullet counts or
  word counts as proof of readability.
- Run focused workflow/source checks, review the diff, and refresh the installed Sia guidance.

## Boundaries

Update canonical planning guidance and its supporting documentation/examples. Keep approval and resume rules intact.
The main risk is hiding important detail while shortening the plan; the requirement comparison addresses that risk.
Local changes and validation only; no paid model runs, commits, pushes, or external actions.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base a098effa9983892d0baad6573d7164a4bf994c09 -->
<!-- sia:progress Planning only. Clean worktree confirmed; planning guidance, writing examples, and validation entrypoints inspected. No implementation changes or tests run. Intended source scope: src/managed/.ai/workflows/sia/delivery/standard.md, docs/orchestration.md, docs/writing-examples.md; refresh installed projection through install.sh. -->
<!-- sia:approved 54b6bc8451edeb38e6eea6022a07ea0b0b3b7d1fb3f6fecadaf6f21969b3f5b3 -->
<!-- sia:progress build: Updated canonical planning guidance, orchestration docs, webhook template, TWRP example, and workspace/dashboard example. Same-context execution; no delegated worker. -->
<!-- sia:progress review: Workflow checks passed 9/9; source checks passed 9/10 with one 124-character documentation line. Fidelity review requires explicit post-commit setup, uncertain-response recovery, and tool classification wording that does not prohibit authorized writes. -->
<!-- sia:progress fix: Restored explicit transaction/commit semantics, uncertain-response recovery, and correct tool classification; retained tool-resolution testing and fixed Markdown width. Installed projection refreshed successfully. -->
<!-- sia:progress review-validate: PASS, same-context review. Webhook retains transaction/uniqueness/retry/authentication and rollout limits. TWRP retains account/workspace cardinality, post-commit setup, recovery, access/secrets, configuration, documentation, tests and delivery boundaries across plan and handoff. Dashboard retains all supplied scope, delivery mechanisms, acceptance/risk cases and deferred features across plan and handoff. Intent, behaviors, checks and limits are directly locatable; no required bolding or nesting. -->
<!-- sia:progress checks: TMPDIR="$PWD/.sia-validation-tmp" sh tests/static/source-contracts.sh passed 10/10 after fixing width; TMPDIR="$PWD/.sia-validation-tmp" sh tests/behavior/workflows/static-contracts.sh passed 9/9; ./install.sh passed; cmp source/installed standard.md passed; scoped git diff --check passed; Python assertions confirmed approval SHA-256 and unchanged approval/resume rule sections. No live model runs or full installer suite; no installer code changed. -->
<!-- sia:progress definitions: operation=.ai/operations/sia/implement.md; workflow=.ai/workflows/sia/delivery.md; support=.ai/workflows/sia/delivery/standard.md,.ai/workflows/sia/delivery/execution.md; skills=.ai/skills/sia/repository-discovery/SKILL.md,.ai/skills/sia/testing/SKILL.md,.ai/skills/sia/documentation/SKILL.md,.ai/skills/sia/code-review/SKILL.md. No resolution change. Model/profile usage unknown; no model override or delegated worker. -->
<!-- sia:progress ship: Completed approved readability changes and retained this plan. Source and installed guidance updated; focused checks and final review passed. No commits, pushes, or external actions. Live generation remains unmeasured. -->
