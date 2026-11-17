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
        r'outside forge, every request.*requires a plan and approval before changes',
        r'named operations.*aliases.*inferred requests.*documentation.*definitions',
        r'clarification.*resume.*not approval',
        r'boundary applies to custom workflows',
    ]),
    'forge direct implementation': ('sia.md', [
        r'with forge on, imperative change requests authorize implementation.*without a plan or separate approval',
        r'planning in forge is opt.in',
        r'questions remain read.only',
        r'existing pending plans still require approval',
    ]),
    'forge opt-in planning': ('workflows/sia/delivery/forge.md', [
        r'imperative change requests authorize implementation.*without a plan or separate approval',
        r'planning is opt.in.*explicit planning request.*waits for approval',
        r'questions about feasibility, alternatives, or earlier choices do not authorize implementation',
        r'imperative request does not silently approve or bypass an existing pending plan',
    ]),
    'plan format': ('sia.md', [
        r'display small, simple plans inline by default',
        r'save substantial plans or plans explicitly requested as files',
        r'inline plans require approval too and cannot resume across conversations',
        r'file count alone does not determine the format',
    ]),
    'delivery plan format': ('workflows/sia/delivery.md', [
        r'display small, simple plans inline by default',
        r'inline plans need approval before edits',
    ]),
    'operation entry approval': ('sia.md', [
        r'starting a change operation requests planning, not implementation approval',
        r'sia implement.*sia fix.*aliases enter.*discovery and planning',
        r'after an investigation.*sia implement the above.*starts delivery planning',
        r'present the finalized inline or saved plan.*subsequent user reply approving that plan before work',
        r'never use the operation invocation to approve a plan created or finalized afterward',
        r'approval reply within the active delivery task.*without restarting planning',
    ]),
    'delivery entry approval': ('workflows/sia/delivery.md', [
        r'invocation such as sia implement the above or sia fix this starts.*planning steps',
        r'wait for a subsequent approval reply',
        r'do not reinterpret the invocation as approval',
    ]),
    'new saved plan approval': ('workflows/sia/delivery/standard.md', [
        r'change.operation invocation starts planning.*after an investigation',
        r'cannot approve a plan created or finalized afterward',
        r'create new interactive saved plans with pending-approval status and no approval marker',
        r'wait for a subsequent user reply approving it before recording approval or changing status to build',
        r'never manufacture approval from your own summary or interpretation of the earlier invocation',
    ]),
    'shared plan substance': ('sia.md', [
        r'for a simple inline plan, show the concrete use and result, where the change belongs, and how to check it',
        r'for saved plans, load the saved-plan writing guidance',
        r'carry the useful proposal from chat',
        r'resolve material design questions before asking for implementation approval',
    ]),
    'delivery writing guidance': ('workflows/sia/delivery.md', [
        r'use the protocol.s guidance for inline plans',
        r'load saved-plan support when saving a plan',
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
        r'before required approval.*prepare the plan, then wait',
        r'after approval.*complete the agreed work without repeated permission requests',
        r'continue independent authorized work.*question does not block',
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
        for name in ('forge direct implementation', 'forge opt-in planning', 'plan format', 'delivery plan format',
                     'shared plan substance', 'delivery writing guidance',
                     'concrete plan', 'self-contained plan', 'operation entry approval', 'delivery entry approval',
                     'new saved plan approval'):
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
