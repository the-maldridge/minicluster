resource "docker_image" "dex" {
  name = "ghcr.io/dexidp/dex:v2.29.0"
}

resource "docker_container" "dex" {
  name = "dex"
  image = docker_image.dex.latest

  command = [
    "dex",
    "serve",
    "/config.yml",
  ]

  ports {
    internal = 5556
    external = 5556
  }

  volumes {
    container_path = "/config.yml"
    host_path = abspath(join("/", [path.root, "dex.yml"]))
  }

  restart = "always"
  start = true
  must_run = true
}
