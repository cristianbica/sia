#!/usr/bin/env python3
"""Protect selected instruction contracts, not model compliance or exact prose layout."""
from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[3]
BASE = 'src/managed/.ai/'

# These are focused textual guardrails. Wording changes may need reviewed pattern updates;
# keeping these tests green never establishes that a model follows the instructions.
CONTRACTS = {
    'shared approval': ('sia.md', [
        r'by default, every request to change files or external state requires a plan and approval',
        r'including inferred requests, aliases, and custom workflows',
        r'read.only requests and session directives need no plan',
        r'before approval, only discovery and plan preparation are authorized',
        r'resume and clarification alone do not approve a plan',
    ]),
    'mode exceptions': ('sia.md', [
        r'follow the loaded forge rules when forge is on',
        r'explicit unattended mode or an explicit instruction to skip planning may bypass the default within the original scope',
        r'these exceptions cannot approve or bypass a pending plan',
        r'an explicit planning.only request stays in planning',
    ]),
    'forge opt-in planning': ('workflows/sia/delivery/forge.md', [
        r'imperative change requests authorize implementation.*without a plan or separate approval',
        r'planning is opt.in.*explicit planning request.*waits for approval',
        r'enabling forge alone authorizes no edits',
        r'questions about feasibility, alternatives, or earlier choices do not authorize implementation',
        r'imperative request does not silently approve or bypass an existing pending plan',
    ]),
    'plan format': ('sia.md', [
        r'display small, simple plans inline by default',
        r'for substantial work.*or when a plan file is requested, load the \[saved-plan guidance\]',
        r'inline plans cannot resume across conversations',
        r'honor explicit inline.only requests',
        r'judge complexity by the work involved, not file count',
    ]),
    'delivery follows shared approval': ('workflows/sia/delivery.md', [
        r'follow the protocol.s change approval rules',
        r'using its inline plan guidance or loading saved.plan support as directed',
        r'once authorized, implement, check, and review the change',
    ]),
    'operation entry approval': ('sia.md', [
        r'an invocation such as sia fix this or sia implement the above starts planning, including after an investigation',
        r'wait for a subsequent user reply approving the presented plan before implementation',
        r'an approval reply in the active task starts execution of that plan without restarting planning',
    ]),
    'new saved plan approval': ('workflows/sia/delivery/standard.md', [
        r'change.operation invocation starts planning.*after an investigation',
        r'cannot approve a plan created or finalized afterward',
        r'create new interactive saved plans with pending-approval status and no approval marker',
        r'wait for a subsequent user reply approving it before recording approval or changing status to build',
        r'never manufacture approval from your own summary or interpretation of the earlier invocation',
    ]),
    'shared plan substance': ('sia.md', [
        r'show the concrete use and result, where the change belongs, and how to check it',
        r'inspect evidence, resolve material design questions, and present the finalized plan',
    ]),
    'concrete plan': ('workflows/sia/delivery/standard.md', [
        r'make the proposed result concrete before explaining the work',
        r'configuration, commands, apis, or output, include a representative input, invocation, and resulting output',
        r'use the user.s example when available',
        r'label hypothetical values and proposed behavior',
        r'connect the affected files and existing functions to the changes needed',
    ]),
    'self-contained plan': ('workflows/sia/delivery/standard.md', [
        r'resolve material design questions before requesting implementation approval',
        r'saved plan must contain the concrete proposal shown in chat, including examples, decisions, and user corrections',
        r'if they must ask for the configuration, command, output, or meaning of a central choice, revise the plan',
    ]),
    'custom resolution': ('sia.md', [
        r'custom entry.*replaces the shipped',
        r'never fall back from an invalid override',
        r'override replaces the entire shipped alias set',
    ]),
    'plan isolation': ('sia.md', [
        r'explicitly requests or approves reading that exact path',
        r'before reading, searching, diffing.*including git history',
        r'filename.only inspection.*solely to allocate',
    ]),
    'delivery review': ('workflows/sia/delivery.md', [
        r'review is required',
        r'use the effective testing skill and reuse it if already loaded',
        r'resolve code-review through the skills catalog',
        r'load it for concrete risks that warrant deeper review, when the user requests deeper review, or when a custom override is selected',
    ]),
    'approved persistence': ('sia.md', [
        r'after approval.*complete the agreed work without repeated permission requests',
        r'answer side questions and continue independent authorized work',
        r'material scope changes need renewed approval',
        r'stop when the request is fulfilled',
    ]),
    'completion evidence': ('workflows/sia/delivery.md', [
        r'completion requires.*required checks.*review to finish',
        r'progress.only response.*does not establish completion',
        r'collect results from relevant background commands or workers',
        r'if a required check cannot run.*report the blocked requirement',
    ]),
    'meaningful verification': ('skills/sia/testing/SKILL.md', [
        r'run a check that exercises the changed behavior',
        r'stop once required checks pass unless.*change, failure, or new concern',
        r'syntax.only check cannot establish runtime behavior',
        r'failed.to.start command.*not a pass',
    ]),
    'saved completion': ('workflows/sia/delivery/standard.md', [
        r'set complete only after required implementation and checks finish successfully',
        r'an unavailable required check.*instead of.*setting complete',
    ]),
    'standalone review': ('workflows/sia/review.md', [
        r'keep source, docs, plans, and external state read.only',
        r'recommend.*without implementing',
    ]),
    'investigation': ('workflows/sia/investigation.md', [
        r'keep repository and external state read.only',
        r'if the user asks.*exactly one new plan',
        r'pending.approval.*do not approve it, execute it',
    ]),
    'documentation scope': ('workflows/sia/documentation.md', [
        r'before documentation writes.*planning and approval',
        r'write only.*\.ai/docs/.*nearest indexes',
        r'source.code fix.*rather than expanding',
    ]),
    'definition ownership': ('workflows/sia/definition.md', [
        r'shipped.*definitions and sia blocks are not project edit targets',
        r'creation does not overwrite',
        r'preserve other entries.*sia blocks.*shipped content',
    ]),
    'worker boundary': ('workflows/sia/delivery/handoff.md', [
        r'authorized_plan_paths.*do_not_load',
        r'for writes, base revision and staged/unstaged/untracked paths',
        r'reject missing.*permission.expanding',
        r'cannot coordinate approval or broaden scope',
    ]),
    'worker selection': ('sia.md', [
        r'for complex work, including planning, look for bounded, independent subtasks that benefit from a different model or reasoning effort',
        r'when the host permits delegation and can apply that choice',
        r'otherwise continue directly',
    ]),
    'planning worker': ('workflows/sia/delivery/handoff.md', [
        r'choose the model or reasoning effort at spawn time through the host',
        r'during complex planning, use a higher.effort worker to independently assess',
        r'keep the assignment read.only before approval',
        r'the coordinator verifies the findings, resolves tradeoffs, and presents one plan for approval',
    ]),
    'saved approval': ('workflows/sia/delivery/standard.md', [
        r'present the plan and wait for approval before any non.plan change',
        r'append.*sia:approved.*only after approval',
        r'pending draft enters approval, never build',
        r'changing the approved boundary.*returns to.*pending.approval',
    ]),
}


