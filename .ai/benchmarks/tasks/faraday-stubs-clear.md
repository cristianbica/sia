# Clear Faraday test stubs

Add a `clear` operation to Faraday's test adapter stubs.

Calling `Stubs#clear` must remove all registered stubs so the same stubs object can be reused for an independent
request scenario. Document the operation and add focused tests for clearing, reuse, and the existing behavior.

## Acceptance criteria

- `clear` removes every registered stub.
- A stub collection can be populated again after clearing.
- Clearing does not alter the public request/response behavior of newly registered stubs.
