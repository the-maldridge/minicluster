module "worker" {
  source = "../terraform-linuxkit-resinstack"

  system_version_metadata = "2cf1db0f0d2c9916b4894318bd76f1c97d8c8f7b"

  enable_console = true

  output_to = "${path.root}/shoelaces_data/static"
  base_name = "worker"

  build_pxe = true
}
