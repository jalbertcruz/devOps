from .consul_keys import consul_keys as public_consul_keys

try:
    from .sb_company import consul_keys as private_consul_keys

    consul_keys = {**private_consul_keys, **public_consul_keys}
    consul_keys = {**public_consul_keys}

except Exception as e:

    consul_keys = public_consul_keys
