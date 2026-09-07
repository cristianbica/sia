---
operation: implement
workflow: delivery
skills: [repository-discovery, testing]
---

# Preserve the standard approval boundary

<!-- sia:approval:start -->
## Outcome and scope

For interactive standard delivery, an implementation request authorizes discovery and a saved plan. Build starts only
when the user approves the presented plan. A generic imperative, a reversible edit, or guidance to work autonomously
must not be treated as approval of an unseen plan. Continue already-approved work without repeated approval.

Clarify this boundary in the canonical protocol, implement operation, and delivery workflow. Before the first write,
state the selected route and its authorization basis; distinguish permitted plan writes from product/source writes.
Preserve trivial and lightweight direct authorization, Forge's explicit routes, and unattended authorization rules.
When higher-priority host instructions conflict, report the limitation rather than silently claiming Sia's gate held.

Update related protocol/orchestration and host-test documentation, routing contracts, and approval test fixtures.
Add a focused Codex behavioral runner using the existing host-test conventions where practical. Use disposable writable
repositories, bounded calls, and recorded outputs. Keep the existing read-only smoke suite intact. Extend the normal
verifier with no-model runner tests. Refresh managed `.ai` files through the installer after validation.

Bounded areas: src/managed/.ai/sia.md, src/managed/.ai/operations/sia/implement.md,
src/managed/.ai/workflows/sia/delivery.md, docs/protocol.md, docs/orchestration.md, docs/host-matrix.md,
tests/behavior/routing/, tests/hosts/, scripts/verify, and a focused approval runner under scripts/.

## Acceptance and checks

- A standard implementation request leaves product/source unchanged, creates a pending-approval plan without an
  approval marker, and asks for approval. The test must allow writes so a read-only sandbox cannot create a false pass.
- Approval of that exact presented plan allows implementation and the fixture's behavior check passes. Record the
  route and authorization evidence before writes. Reject an unsupported continuation or unavailable model as an
  unavailable test, never as a pass. Inspect recorded tool activity for attempted premature edits as well as file state.
- Control cases cover a trivial correction, a qualifying lightweight change, Forge direct execution and its approval
  path, and explicit unattended standard delivery. Preserve their intended artifact and authorization behavior.
- No-model shims exercise the runner's success, premature-write detection, missing/invalid plan, failure, and timeout
  paths. These checks validate the harness, not model compliance.
- Run focused contracts and runner tests, then sh scripts/verify. Review separately, run ./install.sh, and verify
  generated files match source. Preserve existing prompt-size limits.

## Non-goals, risks, and external actions

No new approval system, native Codex mode switching, model migration, broad workflow redesign, or host configuration
changes. Sia remains a prompt protocol and cannot override higher-priority host instructions or guarantee enforcement.

No live model calls are authorized by this plan. Implement and validate the runner with shims; report model behavior
as unverified until a separate live-call budget is agreed. No publishing, commits, pushes, or external writes.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base 232926338e23651db99bf1fc336849c97ba9c06d -->
<!-- sia:approved 91aa6d7394304b2b65302e46b82d99e9aef9ff08ee792e4876f90ddb1554457e -->
<!-- sia:progress approval: User explicitly approved the saved plan in this conversation. -->
<!-- sia:progress build: Clarified standard approval; added writable Codex runner, six route cases, and no-model tests. -->
<!-- sia:progress validation: sh scripts/verify passed, including approval runner shim tests; no live models invoked. -->
<!-- sia:progress review: Found find command actions could bypass pre-approval trace classification; fixing with tests. -->
<!-- sia:progress fix: Removed find from read allowlist; seven runner tests pass; documented approval wording limits. -->
<!-- sia:progress review: Separate reviewer confirmed the find fix and seven tests; no remaining material findings. -->
<!-- sia:progress install: ./install.sh passed; all three refreshed managed files match canonical source. -->
<!-- sia:progress validation: Final sh scripts/verify passed; log /tmp/sia-approval-final-verify.log; diff check passed. -->
<!-- sia:progress usage: Standard route; Build worker and independent reviewer inherited context; model/usage unknown. -->
<!-- sia:progress ship: Approved scope complete; no live model calls; actual Astra compliance remains unverified. -->
