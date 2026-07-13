#!/bin/sh

# Managed refreshes replace reserved Sia paths or marked blocks; project seeds are created once.

set -eu

GITHUB_URL=${GITHUB_URL:-https://github.com/cristianbica/sia.git}
REF=${REF:-}
SOURCE_DIR=${SOURCE_DIR:-}
DOWNLOAD_ROOT=
LOCK_DIR=

cleanup() {
  [ -z "$LOCK_DIR" ] || rmdir "$LOCK_DIR" 2>/dev/null || :
  [ -z "$DOWNLOAD_ROOT" ] || [ ! -d "$DOWNLOAD_ROOT" ] || rm -rf "$DOWNLOAD_ROOT"
}

trap cleanup 0
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM

fail() {
  printf 'install.sh: %s\n' "$*" >&2
  exit 1
}

usage() {
  cat <<EOF
Usage: install.sh

Run from the Git repository that should receive Sia. Re-run to refresh it.

Optional environment variables:
  REF=<branch-or-tag>      Git ref to download when this script is read from standard input
  SOURCE_DIR=<path>        Local Sia source root; its checked-out files are installed as-is
EOF
}

repository_root() {
  root=$(git rev-parse --show-toplevel 2>/dev/null) || \
    fail 'run this from the root of the Git repository that should receive Sia'
  [ "$(pwd -P)" = "$root" ] || fail "run this from repository root: $root"
}

source_from_script() {
  case $0 in
    sh|dash|bash|ksh|zsh|-sh|-dash|-bash|-ksh|-zsh) return 1 ;;
    */*) source_candidate=${0%/*} ;;
    *) [ -f "$0" ] || return 1; source_candidate=. ;;
  esac
  [ -d "$source_candidate/src" ] || return 1
  SOURCE_DIR=$(CDPATH= cd "$source_candidate" && pwd -P) || fail 'cannot read Sia source directory'
}

download_source() {
  DOWNLOAD_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/sia.XXXXXX") || fail 'cannot create temporary directory'
  if [ -n "$REF" ]; then
    printf 'Downloading Sia from %s at %s\n' "$GITHUB_URL" "$REF"
    GIT_TERMINAL_PROMPT=0 git clone --depth 1 --quiet --branch "$REF" -- "$GITHUB_URL" "$DOWNLOAD_ROOT/source" \
      </dev/null || fail 'cannot download Sia from GitHub'
  else
    printf 'Downloading Sia from %s\n' "$GITHUB_URL"
    GIT_TERMINAL_PROMPT=0 git clone --depth 1 --quiet -- "$GITHUB_URL" "$DOWNLOAD_ROOT/source" </dev/null || \
      fail 'cannot download Sia from GitHub'
  fi
  [ -f "$DOWNLOAD_ROOT/source/install.sh" ] || fail 'downloaded source has no install script'
  [ -d "$DOWNLOAD_ROOT/source/src" ] || fail 'downloaded source has no src directory'
  SOURCE_DIR="$DOWNLOAD_ROOT/source" sh "$DOWNLOAD_ROOT/source/install.sh" </dev/null
  exit $?
}

acquire_lock() {
  lock_parent=$(git rev-parse --git-common-dir 2>/dev/null) || fail 'cannot locate Git metadata'
  lock_candidate=$(CDPATH= cd "$lock_parent" && pwd -P)/sia-install.lock || fail 'cannot locate Git metadata'
  mkdir "$lock_candidate" 2>/dev/null || \
    fail "another Sia install may be running; if not, remove the stale lock: $lock_candidate"
  LOCK_DIR=$lock_candidate
}

marker_state() {
  marker_file=$1
  marker_start=$2
  marker_end=$3
  if [ ! -e "$marker_file" ] && [ ! -L "$marker_file" ]; then
    MARKER_STATE=missing
    return
  fi
  [ -f "$marker_file" ] && [ ! -L "$marker_file" ] || fail "$marker_file must be a regular file"
  starts=$(grep -F -x -c "$marker_start" "$marker_file" 2>/dev/null || true)
  ends=$(grep -F -x -c "$marker_end" "$marker_file" 2>/dev/null || true)
  case "${starts:-0}:${ends:-0}" in
    0:0) MARKER_STATE=none ;;
    1:1)
      awk -v start="$marker_start" -v end="$marker_end" '
        $0 == start { inside = 1 }
        $0 == end { if (!inside) bad = 1; inside = 0 }
        END { exit bad || inside }
      ' "$marker_file" || fail "$marker_file has malformed Sia markers"
      MARKER_STATE=present
      ;;
    *) fail "$marker_file has malformed Sia markers" ;;
  esac
}

check_block() {
  marker_state "$1" "$2" "$3"
  if [ "$MARKER_STATE" = none ] && [ -n "${4:-}" ]; then
    grep -F -x "$4" "$1" >/dev/null 2>&1 || fail "$1 must contain $4 before Sia can be added"
  fi
}

replace_block() {
  target=$1
  fragment=$2
  start=$3
  end=$4
  anchor=${5:-}
  marker_state "$target" "$start" "$end"
  if [ "$MARKER_STATE" = missing ]; then
    parent=${target%/*}
    [ "$parent" != "$target" ] || parent=.
    mkdir -p "$parent"
    new_dir=$(mktemp -d "$parent/.sia-new.XXXXXX") || fail "cannot create $target"
    new_file=$new_dir/file
    cp "$fragment" "$new_file" || { rm -f "$new_file"; rmdir "$new_dir"; fail "cannot prepare $target"; }
    if ! ln "$new_file" "$target" 2>/dev/null; then
      rm -f "$new_file"
      rmdir "$new_dir"
      if [ -e "$target" ] || [ -L "$target" ]; then
        fail "$target appeared during installation; it was left unchanged"
      fi
      fail "cannot create $target"
    fi
    rm -f "$new_file"
    rmdir "$new_dir"
    return
  fi

  parent=${target%/*}
  [ "$parent" != "$target" ] || parent=.
  snapshot=$(mktemp "$parent/.sia-original.XXXXXX") || fail "cannot snapshot $target"
  tmp=$(mktemp "$parent/.sia-new.XXXXXX") || { rm -f "$snapshot"; fail "cannot prepare $target"; }
  owner_write=$(LC_ALL=C ls -ld "$target" | cut -c3) || {
    rm -f "$snapshot" "$tmp"
    fail "cannot inspect permissions for $target"
  }
  cp "$target" "$snapshot" || { rm -f "$snapshot" "$tmp"; fail "cannot snapshot $target"; }
  cp -p "$target" "$tmp" || { rm -f "$snapshot" "$tmp"; fail "cannot prepare $target"; }
  chmod u+w "$tmp" || { rm -f "$snapshot" "$tmp"; fail "cannot prepare $target"; }
  if [ "$MARKER_STATE" = present ]; then
    awk -v start="$start" -v end="$end" -v fragment="$fragment" '
      BEGIN { while ((getline line < fragment) > 0) block = block line "\n"; close(fragment) }
      $0 == start { printf "%s", block; inside = 1; next }
      $0 == end && inside { inside = 0; next }
      !inside { print }
    ' "$snapshot" >"$tmp" || { rm -f "$snapshot" "$tmp"; fail "cannot prepare $target"; }
  elif [ -n "$anchor" ]; then
    awk -v anchor="$anchor" -v fragment="$fragment" '
      BEGIN { while ((getline line < fragment) > 0) block = block line "\n"; close(fragment) }
      $0 == anchor && !inserted { printf "%s\n", block; inserted = 1 }
      { print }
      END { exit !inserted }
    ' "$snapshot" >"$tmp" || {
      rm -f "$snapshot" "$tmp"
      fail "$target must contain $anchor before Sia can be added"
    }
  else
    { cat "$snapshot"; [ ! -s "$snapshot" ] || printf '\n'; cat "$fragment"; } >"$tmp" || {
      rm -f "$snapshot" "$tmp"
      fail "cannot prepare $target"
    }
  fi
  if [ "$owner_write" != w ]; then
    chmod u-w "$tmp" || { rm -f "$snapshot" "$tmp"; fail "cannot preserve permissions for $target"; }
  fi
  if ! cmp -s "$snapshot" "$target"; then
    rm -f "$snapshot" "$tmp"
    fail "$target changed during installation; it was left unchanged"
  fi
  mv "$tmp" "$target" || { rm -f "$snapshot" "$tmp"; fail "cannot replace $target"; }
  rm -f "$snapshot"
}

seed() {
  seed_source=$1
  seed_target=$2
  if [ -e "$seed_target" ] || [ -L "$seed_target" ]; then
    return
  fi
  seed_parent=${seed_target%/*}
  mkdir -p "$seed_parent"
  seed_dir=$(mktemp -d "$seed_parent/.sia-seed.XXXXXX") || fail "cannot create $seed_target"
  seed_tmp=$seed_dir/file
  cp "$seed_source" "$seed_tmp" || { rm -f "$seed_tmp"; rmdir "$seed_dir"; fail "cannot prepare $seed_target"; }
  if ! ln "$seed_tmp" "$seed_target" 2>/dev/null; then
    rm -f "$seed_tmp"
    rmdir "$seed_dir"
    if [ -e "$seed_target" ] || [ -L "$seed_target" ]; then
      check_seed "$seed_target"
      return
    fi
    fail "cannot create $seed_target"
  fi
  rm -f "$seed_tmp"
  rmdir "$seed_dir"
}

check_layout() {
  for path in .ai .ai/docs .ai/skills .ai/operations .ai/workflows .claude; do
    [ ! -L "$path" ] || fail "refusing symlinked path: $path"
    [ ! -e "$path" ] || [ -d "$path" ] || fail "$path must be a directory"
  done
}

check_seed() {
  [ ! -e "$1" ] && [ ! -L "$1" ] && return
  [ -f "$1" ] && [ ! -L "$1" ] && [ -r "$1" ] || fail "$1 must be a readable regular file"
}

source_file() {
  [ -f "$1" ] && [ ! -L "$1" ] && [ -r "$1" ] || fail "Sia source file is invalid: $1"
}

source_dir() {
  [ -d "$1" ] && [ ! -L "$1" ] && [ -r "$1" ] && [ -x "$1" ] || \
    fail "Sia source directory is invalid: $1"
}

check_source_catalog() {
  category=$1
  definition_root=$2
  fragment="$SOURCE_DIR/src/managed/catalogs/$category.md"
  source_file "$fragment"
  marker_state "$fragment" "<!-- sia:$category:start -->" "<!-- sia:$category:end -->"
  [ "$MARKER_STATE" = present ] || fail "Sia source catalog has no managed block: $fragment"
  names=$(sed -n 's/^- `\([^`]*\)`.*/\1/p' "$fragment")
  [ -n "$names" ] || fail "Sia source catalog has no definitions: $fragment"
  for name in $names; do
    case $name in
      ''|*[!a-z0-9-]*|-*|*-|*--*) fail "Sia source catalog has an invalid name: $name" ;;
    esac
    if [ "$category" = skills ]; then
      source_dir "$definition_root/$name"
      source_file "$definition_root/$name/SKILL.md"
    else
      source_file "$definition_root/$name.md"
    fi
  done
}

