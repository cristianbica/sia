def receipt(order):
    return {'order_id': order['id'], 'total_cents': order['total_cents']}
