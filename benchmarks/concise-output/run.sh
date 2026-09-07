#!/bin/sh
ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
exec python3 "$ROOT/benchmarks/concise-output/run.py" "$@"
