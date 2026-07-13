#!/bin/sh

set -u

ROOT=$(CDPATH= cd "$(dirname "$0")/../../.." && pwd)
. "$ROOT/tests/lib/test.sh"

PROTOCOL=$ROOT/src/managed/.ai/sia.md
DELIVERY=$ROOT/src/managed/.ai/workflows/sia/delivery.md
INVESTIGATION=$ROOT/src/managed/.ai/workflows/sia/investigation.md
REVIEW=$ROOT/src/managed/.ai/workflows/sia/review.md
DOCUMENT=$ROOT/src/managed/.ai/operations/sia/document.md
INITIAL_FIXTURE=$ROOT/tests/behavior/workflows/fixtures/unattended-initial.md
BLOCKED_FIXTURE=$ROOT/tests/behavior/workflows/fixtures/unattended-blocked-replan.md

check_bounded_handoff() {
  for value in \
    'handoff_protocol: 1' \
    'artifact_id:' \
    'approved_revision:' \
    'execution_mode:' \
    'authorization_ceiling:' \
    'authorized_external_actions:' \
    'operation:' \
    'workflow:' \
    'phase:' \
    'acceptance_criteria:' \
    'repository_root:' \
    'base_ref:' \
    'definition_paths:' \
    'do_not_load:' \
    'command_results:' \
    'usage:' \
    'requested_model_profile:' \
    'final_task:' \
    'handoff_result: 1'; do
    assert_contains "$PROTOCOL" "$value" || return 1
  done
  assert_contains "$PROTOCOL" 'reroute the task' || return 1
  assert_contains "$PROTOCOL" 'Sia handoff' || return 1
}

check_unattended_delivery() {
  assert_contains "$DELIVERY" 'execution_mode: interactive' || return 1
  assert_contains "$DELIVERY" '`execution_mode: unattended`' || return 1
  assert_contains "$DELIVERY" 'plan_revision: 1' || return 1
  assert_contains "$DELIVERY" 'authorization_source: explicit-user' || return 1
  assert_contains "$DELIVERY" 'up-front unattended authorization' || return 1
  assert_contains "$DELIVERY" 'plain-language approval' || return 1
  assert_contains "$DELIVERY" 'Never ask the user to copy, repeat, inspect, or compare a digest' || return 1
  assert_contains "$DELIVERY" 'Review/Validate' || return 1
  assert_contains "$DELIVERY" 'blocks instead of asking' || return 1
  assert_contains "$DELIVERY" 'host permissions or external actions' || return 1
}

fixture_field() {
  sed -n "s/^$1: //p" "$2" | sed -n '1p'
}

check_unattended_artifact_fixtures() {
  for fixture in "$INITIAL_FIXTURE" "$BLOCKED_FIXTURE"; do
    assert_nonempty "$fixture" || return 1
    assert_fixed_count "$fixture" 'execution_mode: unattended' 2 || return 1
    assert_fixed_count "$fixture" 'authorization_ceiling:' 2 || return 1
    assert_fixed_count "$fixture" 'authorized_external_actions: []' 2 || return 1
    assert_contains "$fixture" 'authorization_source: unattended-invocation' || return 1
  done
  assert_equal "$(fixture_field authorization_ceiling "$INITIAL_FIXTURE")" \
    "$(fixture_field authorization_ceiling "$BLOCKED_FIXTURE")" \
    'unattended replan changed its authorization ceiling' || return 1
  assert_equal "$(fixture_field authorized_external_actions "$INITIAL_FIXTURE")" \
    "$(fixture_field authorized_external_actions "$BLOCKED_FIXTURE")" \
    'unattended replan changed its external-action authority' || return 1
  assert_contains "$BLOCKED_FIXTURE" 'status: blocked' || return 1
  assert_contains "$BLOCKED_FIXTURE" '```sia-blocker' || return 1
  assert_contains "$BLOCKED_FIXTURE" 'resume_status: in-progress' || return 1
  assert_contains "$BLOCKED_FIXTURE" 'attempt: 1' || return 1
  assert_contains "$BLOCKED_FIXTURE" 'resume_when:' || return 1
  assert_contains "$BLOCKED_FIXTURE" 'make attribution unsafe' || return 1
  assert_contains "$BLOCKED_FIXTURE" 'plan_revision: 1' || return 1
  assert_contains "$BLOCKED_FIXTURE" 'plan_revision: 2' || return 1
  assert_contains "$DELIVERY" 'Allow at most three unattended Review/Validate → Fix cycles' || return 1
  assert_contains "$DELIVERY" 'unsafe overlap or attribution is' || return 1
}

