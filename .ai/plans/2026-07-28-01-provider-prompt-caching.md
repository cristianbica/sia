---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Increase reusable prompt-cache hits across providers

<!-- sia:approval:start -->
## Outcome

Make Sia's phase prompts and handoffs more cache-friendly, then provide accurate provider-specific implementation
guidance and telemetry mapping so hosts can reduce repeated input-token processing without changing Sia's portable
workflow semantics.

## Scope

- Update `src/managed/.ai/sia.md` with a concise, portable prompt-layout contract: a byte-stable reusable prefix
  (rules, resolved route/workflow, durable pointers, and invariant tool/context declarations), followed by a mutable
  suffix (plan state, focused evidence, current constraints, and one final ask). Require deterministic ordering and
  prohibit timestamps, run IDs, volatile telemetry, broad output, and request-specific text from the reusable prefix.
- Add a canonical provider-cache reference under `docs/` and route to it from the relevant orchestration and
  implementation documentation. Cover OpenAI's exact-prefix matching, stable `prompt_cache_key`, explicit
  breakpoints, and cache read/write telemetry; Anthropic's `cache_control` breakpoints, 5-minute/1-hour TTL tradeoff,
  exact-prefix/tool stability, and usage fields; and Gemini's implicit-cache prefix guidance, thresholds, cache-hit
  telemetry, and the boundary between Interactions and explicit GenerateContent caching.
- Keep provider detail out of the installed runtime prompt except for the portable layout contract. State clearly that
  host support, API shape, model thresholds, cache retention, pricing, and telemetry availability must be detected by
  the host and are not workflow gates.
- Extend the canonical telemetry guidance to preserve provider-reported cache reads and writes when available,
  normalize them without estimating unavailable values, and distinguish cache effectiveness from total token,
  output-token, latency, or correctness outcomes.
- Add focused static/behavioral contracts for the portable ordering, volatile-suffix exclusion, provider-neutral
  fallback, and honest cache telemetry. Regenerate the managed `.ai/` projection via `./install.sh` and keep source and
  generated runtime content synchronized.

## Non-goals

- Do not add provider SDKs, API clients, credentials, cache storage, vendor-specific host configuration, or a runtime
  cache implementation to Sia.
- Do not guarantee cache hits, savings, model selection, pricing, or telemetry availability; do not make caching a
  route, approval, or completion gate.
- Do not change unrelated operation semantics, authorization boundaries, or project-owned `.ai/` extensions.

## Acceptance

- A bounded Sia handoff has an explicitly stable, deterministic prefix and an explicitly variable suffix, preserving
  the current least-context and `do_not_load` safeguards.
- The provider reference differentiates OpenAI, Anthropic, and Gemini capabilities, prerequisites, invalidators, and
  reported cache metrics using verified official documentation; it gives portable fallback guidance when a host exposes
  none of those controls.
- Cache usage reporting never fabricates values and retains current generic telemetry compatibility while allowing
  provider-specific read/write figures to be reported truthfully.
- Canonical source, generated managed projection, documentation links, and focused static contracts agree; the
  repository verifier passes.

## Checks

- Run `./install.sh`, then inspect the managed `.ai/` diff separately from source changes.
- Run `sh scripts/verify static` for source layout, Markdown, catalog, and prompt-budget checks.
- Run `sh scripts/verify` for the full deterministic behavior, workflow, routing, installer, and host-harness suite.

## Risks and external actions

- Provider cache controls, thresholds, TTLs, and pricing change frequently. Treat the provider reference as
  time-sensitive, cite official documentation, and avoid hard-coding economics into portable runtime instructions.
- A longer stable prefix can increase cache-write cost or miss provider thresholds; preserve minimal context and make
  cache effectiveness observable rather than assuming a win.
- No external state changes are authorized. Official provider documentation may be consulted as read-only evidence.
<!-- sia:approval:end -->

<!-- sia:approved 98a2f083ee633d28ee59232db103871d4d6c5759acce02affc1df30010424f0e -->
<!-- sia:status complete -->
<!-- sia:base 27b66262fb79fb787495da6cfd5819e8b2945c14 -->
<!-- sia:progress build: added cache-aware protocol layout, provider guidance, telemetry mapping, and contracts -->
<!-- sia:progress review-validate: managed projection matches source; static and full verifier passed -->
<!-- sia:progress ship: completed without external delivery actions -->
