data "linuxkit_config" "getty" {
  kernel = data.linuxkit_kernel.kernel.id
  init   = [data.linuxkit_init.init.id]

  onboot = [
    data.linuxkit_image.sysctl.id,
    data.linuxkit_image.rngd1.id,
    data.linuxkit_image.dhcp_boot.id,
    data.linuxkit_image.metadata.id,
  ]

  services = [
    data.linuxkit_image.getty.id,
    data.linuxkit_image.rngd.id,
    data.linuxkit_image.dhcpcd.id,
  ]
}

resource "linuxkit_build" "getty" {
  config_yaml = data.linuxkit_config.getty.yaml
  destination = "${path.module}/shoelaces_data/static/getty.tar"
}

resource "linuxkit_image_kernel_initrd" "getty" {
  build = linuxkit_build.getty.destination
  destination = {
    cmdline = "${path.module}/shoelaces_data/static/getty_cmdline"
    kernel  = "${path.module}/shoelaces_data/static/getty_vmlinuz"
    initrd  = "${path.module}/shoelaces_data/static/getty_initrd"
  }
}
