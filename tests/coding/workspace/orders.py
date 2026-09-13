from receipts import format_receipt


def process(event_id, order, stock, seen, sent):
    stock[order["item"]] -= order["quantity"]
    if event_id in seen:
        return
    sent.append(format_receipt(order))
    seen.add(event_id)
