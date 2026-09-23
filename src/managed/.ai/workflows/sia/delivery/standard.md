# Saved plans and resume

Use this shared plan lifecycle for change requests across all workflows. Resolve the actual operation, workflow, and
skills; do not relabel documentation or definition work as implement. CUSTOM workflows keep their task-specific steps
and any additional gates while preserving the protocol's shared approval boundary.

## Save and approve

Create `.ai/plans/YYYY-MM-DD-NN-<slug>.md` using the UTC date and next zero-padded daily sequence. Inspect filenames
only to allocate it. Immediately add the exact new path to `authorized_plan_paths`.

Keep frontmatter to `operation`, `workflow`, and `skills`. Put the proposed change and its approval boundary in one
approval block. Footer state uses one-line comments; omit empty optional fields.

## Writing the plan

Help the reader understand the proposed work well enough to judge it. Start by explaining the approach and why it
fits the problem, using what you found in the repository. Then develop the parts that need explanation.

Choose the organization for this task. A bug fix may follow cause, correction, and regression check. A new feature
may need its behavior explained before the implementation. A migration may need ordered stages and recovery points.
These are possibilities, not templates. Follow the user's requested presentation when they specify one.

Use short, complete sentences and focused bullets. Group related points; add headings when they help the reader find
something. Separate the resulting behavior from the work needed to build it when mixing them would be confusing.
Do not split a simple explanation into several sections just to satisfy a format.

Select detail by asking what it explains:

- State the concrete changes and connect important choices to their reasons. "Add retry handling" is too vague if
  the central problem is that retries can repeat a successful write.
- Name relevant files and existing code to reuse alongside the change they support. Avoid an unexplained inventory.
- Use examples to resolve ambiguity. A small before/after result or configuration may explain more than a paragraph.
  Do not add code samples merely to decorate the plan.
- Keep requirements, dependencies, uncertainties, and risks that affect the approach or approval. Explain what they
  mean for this work. Routine execution notes can wait until implementation; unresolved design decisions cannot.
- State how success will be checked and which actions are authorized. Do not retell the whole proposal as a test list.

A bullet should carry a point the reader can follow, not a compressed paragraph or a chain of technical labels.
When a plan grows, look for repeated ideas and incidental detail before shortening sentences. Do not remove necessary
explanation just to make the document smaller. Do not invent work to make it look comprehensive.

Reread as someone who has not followed the investigation: can they tell what will change, why this approach fits,
what work it requires, and how they will know it worked? Revise whatever makes those answers difficult to find.
The chat presentation should preserve that understanding; link the saved plan for detail without hiding consequential
choices in it. Keep approval hashes and state comments out of the human explanation.

A supplied example demonstrates what helped its reader; do not assume its headings suit every task. Reusable examples
must be fictional. Another project's information shared in conversation is not permission to publish it here.

### Examples of choosing detail

These fictional fragments illustrate writing choices, not required plan layouts.

For a small display fix, the behavior and implementation fit together:

> The receipt formatter drops the currency already stored on the order. Append it to the formatted amount, so
> `12.50` becomes `12.50 EUR`. Keep the existing rounding. Check two currencies and an amount that needs rounding.

For a retry bug, the reason is essential:

> A retried job can add the same book to a list twice. Enforce uniqueness on the list/book pair in the database,
> and make the add action return the existing membership when that pair is already present.
>
> - Check both a repeated request and two simultaneous requests; each must leave one membership.
> - Removing a membership must still leave the catalog book intact.

## Approval and saved state

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
