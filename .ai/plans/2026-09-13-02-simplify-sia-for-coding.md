---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Make Sia easier to use for coding

<!-- sia:approval:start -->
Sia should help developers get the code they asked for with fewer corrections. Simplify its prompts and normal coding
workflow instead of adding another layer of instructions. Keep repository knowledge, useful project guidance, and
optional planning and review.

## What the review found

- Normal delivery asks the agent to classify a route, announce authorization, and often manage a saved plan, approval
  hash, phase state, and handoff. Those are concrete requirements in `src/managed/.ai/sia.md` and
  `src/managed/.ai/workflows/sia/delivery.md`; their benefit to everyday coding has not been demonstrated here.
- The operation, workflow, and skills often repeat the same discovery, scope, review, and reporting instructions.
  Creator operations repeat validation already described by the definition workflow. This makes changes harder to
  maintain and gives the model more instructions to reconcile.
- Standard planning spends more detail on approval and presentation than on explaining how the change will work.
  Forge previously deferred caller and existing-pattern discovery until after approval. My uncommitted patch tries
  to correct this by adding instructions in several places; it is not evidence of better results.
- Tests protect many literal sentences. The previous verifier passed while README's Forge description contradicted
  the edited workflow. The concise-output benchmark does not run the full delivery workflow or its plan template.
- The user reports shallow plans, complicated code, strange decisions, and unwanted features. The failed outputs were
  deleted. These observations justify changing the product, but do not prove which instruction caused each failure
  or that the model itself regressed.

Review coverage: all 10 shipped operations, all 5 workflows and their 3 delivery support files, all 6 shipped skills,
the protocol, default rules, bridges and catalogs. Also inspected product/architecture/usage docs, relevant tests,
recent history, and the local benchmark operation, workflow, skill, and runner documentation. Benchmark internals and
every test implementation were not exhaustively reviewed. No historical plan contents were read.

## Change the normal coding workflow

- Give `implement` and `fix` one ordinary path: inspect relevant code, make the requested change, run suitable checks,
  inspect the result, and report it. Remove trivial/lightweight/standard classification, route announcements,
  mandatory receipts, routine phase comments, and mandatory Build handoffs from that path.
- A clear implementation request authorizes its local in-scope work. Ask only when a missing decision would
  materially change the result or an action needs permission. Do not turn ordinary uncertainty into an automatic
  saved-plan requirement. Host permissions, explicit user limits, and protection of unrelated work still apply.
- An explicit request to plan remains read-only apart from a requested plan file. Explain the current code, the
  proposed change, important choices, and how to check it. Detail follows the actual problem; do not require a fixed
  list of sections or a comparison of alternatives for obvious changes. Approval of that plan permits its work.
- Review and investigation remain available as read-only requests. Review the original request as well as any plan,
  including subsequent user changes. A feature does not become necessary merely because the agent put it in a plan.
- Keep Forge's conversation continuity and inline plans, but use the same coding behavior as normal delivery.
  Keep `do:` and `plan:` meanings; remove the separate eligibility rules. A follow-up such as “next one” uses clear
  conversation context instead of restarting intake. Keep explicit unattended mode and its existing authority limits.

## Cut and reorganize the prompts

| Area | Planned change |
| --- | --- |
| `src/managed/.ai/sia.md` | Keep activation, routing, priority, and essential boundaries. Move saved-plan and worker format details out of ordinary loading. Remove routine model/usage reporting requirements. |
| `workflows/sia/delivery.md` and `delivery/execution.md` | Replace the route system with the ordinary coding path above. Merge useful execution guidance into delivery and remove the redundant support file. |
| `delivery/standard.md` | Keep only optional saved planning/resume behavior. Load it when a saved plan is requested or resumed. |
| `delivery/forge.md` | Keep session controls and inline planning; remove duplicated implementation, review, and authorization policy. |
| Other workflows and operations | Keep task-specific differences. State shared behavior once instead of repeating intake, permission, validation, and report lists. Retain public names, aliases, and CUSTOM overrides. |
| Six shipped skills | Keep useful procedures and repository-specific evidence requirements. Remove generic coaching and lifecycle/reporting rules already owned elsewhere. Keep the documentation routes and freshness checks. |
| Default `RULES.md` | Remove the blanket extra permission requirement for ordinary temporary/cache writes. Rely on host permissions; preserve project-authored rules below the marker. |

Paths abbreviated in the table are beneath `src/managed/.ai/`. Worker handoff details may use one optional support
file loaded only for delegation; do not introduce another registry, runtime, or configuration layer. Keep delegation
optional and use host capabilities without routine Sia model-profile bookkeeping.

Replace the earlier uncommitted additions as part of this rewrite. Do not stack the rewrite on top of them or use a
blanket reset. Update README and affected `docs/` descriptions together, then refresh installed managed files through
`./install.sh`. Adapt context-reporting and verification scripts to the simplified structure.

