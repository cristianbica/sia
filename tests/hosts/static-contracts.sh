#!/bin/sh

set -u

ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
. "$ROOT/tests/lib/test.sh"
TAB=$(printf '\t')

TMP=$(mktemp -d "${TMPDIR:-/tmp}/sia-host-contracts.XXXXXX") || exit 1
trap 'rm -rf "$TMP"' EXIT
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM

make_host_shims() {
  mkdir -p "$TMP/bin"
  for executable in codex opencode claude cursor-agent
  do
    case $executable in
      codex) version='codex-cli 0.144.1' ;;
      opencode) version='1.17.18' ;;
      claude) version='2.1.207 (Claude Code)' ;;
      cursor-agent) version='2026.07.1' ;;
    esac
    sed "s|@VERSION@|$version|" "$ROOT/tests/hosts/version-shim.in" >"$TMP/bin/$executable"
    chmod +x "$TMP/bin/$executable"
  done
}

probe_uses_only_version_commands() {
  make_host_shims || return 1
  : >"$TMP/invocations.log"
  if ! PATH="$TMP/bin:$PATH" SIA_HOST_SHIM_LOG="$TMP/invocations.log" \
    SIA_HOST_TIMEOUT_SECONDS=invalid SIA_CLAUDE_MAX_BUDGET_USD=invalid \
    "$ROOT/scripts/verify-hosts" --probe --artifacts "$TMP/probe" >"$TMP/probe.out" 2>"$TMP/probe.err"
  then
    return 1
  fi

  assert_contains "$TMP/probe/summary.tsv" \
    "codex${TAB}probe${TAB}codex${TAB}0.144.1${TAB}AVAILABLE" || return 1
  assert_contains "$TMP/probe/summary.tsv" \
    "opencode${TAB}probe${TAB}opencode${TAB}1.17.18${TAB}AVAILABLE" || return 1
  assert_contains "$TMP/probe/summary.tsv" \
    "claude${TAB}probe${TAB}claude${TAB}2.1.207${TAB}AVAILABLE" || return 1
  assert_contains "$TMP/probe/summary.tsv" \
    "cursor${TAB}probe${TAB}cursor-agent${TAB}2026.07.1${TAB}AVAILABLE" || return 1
  assert_equal "4" "$(wc -l <"$TMP/invocations.log" | tr -d ' ')" \
    "expected one version probe per host" || return 1
  if grep -F -v -- '--version' "$TMP/invocations.log" >/dev/null 2>&1; then
    fail "probe invoked a host without --version"
  fi
}

declares_live_safeguards() {
  grep -F -- '--live' "$ROOT/scripts/verify-hosts" >/dev/null 2>&1 || return 1
  assert_contains "$ROOT/scripts/verify-hosts" 'read-only' || return 1
  assert_contains "$ROOT/scripts/verify-hosts" 'max-budget-usd' || return 1
  assert_contains "$ROOT/scripts/verify-hosts" 'OPENCODE_CONFIG_CONTENT' || return 1
  assert_contains "$ROOT/scripts/verify-hosts" 'jq is required for Claude live validation' || return 1
  assert_contains "$ROOT/scripts/verify-hosts" 'timeout --signal=TERM --kill-after=5' || return 1
  assert_contains "$ROOT/scripts/verify-hosts" 'tree_digest' || return 1
}

records_the_four_semantic_cases() {
  assert_contains "$ROOT/tests/hosts/prompts/ordinary.txt" 'ORDINARY_OK' || return 1
  assert_contains "$ROOT/tests/hosts/prompts/help.txt" 'Sia' || return 1
  assert_contains "$ROOT/tests/hosts/prompts/load-docs.txt" 'Sia load docs' || return 1
  assert_contains "$ROOT/tests/hosts/prompts/unknown-operation.txt" 'definitely-unknown-7f3d' || return 1
}

live_mode_exercises_all_hosts_without_a_model() {
  mkdir -p "$TMP/live-bin"
  mkdir -p "$TMP/fake-codex-home"
  mkdir -p "$TMP/runtime root"
  printf '{}\n' >"$TMP/fake-codex-home/auth.json"
  for host in codex opencode claude
  do
    cp "$ROOT/tests/hosts/$host-live-shim.in" "$TMP/live-bin/$host"
    chmod +x "$TMP/live-bin/$host"
  done

  for host in codex opencode claude
  do
    if ! PATH="$TMP/live-bin:$PATH" CODEX_HOME="$TMP/fake-codex-home" \
      TMPDIR="$TMP/runtime root" SIA_HOST_TIMEOUT_SECONDS=5 \
      "$ROOT/scripts/verify-hosts" --live --host "$host" --artifacts "$TMP/live-$host" \
      >"$TMP/live-$host.out" 2>"$TMP/live-$host.err"
    then
      return 1
    fi

    assert_equal "4" "$(grep -c "${TAB}PASS${TAB}" "$TMP/live-$host/summary.tsv")" \
      "expected four passing $host live cases" || return 1
    assert_contains "$TMP/live-$host/metadata.txt" 'repository_access=read_only' || return 1
    assert_contains "$TMP/live-$host/metadata.txt" "${host}_requested_model=host-default" || return 1
    assert_nonempty "$TMP/live-$host/hosts/$host/cases/help/command.txt" || return 1
    assert_nonempty "$TMP/live-$host/hosts/$host/cases/unknown-operation/response.normalized.txt" || return 1
  done

  if find "$TMP/runtime root" ! -path "$TMP/runtime root" -print | grep . >/dev/null 2>&1; then
    fail "private host runtime was not cleaned"
  fi
}

live_mode_fails_when_requested_supported_host_is_unavailable() {
  mkdir -p "$TMP/unavailable-bin"
  printf '%s\n' '#!/bin/sh' 'exit 7' >"$TMP/unavailable-bin/opencode"
  chmod +x "$TMP/unavailable-bin/opencode"
  if PATH="$TMP/unavailable-bin:$PATH" "$ROOT/scripts/verify-hosts" --live --host opencode \
    --artifacts "$TMP/unavailable-live" >"$TMP/unavailable-live.out" 2>"$TMP/unavailable-live.err"
  then
    fail "live mode accepted a requested supported host whose CLI was unavailable"
    return 1
  fi
  assert_contains "$TMP/unavailable-live/summary.tsv" "opencode${TAB}live${TAB}unknown${TAB}SKIP"
}

run_case "host harness has valid shell syntax" sh -n "$ROOT/scripts/verify-hosts"
run_case "probe invokes version commands only" probe_uses_only_version_commands
run_case "live mode declares read-only cost and time safeguards" declares_live_safeguards
run_case "host suite records all semantic cases" records_the_four_semantic_cases
run_case "live orchestration passes for all local no-model shims" \
  live_mode_exercises_all_hosts_without_a_model
run_case "live mode fails when a requested supported host cannot run" \
  live_mode_fails_when_requested_supported_host_is_unavailable
finish_tests
