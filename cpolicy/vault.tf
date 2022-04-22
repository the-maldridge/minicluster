module "vault_base" {
  source = "../../terraform-vault-base"

  vault_cert_ca_file = "${path.module}/root_ca.crt"

  vault_role_policy_map = {
    default = ["default"]
  }
}
