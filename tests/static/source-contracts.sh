#!/bin/sh

set -u

ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
. "$ROOT/tests/lib/test.sh"

TMP_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/sia-static.XXXXXX") || exit 1
trap 'rm -rf "$TMP_ROOT"' EXIT
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM

markdown_files() {
  {
    printf '%s\n' "$ROOT/README.md"
    find "$ROOT/docs" "$ROOT/src" "$ROOT/tests" -type f -name '*.md' -print
  } | LC_ALL=C sort -u
}

check_markdown_width() {
  list="$TMP_ROOT/markdown-files"
  markdown_files >"$list"
  failed=0

  while IFS= read -r file; do
    if ! awk 'length($0) > 120 {
      printf "%s:%d: line is %d characters\n", FILENAME, FNR, length($0)
      bad = 1
    } END { exit bad }' "$file"; then
      failed=1
    fi
  done <"$list"

  [ "$failed" -eq 0 ] || fail "Markdown contains lines longer than 120 characters"
}

check_local_links() {
  list="$TMP_ROOT/markdown-files"
  links="$TMP_ROOT/markdown-links"
  markdown_files >"$list"
  : >"$links"

  while IFS= read -r file; do
    grep -Eo '\]\([^()]+\)' "$file" 2>/dev/null |
      sed 's/^](//; s/)$//' |
      while IFS= read -r target; do
        printf '%s\t%s\n' "$file" "$target"
      done >>"$links"
  done <"$list"

  failed=0
  tab=$(printf '\t')
  while IFS="$tab" read -r file target; do
    case "$target" in
      ''|'#'*|http://*|https://*|mailto:*|app://*)
        continue
        ;;
    esac

    target=${target%%#*}
    case "$target" in
      '<'*'>') target=${target#<}; target=${target%>} ;;
    esac

    if [ ! -e "$(dirname "$file")/$target" ]; then
      echo "$file: missing local link target: $target" >&2
      failed=1
    fi
  done <"$links"

  [ "$failed" -eq 0 ] || fail "Markdown contains broken local links"
}

definition_names() {
  category=$1
  case "$category" in
    skills)
      for file in "$ROOT"/src/managed/.ai/skills/sia/*/SKILL.md; do
        [ -f "$file" ] && basename "$(dirname "$file")"
      done
      ;;
    operations|workflows)
      for file in "$ROOT"/src/managed/.ai/"$category"/sia/*.md; do
        [ -f "$file" ] && basename "$file" .md
      done
      ;;
  esac | LC_ALL=C sort
}

catalog_names() {
  category=$1
  sed -n 's/^[[:space:]]*-[[:space:]]*`\([^`]*\)`.*/\1/p' \
    "$ROOT/src/managed/catalogs/$category.md" | LC_ALL=C sort
}

frontmatter_name() {
  awk '
    /^---[[:space:]]*$/ { separators++; next }
    separators == 1 && /^name:[[:space:]]*/ {
      sub(/^name:[[:space:]]*/, "")
      gsub(/^"|"$/, "")
      print
      exit
    }
  ' "$1"
}

