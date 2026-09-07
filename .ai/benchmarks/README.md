# Benchmark corpus

This directory is project-owned benchmark configuration. It is not part of Sia's shipped runtime and must not be
copied into a candidate repository.

`MANIFEST.yml` is the coordinator manifest for the initial corpus. Each task has a public prompt under `tasks/`; the
manifest separately records the pinned base and hidden actual implementation, setup, checks, and evaluator contract.

## Ownership and clean-room boundary

- The project maintains the corpus, task prompts, pins, setup commands, and evaluator contracts.
- The benchmark coordinator may read coordinator-only fields such as `actual_revision` and `evaluator`.
- Candidate agents receive only the selected public prompt, approved setup/check commands, and their isolated checkout.
- Candidate agents never receive the source PR URL, actual revision, evaluator oracle, another candidate workspace, or
  a sibling solution.
- Dependency installation, network access, model execution, and cleanup remain separately approved benchmark actions.

The corpus deliberately uses one task per repository. It favors small, current Ruby/Rails or Ruby library projects,
one Go project, SQLite for the Rails application, and focused merged changes. `difficulty` and `category` let reports
stratify light features, bug fixes, refactors, medium Rails-ecosystem work, and the cross-layer Rails task without
pretending that one task represents a whole language or framework. A task is not considered validated until its pinned
base, setup, checks, and clean-room exclusions have been exercised by the benchmark coordinator.

`globalid-per-class-app` now has isolated setup, base/reference checks, and an independent private evaluator validated
in the environment recorded in `private/globalid-per-class-app/validation.json`. Its expected base evaluator failure
is distinct from setup failure. Other pinned tasks remain pending; no task has a certified live model comparison.

The additional `quality/manifest.json` defines small read-only fixtures and a follow-up sequence for repository
understanding, diagnosis, stale documentation, review quality, and knowledge reuse. These use private evidence rubrics
instead of implementation references; only their public workspace and selected prompt enter candidate context.
The one-task-per-repository policy applies to the pinned public corpus, not this explicit local follow-up sequence.

Use the existing benchmark skill's `report-template.md` and `accounting.md` for reviewed quality verdicts, complete
cold-start/task/review/retry costs, and repeated-task amortization. Static tests check the machinery, not model quality.
