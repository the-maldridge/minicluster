resource "docker_image" "boundary" {
  name = "hashicorp/boundary:0.6.2"
}

resource "docker_container" "boundary" {
  name = "boundary"
  image = docker_image.boundary.latest

  volumes {
    container_path = "/boundary/config.hcl"
    host_path = abspath(join("/", [path.root, "boundary.hcl"]))
  }

  capabilities {
    add = ["IPC_LOCK"]
  }

  network_mode = "host"
  restart = "always"
  start = true
  must_run = true
}

resource "docker_image" "boundarydb" {
  name = "postgres:14-alpine"
}

resource "docker_container" "boundarydb" {
  name = "boundarydb"
  image = docker_image.boundarydb.latest

  env = [
    "POSTGRES_PASSWORD=postgres",
    "POSTGRES_USER=postgres",
  ]

  ports {
    internal = 5432
    external = 5432
  }

  volumes {
    container_path = "/var/lib/postgresql/data"
    host_path = abspath(join("/", [path.root, "postgres_data"]))
  }

  network_mode = "host"
  restart = "always"
  start = true
  must_run = true
}
