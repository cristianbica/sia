#!/bin/sh

set -u

ROOT=$(CDPATH= cd "$(dirname "$0")/../../.." && pwd)
. "$ROOT/tests/lib/test.sh"

PROTOCOL=$ROOT/src/managed/.ai/sia.md

check_routing_fields() {
  assert_contains "$PROTOCOL" '`fast` or `reasoning`' || return 1
  assert_contains "$PROTOCOL" '`requested_model_profile`' || return 1
  assert_contains "$PROTOCOL" '`model_selection_source`' || return 1
  assert_contains "$PROTOCOL" '`actual_model`' || return 1
  assert_contains "$PROTOCOL" '`profile_honored`' || return 1
  assert_contains "$PROTOCOL" 'unknown' || return 1
}

check_host_fallback() {
  assert_contains "$PROTOCOL" 'The host chooses the available model' || return 1
  assert_contains "$PROTOCOL" 'never blocks work' || return 1
  assert_contains "$PROTOCOL" 'never' || return 1
  assert_contains "$PROTOCOL" 'invalidates resumption' || return 1
}

check_workflow_profiles() {
  failed=0
  for workflow in "$ROOT"/src/managed/.ai/workflows/sia/*.md; do
    grep -Eo 'request `(fast|reasoning)`' "$workflow" 2>/dev/null |
      sed -n 's/.*`\([^`]*\)`.*/\1/p' |
      while IFS= read -r profile; do
        case "$profile" in
          fast|reasoning) ;;
          *) echo "$workflow: unsupported model profile: $profile" >&2; exit 1 ;;
        esac
      done || failed=1
  done
  [ "$failed" -eq 0 ] || fail "workflow uses a nonportable model profile"
}

check_no_vendor_agent_payload() {
  for path in \
    "$ROOT/src/managed/.codex" \
    "$ROOT/src/managed/.claude" \
    "$ROOT/src/managed/.cursor" \
    "$ROOT/src/managed/.opencode"; do
    [ ! -e "$path" ] || fail "vendor-specific payload exists: $path" || return 1
  done
}

run_case "model routing records advisory requested and actual fields" check_routing_fields
run_case "host model fallback never changes workflow semantics" check_host_fallback
run_case "workflows use only fast and reasoning profiles" check_workflow_profiles
run_case "the managed payload contains no vendor agent package" check_no_vendor_agent_payload

finish_tests
