# Optional worker handoff

Choose the model or reasoning effort at spawn time through the host. Match it to the assignment:

- During complex planning, use a higher-effort worker to independently assess migration order, compatibility, or
  rollback while the coordinator drafts the plan. Keep the assignment read-only before approval. The coordinator
  verifies the findings, resolves tradeoffs, and presents one plan for approval.
- Use a faster model to map callers for a bounded part of a complex change while the coordinator examines the main
  code path. Use higher effort for an independent review of a risky change when that would improve the review.

Continue directly if the host cannot apply the chosen model or effort. Preserve advisory fields in older handoffs
without treating them as authority. Usage telemetry is optional. Report unavailable model fields as unknown only
when requested.

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
