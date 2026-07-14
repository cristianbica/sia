# Implementation and acceptance

## Current implementation status

| Stage | Repository implementation | Remaining evidence |
| --- | --- | --- |
| 1 | Complete payload, activation bridges, catalogs, GitHub download, and safe install | Live host semantics |
| 2 | Complete daily operations, read-only review/investigation, docs refresh, and supporting skills | Live dogfood |
| 3 | Complete creators, definition workflow, reconciliation, and override contracts | More project usage |
| 4 | Complete bounded handoffs, optional parallelism, fallbacks, and advisory routing | Live host semantics |
| 5 | Small installer, download safety, probes, and context budgets | Public-URL smoke and live certification |

`scripts/verify` covers deterministic local acceptance. `scripts/verify-hosts --probe` records CLI availability without
calling a model. Live host and comparative value evaluation intentionally remain separate because they transfer fixture
content to external model services; see [host-matrix.md](host-matrix.md).

## Implemented delivery sequence

The following stages record how the first implementation was intentionally sequenced. They are retained as capability
and scope boundaries, not as an unfinished roadmap; the status table above names the evidence still outstanding.

### Stage 1 — Smallest vertical slice

Implement only enough to test the core product promise:

- publish a proper root README with Sia's identity, current GitHub installation, quick-start examples, supported hosts,
  opt-in behavior, installed layout, customization, safety, project status, and links to the detailed specification;
- establish the source/payload boundaries in [source-layout.md](source-layout.md) and verify shipped catalog entries;
- safe first install plus root `AGENTS.md` and Claude bridges;
- canonical `.ai/sia.md`, project-owned `.ai/RULES.md`, `Sia load docs`, `Sia load skills`, delivery-plan resume, and
  `Sia stop`/`Sia reload`;
- three SIA/CUSTOM catalog indexes and deterministic resolution;
- the not-initialized docs router and one `document` operation;
- one `delivery` workflow, persisted plan contract, and manual fresh-conversation resumption;
- adaptive delivery routing: planless trivial corrections, compact lightweight definition/documentation work and fully
  evidenced internal source fixes, and the unchanged standard lifecycle for every other source or uncertain work;
- `implement` plus a minimal `repository-discovery` and `testing` skill;
- advisory `fast`/`reasoning` fields with truthful host fallback reporting;
- deterministic activation contracts for all target entrypoints and live runners where safely available.

Do not implement native spawning, parallelism, all creator operations, or the complete v1 catalog in this stage.

### Stage 2 — Useful daily workflows

- Add `fix`, `investigate`, and `review` operations.
- Add investigation and review workflows plus `bug-triage` and `code-review` skills.
- Add documentation refresh and freshness auditing.
- Move documentation impact before final review and keep product and external state read-only during Ship.
- Dogfood representative changes with and without docs loaded.

### Stage 3 — Project extensibility

- Add `create-skill`, stabilize its schema through use, then generalize to `create-operation` and `create-workflow`.
- Add the definition workflow and `reconcile-catalogs`.
- Verify custom-over-Sia behavior, malformed override failure, and upgrade preservation.
- Add further core skills only in response to repeated observed needs.

### Stage 4 — Host-capability isolation and parallelism

- Add prompt-level guidance for worker spawning already exposed by a host; install no native agent, plugin, or worker
  package.
- Verify bounded handoff contents rather than assuming a spawned worker is fresh.
- Add bounded parallel investigation and independent validation where supported.
- Preserve manual artifact resumption and same-conversation fallback on every host.

### Stage 5 — first-release hardening

- Keep installation limited to complete Sia-path replacement and marked-block replacement.
- Maintain a dated host matrix whose observed versions are evidence rather than execution gates.
- Run cross-platform path, marker, symlink, and GitHub-download fixtures.
- Audit prompt size, duplicated policy, stale documentation behavior, and catalog consistency.

## Behavioral fixtures

### Activation

- An ordinary prompt causes no Sia-directed `.ai/**` reads.
- Casual mentions, wrong casing, and `Sia:` do not activate Sia.
- Every valid invocation reads `.ai/sia.md` before any index or definition.
- Missing, empty, unreadable, or structurally invalid `.ai/sia.md` fails closed without improvised Sia behavior.
- `RULES.md` loads for operations, resume, and workers, but not for docs-only or skills-only activation.
- Loading docs or skills does not activate orchestration.
- Missing docs produce the documenting-operation suggestion.
- `Sia stop` stops future Sia-directed loading without claiming context erasure; `Sia reload` rereads the current
  protocol without restarting the host and preserves persisted plans.
- Only exact `Sia unattended <operation> [request]` syntax selects unattended execution; unsupported forms fail clearly.

### Catalogs

- CUSTOM survives upgrade unchanged.
- A valid same-name project definition shadows Sia and is announced.
- Malformed custom overrides fail rather than falling back.
- Unindexed definitions remain undiscoverable until creation or reconciliation updates CUSTOM.
- Missing workflow or skill references fail with exact repair guidance.
- Reserved operation names, including `unattended`, and directives with extra or missing arguments fail clearly.
- Operation aliases parse only from the documented metadata line and alias collisions fail before invocation.
- Free-form Sia requests infer an operation only on high-confidence action intent; otherwise they remain read-only
  conversations.

### Artifacts and workflows

- Source code is unchanged during Plan.
- Build begins only after plain-language approval of the displayed delivery plan; Sia itself binds it to the stored
  revision and digest.
