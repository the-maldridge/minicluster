module "aio_metadata" {
  source = "../terraform-local-metadata"

  cluster_tag = "minicluster"
  base_path = "${path.module}/metadata/aio"
  secret_provider = "insecure"

  consul_server = true
  consul_retry_join = ["node1", "node2", "node3"]
  consul_datacenter = "minicluster"
}

data "linuxkit_metadata" "aio" {
  base_path = "${path.module}/metadata/aio"
}

resource "local_file" "aio_metadata" {
  for_each = toset([
    "00-23-24-5B-85-92",
    "00-23-24-6C-68-5C",
    "00-23-24-79-02-CB",
  ])

  content  = data.linuxkit_metadata.aio.json
  filename = "${path.root}/metaldata_data/${each.value}.userdata"

  file_permission = "0644"
}

data "linuxkit_metadata" "worker" {
  base_path = "${path.module}/metadata/worker"
}

resource "local_file" "worker_metadata" {
  for_each = toset([
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
