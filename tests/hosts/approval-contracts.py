#!/usr/bin/env python3
"""No-model harness regression tests, including full fixture/continuation orchestration."""
import importlib.machinery
import importlib.util
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[2]
loader = importlib.machinery.SourceFileLoader('approval_runner', str(ROOT / 'scripts/verify-approval'))
spec = importlib.util.spec_from_loader(loader.name, loader)
runner = importlib.util.module_from_spec(spec)
loader.exec_module(runner)


class ApprovalHarness(unittest.TestCase):
    def exercise(self, fault='', case='standard', expected=1):
        with tempfile.TemporaryDirectory(prefix='sia-approval-test-') as directory:
            directory = Path(directory)
            shim = directory / 'codex'
            shutil.copyfile(ROOT / 'tests/hosts/approval-shim.py', shim)
            shim.chmod(0o755)
            # Do not copy real user credentials even though the shim cannot use them.
            env = dict(os.environ, PATH=str(directory) + os.pathsep + os.environ['PATH'],
                       CODEX_HOME=str(directory / 'empty-auth'), SIA_APPROVAL_SHIM_FAULT=fault,
                       PYTHONDONTWRITEBYTECODE='1')
            artifacts = directory / 'evidence'
            command = [str(ROOT / 'scripts/verify-approval'), '--live', '--artifacts', str(artifacts)]
            if case:
                command += ['--case', case]
            if fault == 'timeout':
                command += ['--timeout', '0.1']
            result = subprocess.run(command, env=env, capture_output=True, text=True, timeout=90)
            self.assertEqual(result.returncode, expected, result.stdout + result.stderr)
            summary = (artifacts / 'summary.tsv').read_text()
            if expected == 0:
                self.assertEqual(summary.count('\tPASS\t'), 6 if case is None else 1, summary)
            else:
                self.assertIn('\tUNAVAILABLE\t' if expected == 2 else '\tFAIL\t', summary)
            commands = list(artifacts.rglob('command.json'))
            for path in commands:
                args = json.loads(path.read_text())
                self.assertIn('sandbox_mode="workspace-write"', args)
                self.assertNotIn('--last', args)
                if 'resume' in args:
                    self.assertEqual(args[-2], 'fixture-session')
            # Private session data and copied auth must be removed, evidence retained.
            for path in artifacts.rglob('before.json'):
                self.assertIn('app.py', json.loads(path.read_text()))

    def test_all_routes(self):
        self.exercise(case=None, expected=0)

    def test_bad_behavior(self):
        for fault in ('premature-write', 'reverted-attempt', 'shell-attempt', 'missing-plan', 'invalid-plan', 'reversed-plan', 'wrong-digest', 'silent-write'):
            with self.subTest(fault=fault):
                self.exercise(fault)

    def test_unavailable_is_not_pass(self):
        for fault in ('missing-session', 'host-failure', 'unavailable-resume', 'timeout', 'opaque-command', 'output-limit', 'invalid-json', 'incomplete-turn'):
            with self.subTest(fault=fault):
                self.exercise(fault, expected=2)

    def test_route_announcement_precedes_edit(self):
        with self.assertRaisesRegex(AssertionError, 'before route'):
            runner.trace_check([{'type': 'item.started', 'item': {'type': 'file_change',
                'changes': [{'path': '.ai/plans/example.md'}]}}], True)

    def test_read_before_announcement_is_allowed(self):
        events = [{'type': 'item.started', 'item': {'type': 'command_execution', 'command': 'cat app.py'}}]
        self.assertFalse(runner.trace_check(events, False))
        self.assertFalse(runner.trace_check(events, True))

    def test_find_actions_cannot_pass_as_reads(self):
        for command in ('find . -delete', 'find . -exec python3 -c "print(1)" {} +'):
            with self.subTest(command=command):
                events = [{'type': 'item.started', 'item': {'type': 'command_execution', 'command': command}}]
                with self.assertRaises(runner.Unavailable):
                    runner.trace_check(events, True)
                with self.assertRaisesRegex(AssertionError, 'before route'):
                    runner.trace_check(events, False)

    def test_explicit_live_required(self):
        result = subprocess.run([str(ROOT / 'scripts/verify-approval')], capture_output=True)
        self.assertEqual(result.returncode, 2)


if __name__ == '__main__':
    unittest.main()
