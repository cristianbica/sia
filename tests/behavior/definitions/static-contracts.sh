#!/bin/sh

set -u

ROOT=$(CDPATH= cd "$(dirname "$0")/../../.." && pwd)
. "$ROOT/tests/lib/test.sh"

DEFINITION=$ROOT/src/managed/.ai/workflows/sia/definition.md
PROTOCOL=$ROOT/src/managed/.ai/sia.md
EXTENSIONS=$ROOT/docs/extensions.md

check_creators() {
  for kind in skill operation workflow; do
    file="$ROOT/src/managed/.ai/operations/sia/create-$kind.md"
    assert_nonempty "$file" || return 1
    assert_contains "$file" 'CUSTOM' || return 1
    assert_contains "$file" 'Never edit the SIA block' || return 1
    assert_contains "$file" 'one logical change' || return 1
    assert_contains "$file" '120 characters' || return 1
  done
  operation=$ROOT/src/managed/.ai/operations/sia/create-operation.md
  assert_contains "$operation" '`handoff`' || return 1
  assert_contains "$operation" '`unattended`' || return 1
}

check_definition_workflow_boundaries() {
  assert_contains "$DEFINITION" 'Forbidden writes' || return 1
  assert_contains "$DEFINITION" "category's \`sia/\` directory" || return 1
  assert_contains "$DEFINITION" 'SIA marker or block' || return 1
  assert_contains "$DEFINITION" 'Preflight all destinations' || return 1
  assert_contains "$DEFINITION" 'CUSTOM registration, confirm SIA content is unchanged' || return 1
}

check_created_definitions_bound_unattended_mode() {
  workflow=$ROOT/src/managed/.ai/operations/sia/create-workflow.md
  operation=$ROOT/src/managed/.ai/operations/sia/create-operation.md
  skill=$ROOT/src/managed/.ai/operations/sia/create-skill.md
  assert_contains "$workflow" 'cannot activate it' || return 1
  assert_contains "$workflow" 'keep validation and review requirements in unattended mode' || return 1
  assert_contains "$operation" 'activate itself or unattended mode' || return 1
  assert_contains "$skill" 'broaden unattended mode' || return 1
}

check_reconciliation() {
  file=$ROOT/src/managed/.ai/operations/sia/reconcile-catalogs.md
  assert_contains "$file" 'valid unindexed project definition' || return 1
  assert_contains "$file" 'Require exact authorization' || return 1
  assert_contains "$file" 'unattended mode requires the activating request' || return 1
  assert_contains "$file" '`unattended`' || return 1
  assert_contains "$file" 'Preserve every valid CUSTOM description' || return 1
  assert_contains "$file" 'Never regenerate a whole index' || return 1
}

check_skills_remain_prompt_packages() {
  file=$ROOT/src/managed/.ai/operations/sia/create-skill.md
  assert_contains "$file" 'Sia prompt package' || return 1
  assert_contains "$file" 'not a host-native skill' || return 1
  assert_contains "$file" 'Do not create auxiliary README' || return 1
}

check_custom_alias_replacement() {
  assert_contains "$PROTOCOL" 'CUSTOM override replaces the complete shipped alias set' || return 1
  assert_contains "$PROTOCOL" 'an omitted alias is unavailable' || return 1
  assert_contains "$EXTENSIONS" 'Aliases are not inherited or merged' || return 1
  assert_contains "$EXTENSIONS" 'declaring no aliases removes every shipped alias' || return 1
}

run_case "creator operations preserve CUSTOM and SIA ownership" check_creators
run_case "the definition workflow constrains writes and verifies registration" check_definition_workflow_boundaries
run_case "created definitions cannot broaden unattended mode" check_created_definitions_bound_unattended_mode
run_case "catalog reconciliation distinguishes safe and confirmed repairs" check_reconciliation
run_case "created skills remain concise portable prompt packages" check_skills_remain_prompt_packages
run_case "custom operation overrides replace shipped aliases" check_custom_alias_replacement

finish_tests