check_definition_names() {
  failed=0
  for file in \
    "$ROOT"/src/managed/.ai/skills/sia/*/SKILL.md \
    "$ROOT"/src/managed/.ai/operations/sia/*.md \
    "$ROOT"/src/managed/.ai/workflows/sia/*.md; do
    [ -f "$file" ] || continue
    case "$file" in
      */skills/sia/*/SKILL.md) expected=$(basename "$(dirname "$file")") ;;
      *) expected=$(basename "$file" .md) ;;
    esac
    actual=$(frontmatter_name "$file")
    if [ "$actual" != "$expected" ]; then
      echo "$file: frontmatter name '$actual' does not match '$expected'" >&2
      failed=1
    fi
    if ! printf '%s\n' "$expected" | grep -E '^[a-z0-9]+(-[a-z0-9]+)*$' >/dev/null 2>&1; then
      echo "$file: definition name is not normalized lowercase kebab-case: $expected" >&2
      failed=1
    fi
  done

  [ "$failed" -eq 0 ] || fail "definition names do not match their installed paths"
}

check_catalog_sync() {
  failed=0
  for category in skills operations workflows; do
    definitions="$TMP_ROOT/$category-definitions"
    catalog="$TMP_ROOT/$category-catalog"
    definition_names "$category" >"$definitions"
    catalog_names "$category" >"$catalog"

    if ! diff -u "$definitions" "$catalog"; then
      echo "$category catalog does not match shipped definitions" >&2
      failed=1
    fi

    fragment="$ROOT/src/managed/catalogs/$category.md"
    assert_fixed_count "$fragment" "<!-- sia:$category:start -->" 1 || failed=1
    assert_fixed_count "$fragment" "<!-- sia:$category:end -->" 1 || failed=1
  done

  [ "$failed" -eq 0 ] || fail "shipped catalogs are out of sync"
}

frontmatter_scalar() {
  key=$1
  file=$2
  awk -v key="$key" '
    /^---[[:space:]]*$/ { separators++; next }
    separators == 1 && index($0, key ":") == 1 {
      sub("^" key ":[[:space:]]*", "")
      gsub(/^"|"$/, "")
      print
      exit
    }
  ' "$file"
}

frontmatter_list() {
  key=$1
  file=$2
  awk -v key="$key" '
    /^---[[:space:]]*$/ { separators++; if (separators == 2) exit; next }
    separators != 1 { next }
    index($0, key ":") == 1 {
      value = $0
      sub("^" key ":[[:space:]]*", "", value)
      if (value ~ /^\[/) {
        gsub(/^\[|\]$/, "", value)
        count = split(value, parts, /,[[:space:]]*/)
        for (i = 1; i <= count; i++) if (parts[i] != "") print parts[i]
        exit
      }
      in_list = 1
      next
    }
    in_list && /^[[:space:]]*-[[:space:]]*/ {
      value = $0
      sub(/^[[:space:]]*-[[:space:]]*/, "", value)
      print value
      next
    }
    in_list && /^[^[:space:]]/ { exit }
  ' "$file"
}

