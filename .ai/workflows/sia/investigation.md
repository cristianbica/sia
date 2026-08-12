---
name: investigation
description: Investigate a bounded repository question through read-only evidence gathering and synthesis.
---

# Investigation workflow

Investigation keeps product, source, project configuration, existing plans, and external state read-only and normally
completes in one context. It may use bounded workers for independent questions, but native spawning is never required.
Only the coordinating session may use the explicit draft-plan exception defined below.

## Frame

- Define the question, useful evidence, scope, exclusions, time or effort bound, and stopping condition.
- Load project rules, the resolved operation and skills, and only relevant documentation routes.
- Record the repository baseline when changed files could affect interpretation.
- Request `reasoning` for ambiguous diagnosis or synthesis unless the user or project rules choose otherwise.

If the request actually asks for edits, do not silently change workflows. Finish the investigation or recommend an
appropriate delivery operation. A request to save an implementation plan is not authorization for implementation.

## Investigate

Inspect the smallest evidence set capable of answering the question. Test competing explanations where safe and
authorized. Keep repository files, existing plans, indexes, and external state unchanged. Commands may gather evidence
but must not mutate application state unless the user explicitly authorizes that separate action.

Independent areas may be assigned to bounded scouts that request `fast`. Each scout receives one question, exact
allowed paths, relevant context, exclusions, `do_not_load` paths, and an expected evidence shape. Partitions must not
overlap and must remain useful independently. The coordinating session owns synthesis and user-visible conclusions.

## Optional draft plan

Create a plan only when the user's investigation request explicitly asks to save one. After synthesis, the coordinating
session may create exactly one new compact delivery artifact under `.ai/plans/`; scouts remain fully read-only.

- Resolve one unambiguous effective delivery operation and its exact workflow and skills. If none or several fit, report
  the ambiguity and do not create a plan.
- Use `YYYY-MM-DD-NN-<slug>.md`, inspecting filenames only to allocate the UTC daily sequence; never read another plan.
- Use the delivery plan shape with outcome, scope, non-goals, acceptance, checks, risks, and external actions inside one
  approval marker pair. Record the current base and only pre-existing dirty paths when relevant.
- Set exactly one `<!-- sia:status pending-approval -->`; do not add `approved`, `mode`, `ceiling`, or progress
  comments.
- Add the exact new path to `authorized_plan_paths`. Never edit an existing plan, approve, resume, execute, or grant
  unattended authority to the draft.

The new artifact is the only repository write. Report its path and exact `Sia resume <path>` command. The investigation
itself remains non-resumable; only the generated delivery plan can later be resumed through the normal approval gate.

## Synthesize

Request `reasoning`. Distinguish direct observations, supported inference, alternative explanations, confidence, and
unknowns. Reconcile conflicting worker results against source evidence rather than selecting by majority.

Report the answer, evidence paths and commands, limitations, and the smallest useful next operation. An investigation
does not approve implementation. If interrupted, restart explicitly from the bounded question and existing report;
the investigation has no resumable artifact of its own.

Cancellation performs no writes except retaining an already-created explicit draft plan, and reports any commands or
external reads already performed.
