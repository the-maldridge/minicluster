resource "local_file" "dnsmasq_config" {
  content = templatefile("${path.module}/dnsmasq.conf.tpl", {
    shoelaces_host : var.shoelaces_host,
    subnet : var.subnet,
    hosts : local.hosts,
  })
  filename        = "${path.module}/dnsmasq.conf"
  file_permission = "0644"
}

resource "docker_image" "dnsmasq" {
  name = "dnsmasq:latest"
}

resource "docker_container" "dnsmasq" {
  depends_on = [local_file.dnsmasq_config]

  name  = "dnsmasq"
  image = docker_image.dnsmasq.latest

  volumes {
    container_path = "/etc/dnsmasq.conf"
    host_path      = abspath(local_file.dnsmasq_config.filename)
  }

  capabilities {
    add = ["NET_ADMIN"]
  }
  network_mode = "host"

  restart  = "always"
  start    = "true"
  must_run = "true"
}
