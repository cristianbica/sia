#!/bin/sh

set -u
umask 022

ROOT=$(CDPATH= cd "$(dirname "$0")/../../.." && pwd)
. "$ROOT/tests/lib/test.sh"

INSTALL=${SIA_INSTALL:-$ROOT/install}
TMP_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/sia-installer.XXXXXX") || exit 1
trap 'rm -rf "$TMP_ROOT"' EXIT

new_repo() {
  repo=$(mktemp -d "$TMP_ROOT/repo.XXXXXX") || return 1
  git -C "$repo" init -q || return 1
  printf '%s\n' "$repo"
}

run_install() {
  target=$1
  shift
  (cd "$target" && "$INSTALL" install "$@") >/dev/null 2>&1
}

file_permissions() {
  LC_ALL=C ls -ld "$1" | cut -c1-10
}

test_clean_install_creates_the_four_owned_shapes() {
  repo=$(new_repo) || return 1
  run_install "$repo" || return 1

  for path in \
    .ai/sia.md \
    .ai/skills/sia/testing/SKILL.md \
    .ai/operations/sia/implement.md \
    .ai/workflows/sia/delivery.md \
    .ai/RULES.md \
    .ai/docs/INDEX.md \
    .ai/skills/INDEX.md \
    AGENTS.md \
    .claude/CLAUDE.md; do
    assert_nonempty "$repo/$path" || return 1
  done
  for category in skills operations workflows; do
    assert_fixed_count "$repo/.ai/$category/INDEX.md" "<!-- sia:$category:start -->" 1 || return 1
    assert_fixed_count "$repo/.ai/$category/INDEX.md" '## CUSTOM' 1 || return 1
  done
  for path in AGENTS.md .claude/CLAUDE.md .ai/RULES.md .ai/docs/INDEX.md .ai/skills/INDEX.md; do
    assert_equal '-rw-r--r--' "$(file_permissions "$repo/$path")" \
      "new repository file has unexpected permissions: $path" || return 1
  done
}

test_owned_ai_files_are_replaced_and_project_content_survives() {
  repo=$(new_repo) || return 1
  run_install "$repo" || return 1
  printf 'local edit\n' >>"$repo/.ai/sia.md"
  mkdir -p "$repo/.ai/skills/sia/stale" "$repo/.ai/skills/project-skill" || return 1
  printf 'stale\n' >"$repo/.ai/skills/sia/stale/SKILL.md"
  printf 'project skill\n' >"$repo/.ai/skills/project-skill/SKILL.md"
  printf 'project rule\n' >>"$repo/.ai/RULES.md"
  printf 'project docs\n' >>"$repo/.ai/docs/INDEX.md"

  run_install "$repo" || return 1
  cmp -s "$ROOT/src/managed/.ai/sia.md" "$repo/.ai/sia.md" || \
    fail 'rerun did not replace .ai/sia.md' || return 1
  [ ! -e "$repo/.ai/skills/sia/stale" ] || fail 'rerun left stale Sia-owned content' || return 1
  assert_contains "$repo/.ai/skills/project-skill/SKILL.md" 'project skill' || return 1
  assert_contains "$repo/.ai/RULES.md" 'project rule' || return 1
  assert_contains "$repo/.ai/docs/INDEX.md" 'project docs'
}

test_catalog_blocks_are_replaced_without_touching_custom() {
  repo=$(new_repo) || return 1
  run_install "$repo" || return 1
  printf '\nCUSTOM-SENTINEL\n' >>"$repo/.ai/skills/INDEX.md"
  awk '
    { print }
    /<!-- sia:skills:start -->/ { print "OLD-SIA-SENTINEL" }
  ' "$repo/.ai/skills/INDEX.md" >"$repo/.ai/skills/INDEX.md.tmp" || return 1
  mv "$repo/.ai/skills/INDEX.md.tmp" "$repo/.ai/skills/INDEX.md" || return 1

  run_install "$repo" || return 1
  assert_not_contains "$repo/.ai/skills/INDEX.md" 'OLD-SIA-SENTINEL' || return 1
  assert_contains "$repo/.ai/skills/INDEX.md" 'CUSTOM-SENTINEL' || return 1
  assert_fixed_count "$repo/.ai/skills/INDEX.md" '<!-- sia:skills:start -->' 1
}

test_tool_blocks_preserve_surrounding_instructions() {
  repo=$(new_repo) || return 1
  printf '# Project instructions\nAGENTS-SENTINEL\n' >"$repo/AGENTS.md"
  mkdir -p "$repo/.claude" || return 1
  printf '# Claude instructions\nCLAUDE-SENTINEL\n' >"$repo/.claude/CLAUDE.md"

  run_install "$repo" || return 1
  assert_contains "$repo/AGENTS.md" 'AGENTS-SENTINEL' || return 1
  assert_contains "$repo/.claude/CLAUDE.md" 'CLAUDE-SENTINEL' || return 1
  assert_fixed_count "$repo/AGENTS.md" '<!-- sia:entrypoint:start -->' 1 || return 1
  assert_fixed_count "$repo/.claude/CLAUDE.md" '<!-- sia:claude:start -->' 1 || return 1
  assert_equal '-rw-r--r--' "$(file_permissions "$repo/AGENTS.md")" \
    'install changed existing AGENTS.md permissions' || return 1
  assert_equal '-rw-r--r--' "$(file_permissions "$repo/.claude/CLAUDE.md")" \
    'install changed existing Claude instructions permissions'
}

