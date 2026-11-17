#!/usr/bin/env python3
"""Verify each task fails initially and accepts a working change, without a model."""
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

HERE = Path(__file__).resolve().parent


class Fixtures(unittest.TestCase):
    def run_check(self, task, workspace, *options):
        return subprocess.run(
            [sys.executable, "-B", str(HERE / "evaluate.py"), task, str(workspace), *options],
            capture_output=True, text=True, timeout=10,
        )

    def add_currency(self, workspace):
        receipts = workspace / "receipts.py"
        receipts.write_text(receipts.read_text().replace("    return {", "    receipt = {") +
            '    if "currency" in order:\n        receipt["currency"] = order["currency"]\n    return receipt\n')

    def test_each_task_has_a_real_behavior_gap(self):
        for task in json.loads((HERE / "tasks.json").read_text()):
            with self.subTest(task=task["id"]):
                self.assertNotEqual(self.run_check(task["id"], HERE / "workspace").returncode, 0)

    def test_minimal_changes_pass_without_new_modules(self):
        for task in ("currency", "duplicate", "sku-plan"):
            with self.subTest(task=task), tempfile.TemporaryDirectory() as directory:
                workspace = Path(directory) / "work"
                shutil.copytree(HERE / "workspace", workspace)
                receipts = workspace / "receipts.py"
                orders = workspace / "orders.py"
                if task == "currency":
                    self.add_currency(workspace)
                elif task == "duplicate":
                    text = orders.read_text()
                    debit = '    stock[order["item"]] -= order["quantity"]\n'
                    orders.write_text(text.replace(debit, '').replace('    sent.append', debit + '    sent.append'))
                else:
                    text = receipts.read_text().replace('format_receipt(order)', 'format_receipt(order, include_sku=False)')
                    receipts.write_text(text.replace('    return {', '    receipt = {') +
                        '    if include_sku and "sku" in order:\n        receipt["sku"] = order["sku"]\n    return receipt\n')
                    orders.write_text(orders.read_text().replace('stock, seen, sent):',
                        'stock, seen, sent, include_sku=False):').replace('format_receipt(order)',
                        'format_receipt(order, include_sku=include_sku)'))
                result = self.run_check(task, workspace)
                self.assertEqual(result.returncode, 0, result.stderr)
                existing = subprocess.run([sys.executable, '-B', '-m', 'unittest', 'discover', '-v'],
                                          cwd=workspace, capture_output=True, text=True, timeout=10)
                self.assertEqual(existing.returncode, 0, existing.stderr)

    def test_scope_flags_extra_edits_even_when_behavior_passes(self):
        with tempfile.TemporaryDirectory() as directory:
            workspace = Path(directory) / "work"
            shutil.copytree(HERE / "workspace", workspace)
            notes = workspace / "notes.txt"
            notes.write_text("Pre-existing user notes.\n")
            subprocess.run(["git", "init", "-q"], cwd=workspace, check=True)
            subprocess.run(["git", "add", "."], cwd=workspace, check=True)
            subprocess.run(
                ["git", "-c", "user.name=Sia fixture", "-c", "user.email=fixture@example.invalid",
                 "-c", "commit.gpgsign=false", "commit", "-qm", "Fixture baseline"],
                cwd=workspace, check=True,
            )
            self.add_currency(workspace)
            clean = self.run_check("currency", workspace, "--scope-from", "HEAD")
            self.assertEqual(clean.returncode, 0, clean.stderr)

            notes.write_text("Unrelated staged edit.\n")
            subprocess.run(["git", "add", "notes.txt"], cwd=workspace, check=True)
            notes.write_text("Pre-existing user notes.\n")
            orders = workspace / "orders.py"
            orders.write_text(orders.read_text() + "\n# Unrelated cleanup.\n")
            (workspace / "currency_converter.py").write_text("# Unrequested module.\n")

            result = self.run_check("currency", workspace, "--scope-from", "HEAD")
            self.assertEqual(result.returncode, 1, result.stderr)
            self.assertIn("behavior checks passed", result.stdout)
            self.assertIn("'notes.txt'", result.stderr)
            self.assertIn("'orders.py'", result.stderr)
            self.assertIn("'currency_converter.py'", result.stderr)


if __name__ == "__main__":
    unittest.main()
