resource "docker_image" "shoelaces" {
  name = "thousandeyes/shoelaces:latest"
}

resource "docker_container" "shoelaces" {
  name  = "shoelaces"
  image = docker_image.shoelaces.latest

  command = ["-base-url=bootmaster.lan:8081", "-debug=true"]

  volumes {
    container_path = "/data"
    host_path      = abspath(join("/", [path.root, "shoelaces_data"]))
  }

  network_mode = "host"

  restart  = "always"
  start    = true
  must_run = true
}
