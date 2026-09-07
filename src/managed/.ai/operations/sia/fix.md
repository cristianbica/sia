---
name: fix
description: Diagnose and fix a defect with root-cause evidence and proportionate regression coverage.
workflow: delivery
skills:
  - repository-discovery
  - bug-triage
  - testing
---

# Fix

Resolve the reported defect at its verified cause without broadening the change into unrelated cleanup.

## Intake

- Restate the observed behavior, expected behavior, impact, and available reproduction evidence.
- Distinguish confirmed facts from user hypotheses and incomplete symptoms.
- Identify the narrowest affected path, relevant history when available, and pre-existing work.
- Define acceptance criteria that include the original failure and important neighboring behavior.

Use the delivery workflow. Plan from evidence, follow its interactive or unattended authorization gate, and do not edit
product or source code during diagnosis. When reliable reproduction is impractical, state the limitation and use the
strongest available evidence rather than presenting a hypothesis as confirmed.

During Build or Fix, address the root cause, add or update regression coverage at the appropriate test layer, and avoid
masking symptoms with broad rescue, retry, fallback, or validation behavior unless the approved plan requires it.
Materially different causes or remediation return to Plan and Approve.

## Outcome

Follow delivery's Ship reporting guidance. Explain the verified cause, fix, meaningful checks, and unresolved issues;
include deviations when material and keep detailed evidence in the active plan or handoff when one exists.
Ship may close the active plan; product, source, and external state remain read-only unless the user explicitly
requests another delivery action.
