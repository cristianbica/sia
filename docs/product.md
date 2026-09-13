# Product and principles

Sia should help developers get the code they asked for with fewer corrections. Its main contribution is repository
knowledge: where behavior lives, which conventions matter, and which commands actually work. The host agent still
reads files, edits code, runs tools, and controls permissions.

## What belongs in Sia

- Concise, evidence-linked repository documentation, loaded only when relevant.
- Project-specific constraints and useful reusable skills.
- Direct implementation, diagnosis, review, and documentation requests.
- Optional plans and saved context when the developer needs them.
- Portable, explicit activation and safe updates that preserve project-owned content.

Normal coding should not require managing Sia's internal state. An implementation request authorizes its local scope;
asking for a plan pauses before implementation. Existing saved plans retain their approval contracts. Custom workflows
can deliberately choose another process without changing ordinary shipped behavior.

## What does not belong

Do not add a generic engineering handbook, routine model bookkeeping, or a second permission system on top of the host.
Sia has no runtime, plugin requirement, database, index of every symbol, or guarantee of model compliance. It does not
silently publish, deploy, or alter unrelated work. Repository docs are evidence, not behavioral instructions.

Before adding a mechanism, identify a developer problem it solves and the effort it removes. Prefer deleting redundant
instructions to adding exceptions. A shorter prompt is useful only if correctness and clarity survive.

## Judge real work

Compare tasks with Sia and with the same host alone. Inspect requested behavior, unwanted features, unnecessary code,
and the developer's corrective prompts or rewrites. Keep results and limitations. Structural tests protect packaging
and harness behavior; they cannot establish that Sia helps developers or that a model follows every instruction.
