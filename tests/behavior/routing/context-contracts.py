#!/usr/bin/env python3
"""Check source loading structure and accounting, not model compliance."""
import importlib.machinery
import importlib.util
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[3]
loader = importlib.machinery.SourceFileLoader('context_report', str(ROOT / 'scripts/report-context'))
spec = importlib.util.spec_from_loader(loader.name, loader)
report = importlib.util.module_from_spec(spec)
loader.exec_module(report)


class Context(unittest.TestCase):
    def test_optional_support_is_separate(self):
        uses = report.support_map(report.read(report.WORKFLOW))
        self.assertEqual(set(uses), {'coding', 'saved-plan', 'forge', 'worker'})
        self.assertEqual(uses['coding'], [])
        self.assertEqual([Path(p).name for p in uses['saved-plan']], ['standard.md'])
        self.assertEqual([Path(p).name for p in uses['worker']], ['handoff.md'])
        self.assertEqual([Path(p).name for p in uses['forge']], ['forge.md'])
        for paths in uses.values():
            for path in paths:
                self.assertTrue((ROOT / path).is_file())
        self.assertFalse((ROOT / 'src/managed/.ai/workflows/sia/delivery/execution.md').exists())

    def test_invalid_support_table(self):
        body = report.read(report.WORKFLOW)
        for broken in (body + '\n| coding | none |\n',
                       body.replace('delivery/standard.md', '../standard.md'),
                       body.replace('| coding | none |', '| coding | missing |'), ''):
            with self.subTest(broken=broken), self.assertRaises(ValueError):
                report.support_map(broken)

    def test_counts_include_later_and_total_files_without_duplicates(self):
        values = report.measure()
        self.assertLess(values['coding']['words'], values['coding-complete']['words'])
        self.assertLess(values['coding-complete']['words'], values['all-delivery-support']['words'])
        self.assertGreater(values['all-shipped-markdown']['words'], values['all-delivery-support']['words'])
        for entry in values.values():
            self.assertEqual(len(entry['paths']), len(set(entry['paths'])))
            self.assertEqual(entry['words'], sum(len(report.read(p).split()) for p in entry['paths']))
        for path in values['coding-complete']['paths']:
            self.assertNotIn('/delivery/standard.md', path)
            self.assertNotIn('/delivery/handoff.md', path)

    def test_protocol_header_and_skill_schemas(self):
        protocol = report.read('src/managed/.ai/sia.md')
        self.assertEqual(protocol.splitlines()[:3], ['---', 'sia_protocol: 1', '---'])
        for path in (ROOT / 'src/managed/.ai/skills/sia').glob('*/SKILL.md'):
            head, body = path.read_text().split('---', 2)[1:]
            self.assertIn('name: ' + path.parent.name, head)
            self.assertIn('description:', head)
            self.assertTrue(body.strip())
        for vendor in ('.codex', '.claude', '.cursor', '.opencode'):
            self.assertFalse((ROOT / 'src/managed' / vendor).exists())


if __name__ == '__main__':
    unittest.main()
