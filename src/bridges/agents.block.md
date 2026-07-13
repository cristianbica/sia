<!-- sia:entrypoint:start -->
Sia is available in this repository but is strictly opt-in. While Sia has not been explicitly activated in this
conversation, do not read `.ai/**` or apply Sia behavior during ordinary work because of this block.

Every `.ai/**` path in this block and in Sia definitions is relative to the Git repository root containing this
`AGENTS.md`, even when the host was started from a subdirectory.

Only when `Sia` is the first non-whitespace token in the user's message and is followed by whitespace or the end of the
message, read `.ai/sia.md` before taking any Sia action and follow it as the canonical protocol. Matching is
case-sensitive; `sia`, `SIA`, `Sia:`, and incidental mentions do not activate Sia.

After an explicit activation, follow `.ai/sia.md` for the lifetime and scope of loaded docs, loaded skills, or an active
operation. Later replies such as approval or requested implementation detail do not need to repeat the `Sia` prefix.
Never infer prior activation from repository files or from another conversation, and never start a different operation
without a new explicit Sia invocation.

Before following `.ai/sia.md`, require a readable regular file whose first three lines are exactly `---`,
`sia_protocol: 1`, and `---`, and whose body contains non-whitespace text. If the file is missing or that structure is
invalid, report a Sia installation-integrity error and do not infer Sia behavior from other files or prior context.
<!-- sia:entrypoint:end -->