## Preserve existing work and saved plans

Keep exact opt-in activation, docs/skills loading, stop/reload, custom-definition resolution, and installer ownership.
Keep current saved-plan formats, hashes, pending-approval behavior, and refusal of contradictory or completed plans
in the optional resume path. Do not invent a new plan format or migrate historical artifacts for this change.
Never read another plan without its exact authorization. Existing custom workflows retain their chosen behavior.
Document that default implementation now proceeds directly; do not silently apply that change to a pending saved plan.

This plan itself follows the current workflow: it requires approval before implementation. Its approved scope must
remain valid while Sia's definitions are changed. Report material definition changes; never claim newly simplified
rules retroactively authorized earlier edits.

## Check the result

- Update tests that enforce removed routes or wording. Keep executable checks for activation, catalog resolution,
  installer preservation, exact-plan access, pending-plan approval, and continuation after approval. Do not replace
  deleted sentence assertions with a larger collection of new sentence assertions.
- Run focused checks, `sh scripts/verify`, and `git diff --check`. Confirm installed managed files match source.
  Review README and workflow examples against the actual new behavior; passing tests alone is insufficient.
- Report before/after ordinary-load and total shipped prompt sizes using the same counting method, including later
  phase loads. Both should decrease. Do not hide unchanged text in extra files and call that simplification, or treat
  fewer words as proof of better code.
- Prepare three small tasks in disposable fixtures: add a field using an existing formatter; fix duplicate processing;
  and plan then implement a change spanning two existing modules. Reuse existing local fixtures where suitable.
  Include a case where a new abstraction looks tempting but is unnecessary. No deleted user transcripts are needed.
- In fresh sessions, compare the simplified Sia with the host alone using the same task, model, effort, permissions,
  and checks. Count extra user prompts and manual corrections; inspect missing behavior, unwanted features, needless
  abstractions, and whether the plan explains the actual change. Keep prompts and diffs so failures can be inspected.
  A small comparison can expose failures; it cannot certify every future task. Do not tune only to those examples.
- Live model calls require a separately agreed run limit and access. Prepare the cases during implementation, but
  label practical improvement unverified until those runs are completed and reviewed. Do not call static checks a
  successful coding comparison. No benchmark framework rewrite is included.

## Completion and limits

The implementation is ready when the simpler behavior is consistent across prompts/docs, compatibility checks pass,
and the three comparison tasks are ready. Claim it helps coding only after inspecting actual comparison results.
The intended result is correct requested behavior with fewer corrections and no extra features, not merely a shorter
answer or a compliant plan file.

Scope includes the shipped prompts under `src/`, affected docs and verification/fixture code, and their installed
managed projection. Preserve the local custom benchmark definitions, project docs, unrelated changes, and historical
plans. No model migration, new product feature, plugin, runtime, commit, push, deployment, paid run, or external
repository modification is authorized by this plan. Simplifying default approvals is a deliberate user-facing change;
existing explicit approvals, project constraints, and host safety controls must remain effective.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base 238ac412da8e309f1f8975c7f469ca54226ae3bf -->
<!-- sia:dirty .ai/skills/sia/code-review/SKILL.md, .ai/workflows/sia/delivery.md, .ai/workflows/sia/delivery/execution.md, .ai/workflows/sia/delivery/forge.md, .ai/workflows/sia/delivery/standard.md, docs/orchestration.md, src/managed/.ai/skills/sia/code-review/SKILL.md, src/managed/.ai/workflows/sia/delivery.md, src/managed/.ai/workflows/sia/delivery/execution.md, src/managed/.ai/workflows/sia/delivery/forge.md, src/managed/.ai/workflows/sia/delivery/standard.md, tests/behavior/routing/static-contracts.sh, tests/behavior/workflows/static-contracts.sh -->

<!-- sia:approved 3312b37492483f36cb09cac4197476c2c13170ec3817677a67215e378348874a -->
<!-- sia:progress build: User approved this plan. HEAD 147b314 commits the previously recorded dirty edits; scope unchanged. Implementing under the original approval. -->
<!-- sia:progress build: Implemented approved simplification. Effective definitions remain implement/delivery with repository-discovery/testing; execution.md merged into delivery.md, optional handoff.md added. Original approval retained. -->
<!-- sia:progress review-validate: Same-context diff, docs, and source review. Full sh scripts/verify passed; final source/context checks passed after review corrections. Three offline coding fixtures fail before and pass after minimal solutions. Live model comparison not run. -->
<!-- sia:progress ship: Implementation and fixture preparation complete. Source Markdown 13272 to 6138 words; full coding context 7071 to 2481. Installed projection verified; git diff --check passed. No commit or live model run performed; practical improvement remains unverified. -->
