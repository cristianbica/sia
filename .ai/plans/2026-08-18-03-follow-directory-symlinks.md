---
operation: fix
workflow: delivery
skills: [repository-discovery, bug-triage, testing]
---

# Follow valid installer directory symlinks

<!-- sia:approval:start -->
## Outcome

The installer follows symlinked `.ai`, `.ai/docs`, `.ai/skills`, `.ai/operations`, `.ai/workflows`, and `.claude`
directories instead of failing with `refusing symlinked path`.

## Scope

- Replace the blanket directory-symlink rejection in `install.sh` with validation that accepts links resolving to
  directories and rejects dangling links or links resolving to non-directories before installation writes.
- Update `tests/installer/install/stage1.sh` with coverage for every supported symlinked directory shape and invalid
  dangling/non-directory targets.
- Update `docs/integration.md` and `docs/implementation.md` so the installer contract documents followed directory
  links rather than rejected ones.

## Non-goals

- Do not change source-payload symlink validation.
- Do not allow symlinked managed files, seed files, `AGENTS.md`, or `.claude/CLAUDE.md`; their atomic replacement and
  ownership semantics differ from a symlinked parent directory.
- Do not add path-containment restrictions: a valid directory symlink may intentionally point outside the checkout.
- Do not commit, push, publish, release, deploy, or run paid live model tests.

## Acceptance

- Installation succeeds when each supported directory path is independently symlinked to an existing directory.
- Managed files, seed files, catalogs, and the Claude bridge are written through those directory links as applicable.
- A dangling directory link or a link resolving to a file fails during preflight without partial managed installation.
- The installer no longer emits `refusing symlinked path`.
- Existing non-symlink installation, ownership preservation, marker, lock, source-layout, and bootstrap tests still pass.
- `sh tests/installer/install/stage1.sh`, `sh scripts/verify static`, and `sh scripts/verify` pass.

## Risks

- Following a directory link can modify a target outside the checkout; that is intentional and documented as the
  repository owner's explicit filesystem layout.
- Recursive managed-directory refreshes still replace reserved `sia/` children at the resolved target, exactly as they
  do in an ordinary directory.

## External actions

None.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base a1e04648fa36a80e721131e5d17a2bbdc9b3f403 -->
<!-- sia:approved a5e82b1493b4a9a19d81622bcc2ac9c17f27c28bf4d6629ed347dd9084edafb3 -->
<!-- sia:progress build: valid directory symlinks are followed; invalid targets, docs, and installer fixtures updated -->
<!-- sia:progress review-validate: focused installer, static, full, stale-wording, and diff checks pass -->
<!-- sia:progress ship: directory-symlink support complete; no external actions performed -->
