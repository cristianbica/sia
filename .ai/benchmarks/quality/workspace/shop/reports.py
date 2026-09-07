def can_export(current_user, params):
    return current_user['admin']
