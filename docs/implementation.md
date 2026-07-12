# Implementation and acceptance

## Stage 1 — Smallest vertical slice

Implement only enough to test the core product promise:

- publish a proper root README with Sia's identity, pinned installation, quick-start examples, supported hosts,
  opt-in behavior, installed layout, customization, safety, project status, and links to the detailed specification;
- establish the source/payload boundaries in [source-layout.md](source-layout.md) and verify shipped catalog entries;
- safe first install plus root `AGENTS.md` and Claude bridges;
- canonical `.ai/sia.md`, project-owned `.ai/RULES.md`, `Sia load docs`, `Sia load skills`, delivery-plan resume, and
  `Sia stop`;
- three SIA/CUSTOM catalog indexes and deterministic resolution;
- the not-initialized docs router and one `document` operation;
- one `delivery` workflow, persisted plan contract, and manual fresh-conversation resumption;
- `implement` plus a minimal `repository-discovery` and `testing` skill;
- advisory `fast`/`reasoning` fields with truthful host fallback reporting;
- semantic activation tests on the four target hosts.

Do not implement native spawning, parallelism, all creator operations, or the complete v1 catalog in this stage.

## Stage 2 — Useful daily workflows

- Add `fix`, `investigate`, and `review` operations.
- Add investigation and review workflows plus `bug-triage` and `code-review` skills.
- Add documentation refresh and freshness auditing.
- Move documentation impact before final review and verify Ship remains read-only.
- Dogfood representative changes with and without docs loaded.

## Stage 3 — Project extensibility

- Add `create-skill`, stabilize its schema through use, then generalize to `create-operation` and `create-workflow`.
- Add the definition workflow and `reconcile-catalogs`.
- Verify custom-over-Sia behavior, malformed override failure, and upgrade preservation.
- Add further core skills only in response to repeated observed needs.

## Stage 4 — Host-capability isolation and parallelism

- Add prompt-level guidance for worker spawning already exposed by a host; install no native agent, plugin, or worker
  package.
- Verify bounded handoff contents rather than assuming a spawned worker is fresh.
- Add bounded parallel investigation and independent validation where supported.
- Preserve manual artifact resumption and same-conversation fallback on every host.

## Stage 5 — v1 hardening

- Complete install/update/check/uninstall behavior and recovery cases.
- Maintain a tested host/version matrix.
- Run cross-platform path, line-ending, permission, symlink, collision, and interruption fixtures.
- Audit prompt size, duplicated policy, stale documentation behavior, and catalog consistency.

## Behavioral fixtures

### Activation

- An ordinary prompt causes no Sia-directed `.ai/**` reads.
- Casual mentions, wrong casing, and `Sia:` do not activate Sia.
- Every valid invocation reads `.ai/sia.md` before any index or definition.
- Missing, empty, unreadable, structurally invalid, or version-incompatible `.ai/sia.md` fails closed without
  improvised Sia behavior.
- `RULES.md` loads for operations, resume, and workers, but not for docs-only or skills-only activation.
- Loading docs or skills does not activate orchestration.
- Missing docs produce the documenting-operation suggestion.
- `Sia stop` stops future Sia-directed loading without claiming context erasure.

### Catalogs

- CUSTOM survives upgrade unchanged.
- A valid same-name project definition shadows Sia and is announced.
- Malformed custom overrides fail rather than falling back.
- Unindexed definitions remain undiscoverable until creation or reconciliation updates CUSTOM.
- Missing workflow or skill references fail with exact repair guidance.
- Reserved operation names and directives with extra or missing arguments fail clearly.
- Operation aliases parse only from the documented metadata line and alias collisions fail before invocation.

### Artifacts and workflows

- Source code is unchanged during Plan.
- Build begins only after approval of the exact shipped delivery plan revision and digest.
- Editing an approved plan resets approval.
- `Sia resume <approved-plan>` verifies approved content and enters the recorded delivery phase rather than replanning.
- Phase handoffs name exact current definition paths; workers do not independently reroute through catalogs.
- A Sia version change is reported but does not by itself invalidate an approved plan.
- Review uses the base/dirty-worktree baseline and does not attribute pre-existing changes to Sia.
- Documentation changes are included before final review.
- Fixes return to independent review; material changes return to Plan and Approve.
- Ship performs no writes or external delivery actions by default.

### Model routing

- Plan, synthesis, and Review/Validate request `reasoning`; bounded scouts and mechanical Build/Fix may request `fast`.
- Explicit user or project-rule choices override workflow defaults without naming vendor models in Sia files.
- A host that cannot select the requested profile continues with its default and leaves all gates unchanged.
- Handoffs record the requested profile and source; results record the actual model when reported and `unknown`
  otherwise.
- Model availability or a different actual model never blocks work or invalidates artifact resumption.

### Installer

- The README's pinned install command runs successfully against a clean repository using the published release URL.
- Every README command matches the installer's tested interface; unavailable features are labeled truthfully.
- Release verification rejects README placeholders, moving install URLs, version drift, or untested installer commands.
- README invocation examples conform to the activation grammar and remain covered by behavioral fixtures.
- Existing repository instructions and project `.ai` content survive install, update, and uninstall.
- Check performs no writes and reports stable exit results.
- Modified owned content, malformed markers, symlinks, case collisions, or corrupt manifests fail safely.
- Concurrent changes to root or Claude instruction files stop replacement and preserve the newer content.
- The manifest excludes its own digest, validates structurally, and is written only after all other changes succeed.
- Interrupted install/update reruns accept only the documented old-or-exact-target states and preserve project content.
- Shipped definitions and SIA catalog fragments stay synchronized with the source layout.

## Value evaluation

Record the prompt, repository state, host, requested profile, actual model when reported, permissions, cache state,
timeout, scope, and allowed paths. Control them where practical, but do not require exact model matching when routing is
advisory. Evaluate these hypotheses separately:

1. `Sia load docs` versus normal host behavior.
2. A full Sia operation versus direct host behavior.
3. Isolated review versus same-context review.

Judge outcome correctness, scope, approval behavior, validation, recovery, changed paths, and unsupported claims before
efficiency. Then track:

- files and broad directories inspected before a correct plan;
- repeated reads and rediscovery of commands or conventions;
- plan correctness, missed invariants, and unnecessary scope;
- context consumed before implementation readiness;
- stale or misleading docs detected and corrected;
- user corrections and workflow-gate failures.

Sia succeeds only if documentation reduces rediscovery while maintaining or improving correctness. Token or file-read
reductions alone are not success when plans become worse.

## v1 acceptance

- A new user can install and invoke Sia using only the root README, without consulting the design specification.
- Exact invocations behave semantically the same on the tested host surfaces.
- Startup awareness does not deliberately load `.ai/**` or activate Sia.
- Repository documentation is evidence-linked, selectively loaded, and safely refreshed.
- Custom definitions override shipped definitions deterministically and survive upgrades.
- The shipped delivery workflow requires approval, artifact resumption, a separate review phase, and read-only Ship.
- Each run reports whether review used isolated, new-conversation, or same-conversation context.
- Hosts without native worker isolation can complete every required workflow using persisted artifacts.
- Unsupported model selection falls back truthfully without changing workflow semantics or permissions.
- Installer ownership is narrow, digest-backed, recoverable, and non-destructive to project content.

## Deferred until evidence supports them

- Native slash commands, plugins, or host-specific agent packages.
- A large bundled skill or operation catalog.
- Automatic semantic search, source indexing, or scheduled docs refresh.
- A workflow DSL or enforcement runtime.
- Broad migration support for unknown historical Sia/Orchestra layouts.
