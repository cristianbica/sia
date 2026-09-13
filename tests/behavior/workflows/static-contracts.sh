#!/bin/sh

set -u

ROOT=$(CDPATH= cd "$(dirname "$0")/../../.." && pwd)
. "$ROOT/tests/lib/test.sh"

# Check shared invariants across the split workflow; route selection is tested separately.
DELIVERY_CONTEXT=$(mktemp "${TMPDIR:-/tmp}/sia-delivery-contracts.XXXXXX") || exit 1
trap 'rm -f "$DELIVERY_CONTEXT"' EXIT
cat "$ROOT/src/managed/.ai/workflows/sia/delivery.md" \
  "$ROOT"/src/managed/.ai/workflows/sia/delivery/*.md >"$DELIVERY_CONTEXT"

PROTOCOL=$ROOT/src/managed/.ai/sia.md
DELIVERY=$DELIVERY_CONTEXT
INVESTIGATION=$ROOT/src/managed/.ai/workflows/sia/investigation.md
INVESTIGATE=$ROOT/src/managed/.ai/operations/sia/investigate.md
REVIEW=$ROOT/src/managed/.ai/workflows/sia/review.md
DOCUMENT=$ROOT/src/managed/.ai/operations/sia/document.md
DRAFT_FIXTURE=$ROOT/tests/behavior/workflows/fixtures/investigation-draft-plan.md
INITIAL_FIXTURE=$ROOT/tests/behavior/workflows/fixtures/unattended-initial.md
BLOCKED_FIXTURE=$ROOT/tests/behavior/workflows/fixtures/unattended-blocked-replan.md

check_bounded_handoff() {
  for value in \
    'handoff_protocol: 1' \
    'execution_mode:' \
    'authorization_ceiling:' \
    'authorized_external_actions:' \
    'authorized_plan_paths:' \
    'operation:' \
    'workflow:' \
    'phase:' \
    'acceptance_criteria:' \
    'repository_root:' \
    'definition_paths:' \
    'do_not_load:' \
    'requested_model_profile:' \
    'final_task:' \
    'handoff_result: 1'; do
    assert_contains "$PROTOCOL" "$value" || return 1
  done
  assert_contains "$PROTOCOL" 'reroute through catalogs' || return 1
  assert_contains "$PROTOCOL" 'Sia handoff' || return 1
  assert_contains "$PROTOCOL" 'every shown key is required' || return 1
  assert_contains "$PROTOCOL" 'For artifact-backed work also include artifact_id, artifact_status, approved_revision, and next_transition' || return 1
  assert_contains "$PROTOCOL" 'include base_ref and staged_paths/unstaged_paths/untracked_paths' || return 1
  assert_contains "$PROTOCOL" 'Omitted context grants no authority' || return 1
  assert_contains "$PROTOCOL" '.ai/plans/** except exact authorized_plan_paths' || return 1
  python3 - "$PROTOCOL" <<'PYTEST'
import re
import sys
from pathlib import Path
body = Path(sys.argv[1]).read_text().split('```yaml\n', 1)[1].split('```', 1)[0]
keys = re.findall(r'^([a-z_]+):', body, re.M)
required = set('handoff_protocol execution_mode authorization_ceiling authorized_external_actions '
               'authorized_plan_paths operation workflow phase requested_outcome approved_scope non_goals '
               'acceptance_criteria repository_root definition_paths allowed_work exclusions permissions '
               'do_not_load recovery requested_model_profile model_selection_source final_task'.split())
assert set(keys) == required and len(keys) == len(required), 'invalid core handoff fields'
assert keys[-1] == 'final_task', 'handoff task must be last'
assert re.search(r'^definition_paths:\n  operation: .+\n  workflow: .+\n  skills: .+', body, re.M)
PYTEST
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

check_forge_inline_delivery() {
  assert_contains "$DELIVERY" '## Forge delivery' || return 1
  assert_contains "$DELIVERY" 'later valid `Sia …` request' || return 1
  assert_contains "$DELIVERY" 'Discard the optional `Sia` prefix' || return 1
  assert_contains "$DELIVERY" 'Exact operation names and aliases stay in' || return 1
  assert_contains "$DELIVERY" 'Treat terse follow-ups as commands over active Forge context' || return 1
  assert_contains "$DELIVERY" 'do not reopen files or repeat' || return 1
  assert_contains "$DELIVERY" 'user-stated completion or transition as current context' || return 1
  assert_contains "$DELIVERY" 'ask one focused clarification' || return 1
  assert_contains "$DELIVERY" 'run immediately without operation resolution' || return 1
  assert_contains "$DELIVERY" 'safe local diagnostics' || return 1
  assert_contains "$DELIVERY" 'unexpectedly changes durable state' || return 1
  assert_contains "$DELIVERY" 'without silently retaining, reverting, or cleaning it' || return 1
  assert_contains "$DELIVERY" 'authorization clarity and boundary predictability, not size' || return 1
  assert_contains "$DELIVERY" '`do:` explicitly requests' || return 1
  assert_contains "$DELIVERY" '`plan:` and `inline plan` explicitly request' || return 1
  assert_contains "$DELIVERY" 'precise imperative with one clear target' || return 1
  assert_contains "$DELIVERY" 'request itself authorizes a qualifying bounded write' || return 1
  assert_contains "$DELIVERY" 'without an inline plan or a' || return 1
  assert_contains "$DELIVERY" 'stop before acting beyond the bounded' || return 1
  assert_contains "$DELIVERY" 'vague or outcome-oriented request such as `handle #5`' || return 1
  assert_contains "$DELIVERY" 'output and cadence instruction, not approval' || return 1
  assert_contains "$DELIVERY" 'inspect enough existing behavior, callers, and repository patterns' || return 1
  assert_contains "$DELIVERY" 'Stop when the consequential decisions are grounded' || return 1
  assert_contains "$DELIVERY" 'that cannot change the approach or scope until implementation' || return 1
  assert_contains "$DELIVERY" 'without routine command narration' || return 1
  assert_contains "$DELIVERY" 'Ask for explicit approval before the change or external action' || return 1
  assert_contains "$DELIVERY" 'Approval binds' || return 1
  assert_contains "$DELIVERY" 'only that visible task' || return 1
  assert_contains "$DELIVERY" 'Never write Forge state to `.ai/plans/**`' || return 1
  assert_contains "$DELIVERY" 'never promote Forge work to a persisted artifact solely because it is large' || return 1
  assert_contains "$DELIVERY" 'leaves Forge ready for' || return 1
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
  assert_contains "$DELIVERY" 'unavailable isolation alone does not block approved' || return 1
  assert_contains "$PROTOCOL" 'draft resumes to Approve, never Build' || return 1
  assert_contains "$DELIVERY" 'A pending draft enters Approve, never Build' || return 1
  assert_not_contains "$PROTOCOL" 'Refuse ambiguous, missing, unapproved' || return 1
  assert_contains "$PROTOCOL" 'hash UTF-8 content between the unique approval markers, excluding the markers' || return 1
  assert_contains "$PROTOCOL" 'CR to LF, preserve all other whitespace' || return 1
  assert_contains "$DELIVERY" 'one interactive approval for standard work' || return 1
  assert_contains "$DELIVERY" 'directly authorizes a compact receipt' || return 1
  assert_contains "$DELIVERY" 'matching approval digest' || return 1
  assert_contains "$DELIVERY" 'optional `base` and `dirty` comments' || return 1
  assert_contains "$DELIVERY" 'YYYY-MM-DD-NN-<slug>.md' || return 1
  assert_contains "$DELIVERY" 'UTC creation date' || return 1
  assert_contains "$DELIVERY" 'filenames only' || return 1
  assert_contains "$DELIVERY" 'immediately add its exact path' || return 1
  assert_contains "$DELIVERY" 'unauthorized plans' || return 1
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

check_investigation_draft_plan() {
  assert_contains "$INVESTIGATE" 'explicit request to save a plan' || return 1
  assert_contains "$INVESTIGATION" 'exactly one new compact delivery artifact' || return 1
  assert_contains "$INVESTIGATION" 'scouts remain fully read-only' || return 1
  assert_contains "$INVESTIGATION" 'one unambiguous effective delivery operation' || return 1
  assert_contains "$INVESTIGATION" 'inspecting filenames only' || return 1
  assert_contains "$INVESTIGATION" 'Never edit an existing plan' || return 1
  assert_contains "$INVESTIGATION" 'Sia resume <path>' || return 1
  assert_contains "$INVESTIGATION" 'no resumable artifact of its own' || return 1
  assert_nonempty "$DRAFT_FIXTURE" || return 1
  assert_fixed_count "$DRAFT_FIXTURE" '<!-- sia:approval:start -->' 1 || return 1
  assert_fixed_count "$DRAFT_FIXTURE" '<!-- sia:approval:end -->' 1 || return 1
  assert_fixed_count "$DRAFT_FIXTURE" '<!-- sia:status pending-approval -->' 1 || return 1
  assert_contains "$DRAFT_FIXTURE" '<!-- sia:base abc123 -->' || return 1
  assert_contains "$DRAFT_FIXTURE" '<!-- sia:dirty app/webhooks.rb -->' || return 1
  assert_not_contains "$DRAFT_FIXTURE" '<!-- sia:approved ' || return 1
  assert_not_contains "$DRAFT_FIXTURE" '<!-- sia:mode ' || return 1
  assert_not_contains "$DRAFT_FIXTURE" '<!-- sia:ceiling ' || return 1
  assert_not_contains "$DRAFT_FIXTURE" '<!-- sia:progress ' || return 1
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
run_case "Forge delivery uses one approved inline task without persistence" check_forge_inline_delivery
run_case "unattended artifacts preserve authority and block boundedly" check_unattended_artifact_fixtures
run_case "parallel investigation and review partitions remain bounded" check_parallel_work_is_bounded
run_case "investigation and standalone review are read-only" check_read_only_workflows
run_case "investigation may create only an explicit pending delivery draft" check_investigation_draft_plan
run_case "delivery composes override-aware skills by phase" check_phase_specific_skill_composition

finish_tests
