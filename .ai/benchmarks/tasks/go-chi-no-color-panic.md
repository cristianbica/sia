# No-color recovered panic output

When the request logger is configured with `NoColor`, recovered panic output must contain no ANSI escape sequences.

Preserve the existing colored behavior of the exported stack-printing API. Route logger panic output through a
color-aware internal path and add a focused regression test.

## Acceptance criteria

- A panic recovered through a `DefaultLogFormatter` with `NoColor` produces no ANSI color codes.
- The default colored path remains unchanged.
- The public stack-printing API retains its existing behavior.
- The regression test proves the no-color guarantee.
