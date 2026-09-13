---
name: reconcile-catalogs
description: Audit project definitions and CUSTOM entries, then make only targeted, explicitly safe catalog repairs.
workflow: definition
skills: []
---

# Reconcile catalogs

Audit the requested categories' direct project definitions and CUSTOM entries using the definition workflow's checks.
Classify valid entries, unindexed definitions, missing definitions, malformed entries, duplicates, and collisions.
Supporting files are not definitions. Shipped mismatches are installation errors, not project repairs.

Report the proposed repairs and apply only requested or accepted ones. Safe repairs include registering a valid
unindexed definition, adding a missing CUSTOM section with clear ownership, and removing an exact duplicate without
changing the surviving entry. Rename, removal of the sole entry, alias/behavior changes, and competing definitions
need explicit authorization for that choice. Leave ambiguity unresolved rather than guessing.

Preserve valid descriptions, aliases, order, comments, and all bytes outside the repair. Do not regenerate indexes.
On partial failure, repair or revert only this operation's writes and report what remains incomplete.