check_source() {
  managed=$SOURCE_DIR/src/managed/.ai
  seeds=$SOURCE_DIR/src/seed/.ai
  bridges=$SOURCE_DIR/src/bridges
  source_dir "$SOURCE_DIR/src"
  unsupported=$(find "$SOURCE_DIR/src" ! -type f ! -type d -print) || fail 'cannot inspect Sia source'
  [ -z "$unsupported" ] || fail "Sia source contains an unsupported path type: $unsupported"
  unreadable=$(find "$SOURCE_DIR/src" -type f ! -exec test -r {} \; -print) || fail 'cannot inspect Sia source'
  [ -z "$unreadable" ] || fail "Sia source contains an unreadable file: $unreadable"
  source_dir "$managed/skills/sia"
  source_dir "$managed/operations/sia"
  source_dir "$managed/workflows/sia"
  source_file "$managed/sia.md"
  for path in "$seeds/RULES.md" "$seeds/docs/INDEX.md" "$seeds/skills/INDEX.md" \
    "$seeds/operations/INDEX.md" "$seeds/workflows/INDEX.md" \
    "$bridges/agents.block.md" "$bridges/claude.block.md"; do
    source_file "$path"
  done
  check_source_catalog skills "$managed/skills/sia"
  check_source_catalog operations "$managed/operations/sia"
  check_source_catalog workflows "$managed/workflows/sia"
}

