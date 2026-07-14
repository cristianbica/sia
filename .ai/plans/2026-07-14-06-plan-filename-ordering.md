---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Make delivery plan filenames chronological and deterministic

<!-- sia:approval:start -->
## Scope

- Define the required new-plan filename format as `YYYY-MM-DD-NN-<slug>.md`, where `NN` is the zero-padded sequence for plans created on that date.
- Require plan creation to choose the next available daily sequence, so lexicographic filename order is creation order within a date.
- Preserve legacy plan artifacts and keep `Sia resume` accepting an explicitly named existing plan.
- Update the canonical managed workflow/protocol, user-facing documentation, and focused static-contract coverage; run the installer to refresh the managed `.ai/` projection.

## Non-goals

- Do not rename existing plan artifacts.
- Do not add time-of-day, global counters, or new plan frontmatter fields.
- Do not alter approval-digest or resume semantics beyond documenting the filename convention.

## Acceptance

- New-plan instructions consistently prescribe `YYYY-MM-DD-NN-<slug>.md` and define `NN`.
- The artifact-creation workflow directs Sia to inspect only enough of `.ai/plans/` to allocate the next sequence without treating older artifacts as task context.
- Existing plan names remain valid for explicit resume, and verification covers the convention.
- Canonical source and regenerated managed files agree, with relevant static checks passing.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base f2a34f179f1d5610d76e3a9b5a0b600a66c861bc -->
<!-- sia:approved 837e9bb879b5dc27152f5a9c35327b16706d2cd4783bc7eb5910911aa50aa68b -->
<!-- sia:progress build: added the UTC date-and-sequence filename contract, canonical docs, projection, and regression checks -->
<!-- sia:progress review-validate: source/projection consistency and full static verification passed -->
<!-- sia:progress ship: delivered without external actions -->
