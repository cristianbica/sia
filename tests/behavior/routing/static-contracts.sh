#!/bin/sh

set -u

ROOT=$(CDPATH= cd "$(dirname "$0")/../../.." && pwd)
. "$ROOT/tests/lib/test.sh"

DELIVERY="$ROOT/src/managed/.ai/workflows/sia/delivery.md"
IMPLEMENT="$ROOT/src/managed/.ai/operations/sia/implement.md"
ORCHESTRATION="$ROOT/docs/orchestration.md"
PROMPT_CACHING="$ROOT/docs/prompt-caching.md"
PROTOCOL="$ROOT/src/managed/.ai/sia.md"
LIGHTWEIGHT_FIXTURE="$ROOT/tests/behavior/routing/fixtures/lightweight-skill.md"
LIGHTWEIGHT_SOURCE_FIXTURE="$ROOT/tests/behavior/routing/fixtures/lightweight-source-fix.md"
IN_ENVELOPE_FIXTURE="$ROOT/tests/behavior/routing/fixtures/standard-in-envelope-replan.md"
BOUNDARY_FIXTURE="$ROOT/tests/behavior/routing/fixtures/standard-boundary-replan.md"
STANDARD_FIXTURE="$ROOT/tests/behavior/routing/fixtures/standard-feature.md"
TRIVIAL_FIXTURE="$ROOT/tests/behavior/routing/fixtures/trivial-wording.md"
LEGACY_FIXTURE="$ROOT/tests/behavior/routing/fixtures/legacy-plan.md"
BENCHMARK="$ROOT/.ai/workflows/benchmark.md"

check_route_contract() {
  for route in trivial lightweight standard; do
    assert_contains "$DELIVERY" "\`$route\`" || return 1
  done
  assert_contains "$DELIVERY" 'Size is supporting evidence' || return 1
  assert_contains "$DELIVERY" 'Promote before a new' || return 1
  assert_contains "$IMPLEMENT" 'Announce the selected execution route' || return 1
  assert_contains "$IMPLEMENT" 'full or thorough' || return 1
}

check_trivial_contract() {
  assert_contains "$DELIVERY" 'no artifact or approval' || return 1
  assert_contains "$TRIVIAL_FIXTURE" 'expected_route: trivial' || return 1
  assert_contains "$TRIVIAL_FIXTURE" 'behavior_change: false' || return 1
}

check_lightweight_contract() {
  assert_contains "$DELIVERY" 'directly authorizes a compact receipt' || return 1
  assert_contains "$DELIVERY" 'activating request authorizes lightweight' || return 1
  assert_contains "$DELIVERY" 'one Build handoff' || return 1
  assert_contains "$DELIVERY" 'independent review worker' || return 1
  assert_contains "$DELIVERY" 'Promote before a new' || return 1
  assert_contains "$DELIVERY" 'one internal source change' || return 1
  assert_contains "$DELIVERY" 'focused test' || return 1
  assert_contains "$DELIVERY" 'managed-Sia' || return 1
  assert_contains "$DELIVERY" 'shows an inline compact receipt' || return 1
  assert_contains "$DELIVERY" 'outcome, exact paths or bounded area' || return 1
  assert_contains "$DELIVERY" 'does not ask for another approval' || return 1
  assert_contains "$DELIVERY" 'does not write `.ai/plans/`' || return 1
  assert_contains "$DELIVERY" 'become a `Sia resume` target' || return 1
  assert_contains "$ORCHESTRATION" 'It does not create a plan artifact' || return 1
  assert_contains "$LIGHTWEIGHT_FIXTURE" 'expected_route: lightweight' || return 1
  assert_contains "$LIGHTWEIGHT_FIXTURE" 'authorization_source: activating-request' || return 1
  assert_contains "$LIGHTWEIGHT_FIXTURE" '.ai/skills/example/SKILL.md' || return 1
  assert_contains "$LIGHTWEIGHT_SOURCE_FIXTURE" 'expected_route: lightweight' || return 1
  assert_contains "$LIGHTWEIGHT_SOURCE_FIXTURE" 'authorization_source: activating-request' || return 1
  assert_contains "$LIGHTWEIGHT_SOURCE_FIXTURE" 'focused_test: test/options_test.rb' || return 1
}

