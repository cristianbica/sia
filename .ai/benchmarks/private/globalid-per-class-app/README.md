# Coordinator-only GlobalID evaluator and validation

Do not copy this directory, its logs, the actual revision, or its command path into candidate context. Run the evaluator
only after the candidate has stopped, from its repository root, using an absolute path owned by the coordinator:

```sh
bundle exec ruby -Ilib /absolute/coordinator-private/globalid-per-class-app/evaluator.rb
```

The independently authored evaluator loads the repository library, not its test helper or reference tests. It checks
class defaults for normal/signed IDs and parameter aliases, explicit immutable options, subclass inheritance/isolation,
overridden method dispatch, URI-name validation, and the unchanged global default. It is a behavior check, not a source
patch comparison. Candidates also run the declared `bundle exec rake test` suite. Inspect failures before classifying
setup errors versus missing task behavior; successful reference evaluation does not certify a candidate solution.

`validation.json` records the pinned public archives, hashes, exact setup environments, commands, outcomes, and limits.
Downloaded archives, extracted sources, and dependencies remain in `/tmp/sia-benchmark/globalid-validation-20260907`.
Only declared dependencies were installed. The lockfile required Bundler 4.0.12; it and all 46 gems were installed under
the run's temporary `BUNDLE_PATH`. `BUNDLE_USER_HOME` and separate `BUNDLE_APP_CONFIG` paths were also temporary.
The actual revision reused that dependency cache with `bundle install --local`. `Gemfile.lock` preserves the resolved
platform/dependency set for repeatability. No source changes were made in either extracted tree.

The base existing suite passed (166 tests), and the actual existing suite passed (169 tests). The private evaluator
failed on the base because the requested class setter was absent and aliases bypassed overrides; it passed all six
cases on the actual revision. Those base failures are expected behavior evidence, not setup failures. Logs include
Ruby 4.0 dependency warnings; both existing suites still completed without failures, errors, or skips.

Total network/setup duration was not instrumented and remains unknown. Test timings exclude preparation and cannot
stand in for total task cost. This validates one environment only. No live model comparison or other corpus task has
been certified by this validation.
