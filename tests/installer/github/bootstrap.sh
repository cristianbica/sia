#!/bin/sh

set -u

ROOT=$(CDPATH= cd "$(dirname "$0")/../../.." && pwd)
. "$ROOT/tests/lib/test.sh"

TMP_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/sia-github-test.XXXXXX") || exit 1
trap 'rm -rf "$TMP_ROOT"' EXIT

new_repo() {
  repo=$(mktemp -d "$TMP_ROOT/repo.XXXXXX") || return 1
  git -C "$repo" init -q || return 1
  printf '%s\n' "$repo"
}

new_source_repo() {
  source_repo=$(mktemp -d "$TMP_ROOT/source.XXXXXX") || return 1
  cp "$ROOT/install" "$source_repo/install" || return 1
  cp "$ROOT/.gitattributes" "$source_repo/.gitattributes" || return 1
  cp -R "$ROOT/src" "$source_repo/src" || return 1
  git -C "$source_repo" init -q || return 1
  git -C "$source_repo" config user.name 'Sia Test' || return 1
  git -C "$source_repo" config user.email 'sia-test@example.invalid' || return 1
  git -C "$source_repo" add .gitattributes install src || return 1
  git -C "$source_repo" commit -qm 'Sia fixture' || return 1
  git -C "$source_repo" branch -M fixture-default || return 1
  printf '%s\n' "$source_repo"
}

assert_downloads_cleaned() {
  for leftover in "$1"/sia.*; do
    [ ! -e "$leftover" ] && [ ! -L "$leftover" ] && continue
    fail "temporary GitHub clone was not removed: $leftover"
    return 1
  done
}

test_stdin_install_downloads_and_cleans_up() {
  source_repo=$(new_source_repo) || return 1
  repo=$(new_repo) || return 1
  download_tmp=$TMP_ROOT/downloads
  mkdir -p "$download_tmp" || return 1
  (cd "$repo" && TMPDIR="$download_tmp" SIA_GITHUB_URL="file://$source_repo" \
    sh -s -- install <"$ROOT/install") >/dev/null 2>&1 || return 1
  assert_nonempty "$repo/.ai/sia.md" || return 1
  assert_nonempty "$repo/AGENTS.md" || return 1
  assert_downloads_cleaned "$download_tmp"
}

test_clone_failure_writes_nothing() {
  repo=$(new_repo) || return 1
  if (cd "$repo" && SIA_GITHUB_URL="file://$TMP_ROOT/missing" \
    sh -s -- install <"$ROOT/install") >"$TMP_ROOT/failure.log" 2>&1; then
    fail 'accepted a missing GitHub source'
    return 1
  fi
  assert_contains "$TMP_ROOT/failure.log" 'cannot download Sia from GitHub' || return 1
  [ ! -e "$repo/.ai" ] || fail 'clone failure changed the target repository'
}

test_autocrlf_checkout_keeps_installer_payload_usable() {
  source_repo=$(new_source_repo) || return 1
  repo=$(new_repo) || return 1
  download_tmp=$TMP_ROOT/autocrlf-downloads
  mkdir -p "$download_tmp" || return 1
  (cd "$repo" && TMPDIR="$download_tmp" SIA_GITHUB_URL="file://$source_repo" \
    GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=core.autocrlf GIT_CONFIG_VALUE_0=true \
    sh -s -- install <"$ROOT/install") >/dev/null 2>&1 || return 1
  assert_nonempty "$repo/.ai/sia.md" || return 1
  assert_nonempty "$repo/AGENTS.md" || return 1
  assert_downloads_cleaned "$download_tmp"
}

test_malformed_source_writes_nothing() {
  source_repo=$(mktemp -d "$TMP_ROOT/malformed.XXXXXX") || return 1
  cp "$ROOT/install" "$source_repo/install" || return 1
  git -C "$source_repo" init -q || return 1
  git -C "$source_repo" config user.name Test || return 1
  git -C "$source_repo" config user.email test@example.invalid || return 1
  git -C "$source_repo" add install || return 1
  git -C "$source_repo" commit -qm malformed || return 1
  repo=$(new_repo) || return 1
  download_tmp=$TMP_ROOT/malformed-downloads
  mkdir -p "$download_tmp" || return 1
  if (cd "$repo" && TMPDIR="$download_tmp" SIA_GITHUB_URL="file://$source_repo" \
    sh -s -- install <"$ROOT/install") >"$TMP_ROOT/malformed.log" 2>&1; then
    fail 'accepted a malformed GitHub source'
    return 1
  fi
  assert_contains "$TMP_ROOT/malformed.log" 'downloaded source has no src directory' || return 1
  [ ! -e "$repo/.ai" ] || fail 'malformed source changed the target repository'
  assert_downloads_cleaned "$download_tmp"
}

