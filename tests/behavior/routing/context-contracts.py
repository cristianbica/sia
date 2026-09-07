#!/usr/bin/env python3
"""Validate the declared route graph without treating text size as model performance."""
import importlib.machinery
import importlib.util
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[3]
loader = importlib.machinery.SourceFileLoader('context_report', str(ROOT / 'scripts/report-context'))
spec = importlib.util.spec_from_loader(loader.name, loader)
report = importlib.util.module_from_spec(spec)
loader.exec_module(report)


class RouteContext(unittest.TestCase):
    def setUp(self):
        self.body = report.read(report.WORKFLOW)
        self.routes = report.support_map(self.body)

    def test_route_separation_and_required_support(self):
        suffixes = {route: [Path(p).name for p in paths] for route, paths in self.routes.items()}
        self.assertEqual(suffixes['trivial'], [])
        self.assertEqual(suffixes['standard-plan'], ['standard.md'])
        self.assertEqual(suffixes['standard-resume'], ['standard.md'])
        self.assertEqual(suffixes['standard-execute'], ['execution.md'])
        self.assertEqual(suffixes['lightweight'], ['execution.md'])
        self.assertEqual(suffixes['forge-intake'], ['forge.md'])
        self.assertEqual(suffixes['forge-execute'], ['forge.md', 'execution.md'])
        for paths in self.routes.values():
            for path in paths:
                self.assertTrue((ROOT / path).is_file(), path)
        self.assertIn('CUSTOM workflow owns its own supporting references', self.body)
        self.assertIn('definition_paths.support', self.body)

    def test_invalid_and_missing_routes_fail_closed(self):
        for body in [self.body.replace('| trivial | none |', ''),
                     self.body + '\n| trivial | none |\n',
                     self.body.replace('delivery/standard.md', '../standard.md'),
                     self.body.replace('| trivial | none |', '| trivial | maybe |')]:
            with self.subTest(body=body[-100:]), self.assertRaises(ValueError):
                report.support_map(body)

    def test_shared_authority_and_complete_execution(self):
        for values in report.measure().values():
            self.assertIn('src/managed/.ai/sia.md', values['paths'])
            self.assertIn('src/seed/.ai/RULES.md', values['paths'])
            self.assertGreater(values['words'], 0)
        execution = report.read(self.routes['standard-execute'][0])
        for phase in ('Build', 'Review/Validate', 'Fix', 'Ship'):
            self.assertIn('## ' + phase, execution)
        standard = report.read(self.routes['standard-plan'][0])
        self.assertIn('## Approve', standard)
        self.assertIn('before any product/source edit', standard)
        self.assertIn('Only standard delivery writes', execution)


if __name__ == '__main__':
    unittest.main()
