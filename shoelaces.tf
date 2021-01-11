resource "docker_image" "shoelaces" {
  name = "thousandeyes/shoelaces:latest"
}

resource "docker_container" "shoelaces" {
  name  = "shoelaces"
  image = docker_image.shoelaces.latest

  command = [
    "-port", "8081",
    "-domain", "bootmaster.lan",
    "-data-dir", "/data",
    "-static-dir", "/web",
  ]

  network_mode = "host"

  volumes {
    container_path = "/data"
    host_path      = abspath(join("/", [path.root, "shoelaces_data"]))
  }

  restart  = "always"
  start    = true
  must_run = true
}
