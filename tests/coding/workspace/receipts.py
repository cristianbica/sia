def format_receipt(order):
    return {"item": order["item"], "amount": f'{order["amount"]:.2f}'}
