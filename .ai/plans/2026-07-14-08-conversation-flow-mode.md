---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Add conversation-scoped Forge mode for rapid Sia iteration

<!-- sia:approval:start -->
## Scope

- Add exact `Sia forge on` and `Sia forge off` directives, with `Sia stop` also ending Forge mode.
- Make Forge conversation-scoped and non-resumable: it creates no plan artifact and does not survive a new conversation.
- In Forge, answer bounded questions directly; for eligible trivial or lightweight edits, use the existing inline lightweight receipt and focused validation.
- When work would require standard delivery, explain why and ask whether to switch to standard delivery or stay in Forge by breaking it into independently eligible lightweight increments; never silently switch or bypass route safety gates.
- Update the canonical protocol, routing/workflow guidance, generated projection, documentation, and focused contract coverage.

## Non-goals

- Do not use `fast` as a directive or change model-profile semantics.
- Do not alter standard plan approval, resume, unattended, or external-action rules.
- Do not make Forge survive a new chat or create a persisted mode-state artifact.

## Acceptance

- `Sia forge on`/`off` have exact, documented behavior and invalid forms fail rather than falling back to inference.
- Forge directly handles questions and only trivial/lightweight changes; a standard-eligible request presents the user with the choice to switch routes or narrow the next Forge increment.
- `Sia stop` reliably clears Forge state.
- Canonical source and generated managed files agree, with relevant static checks passing.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base 1a900c052f220e051912a91776b67bea32416b5d -->
<!-- sia:approved 4987641325767a2c9cc17b1023dad0c9de5c5ff24828277278b1d60d8a9acdf8 -->
<!-- sia:progress build: added exact Forge directives, routing guidance, generated projection, and contract coverage -->
<!-- sia:progress review-validate: protocol budget, focused contracts, and full static verification passed -->
<!-- sia:progress ship: delivered without external actions -->
