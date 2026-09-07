def reserve(stock, quantity):
    if quantity < 1 or quantity > stock:
        raise ValueError('quantity unavailable')
    return stock - quantity
