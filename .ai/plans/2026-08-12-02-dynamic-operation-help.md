---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# List every effective operation in Sia help

<!-- sia:approval:start -->
## Scope

- Make bare `Sia`, `Sia help`, and `Sia show help` read `.ai/operations/INDEX.md` and list every effective operation
  from its SIA and CUSTOM sections.
- Apply normal catalog semantics: a CUSTOM entry replaces the same-named SIA entry, unique shipped and custom entries
  remain visible, and effective aliases/descriptions are shown so each possible request is actionable.
- Retain the general help directives from the completed first implementation while replacing the generic operation
  placeholder with the resolved operation list.
- Update canonical protocol documentation and focused activation/host coverage, including a custom-operation host
  fixture; refresh `.ai/sia.md` through `./install.sh`.

## Non-goals

- Read every operation definition body during help or activate an operation.
- List skills or workflows as operations.
- Commit, publish, or run paid live-host model checks.

## Acceptance

- Help lists each effective shipped or custom operation exactly once, including a CUSTOM-only operation.
- A CUSTOM override is labeled as project-provided, uses its replacement aliases/description, and suppresses the
  same-named shipped entry.
- Malformed, duplicated, or ambiguous catalog entries produce an error rather than a partial or inferred list.
- Help remains read-only and does not start or replace an operation; its three invocation forms remain equivalent.
- Focused catalog/help tests and `sh scripts/verify` pass; canonical and installed protocols match.

## Risks

- Catalog parsing and override semantics are public behavior; a partial merge could advertise unavailable commands or
  hide project operations.
- Existing uncommitted paths belong to the completed first help implementation; this correction intentionally overlaps
  those paths and must preserve that work.

## External actions

- None.
<!-- sia:approval:end -->

<!-- sia:approved 83dee61ffc52f8cc3bd646ada78fc37732f15264341ca63e5dc24161370b4e6f -->
<!-- sia:status complete -->
<!-- sia:base 310cf70351071e2d2917efb6ddf6c2b364db0d2b -->
<!-- sia:dirty prior help delivery: .ai/sia.md, docs/protocol.md, scripts/verify-hosts, src/managed/.ai/sia.md, tests/** -->
<!-- sia:progress build: help merges the operation index; fixtures add CUSTOM-only and override entries -->
<!-- sia:progress review-validate: no findings; CUSTOM-only and override fixtures plus sh scripts/verify passed -->
<!-- sia:progress ship: delivered locally without commit, paid live-host checks, or external actions -->
