---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Prevent duplicate webhook delivery

<!-- sia:approval:start -->
## Scope

- Implement the evidence-supported webhook deduplication boundary.
- Add focused regression coverage.

## Non-goals

- Deliver externally or change unrelated webhook behavior.

## Acceptance

- Duplicate deliveries are handled once and the focused checks pass.

## Risks

- Existing dirty webhook files require attribution before Build.

## External actions

- None.
<!-- sia:approval:end -->

<!-- sia:status pending-approval -->
<!-- sia:base abc123 -->
<!-- sia:dirty app/webhooks.rb -->
