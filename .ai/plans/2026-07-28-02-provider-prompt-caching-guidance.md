---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Refine provider prompt caching from current guidance

<!-- sia:approval:start -->
## Outcome

Refine Sia's portable prompt-layout contract and OpenAI/Anthropic provider guidance so hosts minimize repeated prompt
content, use current provider cache controls safely, and evaluate net token and cost effects without treating cache hits
as proof of savings.

## Scope

- Update `src/managed/.ai/sia.md` to preserve the deterministic stable-prefix/variable-suffix order while requiring a
  lean reusable prefix: state each invariant once, include only task-relevant tools and durable context, and retain
  paths rather than replaying broad content. Keep provider controls out of the portable runtime prompt.
- Refresh `docs/prompt-caching.md` and its routed references with current official guidance. For OpenAI GPT-5.6-family
  hosts, cover the 1,024-token eligibility threshold, stable privacy-safe `prompt_cache_key`, explicit breakpoints at
  the reusable-prefix boundary, `prompt_cache_options`, and separate cache-read/cache-write accounting. For Anthropic,
  cover static `tools → system → messages` ordering, automatic caching as the default, targeted explicit breakpoints,
  5-minute versus 1-hour TTL selection, exact-prefix invalidators, and cache-read/cache-creation telemetry.
- Document provider-specific optional diagnostics and controls without making them Sia workflow gates: Anthropic cache
  diagnostics remain Claude-API beta/host capability, and OpenAI explicit caching remains model/API capability that a
  host must detect.
- Add a provider-neutral evaluation recipe that compares equivalent cold and warm runs for correctness, total input,
  uncached input, cache reads, cache writes, output/reasoning tokens, latency, and provider-priced estimated cost when
  all required rates are available. Require reporting `unknown` rather than estimated cache fields. Do not make live
  provider calls part of the repository verifier.
- Update focused static contracts for the lean portable layout, provider-capability boundaries, and honest telemetry;
  regenerate `.ai/sia.md` from the managed source with `./install.sh`.

## Non-goals

- Do not add provider SDKs, credentials, cache storage, request execution, billing calculators, or live provider tests.
- Do not hard-code provider pricing as a durable Sia guarantee, require XML rendering in the portable protocol, or make
  cache configuration, diagnostics, model choice, or telemetry a routing or completion gate.
- Do not alter unrelated operation, approval, handoff, or project-owned extension semantics.

## Acceptance

- The managed protocol and generated `.ai/sia.md` agree on a minimal, deterministic reusable prefix and bounded
  request-specific suffix, without broad historical/context replay.
- Canonical provider guidance accurately distinguishes OpenAI's GPT-5.6-family explicit caching from automatic caching
  and Anthropic's automatic/explicit breakpoint, TTL, and diagnostic capabilities; all time-sensitive claims link to
  official provider documentation.
- The evaluation guidance prevents interpreting cache-read totals as savings and supports net-cost calculation only
  where provider prices and read/write telemetry are known.
- Focused contracts cover the new portable and provider-neutral guarantees; managed projection and full repository
  verification pass.

## Checks

- Run `./install.sh` and inspect the generated `.ai/sia.md` projection separately from canonical-source changes.
- Run `sh scripts/verify static` for source, documentation, catalog, and prompt-budget contracts.
- Run `sh scripts/verify` for the deterministic behavior, routing, installer, host-harness, and documentation suites.

## Risks and external actions

- Current provider behavior is model-, API-, region-, and platform-dependent. Keep provider specifics in documentation,
  require host capability detection, and link to official live references rather than treating values as portable rules.
- Leaning the prefix can reduce context needed for a task, while adding explicit cache controls can add cache-write cost;
  only equivalent warm/cold evaluations with correctness evidence can establish a net benefit.
- Existing uncommitted prompt-caching changes overlap this follow-up. Preserve and extend them deliberately; do not reset,
  overwrite, or attribute unrelated work to this plan. No external state change is authorized; official documentation is
  read-only evidence only.
<!-- sia:approval:end -->

<!-- sia:approved 252bbc2525ad7a025a64a4c9d36fb61c5de174e60b8d810d18e2ffc7aced7c1d -->
<!-- sia:status complete -->
<!-- sia:base 27b66262fb79fb787495da6cfd5819e8b2945c14 -->
<!-- sia:dirty .ai/sia.md, docs/README.md, docs/implementation.md, docs/orchestration.md, src/managed/.ai/sia.md, tests/behavior/routing/static-contracts.sh, docs/prompt-caching.md, .ai/plans/2026-07-28-01-provider-prompt-caching.md -->
<!-- sia:progress build: refined the lean portable layout, OpenAI/Anthropic host guidance, evaluation criteria, and static contracts; regenerated the managed projection -->
<!-- sia:progress review-validate: managed projection matched source; git diff --check, static verifier, and full verifier passed -->
<!-- sia:progress ship: completed without external delivery actions -->
