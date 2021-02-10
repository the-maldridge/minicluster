datacenter = "MINICLUSTER"

client {
  host_volume "logs" {
    path = "/run/log/onboot"
    read_only = true
  }
}
