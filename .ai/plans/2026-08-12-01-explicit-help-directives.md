---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Add explicit Sia help directives

<!-- sia:approval:start -->
## Scope

- Make `Sia help` and `Sia show help` exact public help forms alongside bare `Sia`.
- Have all three forms return the same concise menu of supported docs, skills, Forge, operation, unattended, resume,
  stop, and reload requests without starting or replacing an operation.
- Update the canonical managed protocol, public protocol documentation, focused activation/static tests, and host
  semantic fixtures; refresh the installed managed projection with `./install.sh`.

## Non-goals

- Add a new operation, interactive command parser, or dynamically generated catalog listing.
- Change the behavior or arity of existing non-help directives.
- Commit, publish, or run paid live-host model checks.

## Acceptance

- Bare `Sia`, `Sia help`, and `Sia show help` are documented as equivalent exact help requests.
- The help text gives users concrete possible Sia requests and covers docs, skills, Forge, interactive and unattended
  operations, resume, stop, and reload.
- Invalid extra arguments to either explicit help form report a syntax/arity error instead of falling through to a
  conversation or operation.
- Focused static/host tests and the repository verifier pass; the generated `.ai/sia.md` matches canonical source.

## Risks

- This changes Sia's public invocation contract and host-facing semantic cases; incomplete fixture updates could leave
  hosts or documentation inconsistent.

## External actions

- None.
<!-- sia:approval:end -->

<!-- sia:approved 1e7beccb4d867424b1b1ff6267e95d56ee9f429c04a2214c9bd4ff554b4e2331 -->
<!-- sia:status complete -->
<!-- sia:base 310cf70351071e2d2917efb6ddf6c2b364db0d2b -->
<!-- sia:progress build: added equivalent bare/help/show-help routing, concrete menu, docs, and eight-case host fixtures; refreshed installed projection -->
<!-- sia:progress review-validate: no findings; diff check, projection comparison, focused suites, and full sh scripts/verify passed -->
<!-- sia:progress ship: delivered locally without commit, publish, paid live-host checks, or other external actions -->