test_incomplete_payload_writes_nothing() {
  source_repo=$(new_source_repo) || return 1
  rm "$source_repo/src/seed/.ai/skills/INDEX.md" || return 1
  git -C "$source_repo" add -A || return 1
  git -C "$source_repo" commit -qm 'remove required seed' || return 1
  repo=$(new_repo) || return 1
  download_tmp=$TMP_ROOT/incomplete-downloads
  mkdir -p "$download_tmp" || return 1
  if (cd "$repo" && TMPDIR="$download_tmp" SIA_GITHUB_URL="file://$source_repo" \
    sh -s -- install <"$ROOT/install") >"$TMP_ROOT/incomplete.log" 2>&1; then
    fail 'accepted an incomplete Sia payload'
    return 1
  fi
  assert_contains "$TMP_ROOT/incomplete.log" 'Sia source file is invalid' || return 1
  [ ! -e "$repo/.ai" ] || fail 'incomplete payload changed the target repository' || return 1
  assert_downloads_cleaned "$download_tmp"
}

test_invalid_payload_type_writes_nothing() {
  source_repo=$(new_source_repo) || return 1
  rm -rf "$source_repo/src/managed/.ai/skills/sia" || return 1
  printf 'not a directory\n' >"$source_repo/src/managed/.ai/skills/sia"
  git -C "$source_repo" add -A || return 1
  git -C "$source_repo" commit -qm 'replace definitions with a file' || return 1
  repo=$(new_repo) || return 1
  download_tmp=$TMP_ROOT/invalid-type-downloads
  mkdir -p "$download_tmp" || return 1
  if (cd "$repo" && TMPDIR="$download_tmp" SIA_GITHUB_URL="file://$source_repo" \
    sh -s -- install <"$ROOT/install") >"$TMP_ROOT/invalid-type.log" 2>&1; then
    fail 'accepted an invalid Sia source type'
    return 1
  fi
  assert_contains "$TMP_ROOT/invalid-type.log" 'Sia source directory is invalid' || return 1
  [ ! -e "$repo/.ai" ] || fail 'invalid source type changed the target repository' || return 1
  assert_downloads_cleaned "$download_tmp"
}

test_local_checkout_never_downloads() {
  repo=$(new_repo) || return 1
  (cd "$repo" && SIA_GITHUB_URL="file://$TMP_ROOT/missing" "$ROOT/install" install) \
    >/dev/null 2>&1 || return 1
  assert_nonempty "$repo/.ai/sia.md"
}

test_bootstrap_is_plain_github_source() {
  assert_contains "$ROOT/install" 'https://github.com/cristianbica/sia.git' || return 1
  assert_contains "$ROOT/install" 'git clone --depth 1 --quiet --' || return 1
  assert_not_contains "$ROOT/install" 'decode_base64'
}

run_case 'stdin install downloads a shallow GitHub source and cleans it up' test_stdin_install_downloads_and_cleans_up
run_case 'Git bootstrap remains usable with core.autocrlf enabled' \
  test_autocrlf_checkout_keeps_installer_payload_usable
run_case 'GitHub clone failure changes nothing' test_clone_failure_writes_nothing
run_case 'malformed GitHub source changes nothing' test_malformed_source_writes_nothing
run_case 'incomplete GitHub payload changes nothing' test_incomplete_payload_writes_nothing
run_case 'invalid GitHub payload types change nothing' test_invalid_payload_type_writes_nothing
run_case 'local checkout install never downloads GitHub' test_local_checkout_never_downloads
run_case 'bootstrap names a plain GitHub source and embeds no payload' test_bootstrap_is_plain_github_source

finish_tests
