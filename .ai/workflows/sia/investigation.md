---
name: investigation
description: Investigate a bounded repository question through read-only evidence gathering and synthesis.
---

# Investigation

Establish the question, relevant evidence, and a stopping condition. Load relevant docs and repository-discovery
context, then follow evidence across code, tests, configuration, or history. Keep repository and external state
read-only. Report what is known, the supported explanation, competing evidence, and remaining uncertainty.
Stop when the question is answered or the missing evidence is clear. Workers are optional; delegate only independent
questions and verify their findings. Investigation normally finishes in this conversation and has no resume state.

## Explicitly requested plan

If the user asks to save a delivery plan, the coordinator may create exactly one new plan after analysis. Resolve the
effective delivery operation/workflow/skills and load saved-plan support for its shape and naming. Record scope,
checks, risks, base revision, and relevant pre-existing dirty paths. Register that exact new path as authorized.
Set only pending-approval status: do not approve it, execute it, or add mode/ceiling/progress comments. Existing plans,
source, docs, and definitions remain unchanged. Report the path and `Sia resume <path>`; resuming does not approve it.
If interrupted, restart from the bounded question and known evidence. Cancellation retains any explicitly created draft.
