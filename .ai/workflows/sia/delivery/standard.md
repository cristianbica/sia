# Saved plans and resume

Use this shared plan lifecycle for change requests across all workflows. Resolve the actual operation, workflow, and
skills; do not relabel documentation or definition work as implement. CUSTOM workflows keep their task-specific steps
and any additional gates while preserving the protocol's shared approval boundary.

## Save and approve

Create `.ai/plans/YYYY-MM-DD-NN-<slug>.md` using the UTC date and next zero-padded daily sequence. Inspect filenames
only to allocate it. Immediately add the exact new path to `authorized_plan_paths`.

Keep frontmatter to `operation`, `workflow`, and `skills`. Put the proposed outcome, approach, scope, non-goals,
acceptance checks, and material risks/external actions in one approval block. Use readable prose or bullets, not a
mandatory set of headings. Keep the plan concise but retain the decisions and checks needed to judge the change.
Do not repeat protocol rules or narrate investigation. Footer state uses one-line comments; omit empty optional fields.

```markdown
---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Show currency on receipts

<!-- sia:approval:start -->
Add the order's currency to the existing receipt formatter and its caller. Keep the current amount formatting.
Check receipts for two currencies and preserve existing receipt fields. No new currency conversion or external calls.
<!-- sia:approval:end -->

<!-- sia:status pending-approval -->
<!-- sia:base <commit> -->
```

Present the plan and wait for approval before any non-plan change. A clarification answer, resume alone, or an earlier
generic imperative
is not approval. A clear reply referring to the presented plan is sufficient; do not ask again for routine steps.
Compute lowercase SHA-256 of UTF-8 content between the unique approval markers, excluding the markers: normalize CRLF
and CR to LF, preserve all other whitespace. Append `<!-- sia:approved <sha256> -->` only after approval; set status to
`build`. Changing the approved boundary removes that approval and returns to `pending-approval` before further work.
Implementation details within the boundary belong in progress, not a rewritten approval block.

Explicit unattended saved work may approve only within its original ceiling; record `mode`, `ceiling`, and authorized
`external` actions. These cannot expand during replans. A planning-only request stays pending even in unattended mode.

## Validate and resume

Require exact content-read authorization before opening a plan. Compact plans need one ordered, nonnested approval
marker pair, one valid status, and a matching digest whenever status is beyond `pending-approval`. Reject empty,
missing, ambiguous, or contradictory artifacts. A pending draft enters approval, never Build. Refuse complete or
cancelled plans. Valid legacy artifacts remain resumable under their recorded approval and workflow contracts;
do not convert them merely to simplify the format. If their meaning cannot be established, stop rather than guessing.

Valid statuses are `pending-approval`, `build`, `review-validate`, `fix`, `ship`, `blocked`, `complete`, and
`cancelled`.
Optional comments are `approved`, `base`, `dirty`, `mode`, `route`, `ceiling`, `external`, `progress`, and `blocker`.
`base` records initial HEAD; `dirty` names pre-existing changes. Older `route` values are compatibility metadata,
not instructions to remove approvals. Progress cannot repair invalid approval content.

Compare HEAD and changed paths with base/dirty metadata and progress evidence. Record harmless drift without changing
the original base. Preserve unrelated work; unsafe overlap blocks unattended execution. A material boundary change
requires a revised plan and approval, or blocks unattended work outside its ceiling. Resolve current exact definition
paths at phase boundaries and report changes. Definition rewrites do not retroactively grant approval.

## Execute and finish

Build within approval, then set `review-validate` and review/check the result. Record concise evidence in progress;
use `fix` for in-scope corrections and recheck them. `ship` requires passing review and writes only completion metadata.
Set `complete` only after required implementation and checks finish. Keep the plan; delete it only on a separate
explicit
request. A blocker records what must change before retry. Unattended work stops after three unsuccessful fix cycles.
Preserve exact authorized plan/definition paths and approval state across handoffs or compaction.
