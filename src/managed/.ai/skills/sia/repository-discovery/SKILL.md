---
name: repository-discovery
description: Find the smallest reliable evidence set needed to understand a repository task.
use_when:
  - planning a repository change
  - documenting an unfamiliar repository area
  - verifying repository-specific commands or conventions
---

# Repository discovery

Start with the user's question and `.ai/docs/INDEX.md` when initialized. Follow only relevant routes, then verify
behavior-changing assumptions against current code. Trace callers, tests, and analogous implementations until the
important decisions are grounded. Avoid broad inventories and repeated reads of unchanged evidence.

Use repository-specific commands only after checking their conventions. Separate observed facts, documented claims,
and inference. If a document is wrong, identify its exact claim and contrary source evidence; correct it only within
the authorized task, otherwise report it. Stop discovery when further reads would not change the answer or approach.

Exclude `.ai/plans/**` from repository-wide searches, diffs, and history. Read only exact conversation-authorized plans;
filenames may be inspected solely to allocate a new name. Do not infer a past plan from a similar task.
