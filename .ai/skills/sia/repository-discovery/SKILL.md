---
name: repository-discovery
description: Find the smallest reliable evidence set needed to understand a repository task.
use_when:
  - planning a repository change
  - documenting an unfamiliar repository area
  - verifying repository-specific commands or conventions
---

# Repository discovery

Use focused, evidence-led discovery to answer the current task without mapping the whole repository.

## Required context

- The user's requested outcome and explicit constraints.
- The current workflow phase and its allowed reads and writes.
- `.ai/docs/INDEX.md` when initialized, followed only along relevant routes.
- Existing host or project instructions already in scope.

## Procedure

1. Establish the repository root and inspect the narrowest likely entrypoints.
2. Consult relevant repository documentation, but verify behavior-changing claims against current source.
3. Trace outward only as needed through callers, dependencies, data flow, configuration, and representative tests.
4. Look for analogous implementations before proposing a new pattern.
5. Identify verified commands, conventions, invariants, pre-existing changes, and unresolved assumptions.
6. Stop when the evidence is sufficient to plan or document the requested scope.

Prefer filenames, symbols, targeted search, and small directory listings over broad tree dumps or reading every file.
Separate direct observations from inference. Cite repository paths for important claims and state confidence when
evidence is incomplete.

## Constraints

- Do not edit product or source code while using this skill for a read-only phase.
- Do not treat generated files, stale docs, or similarly named code as authoritative without verification.
- Do not claim a command works unless it was run successfully and its result inspected.
- Do not expand into adjacent areas merely to make the map feel complete.

## Output

Return the relevant entrypoints, flows, invariants, commands, tests, risks, unknowns, and paths that support them. The
result should be compact enough to use as plan or documentation input without replaying discovery.
