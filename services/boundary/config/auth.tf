resource "boundary_role" "org_admin" {
  scope_id       = "global"
  grant_scope_id = boundary_scope.global.id
  grant_strings = [
    "id=*;type=*;actions=*"
  ]
  principal_ids = [boundary_user.root.id]
}

resource "boundary_role" "project_admin" {
  scope_id       = boundary_scope.global.id
  grant_scope_id = boundary_scope.minicluster.id
  grant_strings = [
    "id=*;type=*;actions=*"
  ]
  principal_ids = [boundary_user.root.id]
}

resource "boundary_role" "fleet_admin" {
  scope_id       = boundary_scope.global.id
  grant_scope_id = boundary_scope.minicluster_fleet.id
  grant_strings = [
    "id=*;type=*;actions=*"
  ]
  principal_ids = [boundary_user.root.id]
}
