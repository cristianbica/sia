---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Show lightweight delivery plans inline without creating plan artifacts

<!-- sia:approval:start -->
## Scope

- Require a lightweight delivery to show a concise inline receipt before Build rather than writing `.ai/plans/*`.
- Define the receipt’s required fields: outcome, exact paths or bounded area, acceptance checks, documentation impact, and external actions.
- Keep the activating request as lightweight authorization; the receipt is not a second approval gate and does not become resumable state.
- Update the canonical managed workflow, generated `.ai` projection, documentation, and focused contract coverage.

## Non-goals

- Do not change standard delivery’s persisted approval-plan and resume flow.
- Do not make trivial work produce a receipt.
- Do not make an inline receipt a separate approval request or create a new artifact type.

## Acceptance

- The lightweight path explicitly requires the inline receipt before Build and specifies its contents.
- The workflow clearly states that an inline receipt is not persisted or resumable and that material scope/risk promotes the work to standard delivery.
- Standard and trivial delivery semantics remain unchanged.
- Canonical source and generated managed files agree, and the relevant static checks pass.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base 007c29e3bd16ec336f8c18b3714eb38ac6906e78 -->
<!-- sia:approved c5c91913160274a7be177d914358b16fc4f31c896e2820e9a13439d5e063f58f -->
<!-- sia:progress build: added inline lightweight receipt requirements, documentation, projection, and coverage -->
<!-- sia:progress review-validate: focused routing/workflow checks and full static verification passed -->
<!-- sia:progress ship: delivered without external actions -->
