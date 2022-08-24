storage "raft" {
  path = "/var/persist/vault"
}
api_addr = "https://{{ GetPrivateIP }}:8200"
cluster_addr = "http://{{ GetPrivateIP }}:8201"
disable_mlock = true
