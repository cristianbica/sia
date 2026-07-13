#!/bin/sh

TEST_COUNT=0
TEST_FAILURES=0

run_case() {
  case_name=$1
  shift
  TEST_COUNT=$((TEST_COUNT + 1))

  if "$@"; then
    printf 'ok %s - %s\n' "$TEST_COUNT" "$case_name"
  else
    printf 'not ok %s - %s\n' "$TEST_COUNT" "$case_name" >&2
    TEST_FAILURES=$((TEST_FAILURES + 1))
  fi
}

finish_tests() {
  if [ "$TEST_FAILURES" -ne 0 ]; then
    printf '%s of %s checks failed\n' "$TEST_FAILURES" "$TEST_COUNT" >&2
    return 1
  fi

  printf '%s checks passed\n' "$TEST_COUNT"
}

fail() {
  echo "FAIL: $*" >&2
  return 1
}

assert_file() {
  [ -f "$1" ] || fail "expected file: $1"
}

assert_no_file() {
  [ ! -f "$1" ] || fail "unexpected file: $1"
}

assert_nonempty() {
  [ -s "$1" ] || fail "expected nonempty file: $1"
}

assert_contains() {
  file=$1
  value=$2
  grep -F "$value" "$file" >/dev/null 2>&1 || fail "$file does not contain: $value"
}

assert_not_contains() {
  file=$1
  value=$2
  if grep -F "$value" "$file" >/dev/null 2>&1; then
    fail "$file unexpectedly contains: $value"
  fi
}

assert_fixed_count() {
  file=$1
  value=$2
  expected=$3
  actual=$(grep -F -c "$value" "$file" 2>/dev/null || true)
  [ "$actual" -eq "$expected" ] || fail "$file has $actual occurrences of '$value'; expected $expected"
}

assert_equal() {
  expected=$1
  actual=$2
  message=$3
  [ "$expected" = "$actual" ] || fail "$message"
}

