# Right-biased alternative operator

Add `RightBiased#|` as an alias for the existing right-biased `.or` operation.

The operator must preserve the first successful value in chains for `Result` and `Maybe`, while failures or `None`
continue to the next alternative. Add focused tests for successful, failing, and chained cases.

## Acceptance criteria

- `Some(1) | None()` returns `Some(1)`.
- `None() | Some(1)` returns `Some(1)`.
- `Failure(:reason) | Success(1)` returns `Success(1)`.
- Chained alternatives remain left-biased toward the first success.
- Existing `.or` behavior is unchanged.
