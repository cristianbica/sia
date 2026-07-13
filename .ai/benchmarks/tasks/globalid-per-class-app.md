# Per-class GlobalID application

Allow a model class to configure its default GlobalID application.

That setting must apply to normal and signed Global IDs. An explicit per-call `app:` option must override the class
default. Preserve subclass behavior and classes that override `to_global_id`; validate application names using the
existing URI rules. Add focused tests for normal IDs, signed IDs, overrides, and the existing aliases.

## Acceptance criteria

- A class-level application can be configured without changing the global default.
- Normal and signed IDs use the class-level application when no per-call application is provided.
- A per-call application wins over the class-level application.
- Existing aliases and overridden methods retain their documented behavior.