check_delivery_is_resumable() {
  assert_contains "$DELIVERY" 'Sia resume <approved-plan>' || return 1
  assert_contains "$DELIVERY" 'Load only the named active plan' || return 1
  assert_contains "$DELIVERY" '<!-- sia:approval:start -->' || return 1
  assert_contains "$DELIVERY" '<!-- sia:evidence:start -->' || return 1
  assert_contains "$DELIVERY" 'same-context execution' || return 1
  assert_contains "$DELIVERY" 'active plan status and completion evidence only' || return 1
  assert_contains "$DELIVERY" '```sia-phase-boundary' || return 1
  assert_contains "$DELIVERY" 'During Plan, record' || return 1
  assert_contains "$DELIVERY" '## Lifecycle state' || return 1
  assert_contains "$DELIVERY" 'Approval → Build' || return 1
  assert_contains "$DELIVERY" 'Ship → none' || return 1
  assert_contains "$DELIVERY" 'explicit affirmative response' || return 1
  assert_contains "$DELIVERY" 'Unattended execution always' || return 1
  for baseline in staged_paths unstaged_paths untracked_paths; do
    assert_contains "$DELIVERY" "$baseline" || return 1
  done
}

check_parallel_work_is_bounded() {
  assert_contains "$INVESTIGATION" 'Independent areas' || return 1
  assert_contains "$INVESTIGATION" 'must not' || return 1
  assert_contains "$INVESTIGATION" 'overlap' || return 1
  assert_contains "$REVIEW" 'Independent, non-overlapping areas' || return 1
  for workflow in "$INVESTIGATION" "$REVIEW"; do
    assert_contains "$workflow" 'do_not_load' || return 1
    assert_contains "$workflow" 'coordinating session' || return 1
  done
}

check_read_only_workflows() {
  assert_contains "$INVESTIGATION" 'read-only' || return 1
  assert_contains "$REVIEW" 'read-only' || return 1
  assert_contains "$REVIEW" 'never make those edits' || return 1
}

check_phase_specific_skill_composition() {
  assert_contains "$DOCUMENT" '  - documentation' || return 1
  assert_contains "$DELIVERY" 'Resolve Build skills by logical name through the effective skill catalog' || return 1
  assert_contains "$DELIVERY" 'effective `documentation` skill' || return 1
  assert_contains "$DELIVERY" 'effective `safe-refactoring` skill only when' || return 1
  assert_contains "$DELIVERY" 'effective `code-review` and `testing` skills' || return 1
  assert_contains "$DELIVERY" 'respect a CUSTOM' || return 1
}

run_case "isolated phases receive the complete bounded handoff" check_bounded_handoff
run_case "delivery approval and resume remain artifact-based" check_delivery_is_resumable
run_case "unattended delivery preserves artifacts, review, and safety boundaries" check_unattended_delivery
run_case "unattended artifacts preserve authority and block boundedly" check_unattended_artifact_fixtures
run_case "parallel investigation and review partitions remain bounded" check_parallel_work_is_bounded
run_case "investigation and standalone review are read-only" check_read_only_workflows
run_case "delivery composes override-aware skills by phase" check_phase_specific_skill_composition

finish_tests
