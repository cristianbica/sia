# Operations

<!-- sia:operations:start -->
## SIA

- `create-operation` — Create a validated project operation and register its CUSTOM catalog entry.
- `create-skill` — Create a concise project skill package and register its CUSTOM catalog entry.
- `create-workflow` — Create a validated project workflow and register its CUSTOM catalog entry.
- `document` — Create or update concise, evidence-linked repository knowledge and its nearest indexes.
  - aliases: `document-repository`, `document-area`
- `fix` — Diagnose and fix a defect with root-cause evidence and regression coverage.
  - aliases: `bug`, `fix-bug`
- `implement` — Route a repository change to proportionate planning, implementation, validation, and delivery.
  - aliases: `build`
- `investigate` — Answer a bounded repository question from evidence without changing the repository.
- `reconcile-catalogs` — Reconcile project definitions and CUSTOM entries through targeted safe repairs.
- `refresh-docs` — Audit and refresh targeted repository documentation against current evidence.
  - aliases: `refresh-documentation`
- `review` — Review a defined change for correctness, regressions, scope, and validation evidence.
<!-- sia:operations:end -->

## CUSTOM

Project operations registered here override same-named Sia operations. Place each definition at
`.ai/operations/<name>.md`. Use this entry form; omit the second line when the operation has no aliases:

```markdown
- `name` — Description.
  - aliases: `one`, `two`
```
