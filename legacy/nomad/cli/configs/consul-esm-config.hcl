log_level = "INFO"

consul_service = "consul-esm"

consul_kv_path = "custom-esm/"
http_addr = "172.16.10.65:8500"
datacenter = "dc1"

disable_coordinate_updates = true
client_address = "172.16.10.65:8089"
ping_type = "socket"
passing_threshold = 3
critical_threshold = 2
