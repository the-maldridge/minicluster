resource "boundary_host_catalog" "service_boxes" {
  name        = "Service Boxes"
  description = "Auxiliary Service Machines"
  type        = "static"
  scope_id    = boundary_scope.minicluster_fleet.id
}

resource "boundary_host" "router" {
  name = "router0"
  description = "Router for the minicluster"
  address = "192.168.32.1"
  host_catalog_id = boundary_host_catalog.service_boxes.id
  type = "static"
}

resource "boundary_host" "bootmaster" {
  name = "bootmaster"
  description = "Master boot server"
  address = "192.168.32.4"
  host_catalog_id = boundary_host_catalog.service_boxes.id
  type = "static"
}

resource "boundary_host_set" "service_boxes" {
  description = "Networking equipment"
  type = "static"
  host_catalog_id = boundary_host_catalog.service_boxes.id
  host_ids = [
    boundary_host.router.id,
    boundary_host.bootmaster.id,
  ]
}

resource "boundary_target" "service_boxes" {
  name = "Services SSH"
  description = "SSH to services machines"
  type = "tcp"
  default_port = "22"
  scope_id = boundary_scope.minicluster_fleet.id
  host_source_ids = [boundary_host_set.service_boxes.id]
}

resource "boundary_host_catalog" "hashi_boxes" {
  name = "Hashicorp Boxes"
  description = "Cluster services machines"
  type = "static"
  scope_id = boundary_scope.minicluster_fleet.id
}

resource "boundary_host" "node" {
  for_each = local.hosts

  name = each.value.hostname
  description = each.key
  address = each.value.private-ipv4
  host_catalog_id = boundary_host_catalog.hashi_boxes.id
  type="static"
}

resource "boundary_host_set" "hashi_role" {
  for_each = toset(["aio", "worker"])
  
  description = "Hashi host collection: ${each.value}"
  type = "static"
  host_catalog_id = boundary_host_catalog.hashi_boxes.id
  host_ids = [for hostid, host in local.hosts : boundary_host.node[hostid].id if host.role == each.value]
}

resource "boundary_target" "hashi_role" {
  for_each = toset(["aio", "worker"])

  name         = "hashi_ssh_${each.value}"
  description  = "Hashi host SSH: ${each.value}"
  type         = "tcp"
  default_port = "22"
  scope_id     = boundary_scope.minicluster_fleet.id
  host_source_ids = [boundary_host_set.hashi_role[each.value].id]
}

resource "boundary_target" "hashi_api" {
  for_each = toset(["4646", "8200", "8500"])

  name = "hashi_api_port_${each.value}"
  description = "Access to hashicorp API on port ${each.value}"
  type = "tcp"
  default_port = each.value
  scope_id = boundary_scope.minicluster_fleet.id
  host_source_ids = [boundary_host_set.hashi_role["aio"].id]
  session_connection_limit = -1
}
