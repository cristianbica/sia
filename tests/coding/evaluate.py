#!/usr/bin/env python3
"""Evaluator stays outside candidate workspaces. No model calls or dependencies."""
import argparse
from pathlib import Path
import sys


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


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("task", choices=("currency", "duplicate", "sku-plan"))
    parser.add_argument("workspace", type=Path)
    args = parser.parse_args()
    evaluate(args.task, args.workspace)
    print(args.task + ": behavior checks passed; scope and simplicity still need human review")
