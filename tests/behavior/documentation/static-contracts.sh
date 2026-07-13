#!/bin/sh

set -u

ROOT=$(CDPATH= cd "$(dirname "$0")/../../.." && pwd)
. "$ROOT/tests/lib/test.sh"

WORKFLOW=$ROOT/src/managed/.ai/workflows/sia/documentation.md
REFRESH=$ROOT/src/managed/.ai/operations/sia/refresh-docs.md
SKILL=$ROOT/src/managed/.ai/skills/sia/documentation/SKILL.md

check_refresh_contract() {
  assert_contains "$REFRESH" 'freshness metadata as a clue' || return 1
  assert_contains "$REFRESH" 'Correct unsupported or obsolete content' || return 1
  assert_contains "$WORKFLOW" 'refresh mode' || return 1
  assert_contains "$WORKFLOW" 'confirmed, corrected, removed, and unverified' || return 1
}

check_docs_are_evidence_not_authority() {
  assert_contains "$SKILL" 'current source' || return 1
  assert_contains "$SKILL" 'never prove current correctness' || return 1
  assert_contains "$SKILL" 'Do not record a command as verified unless it ran successfully' || return 1
}

run_case "refresh-docs performs a targeted stale-claim audit" check_refresh_contract
run_case "repository documentation remains evidence-linked and qualified" check_docs_are_evidence_not_authority

finish_tests
