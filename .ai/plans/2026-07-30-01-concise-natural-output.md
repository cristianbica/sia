---
operation: implement
workflow: delivery
skills: [testing]
---

# Concise natural-English output

<!-- sia:approval:start -->

## Outcome

Make Sia responses shorter and easier to scan while keeping normal English and every important technical detail.

There will be one default behavior. No modes, intensity controls, setup turns, output skills, artificial shorthand, or
caveman grammar. Ordinary prompts that do not activate Sia remain unchanged.

## Output contract

Add a short presentation rule directly to `src/managed/.ai/sia.md`:

1. Lead with the answer, result, finding, blocker, or decision.
2. Use concise, complete, natural-English sentences.
3. Remove greetings, preambles, self-reference, routine tool narration, repetition, and generic closers.
4. Preserve exact commands, errors, paths, identifiers, numbers, uncertainty, safety limits, and approval boundaries.
5. Expand when the user requests detail or when safety and correctness require explanation.
6. Stop when the answer is complete.

The final protocol must remain within its existing 230-line limit. Prefer replacing duplicated wording over adding a
large new section.

## Evaluation

Keep the evaluation intentionally small:

- `benchmarks/concise-output/cases.jsonl`: eight representative prompts with required facts and forbidden omissions;
- `benchmarks/concise-output/run.sh`: one bounded runner;
- `benchmarks/concise-output/README.md`: commands, rubric, and results format.

The eight cases cover:

1. a direct answer;
2. an exact command;
3. an error with exact evidence;
4. an evidence-limited investigation;
5. an approval boundary;
6. a seeded review finding;
7. a destructive request;
8. a detailed explanation.

The runner first executes one smoke prompt. If that does not return a real response, it stops. It never schedules a
batch after an empty result.

After the smoke test works, compare only:

- the current baseline;
- one candidate contract.

Run each of the eight prompts once. Do not test three near-duplicate candidates or three repetitions until this small
comparison demonstrates a useful signal.

For each response, record:

- required-fact pass or failure;
- exact-string preservation;
- visible characters;
- reported input and output tokens, or `unknown`;
- latency;
- a human natural-English score from 1 to 5.

## Decision rule

Do not integrate the contract unless:

- all baseline-required facts, exact strings, safety limits, approval limits, and review findings are preserved;
- every response remains natural English;
- median visible length decreases by at least 25%;
- reported output tokens decrease, when the host exposes them;
- no setup turn or extra model turn is introduced.

If the candidate fails, change the wording once and rerun the eight cases. Do not add framework, modes, more candidate
families, or a larger corpus.

## Implementation order

1. Add the three benchmark files.
2. Prove one smoke call works.
3. Run the sixteen-turn baseline-versus-candidate comparison.
4. Review the responses manually.
5. Only if the decision rule passes, add the six-rule contract to `src/managed/.ai/sia.md`.
6. Refresh the installed projection with `./install.sh`.
7. Add small deterministic assertions to the existing static test file.
8. Update only the documentation sections that describe response behavior.
9. Run `sh scripts/verify`.

## Non-goals

- No claim that shorter output is always better.
- No input or repository-context compression.
- No hard word or token cap.
- No reduction in reasoning, investigation, testing, or safety work.
- No cross-host certification in this change.
- No benchmark framework or case-per-file layout.

## External action

Model-backed evaluation requires separate explicit authorization stating the host and maximum number of turns. An
approved implementation plan alone does not authorize model calls.

## Definition of done

The change is complete when the three-file evaluation is reproducible, the candidate passes the decision rule, the
small protocol edit is installed, and `sh scripts/verify` passes. If model execution is unavailable, stop with the
benchmark unrun and do not integrate the prompt change.

<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base 5a83d25dee089dd9cfc88a42f84a0ebbe0c3ada2 -->
<!-- sia:approved 88924d4c4942caac2e5cb984aa5bb420910ceccebd34cf65496430f1ed1e7f1f -->
<!-- sia:progress build: three-file benchmark complete; live smoke pending explicit authorization -->
<!-- sia:progress build: first candidate rejected for 32 percent median length increase; one wording revision ready -->
<!-- sia:progress build: final candidate passed gates; protocol, projection, docs, and focused contracts updated -->
<!-- sia:progress review: restore exact resume footer names and handoff grammar before validation -->
<!-- sia:progress fix: restored resume and handoff semantics; projection and static checks pass -->
<!-- sia:progress review: no material findings; full verification and benchmark gates pass -->
<!-- sia:progress ship: concise natural-English contract delivered and verified -->
