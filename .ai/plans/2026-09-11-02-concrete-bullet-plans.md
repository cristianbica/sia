---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Clear writing with substance

<!-- sia:approval:start -->
Make all Sia writing understandable without making the reader unpack it: answers, updates, plans, and final reports.

## Changes

- Use short, concrete sentences and phrases. Say what happens, what causes it, and why it matters when those links need explaining.
- Remove long prose, filler, repetition, and vague abstractions. Explain necessary technical terms; avoid packing several ideas into one sentence or bullet.
- Use bullets for separate points, without turning every answer into a list. Keep enough explanation to convey the meaning; compressed jargon and cryptic fragments also fail.
- Plans must explain the proposed behavior, key decisions, and checks for success. Keep details that affect understanding or approval; remove implementation inventories and repeated safeguards.
- Update the general response rules and delivery plan guidance under `src/managed/.ai/`, matching docs, and validation cases. Replace the placeholder plan template with a worked example.

## Checks

- Use the supplied TWRP plan as a before/after example. Make account and workspace provisioning, failure recovery, workspace isolation, and validation easy to identify. Preserve requirements that affect scope or safety.
- Review answer, progress-update, and final-report examples too. Each must state something specific without requiring the reader to translate jargon. Shorter text or more bullets alone does not pass.
- Run `sh scripts/verify static`, refresh with `./install.sh`, and inspect the diffs. Static checks verify the rules, not live writing quality.
- Preserve approval and resume behavior. No live model runs, external actions, commits, or pushes.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base e77bff1bceda916d78c372c18dce750bdc972c0c -->
<!-- sia:progress Reviewed against the user's example and corrections. Added explicit meaning-first requirements and before/after checks across response types. Draft adjusted as requested; pending implementation approval. No source edits or tests run. -->
<!-- sia:approved db844a35a301c33c7c2ae854cc714cf747f3d66e6aced3063ee720babf1a4552 -->
<!-- sia:progress build: Updated canonical response and planning rules, docs, worked examples, and three offline benchmark cases. Installer refresh passed with required .git access; installed files match source. -->
<!-- sia:progress review-validate: Same-context review covered every source/generated diff, all authored examples, and preservation of the supplied TWRP requirements. No material findings; approval/resume rules unchanged. Live model quality remains unverified. -->
<!-- sia:progress checks: TMPDIR="$PWD/tmp" PYTHONDONTWRITEBYTECODE=1 sh scripts/verify static passed source, activation, workflow, routing, model, definition, documentation, and host checks, then failed the existing benchmark assertion that temporary work must be outside runner.ROOT. -->
<!-- sia:progress checks: Reran all 8 benchmark runner tests unchanged in a temporary source fixture under project tmp, with sibling temporary workspaces; all passed. Copied only runner.py-equivalent run.py, test_runner.py, cases.jsonl, baseline.txt, context.txt, canonical protocol, and execution guidance; fixture removed afterward. No provider calls. -->
<!-- sia:progress checks: PYTHONDONTWRITEBYTECODE=1 TMPDIR="$PWD/tmp" python3 .ai/skills/benchmark/scripts/test_accounting.py passed 6 tests; PYTHONDONTWRITEBYTECODE=1 benchmarks/concise-output/run.sh check validated 15 cases; TMPDIR="$PWD/tmp" sh tests/static/source-contracts.sh passed 10 checks; git diff --check passed. -->
<!-- sia:progress checks: TMPDIR="$PWD/tmp" ./install.sh initially could not create its sandbox-protected .git lock; approved escalation succeeded. Byte comparisons confirmed both changed installed definitions match canonical source. -->
<!-- sia:progress ship: Completed approved writing-rule changes, examples, validation cases, docs, and installed refresh. All check groups passed with the documented benchmark-fixture adaptation. No commits, pushes, or live model runs. -->
