#!/bin/sh

set -u

ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
CASES=$ROOT/benchmarks/concise-output/cases.jsonl
MODE=${1:-check}
ARTIFACTS=${2:-}
TIMEOUT=${SIA_CONCISE_TIMEOUT_SECONDS:-120}
REASONING=${SIA_CONCISE_REASONING_EFFORT:-medium}

fail() {
  printf 'concise-output: %s\n' "$*" >&2
  exit 2
}

check_cases() {
  command -v jq >/dev/null 2>&1 || fail 'jq is required'
  [ -s "$CASES" ] || fail "missing cases: $CASES"
  jq -e '
    type == "object" and
    (.id | type == "string" and length > 0) and
    (.prompt | type == "string" and startswith("Sia ")) and
    (.required | type == "array") and
    (.forbidden | type == "array")
  ' "$CASES" >/dev/null || fail 'invalid case record'
  count=$(wc -l <"$CASES" | tr -d ' ')
  [ "$count" -eq 8 ] || fail "expected 8 cases, found $count"
  duplicate=$(jq -r .id "$CASES" | sort | uniq -d | head -n 1)
  [ -z "$duplicate" ] || fail "duplicate case: $duplicate"
  printf 'Validated 8 concise-output cases; no model invoked.\n'
}

candidate_contract() {
  printf '%s\n' \
    'Write the shortest complete answer that lets the user understand the outcome and act safely.' \
    'Lead with the answer, finding, blocker, or decision in normal English.' \
    'For a simple answer, use one sentence or one exact command.' \
    'For diagnosis or investigation, give the conclusion, decisive evidence, uncertainty, and one next action only.' \
    'For review, report material findings first; omit process narration and unrelated repository observations.' \
    'Remove greetings, preambles, self-reference, repetition, generic closers, and explanations the user did not ask for.' \
    'Preserve every required fact, exact technical string, safety limit, approval boundary, and requested detail.'
}

metric() {
  key=$1
  file=$2
  value=$(jq -r --arg key "$key" \
    '.. | objects | select(has($key)) | .[$key] | select(type == "number")' "$file" 2>/dev/null | tail -n 1)
  [ -n "$value" ] && printf '%s\n' "$value" || printf 'unknown\n'
}

run_call() {
  case_json=$1
  arm=$2
  destination=$3
  prompt=$(printf '%s\n' "$case_json" | jq -r .prompt)
  if [ "$arm" = candidate ]; then
    prompt=$(printf '%s\n\n<presentation_contract>\n%s\n</presentation_contract>\n' \
      "$prompt" "$(candidate_contract)")
  fi
  printf '%s\n' "$prompt" >"$destination/prompt.txt"
  model_args=
  if [ -n "${SIA_CONCISE_CODEX_MODEL:-}" ]; then
    model_args="--model $SIA_CONCISE_CODEX_MODEL"
  fi
  started=$(date +%s)
  # shellcheck disable=SC2086
  (cd "$ROOT" && timeout --signal=TERM --kill-after=5 "${TIMEOUT}s" \
    codex exec --ephemeral --ignore-user-config --sandbox read-only --json \
    --config 'approval_policy="never"' --config "model_reasoning_effort=\"$REASONING\"" \
    $model_args --color never --output-last-message "$destination/response.txt" "$prompt") \
    >"$destination/raw.jsonl" 2>"$destination/stderr.txt" </dev/null
  status=$?
  elapsed=$(($(date +%s) - started))
  printf '%s\n' "$status" >"$destination/exit.txt"
  printf '%s\n' "$elapsed" >"$destination/elapsed.txt"
  [ "$status" -eq 0 ] || return 1
  [ -s "$destination/raw.jsonl" ] || return 1
  [ -s "$destination/response.txt" ] || return 1
}

