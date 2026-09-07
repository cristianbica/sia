#!/usr/bin/env python3
"""Offline tests: no provider calls or credentials required."""
import importlib.util
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

spec = importlib.util.spec_from_file_location('concise_runner', Path(__file__).with_name('run.py'))
runner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runner)


class RunnerTests(unittest.TestCase):
    def test_contracts_are_distinct_and_fixed_baseline(self):
        arms = runner.contracts()
        self.assertNotEqual(arms['baseline'], arms['candidate'])
        self.assertEqual(arms['baseline'], (runner.HERE / 'baseline.txt').read_text())
        self.assertIn('Prefer existing patterns,', arms['candidate'])
        self.assertEqual(len(runner.cases()), 12)

    def test_commands_keep_model_as_one_argument_and_isolation(self):
        for host in ('codex', 'claude'):
            argv = runner.command(host, 'model with spaces', 'high', 'prompt', Path('out'))
            self.assertEqual(argv[argv.index('--model') + 1], 'model with spaces')
            self.assertNotIn('--dangerously-skip-permissions', argv)
        claude = runner.command('claude', 'model', 'high', 'prompt', Path('out'))
        self.assertIn('--safe-mode', claude)
        self.assertEqual(claude[claude.index('--tools') + 1], '')

    def test_missing_cli_capability_is_unavailable(self):
        with patch.object(runner.subprocess, 'run', return_value=subprocess.CompletedProcess([], 0, 'old CLI', '')):
            self.assertEqual(runner.probe('claude')['status'], 'UNAVAILABLE')

    def test_independent_workspaces_and_explicit_telemetry(self):
        directories = []
        def fake_run(argv, **kwargs):
            work = kwargs['cwd']
            directories.append(work)
            self.assertEqual(list(work.iterdir()), [])
            self.assertNotIn(runner.ROOT, work.parents)
            if argv[0] == 'codex':
                private_home = Path(kwargs['env']['CODEX_HOME'])
                self.assertTrue(private_home.is_dir())
                self.assertFalse((private_home / 'config.toml').exists())
                Path(argv[argv.index('--output-last-message') + 1]).write_text('response')
                raw = json.dumps({'type': 'turn.completed', 'usage': {'input_tokens': 7, 'output_tokens': 3}})
            else:
                raw = json.dumps({'type': 'result', 'result': 'response',
                                  'usage': {'input_tokens': 4, 'output_tokens': 2},
                                  'modelUsage': {'reported-model': {}}})
            return subprocess.CompletedProcess(argv, 0, raw, '')
        with tempfile.TemporaryDirectory() as temporary, patch.object(runner, 'execute', side_effect=fake_run):
            for host in ('codex', 'claude'):
                result = runner.run_call(host, 'requested-model', 'medium', 'prompt', Path(temporary) / host, 5)
                self.assertEqual(result['status'], 'AVAILABLE')
                self.assertEqual(result['actual_model'], 'unknown' if host == 'codex' else 'reported-model')
                self.assertTrue((Path(temporary) / host / 'metadata.json').is_file())
        self.assertEqual(len(set(directories)), 2)
        self.assertTrue(all(not path.exists() for path in directories))

    def test_errors_and_missing_response_are_unavailable(self):
        for raw in ('', '{"type":"result","is_error":true,"result":"error"}'):
            with tempfile.TemporaryDirectory() as temporary, patch.object(runner, 'execute',
                    return_value=subprocess.CompletedProcess([], 0, raw, '')):
                result = runner.run_call('claude', 'model', 'high', 'prompt', Path(temporary) / 'out', 5)
                self.assertEqual(result['status'], 'UNAVAILABLE')

    def test_repeated_pair_artifacts_record_snapshots_and_requested_settings(self):
        seen = []
        def fake_call(host, model, effort, prompt, destination, timeout):
            destination.mkdir(parents=True)
            (destination / 'response.txt').write_text('fact')
            seen.append(destination.name.rsplit('-', 1)[1])
            return {'status': 'AVAILABLE', 'input_tokens': 'unknown',
                    'output_tokens': 'unknown', 'elapsed_seconds': 0}
        case = {'id': 'one', 'prompt': 'Sia task', 'required': ['fact'], 'forbidden': [], 'review': 'Check fact.'}
        with tempfile.TemporaryDirectory() as temporary:
            target = Path(temporary) / 'results'
            argv = ['run.py', 'live', str(target), '--model', 'requested', '--effort', 'high', '--repetitions', '2']
            with patch.object(sys, 'argv', argv), patch.object(runner, 'cases', return_value=[case]), \
                    patch.object(runner, 'probe', return_value={'status': 'AVAILABLE', 'version': 'fake', 'reason': ''}), \
                    patch.object(runner, 'run_call', side_effect=fake_call):
                self.assertEqual(runner.main(), 0)
            metadata = json.loads((target / 'metadata.json').read_text())
            self.assertEqual(metadata['requested_model'], 'requested')
            self.assertEqual(metadata['requested_effort'], 'high')
            self.assertEqual(len(metadata['instruction_hashes']['baseline']), 64)
            self.assertIn('Pair verdict', (target / 'review.md').read_text())
            self.assertEqual(len((target / 'results.tsv').read_text().splitlines()), 5)
        self.assertEqual(seen, ['baseline', 'candidate', 'candidate', 'baseline'])

    def test_execution_limits_time_and_output_without_models(self):
        with tempfile.TemporaryDirectory() as temporary:
            timed = runner.execute([sys.executable, '-c', 'import time; time.sleep(5)'],
                                   Path(temporary), None, 0.05)
            self.assertEqual(timed.returncode, 124)
            large = runner.execute([sys.executable, '-c', 'print("x" * 10000)'],
                                   Path(temporary), None, 5, max_bytes=100)
            self.assertEqual(large.returncode, 125)
            self.assertLessEqual(len(large.stdout) + len(large.stderr), 100)

    def test_fidelity_preserves_case_requirements(self):
        with tempfile.TemporaryDirectory() as temporary:
            case = {'required': ['Fact'], 'forbidden': ['invented']}
            self.assertEqual(runner.score(case, 'fact', Path(temporary)), 'PASS')
            self.assertEqual(runner.score(case, 'fact invented', Path(temporary)), 'FAIL')


if __name__ == '__main__':
    unittest.main()