check_intent_envelope_contract() {
  assert_contains "$DELIVERY" 'one interactive approval for standard work' || return 1
  assert_contains "$DELIVERY" 'implementation approach, step order, focused checks' || return 1
  assert_contains "$DELIVERY" 'external actions expand' || return 1
  assert_contains "$IN_ENVELOPE_FIXTURE" 'requires_new_approval: false' || return 1
  assert_contains "$BOUNDARY_FIXTURE" 'requires_new_approval: true' || return 1
}

check_standard_and_backward_compatibility() {
  assert_contains "$DELIVERY" 'legacy artifacts unchanged' || return 1
  assert_contains "$DELIVERY" 'every change not fully qualifying for lightweight' || return 1
  assert_contains "$STANDARD_FIXTURE" 'expected_route: standard' || return 1
  assert_contains "$STANDARD_FIXTURE" 'product/source' || return 1
  assert_contains "$LEGACY_FIXTURE" 'expected_route: standard' || return 1
  assert_not_contains "$LEGACY_FIXTURE" 'execution_route:' || return 1
}

check_context_and_benchmark_contract() {
  assert_contains "$DELIVERY" 'do not reread catalogs, broad docs' || return 1
  assert_contains "$DELIVERY" 'lightweight loads only `testing`' || return 1
  assert_contains "$DELIVERY" 'focused diff/scope check' || return 1
  assert_contains "$BENCHMARK" 'same validation instruction' || return 1
  assert_contains "$BENCHMARK" "manifest's broad checks" || return 1
  assert_contains "$BENCHMARK" 'coordinator runs those same manifest checks' || return 1
}

check_wait_and_telemetry_contract() {
  assert_contains "$ORCHESTRATION" 'Do not poll every few seconds' || return 1
  assert_contains "$DELIVERY" 'longest-safe wait' || return 1
  assert_contains "$DELIVERY" 'never poll without new evidence' || return 1
  assert_contains "$ORCHESTRATION" 'input_tokens' || return 1
  assert_contains "$ORCHESTRATION" 'cached_input_tokens' || return 1
  assert_contains "$ORCHESTRATION" 'cache_read_input_tokens' || return 1
  assert_contains "$ORCHESTRATION" 'cache_write_input_tokens' || return 1
  assert_contains "$ORCHESTRATION" 'never estimate' || return 1
  assert_contains "$ORCHESTRATION" 'child-worker usage' || return 1
  assert_contains "$ORCHESTRATION" 'not a cost guarantee' || return 1
  assert_contains "$PROTOCOL" 'lean, deterministic cache-aware order' || return 1
  assert_contains "$PROTOCOL" 'State each invariant once' || return 1
  assert_contains "$PROTOCOL" 'timestamps, run IDs, volatile telemetry' || return 1
  assert_contains "$PROMPT_CACHING" 'Portable fallback' || return 1
  assert_contains "$PROMPT_CACHING" 'OpenAI' || return 1
  assert_contains "$PROMPT_CACHING" 'Anthropic' || return 1
  assert_contains "$PROMPT_CACHING" 'Gemini' || return 1
  assert_contains "$PROMPT_CACHING" 'prompt_cache_key' || return 1
  assert_contains "$PROMPT_CACHING" 'cache_write_tokens' || return 1
  assert_contains "$PROMPT_CACHING" 'cold and warm' || return 1
}

