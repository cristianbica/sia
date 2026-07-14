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
  assert_contains "$DELIVERY" 'mode: unattended' || return 1
  assert_contains "$DELIVERY" '`ceiling` immutable' || return 1
  assert_contains "$DELIVERY" 'one interactive approval for standard work' || return 1
  assert_contains "$DELIVERY" 'never ask users to compare a digest' || return 1
  assert_contains "$DELIVERY" 'Review/Validate' || return 1
  assert_contains "$DELIVERY" 'blocks instead of asking' || return 1
  assert_contains "$DELIVERY" 'Neither mode expands host' || return 1
}

comment_value() {
  sed -n "s/^<!-- sia:$1 \(.*\) -->$/\1/p" "$2" | sed -n '1p'
}

check_unattended_artifact_fixtures() {
  for fixture in "$INITIAL_FIXTURE" "$BLOCKED_FIXTURE"; do
    assert_nonempty "$fixture" || return 1
    assert_fixed_count "$fixture" '<!-- sia:status ' 1 || return 1
    assert_fixed_count "$fixture" '<!-- sia:mode unattended -->' 1 || return 1
    assert_fixed_count "$fixture" '<!-- sia:ceiling ' 1 || return 1
    assert_contains "$fixture" 'approved fixture-digest' || return 1
    assert_not_contains "$fixture" 'revision:' || return 1
  done
  assert_equal "$(comment_value ceiling "$INITIAL_FIXTURE")" \
    "$(comment_value ceiling "$BLOCKED_FIXTURE")" \
    'unattended replan changed its authorization ceiling' || return 1
  assert_contains "$BLOCKED_FIXTURE" '<!-- sia:status blocked -->' || return 1
  assert_contains "$BLOCKED_FIXTURE" '<!-- sia:blocker fix:' || return 1
  assert_contains "$BLOCKED_FIXTURE" 'make attribution unsafe' || return 1
  assert_contains "$DELIVERY" 'at most three Fix cycles' || return 1
  assert_contains "$DELIVERY" 'unsafe overlap or attribution' || return 1
}

check_delivery_is_resumable() {
  assert_contains "$DELIVERY" '<!-- sia:approval:start -->' || return 1
  assert_contains "$DELIVERY" '<!-- sia:status pending-approval -->' || return 1
  assert_contains "$DELIVERY" 'frontmatter has no ID, status, revision' || return 1
  assert_contains "$DELIVERY" 'legacy artifacts unchanged' || return 1
  assert_contains "$DELIVERY" 'same-context execution' || return 1
  assert_contains "$DELIVERY" 'one interactive approval for standard work' || return 1
  assert_contains "$DELIVERY" 'directly authorizes a compact receipt' || return 1
  assert_contains "$DELIVERY" 'matching approval digest' || return 1
  assert_contains "$DELIVERY" 'optional `base` and `dirty` comments' || return 1
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
  assert_contains "$DELIVERY" 'Resolve required skills' || return 1
  assert_contains "$DELIVERY" 'load `documentation` or `safe-refactoring` only when material' || return 1
  assert_contains "$DELIVERY" 'effective `code-review` and `testing` skills' || return 1
  assert_contains "$DELIVERY" 'lightweight loads only' || return 1
  assert_contains "$DELIVERY" 'focused diff/scope check' || return 1
  assert_contains "$DELIVERY" 'CUSTOM' || return 1
}

run_case "isolated phases receive the complete bounded handoff" check_bounded_handoff
run_case "delivery approval and resume remain artifact-based" check_delivery_is_resumable
run_case "unattended delivery preserves artifacts, review, and safety boundaries" check_unattended_delivery
run_case "unattended artifacts preserve authority and block boundedly" check_unattended_artifact_fixtures
run_case "parallel investigation and review partitions remain bounded" check_parallel_work_is_bounded
run_case "investigation and standalone review are read-only" check_read_only_workflows
run_case "delivery composes override-aware skills by phase" check_phase_specific_skill_composition

finish_tests
