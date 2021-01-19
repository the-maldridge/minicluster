data "linuxkit_metadata" "aio" {
  base_path = "${path.module}/metadata/aio"
}

resource "local_file" "aio_metadata" {
  for_each = toset(["00-23-24-5B-85-92", "00-23-24-6C-68-5C", "00-23-24-79-02-CB"])

  content  = data.linuxkit_metadata.aio.json
  filename = "${path.root}/metaldata_data/${each.value}.userdata"

  file_permission = "0644"
}
