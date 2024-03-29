client {
  host_volume "host_logs" {
    path = "/var/log"
  }

  host_volume "docker_socket" {
    path = "/run/docker.sock"
  }

  host_volume "waypoint" {
    path = "/var/persist/volumes/waypoint"
  }
}
