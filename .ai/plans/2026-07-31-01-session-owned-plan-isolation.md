---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Isolate pre-existing plans from the current conversation

<!-- sia:approval:start -->
## Scope

- Define a session-owned plan allowlist: Sia may read plans created during the current conversation and exact
  pre-existing plan paths the user explicitly requests or approves.
- Treat every other `.ai/plans/**` file as content-inaccessible. Filename-only inspection remains allowed solely to
  allocate a new plan sequence.
- Carry authorized plan paths and historical-plan exclusions through worker handoffs and fail closed when provenance is
  unavailable after isolation or context compaction.
- Apply the contract consistently to activation, planning, discovery, resume, delivery, and documentation.
- Add static contract coverage and an adversarial live-host case that distinguishes a fresh operation from explicit
  resume of a named historical plan.

## Non-goals

- Do not delete, migrate, archive, or rewrite existing plan artifacts.
- Do not change plan approval digests, statuses, filenames, or lifecycle semantics.
- Do not claim control over hidden context injected by a host; document that limitation and require truthful reporting.
- Do not authorize broad historical-plan access from an inferred task relationship or a similarly named plan.

## Acceptance

- A plan created during the current conversation can be read and managed without another user approval.
- A plan that existed before the conversation is not read, searched, summarized, or used as evidence unless the user
  explicitly names or approves its exact path.
- `Sia resume <exact-plan>` authorizes only that named plan, while filename-only sequence allocation remains permitted.
- Bounded workers receive the authorized plan allowlist and exclude every other plan; missing provenance fails closed.
- Repository discovery and broad searches explicitly exclude unauthorized `.ai/plans/**` content.
- Deterministic verification covers the prompt contracts, installation projection, and documentation consistency; the
  live-host harness includes an opt-in adversarial isolation case without adding model calls to the normal verifier.

## Checks

- Run the focused activation, workflow, and host-harness contract tests.
- Run `./install.sh` and inspect the managed `.ai` projection separately.
- Run `sh scripts/verify` and inspect the final diff for unauthorized plan reads or unrelated changes.

## Risks

- Conversation provenance is host state rather than filesystem metadata, so compaction must preserve exact authorized
  paths or access must fail closed.
- A host may inject hidden repository context before Sia can exclude it; Sia can constrain its own reads and report the
  limitation but cannot guarantee host-level isolation.
- Overly broad exclusions could break explicit resume or multi-plan work within one conversation.

## External actions

- None. Live model validation remains opt-in and is not authorized by this plan.
<!-- sia:approval:end -->

<!-- sia:approved 8ae7abfb86f89a4c39ad4ea99dced2763de2872ed26dfb02f800cea219ceb833 -->
<!-- sia:status complete -->
<!-- sia:base cc95142b1ddae45d7962bd7f163a2b54951d279b -->
<!-- sia:progress build: added exact-path plan authorization, propagated worker exclusions, docs, and host regression cases -->
<!-- sia:progress review: fixed fixture validity; full verifier and projection/digest checks pass with no findings -->
<!-- sia:progress ship: completed locally; no external actions requested or performed -->
