# Direct test loader options

Fix the direct test loader so option-like entries in `ARGV` are not treated as Ruby files to require.

Arguments beginning with `-` must be skipped by the direct loader, matching the behavior of the regular test loader.
Add focused regression coverage while preserving normal file loading and argument handling.

## Acceptance criteria

- A direct test run with an option such as `-v` does not attempt to require `-v`.
- Ordinary test file arguments are still loaded.
- Existing direct-loader behavior and tests remain intact.
