# Writing people can understand

These are authored examples for reviewing Sia's writing rules, not measured model results.
Each example must explain the actual situation without making the reader translate jargon.
Short text still fails if it hides the meaning. Longer text is justified when it adds necessary explanation.

## Answer

Before: “The approval-envelope invalidation vector requires boundary reconciliation prior to continuation.”

After: “The approved plan covers a parser fix. The database migration adds new scope and needs approval before work
can continue.”

Check: the reader can identify what changed and why approval is needed.

## Progress update

Before: “Provisioning reconciliation robustness is being enhanced across ambiguous transport outcomes.”

After: “A timeout can happen after TWRP creates the account. I’m checking how retries can find that account instead of
creating a second one.”

Check: the update names the failure, its consequence, and the work underway. It does not claim the fix is complete.

## Final report

Before: “Implemented resilient provisioning semantics with focused validation of the reconciliation surface.”

After: “Retries now look for the existing TWRP account before creating one. The timeout and duplicate-job tests passed
with stubbed responses. Live TWRP behavior has not been tested.”

Check: the report says what changed, what was checked, and what remains unverified. Use these claims only when
supported.

## Plans

The following tasks and repository facts are fictional. These are illustrations of writing judgment, not templates
or measured model results. Notice why each explanation takes its particular shape.

### A small display fix

> The receipt formatter drops the currency already stored on the order. Append it to the formatted amount, so
> `12.50` becomes `12.50 EUR`. Keep the existing rounding. Check two currencies and an amount that needs rounding.

The example makes the change concrete. Separate behavior and implementation sections would repeat the same idea.

### A feature with several parts

Assume a fictional application already has a book catalog, a book picker, and server-side ownership checks.

> Let readers organize catalog books into private lists. Store membership separately from books so removing a list
> entry never removes a book from the catalog.
>
> Readers can create and rename lists, then add or remove books. Each list belongs to its creator. Other readers
> cannot view or edit it, even through a direct request.
>
> The implementation has three parts:
>
> - Add list and membership storage. Make each list/book pair unique so repeated or simultaneous adds leave one entry.
> - Add the list actions using the existing ownership checks. Check reads as well as edits.
> - Build the list screen with the existing book picker, and document the new actions.
>
> Verify creation, renaming, removal, duplicate adds, and access by another reader. Check that removing an entry leaves
> the catalog book intact. Run the storage changes in a disposable local database; production migration is separate.

Here the user needs to understand the feature before assessing the work. The storage decision includes its reason.
A full schema or mockup would add little to this particular decision; a task with a disputed schema could need one.

### A change where order matters

Assume a fictional exporter currently loads every row into memory. Its file format must stay compatible.

> Write export rows in batches to reduce memory use. Reuse the current row formatter so existing consumers receive
> the same columns and escaping.
>
> 1. Capture the current output for representative data, including quotes, empty values, and non-ASCII text.
> 2. Replace the full-table load with batched reads in a stable order. Write each batch to a temporary file.
> 3. Publish the file only after all batches succeed. On failure, remove the temporary file and report the failure.
>
> Compare the resulting files with the captured output. Exercise a failure midway through an export and confirm no
> partial file is published. Measure peak memory on the same large fixture before and after the change.
>
> One question needs resolving before implementation: can records change during an export? If so, we must agree on
> whether the file represents a snapshot before choosing the batching query.

Order helps explain the compatibility check and failure handling. The unresolved question remains visible because
it can change the implementation. Adding generic rollback and risk sections would not resolve it.

### Review the meaning

- Can the reader explain the proposed approach without reconstructing the investigation?
- Do the details explain decisions, behavior, or necessary work?
- Are important assumptions and unresolved questions visible?
- Does each check establish an outcome that matters?
- Would removing a sentence lose meaning, or only remove repetition?

Do not score plans by heading names, bullet counts, or length. A plan can follow every formatting convention and
still leave the reader unable to understand the work.
