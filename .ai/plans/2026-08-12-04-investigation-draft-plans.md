---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Allow investigations to write explicit draft plans

<!-- sia:approval:start -->
## Scope

- Keep the `investigate` operation and investigation workflow read-only for product, source, project definitions,
  indexes, documentation, existing plans, and external state.
- When the investigation request explicitly asks for a saved implementation plan, allow only the coordinating session
  to create one new compact delivery artifact under `.ai/plans/` after evidence synthesis.
- Require an unambiguous effective delivery operation, standard plan shape, `pending-approval` status, base/dirty
  evidence, normal filename allocation, and conversation authorization for the exact new path.
- Never approve, resume, execute, or grant unattended delivery authority to the generated plan; report its exact
  `Sia resume <path>` command. Scouts remain fully read-only and cannot create it.
- Update managed operation/workflow definitions and catalogs, public orchestration/ownership documentation, focused
  workflow contracts and a representative draft-plan fixture; refresh installed managed files with `./install.sh`.

## Non-goals

- Allow arbitrary writes during investigation or edits to existing `.ai/plans/**` files.
- Make every investigation create a plan, or treat recommendations as implicit plan requests.
- Approve implementation, switch into delivery automatically, or run implementation from the investigation workflow.
- Commit, publish, or run paid live-host model checks.

## Acceptance

- Ordinary investigations and all scouts remain fully read-only and planless.
- An explicit plan request may create exactly one new pending-approval delivery plan and no other repository change.
- The draft selects one valid effective delivery operation and contains its exact workflow/skills references, scope,
  non-goals, acceptance, risks, external actions, base, and pre-existing dirty-path evidence.
- Existing plan-content authorization and filename-only discovery rules remain intact.
- Focused workflow tests and `sh scripts/verify` pass; canonical and installed definitions/catalogs match.

## Risks

- A broad exception could let investigation bypass delivery approval or mutate existing authorization evidence.
- Choosing the wrong target operation could create an unusable or misleading resumable artifact; ambiguity must stop
  plan creation rather than default silently.
- Existing uncommitted paths belong to completed help deliveries and must remain preserved.

## External actions

- None.
<!-- sia:approval:end -->

<!-- sia:approved a9fd774600067d3200376316ecabacf4ffb009b744d8de40792bf20e06818a5f -->
<!-- sia:status complete -->
<!-- sia:base 310cf70351071e2d2917efb6ddf6c2b364db0d2b -->
<!-- sia:dirty prior help deliveries: .ai/sia.md, docs/**, scripts/verify-hosts, src/managed/.ai/sia.md, tests/** -->
<!-- sia:progress build: added one-new-pending-plan exception, docs, catalogs, and focused fixture; refreshed installation -->
<!-- sia:progress drift: HEAD advanced with prior help delivery; no overlap with this plan's changes -->
<!-- sia:progress review-validate: no findings; focused workflow contracts and full sh scripts/verify passed -->
<!-- sia:progress ship: delivered locally without commit, paid live-host checks, or external actions -->
