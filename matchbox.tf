resource "docker_image" "matchbox" {
  name = "quay.io/poseidon/matchbox:v0.9.0"
}

resource "docker_container" "matchbox" {
  depends_on = [
    local_file.matchbox_assets,
    local_file.matchbox_key,
    local_file.matchbox_cert,
    local_file.matchbox_ca_cert,
  ]

  name  = "matchbox"
  image = docker_image.matchbox.latest

  network_mode = "host"

  command = [
    "-address=0.0.0.0:8080",
    "-rpc-address=0.0.0.0:8081",
  ]

  volumes {
    host_path      = abspath(join("/", [path.module, "matchbox/etc"]))
    container_path = "/etc/matchbox"
    read_only      = true
  }

  volumes {
    host_path      = abspath(join("/", [path.module, "matchbox/data"]))
    container_path = "/var/lib/matchbox"
    read_only      = true
  }
}

resource "local_file" "matchbox_assets" {
  content  = "Assets Go Here\n"
  filename = "${path.module}/matchbox/data/assets/index.txt"

  file_permission      = "0644"
  directory_permission = "0755"
}
