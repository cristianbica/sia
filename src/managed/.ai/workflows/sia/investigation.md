---
name: investigation
description: Investigate a bounded repository question through read-only evidence gathering and synthesis.
---

# Investigation workflow

Investigation is read-only, planless, and normally completes in one context. It may use bounded workers for independent
questions, but native spawning is never required.

## Frame

- Define the question, useful evidence, scope, exclusions, time or effort bound, and stopping condition.
- Load project rules, the resolved operation and skills, and only relevant documentation routes.
- Record the repository baseline when changed files could affect interpretation.
- Request `reasoning` for ambiguous diagnosis or synthesis unless the user or project rules choose otherwise.

If the request actually asks for edits, do not silently change workflows. Finish the investigation or recommend an
appropriate delivery operation.

## Investigate

Inspect the smallest evidence set capable of answering the question. Test competing explanations where safe and
authorized. Keep repository files, plans, indexes, and external state unchanged. Commands may gather evidence but must
not mutate application state unless the user explicitly authorizes that separate action.

Independent areas may be assigned to bounded scouts that request `fast`. Each scout receives one question, exact
allowed paths, relevant context, exclusions, `do_not_load` paths, and an expected evidence shape. Partitions must not
overlap and must remain useful independently. The coordinating session owns synthesis and user-visible conclusions.

## Synthesize

Request `reasoning`. Distinguish direct observations, supported inference, alternative explanations, confidence, and
unknowns. Reconcile conflicting worker results against source evidence rather than selecting by majority.

Report the answer, evidence paths and commands, limitations, and the smallest useful next operation. An investigation
does not approve implementation. If interrupted, restart explicitly from the bounded question and existing report;
this workflow has no resumable artifact.

Cancellation performs no writes and reports any commands or external reads already performed.
