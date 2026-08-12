---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Add effective skills to Sia help

<!-- sia:approval:start -->
## Scope

- Make bare `Sia`, `Sia help`, and `Sia show help` read `.ai/skills/INDEX.md` in addition to the operation index.
- Merge SIA and CUSTOM skill entries under normal override semantics and add one compact comma-separated `Skills:`
  section containing every effective skill name exactly once.
- Label CUSTOM-only skills and overrides without expanding the compact list into full skill descriptions.
- Update canonical protocol documentation and focused activation/host coverage with CUSTOM-only and override skill
  fixtures; refresh `.ai/sia.md` through `./install.sh`.

## Non-goals

- Read skill bodies, list workflows, or change operation-list detail.
- Activate a skill or operation from help.
- Commit, publish, or run paid live-host model checks.

## Acceptance

- Help lists every effective shipped or custom skill exactly once on a compact comma-separated line.
- A CUSTOM skill override suppresses its same-named SIA entry and is labeled CUSTOM; a CUSTOM-only skill is also shown.
- Malformed, duplicated, or ambiguous skill catalog entries produce an error rather than a partial list.
- Help remains read-only and its three invocation forms remain equivalent.
- Focused catalog/help tests and `sh scripts/verify` pass; canonical and installed protocols match.

## Risks

- Reading a second catalog increases help context and can create inconsistent merge behavior if skill overrides are not
  treated exactly like operation overrides.
- Existing uncommitted paths belong to the two completed help deliveries and must remain preserved.

## External actions

- None.
<!-- sia:approval:end -->

<!-- sia:approved 8b3cbe6d1b174dae4681b7c0ee5054744a545375476b00ed4ddb19488ce549c0 -->
<!-- sia:status complete -->
<!-- sia:base 310cf70351071e2d2917efb6ddf6c2b364db0d2b -->
<!-- sia:dirty prior help deliveries: .ai/sia.md, docs/**, scripts/verify-hosts, src/managed/.ai/sia.md, tests/** -->
<!-- sia:progress build: help merges skills into one compact line; fixtures cover CUSTOM-only and override skills -->
<!-- sia:progress review-validate: no findings; focused fixtures and full sh scripts/verify passed -->
<!-- sia:progress ship: delivered locally without commit, paid live-host checks, or external actions -->
