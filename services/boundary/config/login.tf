resource "boundary_auth_method" "password" {
  name        = "simple_password"
  description = "Password auth method"
  type        = "password"
  scope_id    = boundary_scope.global.id
}

resource "boundary_account" "root" {
  name           = "root"
  description    = "User account for root"
  type           = "password"
  login_name     = "root"
  password       = "password"
  auth_method_id = boundary_auth_method.password.id
}

resource "boundary_user" "root" {
  name        = "root"
  description = "Initial Root User"
  account_ids = [boundary_account.root.id]
  scope_id    = boundary_scope.global.id
}

resource "boundary_auth_method_oidc" "provider" {
  name               = "NetAuth"
  description        = "OIDC auth method for NetAuth"
  scope_id           = boundary_scope.global.id
  issuer             = "http://localhost:5556"
  claims_scopes = ["groups"]
  client_id          = "05BOFZC6EE"
  client_secret      = "BSM4VV3DAL"
  signing_algorithms = ["RS256"]
  api_url_prefix     = "http://localhost:9200"

  is_primary_for_scope = true
}
