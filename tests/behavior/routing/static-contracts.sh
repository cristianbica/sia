#!/bin/sh

set -u

ROOT=$(CDPATH= cd "$(dirname "$0")/../../.." && pwd)
. "$ROOT/tests/lib/test.sh"

DELIVERY="$ROOT/src/managed/.ai/workflows/sia/delivery.md"
IMPLEMENT="$ROOT/src/managed/.ai/operations/sia/implement.md"
ORCHESTRATION="$ROOT/docs/orchestration.md"
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
  assert_contains "$DELIVERY" 'execution_route' || return 1
  assert_contains "$DELIVERY" 'Size is supporting evidence' || return 1
  assert_contains "$DELIVERY" 'promotes it to `lightweight` or `standard`' || return 1
  assert_contains "$IMPLEMENT" 'Announce the selected execution route' || return 1
  assert_contains "$IMPLEMENT" 'full or thorough' || return 1
}

check_trivial_contract() {
  assert_contains "$DELIVERY" 'no plan or approval artifact' || return 1
  assert_contains "$DELIVERY" 'do not create a' || return 1
  assert_contains "$DELIVERY" 'spawn a worker solely' || return 1
  assert_contains "$TRIVIAL_FIXTURE" 'expected_route: trivial' || return 1
  assert_contains "$TRIVIAL_FIXTURE" 'behavior_change: false' || return 1
}

check_lightweight_contract() {
  assert_contains "$DELIVERY" 'directly authorizes a compact receipt' || return 1
  assert_contains "$DELIVERY" 'activating request authorizes lightweight' || return 1
  assert_contains "$DELIVERY" 'one bounded Build handoff' || return 1
  assert_contains "$DELIVERY" 'independent review worker' || return 1
  assert_contains "$DELIVERY" 'promote to standard' || return 1
  assert_contains "$DELIVERY" 'internal repository-source behavior' || return 1
  assert_contains "$DELIVERY" 'focused test' || return 1
  assert_contains "$DELIVERY" 'managed-Sia' || return 1
  assert_contains "$LIGHTWEIGHT_FIXTURE" 'expected_route: lightweight' || return 1
  assert_contains "$LIGHTWEIGHT_FIXTURE" 'authorization_source: activating-request' || return 1
  assert_contains "$LIGHTWEIGHT_FIXTURE" '.ai/skills/example/SKILL.md' || return 1
  assert_contains "$LIGHTWEIGHT_SOURCE_FIXTURE" 'expected_route: lightweight' || return 1
  assert_contains "$LIGHTWEIGHT_SOURCE_FIXTURE" 'authorization_source: activating-request' || return 1
  assert_contains "$LIGHTWEIGHT_SOURCE_FIXTURE" 'focused_test: test/options_test.rb' || return 1
}

check_intent_envelope_contract() {
  assert_contains "$DELIVERY" 'one interactive approval for a standard intent envelope' || return 1
  assert_contains "$DELIVERY" 'implementation approach, step order, focused checks' || return 1
  assert_contains "$DELIVERY" 'external actions expand' || return 1
  assert_contains "$IN_ENVELOPE_FIXTURE" 'requires_new_approval: false' || return 1
  assert_contains "$BOUNDARY_FIXTURE" 'requires_new_approval: true' || return 1
}

check_standard_and_backward_compatibility() {
  assert_contains "$DELIVERY" 'missing route metadata' || return 1
  assert_contains "$DELIVERY" 'optional for backward compatibility' || return 1
  assert_contains "$DELIVERY" 'product/source change not fully qualifying' || return 1
  assert_contains "$STANDARD_FIXTURE" 'expected_route: standard' || return 1
  assert_contains "$STANDARD_FIXTURE" 'product/source' || return 1
  assert_contains "$LEGACY_FIXTURE" 'expected_route: standard' || return 1
  assert_not_contains "$LEGACY_FIXTURE" 'execution_route:' || return 1
}

check_context_and_benchmark_contract() {
  assert_contains "$DELIVERY" 'do not reread catalogs, broad docs' || return 1
  assert_contains "$DELIVERY" 'Lightweight loads only' || return 1
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
  assert_contains "$ORCHESTRATION" 'never estimate' || return 1
  assert_contains "$ORCHESTRATION" 'child-worker usage' || return 1
  assert_contains "$ORCHESTRATION" 'not a cost guarantee' || return 1
}

run_case "adaptive route contract is explicit and conservative" check_route_contract
run_case "trivial work remains planless and exact-file scoped" check_trivial_contract
run_case "lightweight work is directly authorized and remains bounded" check_lightweight_contract
run_case "standard intent envelopes distinguish evidence from boundary changes" check_intent_envelope_contract
run_case "standard routing and old-plan compatibility remain explicit" check_standard_and_backward_compatibility
run_case "lightweight context and benchmark validation remain bounded" check_context_and_benchmark_contract
run_case "wait and usage telemetry guidance prevents hidden context waste" check_wait_and_telemetry_contract

finish_tests
