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
        r'every request.*requires a saved plan and approval before changes',
        r'named operations.*aliases.*inferred requests.*documentation.*definitions.*forge',
        r'clarification.*resume.*not approval',
        r'boundary applies to custom workflows',
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
        r'before final review.*resolve and load.*code-review.*testing.*catalog',
        r'honor custom overrides.*reuse already loaded',
        r'review is required',
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
        r'before documentation writes.*saved.plan and approval',
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

    def test_edit_immediately_protocol_is_rejected(self):
        files = dict(self.files, **{'sia.md': '---\nsia_protocol: 1\n---\nEdit immediately.'})
        self.assertIn('shared approval', failures(files))

    def test_missing_review_skill_is_rejected(self):
        files = dict(self.files)
        path = 'workflows/sia/delivery.md'
        files[path] = files[path].replace('`code-review`', '')
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
