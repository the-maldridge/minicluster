variable "nomad_ready" {
  type    = bool
  default = true
}

module "vault_base" {
  source = "../../terraform-vault-base"

  consul_bootstrap = true

  configure_for_nomad_acl = var.nomad_ready

  vault_role_policy_map = {
    default = {
      certificate = "${path.module}/root_ca.crt"
      policies    = ["default"]
    }
    aio = {
      certificate   = "${path.module}/root_ca.crt"
      policies      = ["default", "resin-consul-agent", "resin-vault-server", "resin-nomad-server"]
      allowed_names = ["node1.lan"]
    }
    worker = {
      certificate = "${path.module}/root_ca.crt"
      policies    = ["default", "resin-consul-agent", "resin-nomad-client"]
    }
  }
}
