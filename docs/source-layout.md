# Source repository layout

The Sia source repository separates released, upgrade-owned payloads from create-once project seeds and bounded host
bridges. This structure is the implementation target; directories appear as their stages are built.

```text
sia/
  README.md
  install

  docs/
    README.md
    product.md
    protocol.md
    repository-knowledge.md
    extensions.md
    orchestration.md
    integration.md
    implementation.md
    source-layout.md

  src/
    managed/
      .ai/
        sia.md
        VERSION
        skills/sia/<skill>/SKILL.md
        operations/sia/<operation>.md
        workflows/sia/<workflow>.md
      catalogs/
        skills.md
        operations.md
        workflows.md

    seed/
      .ai/
        RULES.md
        docs/INDEX.md
        skills/INDEX.md
        operations/INDEX.md
        workflows/INDEX.md

    bridges/
      agents.block.md
      claude.block.md

  tests/
    behavior/
      activation/
      operations/
      workflows/
      model-routing/
    installer/
      install/
      update/
      check/
      uninstall/
      recovery/
    fixtures/
      empty-repo/
      existing-agents/
      existing-ai/
      custom-definitions/
      malformed-install/

  scripts/
    verify
```

## Ownership mapping

- `src/managed/.ai/` contains complete files installed and replaced by compatible upgrades.
- `src/managed/catalogs/` contains only the marked SIA fragments inserted into mixed-ownership catalog indexes.
- `src/seed/.ai/` contains create-if-missing files. After creation, `RULES.md`, the docs index, CUSTOM catalog content,
  and all text outside managed catalog blocks are project-owned.
- `src/bridges/` contains only the marked activation block for root `AGENTS.md` and the optional Claude compatibility
  import block. Neither template is a complete host instruction file.
- `.ai/.sia-manifest` is generated during installation and written last. It is never a checked-in source template.
- Tests use repository fixtures rather than mutating this repository. `scripts/verify` runs formatting, source/catalog
  synchronization, behavior, and installer checks.

Every shipped definition must have exactly one matching SIA catalog entry. Verification fails on missing entries,
orphaned entries, normalized-name collisions, invalid references, or source files that would install outside the layout
defined in [Tool integration and installation](integration.md).
