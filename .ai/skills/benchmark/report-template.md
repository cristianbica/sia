# Benchmark report

Task/sequence, candidate/comparator, source and base revisions, instruction hashes, host/version, requested and actual
model/effort, permissions, isolation, cache state, and evidence directory:

## Quality review

| Task | Correctness | Understanding/evidence | Usefulness | User effort | Verdict | Reviewer/evidence |
| --- | --- | --- | --- | --- | --- | --- |
| task-id | pending | pending | pending | pending | pending | pending |

Use pass/fail/pending/unavailable for the reviewed verdict. Correctness failures cannot pass through a strong efficiency
score. Record required findings, unsupported assumptions, scope drift, omitted checks, and actionable next steps.
For defect review, record seeded defects, true positives, false positives, false negatives, precision, and recall.
Report readability and code quality with concrete examples. Record clarifications, unnecessary approvals, and manual
repair time; do not count required user gates as avoidable effort. Unknown human time remains unknown.

## Complete effort

Record cold-start, documentation bootstrap, implementation/investigation, review, and retry phases in accounting JSON.
Include every worker and failed attempt once. Preserve raw host telemetry alongside normalized values. Record setup and
bootstrap separately and include them in total cost; preserve an independently observed end-to-end wall-clock interval.
Sum phase/worker durations as work time, not wall-clock time when phases overlap.

Report total cost, known subtotals when incomplete, attempted and successfully reviewed tasks, and amortized cost per
successful task. For repeated-task sequences, show cold-start total and cumulative amortization after each task; do not
reset or discard bootstrap, failed-attempt, or retry costs. Report score/pass-rate distributions over repeated trials.

## Boundaries and conclusion

List unavailable telemetry/checks, setup limitations, deviations, cleanup and process state, and surviving evidence.
State the narrow conclusion supported by the paired results. Pending model runs or pending quality review cannot
support an improvement claim. Keep separate quality and efficiency judgments visible.
