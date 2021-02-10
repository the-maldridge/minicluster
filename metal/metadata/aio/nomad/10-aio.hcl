datacenter = "MINICLUSTER"

server {
  bootstrap_expect = 3
}

client {
  host_volume "logs" {
    path = "/run/log/onboot"
    read_only = true
  }
}
