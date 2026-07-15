---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Comprehensive generic code-review stance

<!-- sia:approval:start -->
## Outcome

Make the shipped `code-review` skill adopt the supplied review style as comprehensively as possible while remaining
direct, senior-owner oriented, and useful across application stacks.

## Scope

- Rewrite `src/managed/.ai/skills/sia/code-review/SKILL.md` as a detailed reusable skill, retaining the supplied
  structure rather than reducing it to a summary:
  - a senior-owner review stance: direct, concrete, economical, and led by actionable findings with paths, locations,
    failure modes, and simpler alternatives;
  - ten ordered priorities: production safety; existing patterns; simplicity and scope; domain naming; performance and
    data access; user-facing completeness; data and deployment hygiene; boundary hygiene; product/access/tenant
    correctness; and evidence over intuition;
  - framework taste favoring convention, integration, compatibility, deployability, runtime/lifecycle correctness,
    and evidence-backed hot-path performance over novel local architecture;
  - short comment conventions for questions, nits, blockers with preferred options, approvals with concerns, terse
    praise, and uncertainty; and
  - a complete practical checklist for abstractions, query/index or equivalent data-access shape, loop loading,
    idempotent background work, deploy and schema safety, observable guardrails, performance evidence, feature
    exposure, localization, UI consistency, external contracts, access scoping, and proportionate edge cases.
- Retain the supplied concrete Rails examples where they clarify the concern, but word every framework-specific check
  conditionally and pair it with its general equivalent. For example, indexes and N+1 become database/data-access
  checks; jobs become asynchronous work; migrations become schema/data rollout; i18n becomes localization; and
  model/controller/view boundaries become the target repository's domain, transport, and presentation boundaries.
- Preserve the existing frontmatter and the skill's constraints against speculative findings and unsupported claims.
- Run `./install.sh` to refresh the installed managed projection and inspect its resulting diff.

## Non-goals

- Do not change any other shipped skill, operation, workflow, catalog, installer behavior, or project-owned override.
- Do not require a particular framework, ORM, job system, database, tenancy model, UI system, or deployment strategy.

## Acceptance

- The canonical skill leads with concrete, prioritized findings; avoids speculative or stylistic-only review; and
  recognizes when a terse approval is appropriate.
- It adopts the supplied priorities: production safety; existing patterns; small scope; clear domain naming;
  performance and data access; user-facing completeness; data and deploy hygiene; boundary hygiene; product,
  permission, and tenant correctness; and evidence over intuition.
- It retains the supplied operational, lifecycle, compatibility, concurrency, resiliency, and hot-path concerns when
  relevant to the reviewed system, rather than making Rails mechanisms mandatory.
- It includes a practical checklist covering unnecessary abstractions, data-access shape, background work, deploy and
  schema safety, observable guardrails, performance evidence, feature exposure, localization, UI consistency,
  external contracts, access scoping, and proportionate edge-case handling.
- It prescribes concise, actionable blocking and non-blocking comments without rewriting sound implementations.
- `sh scripts/verify static` passes, and the installed `.ai/skills/sia/code-review/SKILL.md` matches the canonical
  source after installation.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base 51576360a54fb5d02a87f0219fd957c3fab6b93f -->
<!-- sia:approved 2fbca83e9325fd91bf437b05354260f528d182e1a30290d571827bc598c2d7ed -->
<!-- sia:progress build: rewrote the canonical review skill and refreshed the managed projection -->
<!-- sia:progress review-validate: static verifier passed; projection matches source; diff check is clean -->
<!-- sia:progress ship: delivered the canonical skill and managed runtime projection -->
