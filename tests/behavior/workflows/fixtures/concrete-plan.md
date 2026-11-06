# Concrete plan evaluation

This fictional scenario evaluates plan content, not heading names or approval metadata. It is a manual model test;
the offline instruction contracts do not run it or establish that a model passes it.

## Task and evidence

Give the candidate a fictional gallery repository with these verified facts: `config/gallery.yaml` selects reusable
processors, `gallery/selection.py` resolves them, `gallery/runner.py` instantiates them, `gallery/report.py` names
outputs, and `gallery/cli.py` handles commands. The catalog contains a `resize` processor with a `width` option.
Existing processor-only configuration must remain supported. There is no job interface yet.

Request:

> Plan named render jobs. I need a default `previews` job that runs `resize` twice: `small` at width 160 and `wide` at
> width 960, in that order, with separate files. Show the configuration, commands, and output paths. Explain the code
> changes and checks. Save the proposal and wait for approval; do not implement it.

Use a disposable repository containing those modules when running this scenario. Do not give candidates the reference
example or judgment criteria below. A live run requires separately authorized model access and a run limit.

## Judge the result

Read the saved plan without the conversation. It must show a coherent configuration containing both entries,
commands for default and explicit selection, and two distinct output paths. The entry names, widths, order, selection
rules, and output names must agree throughout. Proposed commands must be identified as proposed.

The implementation explanation must connect selection, per-entry processor construction, options, CLI forwarding,
and output naming to the supplied modules. Checks must establish the promised results and compatibility. There must
be no implementation edits and no unresolved material choice hidden behind a request to approve implementation.

Compare the saved artifact with the chat. Fail if the chat contains the concrete design but the artifact omits the
examples or decisions needed to understand it. Record any corrective user turns needed to obtain them.

This candidate fails even if its metadata is valid:

> Introduce named ordered jobs with isolated options and safe output identities. Update selection, runner, reporting,
> and CLI. Preserve compatibility. Test order, isolation, defaults, and paths. Confirm the schema before Build.

It supplies no schema, invocation, output paths, or explanation of how code changes produce the requested behavior.
The fictional gallery example in [writing examples](../../../../docs/writing-examples.md) illustrates a concrete
proposal. It is one acceptable design, not an exact-string oracle. Judge other coherent interfaces by their meaning.
