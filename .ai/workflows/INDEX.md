# Workflows

<!-- sia:workflows:start -->
## SIA

- `definition` — Create and reconcile project definitions and CUSTOM catalog entries safely.
- `delivery` — Deliver approved changes through planning, review, validation, fixes, and product-read-only shipping.
- `documentation` — Create or update scoped repository knowledge from verified evidence.
- `investigation` — Investigate with read-only evidence and an explicit one-new-delivery-plan exception.
- `review` — Independently review a defined change and its evidence without modifying repository content.
<!-- sia:workflows:end -->

## CUSTOM

Project workflows registered here override same-named Sia workflows. Place each definition at
`.ai/workflows/<name>.md` and use this entry form:

- `benchmark` — Compare current Sia with a hidden actual implementation and one optional comparator.

```markdown
- `name` — Description.
```