check_operation_references() {
  failed=0
  for operation in "$ROOT"/src/managed/.ai/operations/sia/*.md; do
    [ -f "$operation" ] || continue
    workflow=$(frontmatter_scalar workflow "$operation")
    if [ -z "$workflow" ] || [ ! -f "$ROOT/src/managed/.ai/workflows/sia/$workflow.md" ]; then
      echo "$operation: missing shipped workflow reference '$workflow'" >&2
      failed=1
    fi

    skills="$TMP_ROOT/operation-skills"
    frontmatter_list skills "$operation" >"$skills"
    while IFS= read -r skill; do
      if [ ! -f "$ROOT/src/managed/.ai/skills/sia/$skill/SKILL.md" ]; then
        echo "$operation: missing shipped skill reference '$skill'" >&2
        failed=1
      fi
    done <"$skills"
  done

  [ "$failed" -eq 0 ] || fail "shipped operations contain invalid references"
}

check_operation_aliases() {
  catalog="$ROOT/src/managed/catalogs/operations.md"
  names="$TMP_ROOT/operation-names-and-aliases"
  aliases="$TMP_ROOT/operation-aliases"
  catalog_names operations >"$names"
  : >"$aliases"

  if ! awk '
    /^[[:space:]]*-[[:space:]]*`[^`]+`/ { operation = 1; next }
    /^  - aliases:/ {
      if (!operation) exit 1
      operation = 0
      next
    }
    { operation = 0 }
  ' "$catalog"; then
    fail "operation alias metadata must immediately follow its operation entry"
    return 1
  fi

  grep 'aliases:' "$catalog" 2>/dev/null |
    grep -Eo '`[^`]+`' 2>/dev/null |
    sed 's/^`//; s/`$//' >"$aliases" || true

  failed=0
  while IFS= read -r alias; do
    if ! printf '%s\n' "$alias" | grep -E '^[a-z0-9]+(-[a-z0-9]+)*$' >/dev/null 2>&1; then
      echo "$catalog: alias is not normalized lowercase kebab-case: $alias" >&2
      failed=1
    fi
    case "$alias" in
      sia|unattended|load|resume|handoff|stop)
        echo "$catalog: alias uses reserved protocol name: $alias" >&2
        failed=1
        ;;
    esac
    if grep -F -x "$alias" "$names" >/dev/null 2>&1; then
      echo "$catalog: duplicate operation name or alias: $alias" >&2
      failed=1
    fi
    printf '%s\n' "$alias" >>"$names"
  done <"$aliases"

  [ "$failed" -eq 0 ] || fail "operation aliases are ambiguous or invalid"
}

check_source_boundaries() {
  assert_file "$ROOT/src/managed/.ai/sia.md" || return 1
  assert_file "$ROOT/src/seed/.ai/RULES.md" || return 1
  assert_file "$ROOT/src/seed/.ai/docs/INDEX.md" || return 1
  assert_file "$ROOT/src/bridges/agents.block.md" || return 1
  assert_file "$ROOT/src/bridges/claude.block.md" || return 1

  for forbidden in \
    "$ROOT/src/managed/.codex" \
    "$ROOT/src/managed/.claude" \
    "$ROOT/src/managed/.cursor" \
    "$ROOT/src/managed/.opencode"; do
    [ ! -e "$forbidden" ] || fail "source contains deferred or generated path: $forbidden" || return 1
  done
}

check_prompt_sizes() {
  protocol_lines=$(wc -l <"$ROOT/src/managed/.ai/sia.md" | tr -d ' ')
  [ "$protocol_lines" -le 225 ] || fail "canonical protocol exceeds 225 lines" || return 1

  for file in "$ROOT"/src/managed/.ai/skills/sia/*/SKILL.md; do
    lines=$(wc -l <"$file" | tr -d ' ')
    [ "$lines" -le 500 ] || fail "skill exceeds 500 lines: $file" || return 1
  done
  for file in "$ROOT"/src/managed/.ai/operations/sia/*.md "$ROOT"/src/managed/.ai/workflows/sia/*.md; do
    lines=$(wc -l <"$file" | tr -d ' ')
    [ "$lines" -le 300 ] || fail "definition exceeds 300 lines: $file" || return 1
  done
  for file in "$ROOT"/src/bridges/*.md; do
    lines=$(wc -l <"$file" | tr -d ' ')
    [ "$lines" -le 40 ] || fail "activation bridge exceeds 40 lines: $file" || return 1
  done
}

check_plain_github_install() {
  assert_contains "$ROOT/install.sh" 'https://github.com/cristianbica/sia.git' || return 1
  assert_contains "$ROOT/install.sh" 'SIA_REF' || return 1
  assert_not_contains "$ROOT/install.sh" 'decode_base64' || return 1
  assert_contains "$ROOT/README.md" 'raw.githubusercontent.com/cristianbica/sia/HEAD/install.sh'
}

run_case "Markdown lines are at most 120 characters" check_markdown_width
run_case "Markdown local links resolve" check_local_links
run_case "source boundaries match the installation layout" check_source_boundaries
run_case "prompt packages remain within explicit context budgets" check_prompt_sizes
run_case "installer downloads plain GitHub source" check_plain_github_install
run_case "definition names match installed paths" check_definition_names
run_case "catalog fragments match shipped definitions" check_catalog_sync
run_case "shipped operation references resolve" check_operation_references
run_case "operation aliases are normalized and unambiguous" check_operation_aliases

finish_tests
