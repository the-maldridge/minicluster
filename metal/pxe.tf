resource "docker_image" "dnsmasq" {
  name = "dnsmasq:latest"
}

resource "docker_container" "dnsmasq" {
  name  = "dnsmasq"
  image = docker_image.dnsmasq.latest

  command = [
    "-d", "-q",
    "-p", "0",
    "--dhcp-range=${cidrhost(var.subnet, 2)},proxy,${cidrnetmask(var.subnet)}",
    "--enable-tftp",
    "--tftp-root=/tftproot",
    "--dhcp-userclass=set:ipxe,iPXE",
    "--pxe-service=tag:#ipxe,x86PC,'PXE chainload to iPXE',undionly.kpxe",
    "--pxe-service=tag:ipxe,x86PC,'iPXE',http://${var.shoelaces_host}:8081/poll/1/$${netX/mac:hexhyp}",
  ]

  capabilities {
    add = ["NET_ADMIN"]
  }
  network_mode = "host"

  restart  = "always"
  start    = "true"
  must_run = "true"
}
