from .inventory import reserve
from .receipts import receipt


def checkout(order, stock, event_id, sent_events):
    remaining = reserve(stock, order['quantity'])
    if event_id in sent_events:
        return None, remaining
    sent_events.add(event_id)
    return receipt(order), remaining
