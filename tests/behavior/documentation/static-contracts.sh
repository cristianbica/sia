#!/bin/sh

set -u

ROOT=$(CDPATH= cd "$(dirname "$0")/../../.." && pwd)
. "$ROOT/tests/lib/test.sh"

WORKFLOW=$ROOT/src/managed/.ai/workflows/sia/documentation.md
REFRESH=$ROOT/src/managed/.ai/operations/sia/refresh-docs.md
DOCUMENT=$ROOT/src/managed/.ai/operations/sia/document.md
SKILL=$ROOT/src/managed/.ai/skills/sia/documentation/SKILL.md

check_documentation_dependencies() {
  python3 - "$DOCUMENT" "$REFRESH" "$WORKFLOW" "$SKILL" <<'PY'
from pathlib import Path
import re
import sys

def valid_operation(body):
    parts = body.split('---\n', 2)
    if len(parts) != 3 or parts[0]:
        return False
    header = parts[1]
    skills = re.findall(r'^  - ([a-z-]+)$', header, re.M)
    return (re.findall(r'^workflow: (.+)$', header, re.M) == ['documentation']
            and skills == ['repository-discovery', 'documentation'])

for filename in sys.argv[1:3]:
    body = Path(filename).read_text()
    assert valid_operation(body), filename + ': missing documentation dependency'
    assert not valid_operation(body.replace('workflow: documentation', 'workflow: delivery'))
    assert not valid_operation(body.replace('  - documentation\n', ''))
    assert not valid_operation(body.replace('  - documentation\n', '  - documentation\n  - documentation\n'))
workflow = Path(sys.argv[3]).read_text()
assert re.findall(r'^## (.+)$', workflow, re.M) == ['Scope', 'Discover', 'Write', 'Review']
assert Path(sys.argv[4]).read_text().startswith('---\nname: documentation\n')
PY
}

check_documentation_boundaries() {
  assert_contains "$WORKFLOW" 'writes only the requested `.ai/docs/**` scope' || return 1
  assert_contains "$WORKFLOW" 'Do not edit product, source, plans, or external state' || return 1
  assert_contains "$WORKFLOW" 'read-only' || return 1
  assert_contains "$SKILL" 'current phase and authorized scope' || return 1
  assert_contains "$SKILL" 'exact document, claim, and contradicting evidence' || return 1
}

check_evidence_has_one_owner() {
  assert_contains "$SKILL" 'never prove current correctness' || return 1
  assert_contains "$SKILL" 'Do not record a command as verified unless it ran successfully' || return 1
  assert_contains "$SKILL" 'never infer historical intent from code' || return 1
  assert_contains "$SKILL" 'confirmed, corrected, removed, and unverified' || return 1
  for path in "$DOCUMENT" "$REFRESH" "$WORKFLOW"; do
    assert_not_contains "$path" 'last_verified_ref' || return 1
  done
}

run_case "documentation operations retain their workflow and skill dependencies" check_documentation_dependencies
run_case "documentation phases retain scope and write boundaries" check_documentation_boundaries
run_case "documentation skill owns evidence and freshness requirements" check_evidence_has_one_owner

finish_tests
