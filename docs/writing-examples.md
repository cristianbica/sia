# Writing people can understand

These are authored examples for reviewing Sia's writing rules, not measured model results.
Each example must explain the actual situation without making the reader translate jargon.
Short text still fails if it hides the meaning. Longer text is justified when it adds necessary explanation.

## Answer

Before: “The approval-envelope invalidation vector requires boundary reconciliation prior to continuation.”

After: “The approved plan covers a parser fix. The database migration adds new scope and needs approval before work
can continue.”

Check: the reader can identify what changed and why approval is needed.

## Progress update

Before: “Provisioning reconciliation robustness is being enhanced across ambiguous transport outcomes.”

After: “A timeout can happen after TWRP creates the account. I’m checking how retries can find that account instead of
creating a second one.”

Check: the update names the failure, its consequence, and the work underway. It does not claim the fix is complete.

## Final report

Before: “Implemented resilient provisioning semantics with focused validation of the reconciliation surface.”

After: “Retries now look for the existing TWRP account before creating one. The timeout and duplicate-job tests passed
with stubbed responses. Live TWRP behavior has not been tested.”

Check: the report says what changed, what was checked, and what remains unverified. Use these claims only when
supported.

## Plan: built-in TWRP publishing

The supplied plan combined concrete requirements with dense implementation language. For example:

> Provision after database commit through jobs/services, covering registration's initial workspace and later workspace
> creation. Serialize provisioning for an organization, persist progress, and reconcile existing remote accounts by
> stable login email before retrying uncertain account creation.

Splitting this into “Post-commit provisioning; serialized reconciliation; persisted progress” would still fail.
The reader needs to understand when setup runs, what happens on failure, and how retries avoid duplicates.

The rewrite below preserves the supplied proposal's requirements. It is a writing example, not a verified design or
authorization to call TWRP.

### Example approval plan

Set up TWRP publishing automatically so each new workspace is ready to publish. Signup must still succeed when TWRP
is unavailable.

#### What changes

- Give each new organization one TWRP account and one managed MCP connection.
- Give each workspace its own remote workspace and enabled connection grant, including the initial signup workspace.
- Start setup in the background after the database commit.
- Show pending or failed setup with a retry action. Mark a connection active only when setup is complete.
- Translate setup status and errors, and document setup and publishing for users and developers.

#### Reliable setup

- Run one setup job per organization at a time and save progress for retries.
- After a timeout or uncertain response, check whether the remote account or workspace exists before trying again.
- TWRP cannot deduplicate account creation; use a stable service email to find an existing account.
- Attribute managed records to the organization owner or workspace creator. Retry if ownership is unavailable.
- Use platform credentials and a generated password unrelated to user passwords. Keep secrets encrypted and out of
  logs, screens, and agent results.

#### Access

- Protect managed endpoints, credentials, and workspace mappings from ordinary edits.
- Keep authorized enable/disable controls and existing publishing/deletion approvals.
- Resolve the workspace on the server and check site ownership before any site, page, inbox, or submission call.
- Filter lists to the workspace. TWRP tokens span workspaces, so local checks must prevent cross-workspace access.
- Exclude account-wide workspace management from agent tools.
- Classify only known read tools as reads; reject unclassified tools.

#### Checks and limits

- Verify setup during signup and later workspace creation, with one account per organization and one remote workspace
  per local workspace.
- Exercise duplicate jobs, interrupted setup, and retries without creating duplicates or showing false success.
- Verify workspace isolation, protected settings, and existing MCP behavior.
- Run focused automated checks with external requests stubbed. Apply migrations only to an isolated test database.
- Preserve existing application and test edits; stop if overlapping work cannot be preserved safely.
- No existing-tenant backfill, automatic remote deletion, deployment, commits, pushes, or live account/content creation.
- Live setup needs the platform token in deployment secrets, never source control.

### Execution notes for the handoff

These retain supplied implementation requirements without making the approval plan a file-and-command inventory.
They do not change its scope or authorize live setup.

- Default endpoint: `https://twrp.cb.b1z.eu/`.
- Reuse encrypted provider credentials and the existing MCP transport/resolver.
- Store the remote account ID in provider config; use a stable service email per organization.
- Store `twrp_workspace_id` in WorkspaceConnection JSONB configuration with Rails store accessors.
  Keep `connection_id` pointing to the local Connection.
- Document service-email setup, account confirmation, and agent use of sites, pages, forms, and responses.
  Update MCP/development docs and the feature index.
- Test concurrency, timeouts, validation/transport/tool errors, missing credentials, and missing ownership.
- Test tool resolution alongside the access and MCP regressions.
- Run focused Minitest tests, MCP/connection suites, `test/i18n_test.rb`, relevant access/registration tests,
  targeted RuboCop, Rails autoload checks, and scoped diff checks.