check_forge_contract() {
  assert_contains "$ORCHESTRATION" '## Forge mode' || return 1
  assert_contains "$ORCHESTRATION" 'Sia forge on' || return 1
  assert_contains "$ORCHESTRATION" 'Sia forge off' || return 1
  assert_contains "$ORCHESTRATION" 'Questions receive direct answers' || return 1
  assert_contains "$ORCHESTRATION" '`Read tmp/review-mandates.md`' || return 1
  assert_contains "$ORCHESTRATION" '`Sia Read tmp/review-mandates.md` follows the same immediate path' || return 1
  assert_contains "$ORCHESTRATION" '`Sia implement feature X`' || return 1
  assert_contains "$ORCHESTRATION" '`Sia fix bug Y`' || return 1
  assert_contains "$ORCHESTRATION" 'Turn Forge off first' || return 1
  assert_contains "$ORCHESTRATION" 'Forge is context-first for terse follow-ups' || return 1
  assert_contains "$ORCHESTRATION" 'reopening files or repeating searches' || return 1
  assert_contains "$ORCHESTRATION" 'one focused clarification' || return 1
  assert_contains "$ORCHESTRATION" '`inline plan` request is a cadence instruction' || return 1
  assert_contains "$ORCHESTRATION" 'only minimum' || return 1
  assert_contains "$ORCHESTRATION" 'without routine command' || return 1
  assert_contains "$ORCHESTRATION" '`done and move to next one. inline plan`' || return 1
  assert_contains "$ORCHESTRATION" 'reads the file and returns the result directly' || return 1
  assert_contains "$ORCHESTRATION" 'non-mutating local work runs immediately' || return 1
  assert_contains "$ORCHESTRATION" 'without a plan or approval' || return 1
  assert_contains "$ORCHESTRATION" 'local diagnostics whose purpose' || return 1
  assert_contains "$ORCHESTRATION" 'unexpectedly changes durable state' || return 1
  assert_contains "$ORCHESTRATION" 'Changes that do not qualify for direct execution and all external actions' || return 1
  assert_contains "$ORCHESTRATION" 'inline plan → explicit approval' || return 1
  assert_contains "$ORCHESTRATION" 'direct bounded-write lane' || return 1
  assert_contains "$ORCHESTRATION" 'precise imperative is its own authorization' || return 1
  assert_contains "$ORCHESTRATION" '`do:` explicitly requests direct execution' || return 1
  assert_contains "$ORCHESTRATION" '`plan:` and `inline plan` explicitly request the approval path' || return 1
  assert_contains "$ORCHESTRATION" '`mark #4 done`' || return 1
  assert_contains "$ORCHESTRATION" '`handle #5`' || return 1
  assert_contains "$ORCHESTRATION" 'stops before crossing the bounded request' || return 1
  assert_contains "$ORCHESTRATION" 'Approval binds one visible task' || return 1
  assert_contains "$ORCHESTRATION" 'writes no `.ai/plans/**`' || return 1
  assert_contains "$ORCHESTRATION" 'ready for the next request' || return 1
  assert_contains "$PROTOCOL" 'Reuse active context' || return 1
  assert_contains "$PROTOCOL" 'resolve clear terse follow-ups without fresh intake' || return 1
  assert_contains "$PROTOCOL" 'precise bounded imperative authorizes its local write' || return 1
  assert_contains "$PROTOCOL" '`do:` requests that lane' || return 1
  assert_contains "$PROTOCOL" '`plan:`/`inline plan` or uncertainty requires approval' || return 1
  assert_contains "$PROTOCOL" 'prefixed operations stay in Forge' || return 1
  assert_not_contains "$PROTOCOL" 'every action gets an' || return 1
}

run_case "adaptive route contract is explicit and conservative" check_route_contract
run_case "trivial work remains planless and exact-file scoped" check_trivial_contract
run_case "lightweight work is directly authorized and remains bounded" check_lightweight_contract
run_case "standard intent envelopes distinguish evidence from boundary changes" check_intent_envelope_contract
run_case "standard routing and old-plan compatibility remain explicit" check_standard_and_backward_compatibility
run_case "lightweight context and benchmark validation remain bounded" check_context_and_benchmark_contract
run_case "wait and usage telemetry guidance prevents hidden context waste" check_wait_and_telemetry_contract
run_case "Forge reuses context and presents requested inline plans promptly" check_forge_contract

finish_tests
