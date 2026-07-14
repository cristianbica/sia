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

check_protocol_directives() {
  assert_nonempty "$PROTOCOL" || return 1
  for directive in 'Sia load docs' 'Sia load skills' 'Sia resume' 'Sia handoff' 'Sia stop' 'Sia reload'; do
    assert_contains "$PROTOCOL" "$directive" || return 1
  done
  assert_contains "$PROTOCOL" '.ai/RULES.md' || return 1
  assert_contains "$PROTOCOL" '.ai/operations/INDEX.md' || return 1
  assert_contains "$PROTOCOL" 'handoff_protocol: 1' || return 1
  assert_contains "$PROTOCOL" 'interactive and unattended operations' || return 1
  assert_contains "$PROTOCOL" 'direct Sia conversation' || return 1
  assert_contains "$PROTOCOL" 'high confidence' || return 1
  assert_contains "$PROTOCOL" 'Never infer unattended mode' || return 1
  assert_contains "$PROTOCOL" 'invalid form reports an arity or syntax error' || return 1
  assert_contains "$PROTOCOL" 'YYYY-MM-DD-NN-<slug>.md' || return 1
  assert_contains "$PROTOCOL" 'filenames only' || return 1
}

check_unattended_directive() {
  assert_contains "$PROTOCOL" 'Sia unattended <operation> [request]' || return 1
  assert_contains "$PROTOCOL" 'Do not infer unattended mode from natural-language requests' || return 1
  assert_contains "$PROTOCOL" 'accepts an operation, not a reserved directive' || return 1
  assert_contains "$PROTOCOL" 'return `blocked` rather than asking the user' || return 1
  assert_contains "$PROTOCOL" 'does not expand host permissions or authorize external actions' || return 1
}

check_fail_closed_contract() {
  assert_contains "$AGENTS_BRIDGE" 'missing' || return 1
  assert_contains "$AGENTS_BRIDGE" 'invalid' || return 1
  assert_contains "$AGENTS_BRIDGE" 'installation-integrity error' || return 1
  assert_contains "$AGENTS_BRIDGE" 'do not infer' || return 1
}

check_workflow_contract() {
  delivery="$ROOT/src/managed/.ai/workflows/sia/delivery.md"
  assert_nonempty "$delivery" || return 1
  for phase in Plan Approve Build Review Validate Fix Ship; do
    assert_contains "$delivery" "$phase" || return 1
  done
  assert_contains "$delivery" 'reasoning' || return 1
  assert_contains "$delivery" 'fast' || return 1
  assert_contains "$delivery" 'do_not_load' || return 1
  assert_contains "$delivery" '<!-- sia:approval:start -->' || return 1
  assert_contains "$delivery" 'lowercase SHA-256' || return 1
  assert_contains "$delivery" '<!-- sia:status pending-approval -->' || return 1
  assert_contains "$delivery" 'frontmatter has no ID, status, revision' || return 1
  assert_contains "$delivery" 'retain the plan for history without asking' || return 1
  assert_contains "$delivery" 'separate explicit user request' || return 1
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
run_case "the protocol declares core reserved directives" check_protocol_directives
run_case "unattended activation is exact, bounded, and noninteractive" check_unattended_directive
run_case "activation fails closed at the bridge" check_fail_closed_contract
run_case "delivery declares phases, exclusions, and advisory profiles" check_workflow_contract
run_case "seed indexes expose project-owned CUSTOM sections" check_seed_indexes

finish_tests