score_call() {
  case_json=$1
  arm=$2
  destination=$3
  case_id=$(printf '%s\n' "$case_json" | jq -r .id)
  response=$destination/response.txt
  fidelity=PASS
  printf '%s\n' "$case_json" | jq -r '.required[]' |
    while IFS= read -r required; do
      if grep -F -i "$required" "$response" >/dev/null 2>&1; then
        printf 'PASS\trequired\t%s\n' "$required"
      else
        printf 'FAIL\trequired\t%s\n' "$required"
      fi
    done >"$destination/assertions.tsv"
  printf '%s\n' "$case_json" | jq -r '.forbidden[]' |
    while IFS= read -r forbidden; do
      if grep -F -i "$forbidden" "$response" >/dev/null 2>&1; then
        printf 'FAIL\tforbidden\t%s\n' "$forbidden"
      else
        printf 'PASS\tforbidden\t%s\n' "$forbidden"
      fi
    done >>"$destination/assertions.tsv"
  awk -F '\t' '$1 == "FAIL" { found = 1 } END { exit !found }' "$destination/assertions.tsv" &&
    fidelity=FAIL
  chars=$(wc -m <"$response" | tr -d ' ')
  input=$(metric input_tokens "$destination/raw.jsonl")
  output=$(metric output_tokens "$destination/raw.jsonl")
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\tpending\n' \
    "$arm" "$case_id" "$fidelity" "$chars" "$input" "$output" \
    "$(cat "$destination/elapsed.txt")" >>"$ARTIFACTS/results.tsv"
}

check_cases
[ "$MODE" = check ] && exit 0
[ "$MODE" = live ] || fail 'usage: run.sh [check | live NEW_ARTIFACT_DIRECTORY]'
[ -n "$ARTIFACTS" ] || fail 'live mode requires a new artifact directory'
[ ! -e "$ARTIFACTS" ] || fail "artifact path already exists: $ARTIFACTS"
case $TIMEOUT in ''|*[!0-9]*|0) fail 'timeout must be a positive integer' ;; esac
command -v codex >/dev/null 2>&1 || fail 'codex is required for live mode'
command -v timeout >/dev/null 2>&1 || fail 'GNU timeout is required for live mode'

mkdir -p "$ARTIFACTS/smoke" "$ARTIFACTS/runs"
ARTIFACTS=$(CDPATH= cd "$ARTIFACTS" && pwd)
printf 'arm\tcase\tfidelity\tvisible_chars\tinput_tokens\toutput_tokens\telapsed_seconds\tnatural_english_1_to_5\n' \
  >"$ARTIFACTS/results.tsv"
{
  printf 'revision=%s\n' "$(git -C "$ROOT" rev-parse HEAD)"
  printf 'model=%s\n' "${SIA_CONCISE_CODEX_MODEL:-host-default}"
  printf 'reasoning_effort=%s\n' "$REASONING"
  printf 'timeout_seconds=%s\n' "$TIMEOUT"
  printf 'child_standard_input=/dev/null\n'
} >"$ARTIFACTS/metadata.txt"

smoke=$(sed -n '1p' "$CASES")
if ! run_call "$smoke" baseline "$ARTIFACTS/smoke"; then
  printf 'Smoke call failed; comparison was not started. Evidence: %s\n' "$ARTIFACTS/smoke" >&2
  exit 1
fi
printf 'Smoke call passed; starting 16 comparison calls.\n'

while IFS= read -r case_json; do
  case_id=$(printf '%s\n' "$case_json" | jq -r .id)
  for arm in baseline candidate; do
    destination=$ARTIFACTS/runs/$case_id-$arm
    mkdir -p "$destination"
    if ! run_call "$case_json" "$arm" "$destination"; then
      printf 'Call failed; comparison stopped: %s/%s\n' "$case_id" "$arm" >&2
      exit 1
    fi
    score_call "$case_json" "$arm" "$destination"
  done
done <"$CASES"

cat "$ARTIFACTS/results.tsv"
printf 'Human review is required before integration.\n'
