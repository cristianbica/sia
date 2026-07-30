# Prompt caching

Sia has no runtime or provider client, so it cannot create, configure, or guarantee a prompt cache. It can make the
prompts it owns easier for a capable host to reuse: render a small stable prefix in the same order, then append the
changing request suffix. Whether that reduces cost or latency depends on the provider, model, API, request shape,
cache lifetime, and workload.

## Portable layout

For a phase prompt or bounded handoff, put these reusable items first and preserve their bytes and order across
requests:

1. Protocol and project rules.
2. Resolved route, workflow, definitions, and only task-relevant invariant tool/context declarations.
3. Durable documentation pointers and other reusable references.

State each invariant once. Prefer exact paths and focused excerpts to replaying whole documents, catalogs, plans, tool
lists, examples, or successful output. Append active plan state, focused evidence, current constraints, and one final
task after that prefix. Do not add timestamps, run identifiers, volatile telemetry, user-specific values, or broad
command output before the cache boundary.

Keep the prefix minimal: a cache write for unnecessary context can cost more than omitting it. Sia must keep using
bounded handoffs, phase-specific excerpts, and `do_not_load`; caching never justifies replaying a repository, catalog,
historical plan, or successful bulk output. Hosts may use a different message format, omit cache controls, or provide
no cache telemetry without changing Sia's workflow, approval, or completion requirements.

## Provider mapping

### OpenAI

[OpenAI prompt caching](https://developers.openai.com/api/docs/guides/prompt-caching) automatically considers eligible
recent-model requests whose rendered prompt is at least 1,024 tokens. Exact prefix reuse still matters: put stable
instructions, examples, tools, and files first, then variable input. For GPT-5.6 and later model families, a host
should reuse a stable, privacy-safe `prompt_cache_key` for requests with the same long prefix; the key improves cache
routing and matching but must not contain user data or a per-request value.

When a GPT-5.6-family host can identify a long reusable prefix, it may place an explicit breakpoint at the end of that
prefix and choose `prompt_cache_options.mode: "explicit"` to avoid writing transient suffixes. Explicit controls are
model/API capabilities, not portable Sia requirements. The documented minimum cache lifetime is currently 30 minutes;
hosts must feature-detect support and retain implicit caching for older models. Record provider-reported
`cached_tokens` and `cache_write_tokens` separately. GPT-5.6-family cache writes are billed at a higher rate than
uncached input, so a read count alone is not proof of a net saving.

### Anthropic

[Anthropic prompt caching](https://platform.claude.com/docs/en/build-with-claude/prompt-caching) builds a cumulative
prefix in `tools` → `system` → `messages` order. Where supported, begin with automatic caching and place static tool
definitions, system instructions, context, and examples first. Use an explicit `cache_control` breakpoint only when a
host needs independently reusable regions with different change frequencies; put it on the final stable block, not on
a timestamp, incoming request, or mutable tool setting. Any change at or before a breakpoint invalidates the dependent
prefix, including reordered tools or altered system content.

The normal TTL is five minutes; select a one-hour TTL only when the reuse horizon justifies its higher write cost.
Automatic caching availability and token thresholds vary by model and platform, and Bedrock does not support Anthropic
automatic caching. Preserve `cache_read_input_tokens`, `cache_creation_input_tokens`, and per-TTL cache-creation fields
when the host reports them. [Cache diagnostics](https://platform.claude.com/docs/en/build-with-claude/cache-diagnostics)
is a Claude-API beta capability that can identify the first divergent request component; treat it as optional host
troubleshooting, not a Sia dependency.

### Gemini

[Gemini context caching](https://ai.google.dev/gemini-api/docs/caching?hl=en) implicitly reuses common prefixes on
supported models. Put large common content first and send similar prefixes close together; inspect
`usage.total_cached_tokens` when exposed. The documented Interactions API supports implicit caching only, whereas the
GenerateContent API can provide explicit cached-content resources. Token thresholds and cache capabilities are
model/API-specific, so hosts must verify them before selecting an approach.

## Telemetry and evaluation

Use `cached_input_tokens` as the portable aggregate when that is all a host reports. When a provider exposes a split,
also record `cache_read_input_tokens` and `cache_write_input_tokens`; map a provider's cache-creation field to writes
without inventing absent values. Keep `unknown` for unavailable fields, and never derive child-worker cache use from a
coordinator's totals.

Evaluate equivalent cold and warm runs with task correctness, scope, total input, uncached input, cache reads, cache
writes, output tokens, reasoning tokens, and latency. Estimate provider cost only when all applicable input,
cache-read, cache-write, and output rates are known for the selected model/API; otherwise report cost as `unknown`.
Cache reads are not proof of lower total cost, better answers, or lower rate-limit usage. Cache thresholds, write
prices, expiry, and provider behavior change, so refresh this reference from official documentation when revisiting the
comparison.

## Portable fallback

When a host exposes no cache controls or metrics, preserve the lean stable-prefix layout and context budget anyway. It
still reduces avoidable prompt variation and keeps Sia portable; report cache values as `unknown` rather than estimating
savings.
