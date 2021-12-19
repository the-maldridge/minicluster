module "aio_metadata" {
  source = "../../terraform-local-metadata"

  cluster_tag     = "minicluster"
  base_path       = "${path.module}/metadata/aio"
  secret_provider = "insecure"

  consul_server           = true
  consul_retry_join       = ["node1.lan"]
  consul_datacenter       = "minicluster"
  consul_bootstrap_expect = 1

  vault_server = true

  nomad_server           = true
  nomad_datacenter       = "minicluster-control"
  nomad_bootstrap_expect = 1
}

data "linuxkit_metadata" "aio" {
  base_path = "${path.module}/metadata/aio"
}

resource "local_file" "aio_metadata" {
  for_each = toset([
    "00-23-24-5B-85-92",
  ])

  content  = data.linuxkit_metadata.aio.json
  filename = "${path.root}/metaldata_data/${each.value}.userdata"

  file_permission = "0644"
}

module "worker_metadata" {
  source = "../../terraform-local-metadata"

  cluster_tag     = "minicluster"
  base_path       = "${path.module}/metadata/worker"
  secret_provider = "insecure"

  consul_agent      = true
  consul_retry_join = ["node1.lan"]
  consul_datacenter = "minicluster"

  nomad_client     = true
  nomad_datacenter = "minicluster"
}

data "linuxkit_metadata" "worker" {
  base_path = "${path.module}/metadata/worker"
}

resource "local_file" "worker_metadata" {
  for_each = toset([
    "00-23-24-6C-68-5C",
    "00-23-24-79-02-CB",
    "00-23-24-64-1D-59",
    "D8-CB-8A-20-92-E6",
    "00-23-24-78-24-39",
    "00-23-24-76-8B-ED",
    "00-23-24-76-C6-A3",
    "00-23-24-79-02-FA",
    "00-23-24-69-DF-C4",
  ])

  content  = data.linuxkit_metadata.worker.json
  filename = "${path.root}/metaldata_data/${each.value}.userdata"

  file_permission = "0644"
}
