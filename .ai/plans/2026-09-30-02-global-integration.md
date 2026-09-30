---
operation: implement
workflow: delivery
skills:
  - repository-discovery
  - testing
---

# Global Sia integration

<!-- sia:approval:start -->
Make the default installer keep all repository writes inside `.ai/`. The current installer always modifies root
`AGENTS.md` and often creates `.claude/CLAUDE.md`, so ignoring `.ai/` alone cannot keep Sia out of tracked project
instructions.

Install the shared opt-in entrypoint at `~/.config/sia/AGENTS.md`. Resolve project paths from the current Git root,
rather than the location of a global instruction file. Keep explicit activation and protocol-integrity checks.

- On install and update, offer to add a managed reference to each of `~/.codex/AGENTS.md`, `~/.claude/CLAUDE.md`, and
  `~/.copilot/copilot-instructions.md` when its reference is absent. Require an affirmative response for each new
  injection; preserve surrounding instructions. Refresh existing managed references without duplicating them.
- Read interactive answers from the terminal so the documented curl-to-shell bootstrap works. With no terminal,
  skip new injections and explain manual loading. Provide an explicit installer setting for automated consent or
  manual-only integration, and validate settings before writes.
- Use the existing `.ai/sia.md` for manual loading; do not add an uppercase entrypoint. Present this alternative
  when an injection is declined or interactive consent is unavailable.
- Keep repository bridges available through an explicit repository integration setting. Default global mode leaves
  existing repository instruction files untouched; it does not automatically remove previous Sia blocks or modify
  `.gitignore`. Explain optional ignoring and deliberate cleanup in the documentation.
- Update installer/bootstrap tests and activation/source contracts affected by the new integration. Isolate test home
  directories so verification cannot modify real host settings. Cover acceptance, refusal, updates, preservation,
  manual mode, missing files, malformed targets, and bootstrap consent behavior.

Update README and affected integration/protocol documentation. Refresh the installed dogfood runtime using the
manual mode so this implementation does not modify actual user configuration. Run the installer and static suites,
review the diff, and fix issues within this scope. No commits, publishing, or real home-directory installation are
included.
<!-- sia:approval:end -->

<!-- sia:status complete -->
<!-- sia:base f886a9820880ce4cddaf459a5cfcd3fbb53f841e -->

<!-- sia:approved 965d04f8d52908e78399014cd8076765b85d528030b3d6dbb297aa4a767bc306 -->

<!-- sia:progress Implemented global/manual/repository modes, per-host terminal consent and manual alternative; refreshed dogfood in manual mode. Full sh scripts/verify passed, including nine global integration tests, installer/bootstrap suites and offline host harnesses. Diff and shell syntax checks passed; no live model runs or real home configuration changes. -->

<!-- sia:progress User correction: removed repository integration mode, obsolete bridge sources, and related documentation. Installer supports only global/manual; host fixtures supply their own instructions. -->
