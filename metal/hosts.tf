locals {
  hosts = {

    "00-23-24-5B-85-92" = {
      hostname        = "node1"
      private-ipv4    = "192.168.32.10"
      failure-domain  = "S1L"
      machine-type    = "m73-tiny"
      role            = "aio"
      authorized-keys = file(pathexpand("~/.ssh/minicluster_fleet.pub"))
    }

    "00-23-24-6C-68-5C" = {
      hostname        = "node2"
      private-ipv4    = "192.168.32.11"
      failure-domain  = "S1R"
      machine-type    = "m73-tiny"
      role            = "worker"
      authorized-keys = file(pathexpand("~/.ssh/minicluster_fleet.pub"))
    }

    "00-23-24-79-02-CB" = {
      hostname        = "node3"
      private-ipv4    = "192.168.32.12"
      failure-domain  = "S2L"
      machine-type    = "m73-tiny"
      role            = "worker"
      authorized-keys = file(pathexpand("~/.ssh/minicluster_fleet.pub"))
    }

    "00-23-24-64-1D-59" = {
      hostname        = "node4"
      private-ipv4    = "192.168.32.13"
      failure-domain  = "S2R"
      machine-type    = "m73-tiny"
      role            = "worker"
      authorized-keys = file(pathexpand("~/.ssh/minicluster_fleet.pub"))
    }

    "D8-CB-8A-20-92-E6" = {
      hostname        = "node5"
      private-ipv4    = "192.168.32.14"
      failure-domain  = "S3L"
      machine-type    = "m73-tiny"
      role            = "worker"
      authorized-keys = file(pathexpand("~/.ssh/minicluster_fleet.pub"))
    }

    "00-23-24-78-24-39" = {
      hostname        = "node6"
      private-ipv4    = "192.168.32.15"
      failure-domain  = "S3R"
      machine-type    = "m73-tiny"
      role            = "worker"
      authorized-keys = file(pathexpand("~/.ssh/minicluster_fleet.pub"))
    }

    "00-23-24-76-8B-ED" = {
      hostname        = "node7"
      private-ipv4    = "192.168.32.16"
      failure-domain  = "S4L"
      machine-type    = "m73-tiny"
      role            = "worker"
      authorized-keys = file(pathexpand("~/.ssh/minicluster_fleet.pub"))
    }

    "00-23-24-76-C6-A3" = {
      hostname        = "node8"
      private-ipv4    = "192.168.32.17"
      failure-domain  = "S4R"
      machine-type    = "m73-tiny"
      role            = "worker"
      authorized-keys = file(pathexpand("~/.ssh/minicluster_fleet.pub"))
    }

    "00-23-24-79-02-FA" = {
      hostname        = "node9"
      private-ipv4    = "192.168.32.18"
      failure-domain  = "S5L"
      machine-type    = "m73-tiny"
      role            = "worker"
      authorized-keys = file(pathexpand("~/.ssh/minicluster_fleet.pub"))
    }

    "00-23-24-69-DF-C4" = {
      hostname        = "node10"
      private-ipv4    = "192.168.32.19"
      failure-domain  = "S5R"
      machine-type    = "m73-tiny"
      role            = "worker"
      authorized-keys = file(pathexpand("~/.ssh/minicluster_fleet.pub"))
    }

  }
}

resource "local_file" "metadata" {
  for_each = local.hosts

  content = jsonencode(each.value)

  filename        = "${path.root}/metaldata_data/${each.key}.json"
  file_permission = "0644"
}

resource "local_file" "shoelaces_mappings" {
  content = yamlencode({
    networkMaps  = []
    hostnameMaps = [for host, attrs in local.hosts : { hostname = "${attrs.hostname}.lan", script = { name = "${attrs.role}.ipxe" } }]
  })

  filename        = abspath(join("/", [path.root, "shoelaces_data", "mappings.yaml"]))
  file_permission = "0644"
}
