# Implementation and evaluation

## What is implemented

Sia installs readable source prompts, shared activation bridges, catalog entries, and initial project seeds. The
installer preserves project content and validates inputs before writing.

The shared protocol requires saved planning and approval for all change requests, including fixes, documentation,
definitions, natural-language requests, and Forge. Workflows keep their task-specific checks. Read-only requests and
session directives need no plan. Explicit user exceptions preserve their scope and existing pending approvals.
Operation names, aliases, CUSTOM resolution, exact activation, and saved-plan compatibility remain supported.

## Local checks

The contract suite checks selected planning, ownership, read-only, handoff, and skill-loading instructions in source.
It includes deliberately weakened source variants, so removing the approval boundary or required review skill fails.
These are textual guardrails: wording changes may require reviewed pattern updates, and matching text cannot prove
that a model will comply. Offline host shims separately validate trace handling and continuation.


`sh scripts/verify` runs package/schema/link checks, activation bridge checks, context-loading checks, installer tests,
offline host shims, approval/continuation harness tests, and benchmark fixture checks. Executable invariants such as
preserving files on install, rejecting malformed approval hashes, and continuing an exact session remain covered.
Tests that only required old route names, report wording, or advisory profile fields have been removed.

`scripts/report-context --baseline-ref 147b314` reports ordinary and optional loads, accumulated delivery context, and
all shipped Markdown with a consistent word-count method. It excludes host instructions and project code/docs. Text
reduction is a maintenance measurement, not proof of better coding.

## Check actual coding

The [coding comparison fixtures](../tests/coding/README.md) provide three small tasks: extend an existing formatter,
fix duplicate processing, and plan then implement a two-module change. They include runnable behavior checks and
manual criteria for scope and simplicity. No deleted user failure transcripts are required.

After a run limit and model access are explicitly agreed, run fresh sessions with the simplified Sia and with the
same host alone. Hold task, base, model, effort, permissions, and checks constant. Keep prompts, diffs, results, and
corrective user messages. Inspect the whole result, including unnecessary features, abstractions, and shallow plans.
A hidden oracle must not be copied into the candidate workspace. Do not rank solutions by similarity to one patch.

This does not replace the local custom benchmark framework. No live coding comparison is part of the normal
verifier or authorized merely by installing this change. Practical benefit remains unverified until real outputs
have been reviewed.