- Generate schema changes through Rails tasks. Inspect existing Workspace, locale, schema, and documentation edits.

Review: the plan makes the result, failure recovery, access restrictions, and delivery boundaries easy to find.
The handoff retains the exact configuration and validation details. Compare both against the source requirements;
shortening the plan must not remove work or move an approval decision out of sight.

## Plan: workspace pages and dashboard

The supplied proposal puts many requirements into each bullet. For example:

> **Dates:** offer common ranges and custom dates, defaulting to All time. Each widget explicitly selects its date field
> or opts out. Combine dates with saved filters, preserve runtime choices in the URL, and use a displayed, consistent
> time zone. Refresh on load, filter changes, or request; ignore obsolete responses.

Each requirement is useful, but the reader has to unpack the paragraph. The following example uses short groups and
points so the behavior is visible on a scan. Grouping is a tool, not a mandatory template. This is an authored rewrite
of the supplied proposal, not authorization to build the feature or evidence that its design has been verified.

### Example approval plan

Let workspaces build shared pages from configurable blocks. A Positions page could combine a records table with
recruitment statistics and charts.

#### Pages

- Offer Records, Dashboard, and Blank templates.
- Owners/operators can create, rename, duplicate, reorder, and delete shared pages. Other members can view them.
- Preserve existing data and action permissions.

#### Main dashboard

- Create exactly one for every existing and new workspace, pinned beside assistant Home.
- Allow title and block customization, with a reset to defaults.
- Start with activity, attention/running counts, and shortcuts.
- Prevent deletion, hiding, reassignment, or conversion. Deleting the workspace can remove it.

#### Editor and blocks

- Add, configure, and preview blocks in a responsive grid with adjustable widths and order.
- Support keyboard and click controls, explicit Save/Cancel, and protection against concurrent edits.
- Include records tables, recent-record feeds, permission-aware activity, sanitized text, and internal links.
- Offer metric cards for count, sum, average, minimum, and maximum, with optional prior-period comparisons.
- Offer line/area, bar, and donut charts with accessible chart data.

#### Records and dates

- Reuse existing search, filters, sorting, pagination, detail panels, and authorized actions.
- Give each table independent controls and page-specific columns.
- Offer common date ranges and custom dates; default to All time.
- Each widget selects its date field or opts out of date filtering.
- Combine dates with saved filters. Keep runtime choices in the URL.
- Display and consistently use one time zone.
- Refresh on load, filter changes, or request; ignore obsolete responses.

#### Correct results

- Aggregate all matching records, including those beyond the current table page.
- Make period comparisons meaningful, including zero and missing values.
- Show empty, invalid-source, and per-widget failure states clearly. Invalid filters must never broaden results.
- Bound aggregation cost and make chart truncation visible.
- Current-state charts do not imply historical conversion.

#### Checks and delivery limits

- Save and reload a Positions page and mixed dashboard; check editing, mobile layout, table independence, and refresh.
- Verify one protected dashboard through creation, backfill, concurrent requests, and deletion attempts.
- Confirm ordinary page deletion and workspace deletion still work.
- Check workspace isolation, viewer restrictions, private activity, stale edits, and removed datasets or fields.
- Check totals, date/time boundaries, empty values, period comparisons, and visible truncation.
- Translate all copy, update feature documentation, and run focused tests and regressions.
- Local implementation and isolated validation only, including Rails-generated schema changes and repository docs.
- No production migration, deployment, commits, pushes, or outbound messages. Tests have not yet run.

#### Deferred

- Other views and analysis: Kanban, calendars, historical conversion funnels, goals, pivots/joins.
- More customization: additional shared filters, personal layouts, AI-authored pages.
- Sharing and automation: public publishing, external-service widgets, scheduled refresh/reports.
- No arbitrary code, SQL, or embeds; no new record or form engine.

### Execution notes for the handoff

- Add workspace-owned pages/blocks with validated configuration and policies.
- Protect the main-dashboard invariant in the database and safely backfill existing workspaces.
- Build navigation, templates, editor, and records blocks using existing dataset components.
- Use bounded, authorized database aggregation and Chartkick charts; share date filtering across widgets.
- Bound blocks, rows, filters, categories, time buckets, and query time.
- Run focused model, policy, migration, query, integration, and Cuprite tests.
- Cover dataset/Activity/Home regressions; check translations, RuboCop, Rails loading, and whitespace.

Review: locate who can edit pages, what makes the main dashboard special, how dates affect widgets, and what proves the
results correct. Compare each original scope, delivery, acceptance/risk, and limit item against the plan and handoff.
For example, changing “owners/operators” to “users” would expand permissions, even if it made the sentence shorter.
A complete complex scope will take more space than a small change; make that space easy to scan rather than compressing
it into dense prose or dropping requirements.
