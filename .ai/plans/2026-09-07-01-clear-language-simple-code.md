---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Clear language and simple code

<!-- sia:approval:start -->
## Scope

Make Sia replies easier to understand and implementations simpler. Replace response rules with concrete wording,
connected sentences, necessary detail, and one small example. Simplify user-facing reporting while retaining required
internal records. Strengthen Build guidance for existing patterns, direct code, and justified abstractions, options,
dependencies, and fallbacks.

Update the protocol, delivery/reporting guidance, related documentation, contract checks, and existing concise-output
benchmark. Add dense-language cases and small coding tasks. Preserve approval gates, workflow phases, required error
handling, and compatibility. No unrelated cleanup, model migration, or external publishing.

## Acceptance

Clarity takes priority over shortest output. Reports cover results, meaningful checks, and unresolved issues without
routine internal detail. Code guidance favors the current requirement and preserves necessary safeguards.
Benchmark review covers correctness, readability, scope, and unnecessary complexity; length is diagnostic, not a
mandatory reduction. Keep prompt budgets. Run focused checks and the verifier, then refresh `.ai` through the installer.

## Risks and external actions

Prompt improvements need live comparisons to establish effectiveness. Live model calls require a separately agreed
budget and are excluded from this implementation. No external writes. Simplicity must not weaken correctness or gates.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base e630499f29cd518407674f1755faf85b2226e9b3 -->
<!-- sia:approved 1571807ac1f79fcc243adf473ca1cb8df3278e12c7b4a8b2557dc068a88b0895 -->
<!-- sia:progress approval: User approved the proposed plan in this conversation; recorded before Build. -->
<!-- sia:progress build: Updated prompts, reporting, docs, and 12 benchmark cases; installer refresh passed. -->
<!-- sia:progress validation: sh scripts/verify passed; 12 cases valid; 25 stub calls passed; live models not run. -->
<!-- sia:progress review: Separate reviewer inspected the scoped diff and validation evidence; no material findings. -->
<!-- sia:progress checks: sh scripts/verify; sh benchmarks/concise-output/run.sh check; python /tmp/check-sia-benchmark.py; ./install.sh all passed. -->
<!-- sia:progress evidence: /tmp/sia-simplicity-verify.log; installed files match source; git diff --check passed. -->
<!-- sia:progress usage: Standard route; reviewer used inherited context; actual model and token usage unknown. -->
<!-- sia:progress ship: Completed approved scope and retained plan; live behavioral comparison remains unverified. -->
