module "aio_server" {
  source = "../terraform-linuxkit-resinstack"

  system_version_metadata = "2cf1db0f0d2c9916b4894318bd76f1c97d8c8f7b"

  enable_console = true

  consul_server = true

  output_to = "${path.root}/shoelaces_data/static"
  base_name = "aio"

  build_pxe = true
}
