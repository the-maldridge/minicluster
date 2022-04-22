module "aio_server" {
  source = "../../terraform-linuxkit-resinstack"

  enable_console = true
  enable_sshd    = true
  enable_ntpd    = true
  enable_persist = true

  system_format_cmd = ["/usr/bin/format", "-force"]

  consul_server = true
  consul_acl    = "deny"

  nomad_server  = true
  nomad_client  = true
  enable_docker = true
  nomad_acl     = true
  nomad_mkdirs  = ["/var/persist/volumes/void-packages"]

  vault_server = true
  vault_agent = true

  output_to = "${path.root}/shoelaces_data/static"
  base_name = "aio"
  build_pxe = true
}
