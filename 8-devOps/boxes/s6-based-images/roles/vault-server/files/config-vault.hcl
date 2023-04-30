storage "raft" {
   path    = "/data/raft-vault/"
   node_id = "vault_1"
}

listener "tcp" {
   address = "127.0.0.1:8300"
   cluster_address = "127.0.0.1:8301"
   tls_disable = true
}

ui = true
disable_mlock = true
cluster_addr = "http://127.0.0.1:8301"
