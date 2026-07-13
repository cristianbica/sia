# Shared IRB history test setup

Refactor the IRB history tests so common setup is defined once and shared by the platform-specific history test
cases.

Preserve all existing history behavior and assertions, including the Windows-specific coverage. The change should
reduce duplicated setup without changing production code or weakening tests.

## Acceptance criteria

- Shared history fixtures and setup live in one reusable test case/helper.
- Unix and Windows history tests continue to exercise their platform-specific behavior.
- Existing history tests pass without reducing their assertions or coverage.
