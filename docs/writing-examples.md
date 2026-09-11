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

### Proposed change

Set up TWRP publishing automatically for new organizations and workspaces. Use `https://twrp.cb.b1z.eu/` by default.

- Each new organization gets one TWRP account and one managed MCP connection.
- Each Molva workspace gets its own TWRP workspace and an enabled connection grant. Include the initial signup
  workspace.
- Use the existing encrypted provider credentials and MCP transport. Store the remote account ID in provider config.
- Store `twrp_workspace_id` in new JSONB configuration on WorkspaceConnection, with Rails store accessors.
  Keep `connection_id` pointing to the local Connection.

### Setup and recovery

- Run setup in background jobs after the local records are committed. Signup must still succeed if TWRP is unavailable.
- Use configured platform credentials, a stable service email per organization, and a generated password unrelated to
  user passwords. Document service-email setup and TWRP's account-confirmation behavior.
- Allow only one setup job per organization at a time. Save progress so retries continue from the last successful step.
- TWRP cannot deduplicate account-creation requests. After a timeout, look up the account by service email before
  retrying.
  Check for an already-created remote workspace after an uncertain response too.
- Show pending or failed setup honestly, with a way to retry. Missing credentials, ownership, or remote errors must not
  leave an incomplete connection marked active.
- Attribute managed records to the organization owner or workspace creator, as existing models require.
  Retry if ownership is not available yet.

### Access and publishing

- Keep tokens encrypted and secrets out of logs, UI, and agent results.
- Prevent ordinary edits to managed endpoints, credentials, and workspace mappings. Keep authorized enable/disable
  controls.
- Use the existing tool resolver. Select the mapped workspace on the server, filter lists, and verify site ownership
  before site, page, inbox, or submission calls. Forged IDs must not expose another workspace's data.
- TWRP account tokens cover all remote workspaces, so the local tool checks must enforce isolation.
- Exclude account-wide workspace management from agent tools. Keep existing approval checks for publishing and deletion.
  Recognize only known read tools; reject unclassified tools.
- Add localized setup status and errors. Document agent use of sites, pages, forms, and responses; update MCP and
  development docs and the feature index.

### Checks and boundaries

- Test registration and later workspace creation: one account per organization and one remote workspace per local
  workspace.
- Test duplicate and concurrent jobs, timeouts, validation/transport/tool errors, missing credentials, and missing
  ownership.
- Test workspace isolation, managed-connection editing, tool resolution, and existing generic MCP behavior.
- Stub external requests. Run focused Minitest tests, MCP/connection suites, `test/i18n_test.rb`, relevant access and
  registration tests, targeted RuboCop, Rails autoload checks, and scoped diff checks.
- Apply migrations only to an isolated test database. Generate schema changes through Rails tasks.
- Preserve the existing application and test edits, especially Workspace, locales, schema, and docs.
  Inspect overlapping diffs; stop if those edits cannot be preserved safely.
- No automatic remote deletion, existing-tenant backfill, deployment, commits, pushes, or live account/content creation.
  Live setup requires the platform token in deployment secrets, never source control.

Review the rewrite for these facts: who gets an account or workspace, when setup happens, how retries recover, how
access is restricted, and what will be tested. Reject a rewrite that drops a requirement merely to sound concise.
