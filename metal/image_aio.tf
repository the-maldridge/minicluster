module "aio_server" {
  source = "../../terraform-linuxkit-resinstack"

  enable_console = true
  enable_sshd    = true
  enable_ntpd    = true

  consul_server = true
  consul_acl    = "deny"

  nomad_server  = true
  nomad_client  = true
  enable_docker = true
  nomad_acl     = true
  nomad_mkdirs  = ["/var/persist/volumes/void-packages"]

  vault_server = true

  output_to = "${path.root}/shoelaces_data/static"
  base_name = "aio"
  build_pxe = true
}
