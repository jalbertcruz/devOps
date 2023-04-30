
# Increase log verbosity
log_level = "DEBUG"

bind_addr = "172.16.10.65"

advertise {
  # Defaults to the first private IP address.
  http = "172.16.10.65"
  rpc  = "172.16.10.65"
  serf = "172.16.10.65" # non-default ports may be specified
}

# Setup data dir
data_dir = "/tmp/serverx3"

# Give the agent a unique name. Defaults to hostname
name = "server1"

# Enable the client
client {
  enabled = true

  # For demo assume we are talking to server1. For production,
  # this should be like "nomad.service.consul:4647" and a system
  # like Consul used for service discovery.
  servers = ["172.16.10.65:4647"]
  options = {
    docker.volumes.enabled = true
  }
}

# Enable the server
server {
  enabled = true

  # Self-elect, should be 3 or 5 for production
  bootstrap_expect = 1
}

consul {
  # The address to the Consul agent.
  # address = "172.17.0.2:8500"

  address = "172.16.10.65:8500"

  # The service name to register the server and client with Consul.
  server_service_name = "nomad"

  # Enables automatically registering the services.
  auto_advertise = true

  # Enabling the server and client to bootstrap using Consul.
  server_auto_join = true
  client_auto_join = true
}



//docker {
// volumes
// {
//  enabled=true
// }
//}

# export NOMAD_ADDR=172.16.10.65
# sudo nomad agent -config server.hcl