---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Reliable approval, simpler delivery, and comparable model evaluations

<!-- sia:approval:start -->
## Outcome
Make Sia's approval rules consistent, remove avoidable workflow overhead, and provide reproducible evaluations for Codex and Claude without claiming unmeasured model improvements.

## Scope
1. Fix pending-plan resume to enter Approve without authorizing Build. Define one exact approval digest convention: UTF-8, CRLF/CR normalized to LF, all content between the unique markers preserved, markers excluded. Align canonical protocol, workflows, documentation, and verifier fixtures; retain valid legacy artifact support.
2. Fix the approval trace classifier to accept exact argument-free read commands (pwd, ls, git status, git diff) while retaining conservative treatment of unknown commands and write attempts. Add focused regressions.
3. Extend existing evaluation tooling with a small Claude adapter for equivalent approval and language/code cases. Verify local CLI interfaces; preserve sessions where continuation is required. Record requested model/effort, host version, source revision/instruction hash, and actual model/usage only when reported. Unsupported capabilities return unavailable rather than fabricated results.
4. Isolate baseline and candidate instruction environments in the clarity benchmark. Add one small repository implementation fixture and executable continuation cases for continuing approved work after an update and stopping checks after passing evidence. Preserve traces and review criteria for correctness, readability, unnecessary abstractions, unrelated edits, and repeated checks. Add trace-based unauthorized-read checks where the host exposes sufficient evidence; otherwise mark the result unavailable. Support repeated paired comparisons without treating shorter output as inherently better.
5. Simplify bounded worker handoffs while retaining exact definitions, scope, authorization, exclusions, and recovery. Prefer same-context continuation when a useful isolated worker is unavailable; reserve a user-started fresh conversation for a genuine context limitation. Preserve separate standard review and report actual isolation honestly. Update dependent contracts and documentation.
6. Clarify that detailed worker/check evidence belongs in the active plan or handoff, while user replies contain the result, meaningful checks, and material limits. Consolidate overlapping review guidance where it adds no distinct requirement. Keep current direct-code, targeted-edit, proportionate-testing, approval, and permission rules. Document model/host distinctions without adding a new runtime or untested model-specific prompt bundles.

Implementation is confined to relevant canonical src/managed/.ai definitions, scripts, tests, benchmarks/concise-output, and affected docs. Refresh the installed managed projection using ./install.sh after canonical edits. Preserve project-owned configuration and unrelated work.

## Non-goals
No provider SDK/runtime, broad refactor, changes to model availability, weakened approval or security boundaries, live model calls, commits, pushes, or publishing. Do not read or modify other plan artifacts. Do not claim that offline checks demonstrate improved live model behavior.

## Acceptance
- A valid pending draft resumes to approval; unapproved Build and invalid approved artifacts remain rejected.
- Digest fixtures cover LF/CRLF, whitespace preservation, marker boundaries, and changed approved content.
- Bare read commands are classified correctly; suspicious writes and opaque activity retain conservative outcomes.
- Codex and Claude evaluation paths have offline command/session/trace coverage, reproducible metadata, and explicit unsupported outcomes.
- Baseline and candidate environments do not silently share the candidate's Sia instructions; implementation and continuation cases assess actual edits and tool evidence.
- Smaller handoffs retain mandatory authority boundaries, and unavailable isolation does not itself force a user restart.
- Documentation matches the final behavior; managed source and installed projection agree.

## Checks
Run focused protocol/routing and host-harness regressions, benchmark fixture validation, then sh scripts/verify. Verify applicable CLI help without model calls before relying on flags. Run ./install.sh and inspect scoped source/projection diffs, excluding unauthorized plans. Perform a separate final code review and fix in-scope findings. Record unavailable checks honestly and do not repeat passing checks without new evidence.

## Risks
Trace formats and session controls vary across hosts; unsupported evidence must remain explicit. Shorter handoffs could omit authority, so acceptance tests must retain those boundaries. Prompt behavior is nondeterministic; later budgeted live comparisons are necessary to establish improvement. Keep changes incremental within existing tooling.

## External actions
None. Live provider evaluations require a separately defined model/access/cost budget. Local installer refresh is included.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base c2b5974ba1b0ba4878ba1e28c00239f8deb74918 -->
<!-- sia:approved f6464a1c44201e2994aabc6aa3e6397d4ffb772e5a72b592b68b56b38460f452 -->
<!-- sia:progress review: independent reviewer found test-command evidence and missing-host classification defects; bounded fixes in progress. -->
<!-- sia:progress checks: sh scripts/verify passed before review fixes; evidence /tmp/sia-model-guidance-verify.log. ./install.sh passed after permitted lock escalation; four changed managed files match installed projection. -->
<!-- sia:progress fix: added regressions and corrected exact test invocation, intervening mutation, missing CLI, and exact-session evidence handling; 12 approval harness tests pass. -->
<!-- sia:progress ship: approved scope complete; independent review found no remaining material issues after fixes. sh scripts/verify passed (/tmp/sia-model-guidance-final-verify.log): 12 approval tests, 8 benchmark tests, static and installer suites. -->
<!-- sia:progress evidence: final documentation source contracts passed (/tmp/sia-model-guidance-final-docs.log); scoped git diff --check passed; installed managed files match source. Live evaluations not run; model/profile usage unknown. No commit or external action. -->