def failures(files):
    broken = []
    for name, (path, patterns) in CONTRACTS.items():
        body = ' '.join(files.get(path, '').lower().replace('`', '').split())
        if any(not re.search(pattern, body) for pattern in patterns):
            broken.append(name)
    for operation, workflow, skills in (
        ('implement', 'delivery', {'repository-discovery', 'testing'}),
        ('fix', 'delivery', {'repository-discovery', 'bug-triage', 'testing'}),
        ('review', 'review', {'repository-discovery', 'code-review', 'testing'}),
        ('document', 'documentation', {'repository-discovery', 'documentation'}),
        ('refresh-docs', 'documentation', {'repository-discovery', 'documentation'}),
    ):
        parts = files.get(f'operations/sia/{operation}.md', '').split('---', 2)
        header = parts[1] if len(parts) == 3 and parts[0] == '' else ''
        declared = re.findall(r'^  - ([a-z-]+)$', header, re.M)
        if (re.findall(r'^workflow: (.+)$', header, re.M) != [workflow]
                or set(declared) != skills or len(declared) != len(skills)):
            broken.append(operation + ' dependencies')
    return broken


class Contracts(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.files = {str(p.relative_to(ROOT / BASE)): p.read_text()
                     for p in (ROOT / BASE).rglob('*.md')}

    def test_current_contracts(self):
        self.assertEqual(failures(self.files), [])

    def test_removed_contracts_are_rejected(self):
        # Remove each contract's matching span, retaining the rest of the source.
        # This detects deletion without requiring a route name, heading, or fixed line wrapping.
        for name, (path, patterns) in CONTRACTS.items():
            with self.subTest(contract=name):
                files = dict(self.files)
                body = ' '.join(files[path].lower().replace('`', '').split())
                self.assertRegex(body, patterns[0])
                files[path] = re.sub(patterns[0], '', body)
                self.assertIn(name, failures(files))

    def test_plan_guards_are_individually_required(self):
        for name in ('shared approval', 'mode exceptions', 'forge opt-in planning', 'plan format',
                     'delivery follows shared approval', 'shared plan substance', 'concrete plan',
                     'self-contained plan', 'operation entry approval', 'new saved plan approval'):
            path, patterns = CONTRACTS[name]
            body = ' '.join(self.files[path].lower().replace('`', '').split())
            for pattern in patterns:
                with self.subTest(contract=name, pattern=pattern):
                    files = dict(self.files)
                    files[path] = re.sub(pattern, '', body)
                    self.assertIn(name, failures(files))

    def test_edit_immediately_protocol_is_rejected(self):
        files = dict(self.files, **{'sia.md': '---\nsia_protocol: 1\n---\nEdit immediately.'})
        self.assertIn('shared approval', failures(files))

    def test_review_skill_triggers_are_required(self):
        path, patterns = CONTRACTS['delivery review']
        body = ' '.join(self.files[path].lower().replace('`', '').split())
        for pattern in patterns:
            with self.subTest(pattern=pattern):
                files = dict(self.files)
                files[path] = re.sub(pattern, '', body)
                self.assertIn('delivery review', failures(files))

    def test_missing_and_duplicate_dependencies_are_rejected(self):
        for operation, skill in (('fix', 'testing'), ('review', 'code-review'), ('document', 'documentation')):
            path = f'operations/sia/{operation}.md'
            declaration = f'  - {skill}\n'
            for replacement in ('', declaration * 2):
                with self.subTest(operation=operation, replacement=replacement):
                    files = dict(self.files)
                    files[path] = files[path].replace(declaration, replacement)
                    self.assertIn(operation + ' dependencies', failures(files))

    def test_wrapping_and_case_do_not_define_contracts(self):
        files = {path: body for path, body in self.files.items()}
        for path, _ in CONTRACTS.values():
            files[path] = '\n'.join(files[path].upper().split())
        self.assertEqual(failures(files), [])


if __name__ == '__main__':
    unittest.main()
