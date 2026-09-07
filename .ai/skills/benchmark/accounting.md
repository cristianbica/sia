# Accounting records

Use `python3 .ai/skills/benchmark/scripts/accounting.py RECORD.json` to summarize a completed report's measurements.
This small helper performs arithmetic; it does not run candidates, certify quality, or estimate absent telemetry.

```json
{
  "tasks": [{"id": "ownership", "quality_verdict": "pass"}],
  "end_to_end_wall_seconds": 20,
  "phases": [
    {"phase": "bootstrap", "task_id": null, "phase_seconds": 5, "cost_usd": 0.1,
     "input_tokens": 100, "cached_input_tokens": 0, "output_tokens": 20,
     "reasoning_tokens": "unknown", "user_minutes": 0},
    {"phase": "implementation", "task_id": "ownership", "phase_seconds": 15, "cost_usd": "unknown",
     "input_tokens": 200, "cached_input_tokens": 100, "output_tokens": 40,
     "reasoning_tokens": 10, "user_minutes": "unknown"}
  ]
}
```

Allowed phases: `cold_start`, `bootstrap`, `implementation`, `review`, `retry`. Use implementation for the substantive
answer phase of read-only tasks. Shared cold-start/bootstrap rows have null task IDs; other rows name an attempted
task. Represent each worker/attempt once, including failed work. Omit a phase only when it did not happen, not because
its measurements are missing; record an `unknown` row when a performed phase lacks telemetry.

Token totals are normalized inclusive totals: input includes cached input and output includes reasoning. Cached and
reasoning fields are subsets, never added again to those totals. Some providers report cache separately; normalize
only from documented reported fields and retain raw evidence. If the host's semantics are unclear, use `unknown`.
Do not infer reasoning from visible text or infer cost from a guessed price. Currency is USD throughout one report.

A missing metric propagates `unknown` into totals and amortized values; the known subtotal is labeled separately and
is not a complete cost estimate. No successful reviewed task yields unknown amortization. Failed-attempt costs remain
in the numerator; only tasks with an explicit reviewed pass count in the denominator. Pending is not pass.
Phase seconds sum work durations, including parallel workers; end-to-end wall time is separately observed or unknown.
The helper cannot detect omitted phases: the reviewer must reconcile records with process/worker evidence.
