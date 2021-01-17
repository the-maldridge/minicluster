resource "docker_image" "shoelaces" {
  name = "thousandeyes/shoelaces:latest"
}

resource "docker_container" "shoelaces" {
  name  = "shoelaces"
  image = docker_image.shoelaces.latest

  command = ["-base-url=bootmaster.lan:8081"]

  volumes {
    container_path = "/data"
    host_path      = abspath(join("/", [path.root, "shoelaces_data"]))
  }

  ports {
    internal = 8081
    external = 8081
  }

  restart  = "always"
  start    = true
  must_run = true
}
