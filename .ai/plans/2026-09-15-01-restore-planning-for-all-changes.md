---
operation: fix
workflow: delivery
skills: [repository-discovery, bug-triage, testing]
---

# Restore planning for all change requests

<!-- sia:approval:start -->
Restore one default: every Sia request to change something creates a saved plan and waits for approval before edits.
This includes implement, fix, aliases, natural-language requests, docs, definitions, catalog repairs, and Forge.

## Changes

- Put the rule in the shared protocol and align all affected workflows, including custom-workflow boundaries.
  Reuse the existing plan format for each operation; remove the current implement-only restriction.
- Keep read-only questions and session directives free of unnecessary plans. Forge activation and `do:` do not skip
  planning. An explicitly requested inline plan still needs approval; unattended or skipped planning must be explicit.
- Resolve material scope questions before presenting the plan. Clarification and resume do not approve a pending plan.
  After approval, finish the agreed work without repeated permission requests; seek approval for material scope changes.
- Update the conflicting docs and refresh installed instructions with `./install.sh`. Preserve unrelated work and
  existing plan-access and external-action permissions. Keep the rules portable across Codex and Claude.

## Checks

- Cover named operations, aliases, inferred requests, non-code changes, and Forge: a pending plan must precede edits.
  Reject missing plans and premature writes, including helpers, tests, and edits later reverted.
- Check clarification, pending-plan resume, approved continuation, read-only requests, and explicit planning exceptions.
  Extend the Codex and Claude offline harness cases; run `sh scripts/verify` and review source and installed diffs.

This corrects the current patch, not the past weeks of changes. No commits, publishing, or paid live-model runs.
Offline tests check the harness and instruction contracts; they cannot prove either model will follow the rules.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base 953fc8aee7fdb203d827fda1515020749720ea9e -->
<!-- sia:dirty .ai/operations/sia/implement.md, .ai/sia.md, .ai/workflows/sia/delivery.md, .ai/workflows/sia/delivery/standard.md, README.md, docs/host-matrix.md, docs/implementation.md, docs/orchestration.md, docs/product.md, docs/protocol.md, scripts/verify-approval, src/managed/.ai/operations/sia/implement.md, src/managed/.ai/sia.md, src/managed/.ai/workflows/sia/delivery.md, src/managed/.ai/workflows/sia/delivery/standard.md, tests/hosts/README.md, tests/hosts/approval-contracts.py, tests/hosts/approval-shim.py -->
<!-- sia:approved 0c916e827cc7869ca656977f3054db073aa6f19f0b3f1b7d4bda6258e41f0dd9 -->
<!-- sia:progress Shared planning boundary applied across workflows; source and installed diffs reviewed. -->
<!-- sia:progress Validation: sh scripts/verify passed; final source contracts and git diff --check passed. -->
<!-- sia:progress Both offline host shims passed 17 scenarios; 7 changed managed files match installed copies. -->
<!-- sia:progress Live-model checks unrun. No commits or external publication. -->
