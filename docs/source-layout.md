# Source repository layout

The source tree separates the two managed-refresh modes from create-once project seeds.

```text
sia/
  .gitattributes
  README.md
  install

  src/
    managed/
      .ai/
        sia.md
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
    installer/{install,github}/
    behavior/
    hosts/

  scripts/
    verify
    verify-hosts
```

## Mapping source to a repository

- `src/managed/.ai/` is copied over the corresponding Sia-owned installed paths on every install.
- `src/managed/catalogs/` contains complete marker-delimited SIA sections inserted into mixed-ownership indexes.
- `src/seed/.ai/` is copied only when a project file does not yet exist. Its files are project-owned afterwards.
- `src/bridges/` contains marker-delimited blocks, never complete user instruction files.
- `.gitattributes` keeps the shell entrypoint and managed text usable when a clone enables automatic line-ending
  conversion.
- `install` uses adjacent `src/` when run from a checkout. When read from standard input for installation, it
  temporarily shallow-clones the current GitHub source and invokes that same script against the clone.

The repository does not generate a release payload, distribution directory, manifest, or installer checksum. The
installer consumes these readable source files directly.

Every shipped definition must have a matching SIA catalog entry. Verification checks that mapping, prompt contracts,
installer ownership behavior, plain GitHub bootstrap behavior, and the no-model host harness.