- Unattended delivery persists and digests the plan, records standing authorization, and never claims user review.
- `execution_mode` is approval-controlled, propagates through handoffs, and is inherited by `Sia resume`.
- Unattended authorization ceiling and external-action fields remain immutable across revisions and resume.
- In-scope unattended replans auto-approve; outcome expansion, unsafe choices, or permission blockers return `blocked`.
- Editing an approved plan resets approval.
- Appending valid phase evidence outside the approval-controlled block does not invalidate approval.
- Phase-boundary sequences are scoped to `plan_revision`; prior revisions remain historical evidence.
- Malformed approval/evidence markers, metadata mismatch, or noncanonical digest verification prevent resume.
- `Sia resume <approved-plan>` verifies approved content and enters the recorded delivery phase rather than replanning.
- Phase handoffs name exact current definition paths; workers do not independently reroute through catalogs.
- Lightweight delivery uses one bounded Build handoff and focused coordinator validation. An internal source change
  qualifies only with an evidenced seam, exact paths, criteria, and focused test; all excluded risks promote it.
- A refreshed Sia definition set does not by itself invalidate an approved plan.
- Review uses the base/dirty-worktree baseline and does not attribute pre-existing changes to Sia.
- Documentation changes are included before final review.
- Standard fixes return to a separate review phase, isolated when available; lightweight material findings promote to
  standard before remediation.
- Unattended Fix and Review/Validate cycles continue without questions until completion or a genuine blocker.
- Blocked resumes require a changed observable condition; retries and unattended Fix cycles are bounded.
- Ship writes only plan completion state by default and may offer explicit interactive deletion of the exact completed
  plan; unattended runs retain it. It performs no product or external delivery action by default.
- Unattended mode never weakens host permissions, project safety, dirty-work safeguards, or external-action boundaries.

### Model routing

- Plan, synthesis, and Review/Validate request `reasoning`; bounded scouts and mechanical Build/Fix may request `fast`.
- Explicit user or project-rule choices override workflow defaults without naming vendor models in Sia files.
- A host that cannot select the requested profile continues with its default and leaves all gates unchanged.
- Handoffs record the requested profile and source; results record the actual model when reported and `unknown`
  otherwise.
- Model availability or a different actual model never blocks work or invalidates artifact resumption.
- `fast` is a latency hint rather than a price guarantee; cost optimization comes from safe route and context reduction.

### Installer

- The README's GitHub install command downloads current source and runs successfully against a clean repository.
- Every README command matches the installer's tested interface; unavailable features are labeled truthfully.
- Download failure or malformed downloaded source refuses before changing the target repository.
- Local source installation and standard-input GitHub installation use the same small implementation.
- README invocation examples conform to the activation grammar and remain covered by behavioral fixtures.
- Re-running install replaces only reserved Sia paths and marked Sia blocks.
- Project rules, docs, plans, custom definitions, CUSTOM text, and surrounding instructions survive install and
  refresh.
- Malformed markers and symlinked top-level Sia directories fail clearly.
- The installer does not implement manifests, content digests, transactional recovery, or historical-layout migration.
- Shipped definitions and SIA catalog fragments stay synchronized with the source layout.

## Value evaluation

Record the prompt, execution mode, selected execution route, repository state, host, requested profile, actual model
when reported, permissions, cache state, timeout, scope, allowed paths, worker count, wait behavior, and token usage
when the host reports it. Control them where practical, but do not require exact model matching when routing is
advisory.
Evaluate these hypotheses separately:

1. `Sia load docs` versus normal host behavior.
2. A full Sia operation versus direct host behavior.
3. Isolated review versus same-context review.
4. Interactive delivery versus the same task invoked with the exact unattended modifier.

Judge outcome correctness, scope, approval behavior, validation, recovery, changed paths, and unsupported claims before
efficiency. Then track:

- files and broad directories inspected before a correct plan;
- repeated reads and rediscovery of commands or conventions;
- plan correctness, missed invariants, and unnecessary scope;
- context consumed before implementation readiness;
- stale or misleading docs detected and corrected;
- user corrections and workflow-gate failures.
- route promotions, unnecessary workers, polling turns, elapsed time, cached versus uncached input, and generated
  reasoning/output tokens.
- repeated active-context loading, bulk successful command output, and broad-diff replay; retain artifacts by path and
  compare concise results instead.

Sia succeeds only if documentation reduces rediscovery while maintaining or improving correctness. Token or file-read
reductions alone are not success when plans become worse.

## v1 acceptance

- A new user can install and invoke Sia using only the root README, without consulting the design specification.
- Exact invocations behave semantically the same on the tested host surfaces.
- Startup awareness does not deliberately load `.ai/**` or activate Sia.
- Repository documentation is evidence-linked, selectively loaded, and safely refreshed.
- Custom definitions override shipped definitions deterministically and survive upgrades.
- The shipped delivery workflow requires plain-language approval bound internally to the displayed plan or unattended
  standing authorization, artifact resumption, a separate review phase, product-read-only Ship, and optional confirmed
  cleanup of completed plans.
- Unattended execution asks no Sia questions and stops blocked rather than expanding scope or weakening permissions.
- Each run reports whether review used isolated, new-conversation, or same-conversation context.
- Hosts without native worker isolation can complete every required workflow using persisted artifacts.
- Unsupported model selection falls back truthfully without changing workflow semantics or permissions.
- Installer ownership is narrow, explicit, and non-destructive to project content outside reserved Sia paths and blocks.

## Deferred until evidence supports them

- Native slash commands, plugins, or host-specific agent packages.
- A large bundled skill or operation catalog.
- Automatic semantic search, source indexing, or scheduled docs refresh.
- A workflow DSL or enforcement runtime.
- Broad migration support for unknown historical layouts.