test_existing_claude_import_is_left_alone() {
  for import in '@AGENTS.md' '@./AGENTS.md'; do
    repo=$(new_repo) || return 1
    printf '%s\nROOT-CLAUDE-SENTINEL\n' "$import" >"$repo/CLAUDE.md"
    run_install "$repo" || return 1
    assert_contains "$repo/CLAUDE.md" 'ROOT-CLAUDE-SENTINEL' || return 1
    [ ! -e "$repo/.claude/CLAUDE.md" ] || fail "created an unnecessary Claude bridge for $import" || return 1
  done

  repo=$(new_repo) || return 1
  mkdir -p "$repo/.claude" || return 1
  printf '@../AGENTS.md\nNESTED-CLAUDE-SENTINEL\n' >"$repo/.claude/CLAUDE.md"
  run_install "$repo" || return 1
  assert_contains "$repo/.claude/CLAUDE.md" 'NESTED-CLAUDE-SENTINEL' || return 1
  assert_not_contains "$repo/.claude/CLAUDE.md" '<!-- sia:claude:start -->'
}

test_new_files_honor_restrictive_umask() {
  repo=$(new_repo) || return 1
  (umask 077; cd "$repo" && "$INSTALL" install) >/dev/null 2>&1 || return 1
  for path in AGENTS.md .claude/CLAUDE.md .ai/sia.md .ai/RULES.md .ai/docs/INDEX.md .ai/skills/INDEX.md; do
    assert_equal '-rw-------' "$(file_permissions "$repo/$path")" \
      "new repository file ignored restrictive umask: $path" || return 1
  done
}

test_malformed_blocks_refuse_before_installing() {
  repo=$(new_repo) || return 1
  printf '<!-- sia:entrypoint:start -->\n' >"$repo/AGENTS.md"
  if run_install "$repo"; then
    fail 'accepted an incomplete Sia block'
    return 1
  fi
  [ ! -e "$repo/.ai/sia.md" ] || fail 'wrote managed content after malformed block'

  reversed=$(new_repo) || return 1
  printf '%s\n' '<!-- sia:entrypoint:end -->' '<!-- sia:entrypoint:start -->' >"$reversed/AGENTS.md"
  if run_install "$reversed"; then
    fail 'accepted reversed Sia markers'
    return 1
  fi
  [ ! -e "$reversed/.ai/sia.md" ] || fail 'wrote managed content after reversed markers'
}

test_invalid_seed_layouts_fail_before_installing() {
  for invalid in docs-file docs-symlink rules-directory docs-index-directory; do
    repo=$(new_repo) || return 1
    case $invalid in
      docs-file)
        mkdir -p "$repo/.ai" || return 1
        printf 'not a directory\n' >"$repo/.ai/docs"
        ;;
      docs-symlink)
        outside=$(mktemp -d "$TMP_ROOT/outside.XXXXXX") || return 1
        mkdir -p "$repo/.ai" || return 1
        ln -s "$outside" "$repo/.ai/docs" || return 1
        ;;
      rules-directory)
        mkdir -p "$repo/.ai/RULES.md" || return 1
        ;;
      docs-index-directory)
        mkdir -p "$repo/.ai/docs/INDEX.md" || return 1
        ;;
    esac

    if run_install "$repo"; then
      fail "accepted invalid seed layout: $invalid"
      return 1
    fi
    [ ! -e "$repo/.ai/sia.md" ] || fail "partially installed after invalid seed layout: $invalid" || return 1
    if [ "$invalid" = docs-symlink ]; then
      [ ! -e "$outside/INDEX.md" ] || fail 'wrote through a symlinked .ai/docs directory' || return 1
    fi
  done
}

test_concurrent_install_lock_fails_without_writing() {
  repo=$(new_repo) || return 1
  git_dir=$(git -C "$repo" rev-parse --git-common-dir) || return 1
  mkdir "$repo/$git_dir/sia-install.lock" || return 1
  if run_install "$repo"; then
    fail 'accepted a concurrent Sia installer'
    return 1
  fi
  [ ! -e "$repo/.ai" ] || fail 'concurrent-install refusal changed the repository' || return 1
  [ -d "$repo/$git_dir/sia-install.lock" ] || fail 'refusal removed the active installer lock'
}

test_uninstall_is_not_a_supported_command() {
  repo=$(new_repo) || return 1
  if (cd "$repo" && "$INSTALL" uninstall) >"$TMP_ROOT/uninstall.log" 2>&1; then
    fail 'uninstall is still accepted'
    return 1
  fi
  assert_contains "$TMP_ROOT/uninstall.log" 'Usage: install [install]' || return 1
  [ ! -e "$repo/.ai" ] || fail 'unsupported uninstall changed the repository'
}

run_case 'clean install creates Sia-owned files, shared blocks, and project seeds' \
  test_clean_install_creates_the_four_owned_shapes
run_case 'rerun replaces Sia-owned .ai files and preserves project content' \
  test_owned_ai_files_are_replaced_and_project_content_survives
run_case 'catalog blocks refresh without changing CUSTOM content' \
  test_catalog_blocks_are_replaced_without_touching_custom
run_case 'tool blocks preserve surrounding project instructions' test_tool_blocks_preserve_surrounding_instructions
run_case 'an existing Claude import is left alone' test_existing_claude_import_is_left_alone
run_case 'new repository files honor a restrictive umask' test_new_files_honor_restrictive_umask
run_case 'malformed markers fail before Sia writes' test_malformed_blocks_refuse_before_installing
run_case 'invalid create-once seed layouts fail before Sia writes' test_invalid_seed_layouts_fail_before_installing
run_case 'a concurrent installer is refused before Sia writes' test_concurrent_install_lock_fails_without_writing
run_case 'uninstall is not an installer command' test_uninstall_is_not_a_supported_command

finish_tests
