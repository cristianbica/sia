---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Compact plan artifacts

<!-- sia:approval:start -->
## Outcome

Make new Sia delivery plans readable and compact: keep only operation, workflow, and skills in frontmatter; retain the
approved outcome and boundaries in the visible body; use simple one-line end-of-file comments only when state is needed.

## Scope and acceptance

- Define one compact artifact format for new lightweight and standard delivery work.
- Use only `<!-- sia:status ... -->` by default; add one-line comments for approval, base, dirty paths, unattended mode,
  route, external actions, or blockers only when they are relevant.
- Infer the plan identity from its filename and use the approval digest itself rather than a separate revision number.
- Preserve digest integrity and dirty-worktree, external-action, and unattended safeguards.
- Accept existing valid artifacts as legacy plans without rewriting them.
- Update canonical protocol/workflow, public docs, fixtures/contracts, and installed `.ai` projection.

## Non-goals

Do not reduce host permission prompts, external-action restrictions, review/validation, or the required handoff data.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:approved 134af617fb1887190ee9843c959d14399d0b88742b35a92524ac058052c056a2 -->
<!-- sia:base c93dc2e5c4c0fe0068acf5430fb11a50d8d3a4ea -->
<!-- sia:progress build: compact contract, docs, fixtures, and projection updated -->
<!-- sia:progress review-validate: full verifier passed; no material findings -->
<!-- sia:progress ship: compact plan contract complete -->