preflight() {
  check_layout
  check_seed .ai/RULES.md
  check_seed .ai/docs/INDEX.md
  for category in skills operations workflows; do
    check_block ".ai/$category/INDEX.md" "<!-- sia:$category:start -->" \
      "<!-- sia:$category:end -->" '## CUSTOM'
  done
  check_block AGENTS.md '<!-- sia:entrypoint:start -->' '<!-- sia:entrypoint:end -->'
  check_block .claude/CLAUDE.md '<!-- sia:claude:start -->' '<!-- sia:claude:end -->'
}

has_claude_import() {
  grep -Eq '^[[:space:]]*@([.]/)?AGENTS[.]md[[:space:]]*$' CLAUDE.md 2>/dev/null || \
    grep -Eq '^[[:space:]]*@\.\./AGENTS[.]md[[:space:]]*$' .claude/CLAUDE.md 2>/dev/null
}

install_sia() {
  managed=$SOURCE_DIR/src/managed/.ai
  catalogs=$SOURCE_DIR/src/managed/catalogs
  seeds=$SOURCE_DIR/src/seed/.ai
  bridges=$SOURCE_DIR/src/bridges
  check_source
  preflight
  mkdir -p .ai/skills .ai/operations .ai/workflows
  [ ! -d .ai/sia.md ] || fail '.ai/sia.md must be a file'
  rm -f .ai/sia.md
  cp "$managed/sia.md" .ai/sia.md
  for category in skills operations workflows; do
    rm -rf ".ai/$category/sia"
    cp -R "$managed/$category/sia" ".ai/$category/"
  done
  seed "$seeds/RULES.md" .ai/RULES.md
  seed "$seeds/docs/INDEX.md" .ai/docs/INDEX.md
  for category in skills operations workflows; do
    seed "$seeds/$category/INDEX.md" ".ai/$category/INDEX.md"
    replace_block ".ai/$category/INDEX.md" "$catalogs/$category.md" \
      "<!-- sia:$category:start -->" "<!-- sia:$category:end -->" '## CUSTOM'
  done
  replace_block AGENTS.md "$bridges/agents.block.md" '<!-- sia:entrypoint:start -->' '<!-- sia:entrypoint:end -->'
  marker_state .claude/CLAUDE.md '<!-- sia:claude:start -->' '<!-- sia:claude:end -->'
  if [ "$MARKER_STATE" = present ] || ! has_claude_import; then
    replace_block .claude/CLAUDE.md "$bridges/claude.block.md" '<!-- sia:claude:start -->' '<!-- sia:claude:end -->'
  fi
  printf '%s\n' 'Sia installed. Invoke it explicitly with: Sia load docs'
}

if [ "${1:-}" = -h ] || [ "${1:-}" = --help ]; then
  [ "$#" -eq 1 ] || { usage >&2; exit 2; }
  usage
  exit 0
fi
[ "$#" -eq 0 ] || { usage >&2; exit 2; }

repository_root
[ -n "$SOURCE_DIR" ] || source_from_script || download_source
SOURCE_DIR=$(CDPATH= cd "$SOURCE_DIR" && pwd -P) || fail "cannot read source directory: $SOURCE_DIR"
acquire_lock
install_sia
