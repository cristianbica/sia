# Optional worker handoff

Use only for a useful independent task that the host can delegate. Keep ordinary work in the current context when
isolation adds no value. Do not require model-profile selection or usage telemetry; preserve advisory fields in older
handoffs without treating them as authority. Report unavailable model fields as unknown only when requested.

Send the worker a message beginning exactly `Sia handoff`, then `handoff_protocol: 1`. Include:

- the original request, subsequent user changes, bounded assignment, allowed work, and exclusions;
- repository root, effective operation/workflow, phase, exact definition paths and required support/skills;
- relevant evidence, checks, permissions, execution mode, and authorization ceiling/external actions;
- exact `authorized_plan_paths`, or `[]`, with all other `.ai/plans/**` paths in `do_not_load`;
- for writes, base revision and staged/unstaged/untracked paths; for saved work, artifact path, status, approval
  revision, and next transition;
- recovery/stop conditions and one final task.

Full older envelopes remain valid. Required context must be nonempty or explicitly inapplicable; reject missing,
contradictory, or permission-expanding envelopes. The worker reads protocol/rules and only the exact named definitions,
support, evidence, and authorized plans. Do not resolve through catalogs or start a different operation. An invalid
handoff starts no work. The worker cannot coordinate approval or broaden scope; unattended blockers return to the
caller.

Keep stable instructions before task-specific evidence. Do not claim a fresh context if the host may inherit history.
Return `handoff_result: 1`, phase, status (`complete`, `blocked`, or `failed`), findings, changed paths, checks/results,
and next transition. The coordinator verifies the result and retains responsibility for the task and its approvals.
