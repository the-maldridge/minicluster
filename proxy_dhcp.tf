resource "docker_container" "proxy_dhcp" {
  name  = "proxy_dhcp"
  image = "quay.io/poseidon/dnsmasq"

  network_mode = "host"
  restart      = "always"
  start        = true
  must_run     = true

  capabilities {
    add = ["NET_ADMIN"]
  }

  command = [
    "-d", "-q",
    "--dhcp-range=192.168.32.1,proxy,255.255.255.0",
    "--enable-tftp", "--tftp-root=/var/lib/tftpboot",
    "--dhcp-userclass=set:ipxe,iPXE",
    "--pxe-service=tag:#ipxe,x86PC,'PXE chainload to iPXE',undionly.kpxe",
    "--pxe-service=tag:ipxe,x86PC,'iPXE',http://${var.matchbox_domain}:8080/boot.ipxe",
    "--pxe-service=tag:#ipxe,X86-64_EFI,'PXE chainload to iPXE UEFI',ipxe.efi",
    "--pxe-service=tag:ipxe,X86-64_EFI,'iPXE UEFI',http://${var.matchbox_domain}:8080/boot.ipxe"
  ]
}
