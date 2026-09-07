# Local engineering-quality fixtures

These five small answer tasks extend the existing custom benchmark; they are not another model runner. They isolate
ownership discovery, causal diagnosis, stale documentation, review precision/recall, and follow-up knowledge reuse.
They complement the pinned public implementation corpus and do not establish general coding ability.

The coordinator reads `manifest.json` and `private/rubrics.json`. Every task inherits the manifest
`defaults` for supported environment, timeout, scope, setup, and checks. The pinned per-file SHA-256 map identifies
the complete public workspace: reject changed, missing, extra, or non-regular files before selection. No dependency
installation or setup command is required; the declared copy/bootstrap procedure still applies. Run the offline
fixture-contract command from the coordinator source root, then assess task answers with the private rubric and
post-bootstrap workspace comparison. Static fixture checks do not score a candidate answer. Copy only `workspace/` into each clean candidate
workspace, and supply only the selected public prompt. Do not expose this directory, manifests, private rubrics,
reference answers, or sibling candidates. `proposed.diff` is public task input, not a hidden solution.
The private rubrics define evidence and acceptable conclusions rather than exact output strings.

All tasks are read-only. Run `ownership` before `knowledge-reuse` in the same candidate session; preserve the first
response/trace and record both costs. Other tasks start in fresh sessions. If continuation is unavailable, report that
assertion unavailable rather than turning the follow-up into an independent task. A supported explicit handoff may be
evaluated separately and must be labeled as such. Never put the private expected answer into a handoff.

Score required findings and cited evidence first, then usefulness/readability and unnecessary user effort. For review,
report precision and recall separately, distinguishing actionable defects from optional suggestions. There is one
seeded material defect. A missed authorization defect fails even if the response is short; invented material defects
reduce precision. Human reviewers assess semantic matches and false positives; substring matches are insufficient.
For knowledge reuse, inspect justified discovery and total cost across both turns, not just the shorter second answer.

These intentionally small fixtures do not run model calls through the normal verifier. Offline checks validate corpus
links, authority separation, accounting, and the seeded behaviors. Budgeted repeated host comparisons remain necessary.
