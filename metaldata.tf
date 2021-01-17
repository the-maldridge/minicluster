resource "docker_image" "metaldata" {
  name = "resinstack/metaldata:latest"
}

resource "docker_container" "metaldata" {
  name  = "metaldata"
  image = docker_image.metaldata.latest

  # Must be in the host network namespace to be on the same layer 2
  # fabric.
  network_mode = "host"

  volumes {
    container_path = "/data"
    host_path      = abspath(join("/", [path.root, "metaldata_data"]))
  }

  restart  = "always"
  start    = true
  must_run = true
}
