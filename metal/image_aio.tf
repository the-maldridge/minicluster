module "aio_server" {
  source = "../../terraform-linuxkit-resinstack"

  system_version_metadata   = "2cf1db0f0d2c9916b4894318bd76f1c97d8c8f7b"
  system_metadata_providers = ["metaldata"]

  enable_console = true
  enable_sshd    = true
  enable_ntpd    = true

  consul_version = "1.10.0-rc2"
  consul_server = true
  consul_acl    = "deny"

  nomad_version = "v1.1.1r0"
  nomad_server  = true
  nomad_client  = true
  enable_docker = true
  nomad_acl     = true

  vault_server      = true

  output_to = "${path.root}/shoelaces_data/static"
  base_name = "aio"
  build_pxe = true
}
