import unittest
from orders import process
from receipts import format_receipt


class ExistingBehavior(unittest.TestCase):
    def test_receipt(self):
        receipt = format_receipt({"item": "book", "amount": 12.5})
        self.assertEqual(receipt["item"], "book")
        self.assertEqual(receipt["amount"], "12.50")

    def test_process(self):
        stock, seen, sent = {"book": 5}, set(), []
        process("one", {"item": "book", "amount": 12.5, "quantity": 2}, stock, seen, sent)
        self.assertEqual(stock, {"book": 3})
        self.assertEqual(seen, {"one"})
        self.assertEqual(len(sent), 1)


if __name__ == "__main__":
    unittest.main()
