#!/bin/sh

set -u

ROOT=$(CDPATH= cd "$(dirname "$0")/../../.." && pwd)
. "$ROOT/tests/lib/test.sh"

PROTOCOL="$ROOT/src/managed/.ai/sia.md"
AGENTS_BRIDGE="$ROOT/src/bridges/agents.block.md"
CLAUDE_BRIDGE="$ROOT/src/bridges/claude.block.md"

check_agents_bridge() {
  assert_nonempty "$AGENTS_BRIDGE" || return 1
  assert_fixed_count "$AGENTS_BRIDGE" '<!-- sia:entrypoint:start -->' 1 || return 1
  assert_fixed_count "$AGENTS_BRIDGE" '<!-- sia:entrypoint:end -->' 1 || return 1
  assert_contains "$AGENTS_BRIDGE" '.ai/sia.md' || return 1
  assert_contains "$AGENTS_BRIDGE" 'Sia' || return 1
  assert_not_contains "$AGENTS_BRIDGE" '.ai/docs/INDEX.md' || return 1
  assert_not_contains "$AGENTS_BRIDGE" '.ai/skills/INDEX.md' || return 1
  assert_not_contains "$AGENTS_BRIDGE" '.ai/RULES.md' || return 1
  assert_contains "$AGENTS_BRIDGE" 'After an explicit activation' || return 1
  assert_contains "$AGENTS_BRIDGE" 'do not need to repeat the `Sia` prefix' || return 1
  assert_contains "$AGENTS_BRIDGE" 'Never infer prior activation' || return 1
  assert_contains "$AGENTS_BRIDGE" 'Git repository root' || return 1
  assert_contains "$AGENTS_BRIDGE" 'sia_protocol: 1' || return 1
}

check_claude_bridge() {
  assert_nonempty "$CLAUDE_BRIDGE" || return 1
  assert_fixed_count "$CLAUDE_BRIDGE" '<!-- sia:claude:start -->' 1 || return 1
  assert_fixed_count "$CLAUDE_BRIDGE" '<!-- sia:claude:end -->' 1 || return 1
  assert_contains "$CLAUDE_BRIDGE" '@../AGENTS.md' || return 1
}

check_fail_closed_contract() {
  assert_contains "$AGENTS_BRIDGE" 'missing' || return 1
  assert_contains "$AGENTS_BRIDGE" 'invalid' || return 1
  assert_contains "$AGENTS_BRIDGE" 'installation-integrity error' || return 1
  assert_contains "$AGENTS_BRIDGE" 'do not infer' || return 1
}

check_seed_indexes() {
  for category in skills operations workflows; do
    index="$ROOT/src/seed/.ai/$category/INDEX.md"
    assert_nonempty "$index" || return 1
    assert_contains "$index" '## CUSTOM' || return 1
  done
  assert_contains "$ROOT/src/seed/.ai/docs/INDEX.md" 'not-initialized' || return 1
}

run_case "the root bridge is awareness-only" check_agents_bridge
run_case "the Claude bridge only imports root instructions" check_claude_bridge
run_case "activation fails closed at the bridge" check_fail_closed_contract
run_case "seed indexes expose project-owned CUSTOM sections" check_seed_indexes

finish_tests
