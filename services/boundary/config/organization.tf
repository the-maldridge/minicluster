resource "boundary_scope" "global" {
  global_scope = true
  scope_id     = "global"
  name = "Global"
}

resource "boundary_scope" "minicluster" {
  scope_id    = boundary_scope.global.id
  name        = "minicluster"
  description = "Minicluster Organization"

  auto_create_admin_role   = false
  auto_create_default_role = false
}

resource "boundary_scope" "minicluster_fleet" {
  name                     = "fleet"
  description              = "Fleet Management"
  scope_id                 = boundary_scope.minicluster.id
  auto_create_admin_role   = false
  auto_create_default_role = false
}
