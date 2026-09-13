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

Find and correct the reported defect. Use bug-triage to distinguish the cause from symptoms, then the delivery workflow
to implement and check the fix. Prefer a reproducing regression check when practical. If reproduction is unavailable,
state the evidence and uncertainty rather than presenting a hypothesis as confirmed. Do not mask the problem with
broad retries, fallbacks, or unrelated cleanup.
