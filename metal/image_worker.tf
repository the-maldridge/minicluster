module "worker" {
  source = "../../terraform-linuxkit-resinstack"

  enable_console = true
  enable_sshd    = true
  enable_ntpd    = true
  enable_persist = true

  system_format_cmd = ["/usr/bin/format", "-force", "/dev/sda"]

  nomad_client  = true
  enable_docker = true
  nomad_acl     = true
  nomad_mkdirs = [
    "/var/persist/volumes/void-packages",
    "/var/persist/volumes/waypoint",
  ]

  nomad_vault_integration = true

  custom_files = [data.linuxkit_file.worker_kill_timeout.id]

  vault_agent         = true
  vault_agent_role    = "worker"
  vault_agent_address = "https://node1.lan:8200"

  output_to = "${path.root}/shoelaces_data/static"
  base_name = "worker"

  build_pxe = true
}

data "linuxkit_file" "worker_kill_timeout" {
  contents = "client {\n\tmax_kill_timeout = \"30m\"\n}\n"
  path     = "etc/nomad/50-timeout.hcl"
  mode     = "0644"
  optional = false
}
