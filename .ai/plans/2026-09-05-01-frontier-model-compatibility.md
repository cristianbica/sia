---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Frontier model compatibility

<!-- sia:approval:start -->
## Outcome and scope
Implement the five recommendations explicitly authorized by “Sia implement the above”: compatible configurable Codex host-test effort and evidence; compaction-state preservation; meaningful progress and authorized continuation; bounded reads, edits, retrieval and verification; refreshed provider integration guidance.

Change canonical protocol and relevant skills/workflow, host runner and tests, and related documentation. Refresh the managed installation through install.sh.

## Acceptance and checks
Preserve activation, approval boundaries, plan isolation and portable model profiles. Cover default and overridden effort and recorded command arguments with no-model shims. Add protocol regression scenarios for compaction, authorized continuation, scope and verification stopping. Run focused checks, sh scripts/verify, installer refresh, and final diff review.

## Non-goals, risks and external actions
No provider client, new model default, approval-policy redesign, paid model invocation, commit, push or publication. Prompt behavior remains model-dependent; static contracts and scenario specifications do not certify live semantics. Main risks are prompt growth and accidental boundary weakening.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base 9927175144c92ecd03f0be4efff6964ae4475dd7 -->
<!-- sia:approved 10a7e9ef779289018564b9fb1d9731159f31803246910b4abf16454788145c04 -->
<!-- sia:progress build: Implemented the five authorized recommendations; focused routing contracts passed; validation and separate final review pending. -->
<!-- sia:progress review-validate: Same-context final diff review found no remaining material issues. sh scripts/verify passed 77 checks; subsequent documentation wrapping passed source contracts and routing checks. git diff --check passed. No live model calls; scenario specs are not semantic certification. -->
<!-- sia:progress review-validate: ./install.sh succeeded after sandbox escalation for its temporary .git lock. All four changed managed files match source. Resolved definition paths unchanged; installed content refreshed as authorized. Model/usage telemetry unknown. -->
<!-- sia:progress ship: Standard delivery complete; plan retained. No commit, publication, or paid model validation performed. -->
