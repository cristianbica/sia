# Delivery execution

Supporting guidance for the effective delivery workflow; not a separately invokable workflow.
Load only for authorized Build, Review/Validate, Fix, or Ship. The applicable route establishes authorization.
Only standard delivery writes the plan status/progress comments below; lightweight and Forge remain planless.

## Build

Implement only approved scope, including tests and affected documentation. Prefer targeted edits over whole-file
rewrites unless most of the file must change. Leave unrelated cleanup as a finding. Continue in-scope steps
without reapproval; ask only at actual workflow gates or when the authorized boundary expands.
Prefer existing patterns, clear names, and direct control flow. Add an abstraction, dependency, option, or fallback
only when the current task needs it; do not design for hypothetical future requirements. Readability matters more
than fewer lines. Comments explain non-obvious reasons. Preserve required error handling, validation, security, and
compatibility; avoid extra safeguards for scenarios ruled out by verified internal contracts.

Standard prefers an isolated worker when useful and available, otherwise same-context execution. Request a fresh
user-started conversation only for a genuine context limitation; unavailable isolation alone does not block approved
work. Lightweight uses one core Build handoff with write-baseline fields. Compare the worktree with
optional `base` and `dirty` comments. Preserve pre-existing work; unsafe overlap or attribution is blocked before
unattended writes. Do not stash, reset, clean, or overwrite it.

Request `fast` for mechanical work and `reasoning` for risky work. Resolve required skills through the effective
catalog, load `documentation` or `safe-refactoring` only when material, and put exact paths,
`authorized_plan_paths`, and every other `.ai/plans/**` path in `do_not_load` in the handoff.
After resolution, do not reread catalogs, broad docs, unauthorized plans, or prior evidence. Append a short
`<!-- sia:progress build: <summary> -->` comment and set status to `review-validate` when complete.

## Review/Validate

Compare the result with both the original request and the approved plan, including later explicit user changes.
Challenge unnecessary capabilities and mechanisms even when the plan introduced them; plan inclusion alone is not
evidence of necessity. If correcting the plan changes its approved boundary, use the existing replanning gate.
Inspect correctness, scope, regressions, security/operational risk, documentation, and command claims. Standard prefers
a reviewer who did not build; lightweight uses focused coordinator testing and a focused diff/scope check. A
material lightweight finding promotes to standard before Fix or Ship. Append one short progress comment; set status to
`fix`, `ship`, or `pending-approval` as appropriate.

Standard resolves effective `code-review` and `testing` skills; lightweight loads only `testing`. Respect CUSTOM
overrides and record exact definition paths in the handoff. Never claim an uninspected command passed.

## Fix

Fix only in-scope standard findings, then return to Review/Validate. A material change returns to Plan. Unattended work
may make at most three Fix cycles; then append one `<!-- sia:blocker <reason>; resume when <condition> -->` comment and
set status to `blocked` rather than weakening acceptance criteria.

## Ship

Ship requires passing review evidence. It writes only `<!-- sia:status complete -->` and a final short progress comment;
retain the plan for history without asking. Delete an exact completed plan only after a separate explicit user request.
Commit, push, pull request, release, publish, and deploy require explicit user intent.

Lead the user-facing report with the result, meaningful checks, and unresolved issues. Include paths and deviations
when they help assess the change. Keep required route, model/usage, and detailed command evidence in the active plan
or handoff when one exists; report them directly when requested or material to a decision. Do not create an artifact
solely to hold routine reporting details. This changes presentation, not approval gates or evidence requirements.
