#!/usr/bin/env python3
"""Offline evaluator that stays outside candidate workspaces."""
import argparse
import os
from pathlib import Path
import subprocess
import sys

EXPECTED_PATHS = {
    "currency": {"receipts.py", "test_existing.py"},
    "duplicate": {"orders.py", "test_existing.py"},
    "sku-plan": {"orders.py", "receipts.py", "test_existing.py"},
}


def evaluate(task, workspace):
    sys.path.insert(0, str(workspace.resolve()))
    from receipts import format_receipt
    from orders import process
    order = {"item": "book", "amount": 12.5, "quantity": 2}
    if task == "currency":
        for currency in ("USD", "EUR"):
            receipt = format_receipt(dict(order, currency=currency))
            assert receipt == {"item": "book", "amount": "12.50", "currency": currency}
        assert format_receipt(order) == {"item": "book", "amount": "12.50"}
    elif task == "duplicate":
        stock, seen, sent = {"book": 10}, set(), []
        process("one", order, stock, seen, sent)
        process("one", dict(order), stock, seen, sent)
        assert stock == {"book": 8} and len(sent) == 1 and seen == {"one"}
        process("two", order, stock, seen, sent)
        assert stock == {"book": 6} and len(sent) == 2 and seen == {"one", "two"}
    elif task == "sku-plan":
        order["sku"] = "BK-1"
        expected = {"item": "book", "amount": "12.50"}
        assert format_receipt(order) == expected
        assert format_receipt(order, include_sku=True) == dict(expected, sku="BK-1")
        no_sku = {k: v for k, v in order.items() if k != "sku"}
        assert format_receipt(no_sku, include_sku=True) == expected
        for include in (False, True):
            stock, seen, sent = {"book": 10}, set(), []
            process("one", order, stock, seen, sent, include_sku=include)
            assert sent == [dict(expected, sku="BK-1") if include else expected]
            assert stock == {"book": 8} and seen == {"one"}
    else:
        raise ValueError(task)


def unexpected_paths(task, workspace, base):
    # Check the index and worktree separately. An unstaged edit can cancel a staged edit.
    commands = (
        ["diff", "--cached", "--name-only", "--no-renames", "-z", "--end-of-options", base],
        ["diff", "--name-only", "--no-renames", "-z"],
        ["ls-files", "--others", "--exclude-standard", "-z"],
    )
    paths = set()
    for command in commands:
        output = subprocess.check_output(
            ["git", *command, "--", ".", ":(exclude,top).ai/plans/**"],
            cwd=workspace, timeout=10,
        )
        paths.update(os.fsdecode(path) for path in output.split(b"\0") if path)
    return sorted(paths - EXPECTED_PATHS[task])


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("task", choices=EXPECTED_PATHS)
    parser.add_argument("workspace", type=Path)
    parser.add_argument("--scope-from", metavar="COMMIT", help="scope baseline after candidate setup")
    args = parser.parse_args()
    evaluate(args.task, args.workspace)
    print(f"{args.task}: behavior checks passed")
    if args.scope_from:
        outside = unexpected_paths(args.task, args.workspace, args.scope_from)
        if outside:
            print("Paths outside the expected scope:", file=sys.stderr)
            for path in outside:
                print(f"  {path!r}", file=sys.stderr)
            sys.exit(1)
        print("Changed paths fit the fixture; inspect the hunks for unnecessary changes.")
    else:
        print("Scope and simplicity still need human review.")
