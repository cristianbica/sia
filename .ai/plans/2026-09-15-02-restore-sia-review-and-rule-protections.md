---
operation: fix
workflow: delivery
skills: [repository-discovery, bug-triage, testing]
---

# Restore useful Sia protections

<!-- sia:approval:start -->
Restore protections lost in September's simplification while keeping the shared planning-and-approval rule.
The main sources are the installer change `e77bff1` and workflow rewrite `f34176e`.

## Changes

- Preserve existing `.ai/RULES.md` files byte-for-byte during installation. Create the file only when missing;
  changing an existing project's defaults requires an explicit task. Update ownership docs to match.
- Restore practical writing guidance from `a098eff`, `238ac41`, and `147b314`: readable points, an evidence-based
  approach, clear checks and limits. Keep a short structured example; avoid both prose walls and shallow summaries.
- Restore concrete review checks for access boundaries, data access, asynchronous work, deployment, and UI behavior.
  Apply checks relevant to the change. Require delivery to load the effective code-review and testing skills before
  final review, honoring CUSTOM overrides and reusing already loaded skills.
- Restore coverage for approval, read-only work, bounded handoffs, CUSTOM resolution, required skills, and documentation
  boundaries. Preserve useful old assertions without restoring obsolete route names or exact prose requirements.
  Add checks that reject deliberately weakened source contracts, alongside the existing host-shim tests.
- Align docs and refresh installed instructions. Keep current approval/resume safeguards, Claude support, scoped
  continuation, verification stopping, and benchmark accounting. Do not reinstate automatic planning bypasses.

## Checks

- Reproduce the lost-rule upgrade and prove legacy/custom rules survive repeated installs, including files with changed
  or absent markers. Keep missing-file creation and existing installer safety checks working.
- Show that removing a protected contract or required review skill fails a test. Retain the Codex and Claude offline
  approval cases. Review one small and one substantial plan example for readability and retained requirements.
- Run focused checks, then `sh scripts/verify`; run `./install.sh` and inspect source and installed diffs.

No blanket rollback, model switch, mandatory delegation, commits, or paid live-model calls. Offline checks protect
specified contracts and the harness; report actual model compliance as unverified.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base 5e76b66b7be5e6340fed12b27fd74b04d06446af -->
<!-- sia:approved c3ab6b4a13cb9c45a1184f3bcc6a5d0461311fefee1c1ca9d61074826fc29d3f -->
<!-- sia:progress Review passed: existing rules preserved; readable examples and required review skills restored. -->
<!-- sia:progress Full sh scripts/verify passed, including contract mutations, both offline hosts, and installers. -->
<!-- sia:progress An earlier combined host check failed without detail; isolated rerun and final full run passed. -->
<!-- sia:progress Installed managed files match source; project RULES.md checksum unchanged; git diff --check passed. -->
<!-- sia:progress Small and substantial plan examples reviewed; live model compliance remains unverified. -->
