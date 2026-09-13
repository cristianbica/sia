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
    def run_check(self, task, workspace):
        return subprocess.run([sys.executable, "-B", str(HERE / "evaluate.py"), task, str(workspace)],
                              capture_output=True, text=True, timeout=10)

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
                    receipts.write_text(receipts.read_text().replace("    return {", "    receipt = {") +
                        '    if "currency" in order:\n        receipt["currency"] = order["currency"]\n    return receipt\n')
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


if __name__ == "__main__":
    unittest.main()
