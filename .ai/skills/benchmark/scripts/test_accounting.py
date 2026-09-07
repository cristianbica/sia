#!/usr/bin/env python3
import importlib.util
import json
import hashlib
from pathlib import Path
import unittest
import sys

HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('accounting', HERE / 'accounting.py')
accounting = importlib.util.module_from_spec(spec)
spec.loader.exec_module(accounting)
CORPUS = HERE.parents[2] / 'benchmarks'


def row(phase, task, seconds, cost):
    return dict(phase=phase, task_id=task, phase_seconds=seconds, cost_usd=cost,
                input_tokens=100, cached_input_tokens=60, output_tokens=20, reasoning_tokens=5, user_minutes=0)


class AccountingTests(unittest.TestCase):
    def test_total_amortization_and_subsets(self):
        data = {'tasks':[{'id':'a','quality_verdict':'pass'}, {'id':'b','quality_verdict':'fail'}],
                'phases':[row('bootstrap', None, 10, 1), row('implementation','a',20,2), row('retry','b',30,3)],
                'end_to_end_wall_seconds':45}
        result = accounting.summarize(data)
        self.assertEqual(result['totals']['phase_seconds'], 60)
        self.assertEqual(result['totals']['input_tokens'], 300)
        self.assertEqual(result['totals']['cached_input_tokens'], 180)
        self.assertEqual(result['amortized_per_successful_task']['cost_usd'], 6)
        self.assertEqual(result['end_to_end_wall_seconds'], 45)
        data['tasks'][1]['quality_verdict'] = 'pass'
        self.assertEqual(accounting.summarize(data)['amortized_per_successful_task']['cost_usd'], 3)

    def test_unknown_does_not_become_zero(self):
        first, second = row('bootstrap',None,10,1), row('implementation','a',20,2)
        second['cost_usd'] = 'unknown'
        data = {'tasks':[{'id':'a','quality_verdict':'pass'}], 'phases':[first,second]}
        result = accounting.summarize(data)
        self.assertEqual(result['totals']['cost_usd'], 'unknown')
        self.assertEqual(result['totals']['cost_usd_known_subtotal'], 1)
        self.assertEqual(result['amortized_per_successful_task']['cost_usd'], 'unknown')
        self.assertEqual(result['end_to_end_wall_seconds'], 'unknown')
        data['tasks'][0]['quality_verdict'] = 'pending'
        self.assertEqual(accounting.summarize(data)['amortized_per_successful_task']['phase_seconds'], 'unknown')

    def test_missing_evidence_and_invalid_values_fail(self):
        data = {'tasks':[{'id':'a','quality_verdict':'pass'}], 'phases':[]}
        with self.assertRaises(ValueError): accounting.summarize(data)
        for value in (-1, float('inf'), float('nan'), True):
            with self.assertRaises(ValueError): accounting.measure(value)
        data['phases'] = [row('implementation','a',1,1)]
        data['phases'][0]['cached_input_tokens'] = 101
        with self.assertRaises(ValueError): accounting.summarize(data)

    def test_diagnosis_fixture_reproduces_the_seeded_ordering_defect(self):
        workspace = CORPUS / 'quality/workspace'
        sys.path.insert(0, str(workspace))
        try:
            from shop.checkout import checkout
            order = {'id': 'one', 'total_cents': 100, 'quantity': 2}
            sent = set()
            first, stock = checkout(order, 10, 'evt_42', sent)
            second, stock = checkout(order, stock, 'evt_42', sent)
            self.assertEqual(first['order_id'], 'one')
            self.assertIsNone(second)
            self.assertEqual(stock, 6)
        finally:
            sys.path.remove(str(workspace))
            for name in list(sys.modules):
                if name == 'shop' or name.startswith('shop.'):
                    del sys.modules[name]

    def test_globalid_validation_retains_verifiable_private_evidence(self):
        folder = CORPUS / 'private/globalid-per-class-app'
        evidence = json.loads((folder / 'validation.json').read_text())
        self.assertEqual(evidence['evaluator_sha256'], hashlib.sha256((folder / 'evaluator.rb').read_bytes()).hexdigest())
        self.assertEqual(evidence['dependency_lock_sha256'], hashlib.sha256((folder / 'Gemfile.lock').read_bytes()).hexdigest())
        self.assertEqual(evidence['model_calls'], 0)
        for command in evidence['commands']:
            self.assertTrue((folder / command['evidence']).is_file())
            if command.get('classification') == 'expected-missing-task-behavior':
                self.assertEqual(command['side'], 'base')
                self.assertNotEqual(command['exit_code'], 0)
            else:
                self.assertEqual(command['exit_code'], 0)

    def test_quality_fixtures_keep_answers_out_of_workspace(self):
        folder = CORPUS / 'quality'
        manifest = json.loads((folder / 'manifest.json').read_text())
        rubrics = json.loads((folder / 'private/rubrics.json').read_text())
        self.assertEqual({t['id'] for t in manifest['tasks']}, set(rubrics))
        defaults = manifest['defaults']
        self.assertGreater(defaults['timeout_seconds'], 0)
        self.assertEqual(defaults['setup']['commands'], [])
        self.assertTrue(defaults['supported_environment']['python'])
        self.assertEqual({check['kind'] for check in defaults['checks']},
                         {'offline-fixture-contracts', 'workspace-unchanged', 'private-answer-rubric'})
        workspace = folder / manifest['workspace']
        files = {}
        for path in sorted(workspace.rglob('*')):
            self.assertFalse(path.is_symlink())
            if path.is_file():
                files[str(path.relative_to(workspace))] = hashlib.sha256(path.read_bytes()).hexdigest()
            else:
                self.assertTrue(path.is_dir())
        self.assertEqual(manifest['workspace_fingerprint']['algorithm'], 'sha256-per-file')
        self.assertEqual(files, manifest['workspace_fingerprint']['files'])
        self.assertFalse((folder / 'workspace/private').exists())
        for task in manifest['tasks']:
            self.assertEqual(task['mode'], 'read-only')
            self.assertTrue(rubrics[task['id']]['expected_evidence'])
            self.assertTrue(rubrics[task['id']]['unsupported_conclusions'])
            self.assertNotIn('required_findings', task['prompt'])
        self.assertEqual(rubrics['review']['material_defects'], 1)
        self.assertEqual(next(t for t in manifest['tasks'] if t['id']=='knowledge-reuse')['requires_prior'], 'ownership')


if __name__ == '__main__':
    unittest.main()
