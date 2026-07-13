---
name: investigate
description: Answer a bounded repository question from evidence without changing the repository.
workflow: investigation
skills:
  - repository-discovery
---

# Investigate

Establish what is happening, why it may be happening, or where a concern belongs without implementing a change.

## Intake

- Turn the request into a concrete question, scope, exclusions, and stopping condition.
- Clarify materially different interpretations before searching broadly.
- Identify what evidence would confirm, weaken, or disprove the leading explanations.

Use the investigation workflow. Keep repository and external state read-only. Follow relevant evidence across code,
tests, configuration, logs, history, or documentation only as available and authorized. Do not turn a recommendation
into an implicit implementation plan or approval.

## Outcome

Return concise observations, supported inferences, competing explanations, confidence, unknowns, and the most useful
next operation. Say when the evidence is insufficient rather than forcing a conclusion.
