resource "tls_private_key" "ca" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "ca" {
  key_algorithm   = tls_private_key.ca.algorithm
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name         = "MiniCluster Trust Services"
    organization        = "p0rtalNet"
    organizational_unit = "Garage Innovation Division"
  }

  validity_period_hours = 24 * 365

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  is_ca_certificate = true
}

resource "tls_private_key" "matchbox" {
  algorithm = "RSA"
}

resource "tls_cert_request" "matchbox" {
  key_algorithm   = tls_private_key.matchbox.algorithm
  private_key_pem = tls_private_key.matchbox.private_key_pem

  subject {
    common_name = "bootmaster.lan"
  }

  dns_names = ["bootmaster.lan"]
}

resource "tls_locally_signed_cert" "matchbox" {
  cert_request_pem   = tls_cert_request.matchbox.cert_request_pem
  ca_key_algorithm   = tls_private_key.ca.algorithm
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = 24 * 365

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "tls_private_key" "matchbox_terraform" {
  algorithm = "RSA"
}

resource "tls_cert_request" "matchbox_terraform" {
  key_algorithm   = tls_private_key.matchbox_terraform.algorithm
  private_key_pem = tls_private_key.matchbox_terraform.private_key_pem

  subject {
    common_name = "terraform"
  }
}

resource "tls_locally_signed_cert" "matchbox_terraform" {
  cert_request_pem   = tls_cert_request.matchbox_terraform.cert_request_pem
  ca_key_algorithm   = tls_private_key.ca.algorithm
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = 24 * 365

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth",
  ]
}

resource "local_file" "matchbox_ca_cert" {
  content  = tls_self_signed_cert.ca.cert_pem
  filename = "${path.module}/matchbox/etc/ca.crt"

  file_permission      = "0644"
  directory_permission = "0755"
}

resource "local_file" "matchbox_cert" {
  content  = tls_locally_signed_cert.matchbox.cert_pem
  filename = "${path.module}/matchbox/etc/server.crt"

  file_permission      = "0644"
  directory_permission = "0755"
}

resource "local_file" "matchbox_key" {
  content  = tls_private_key.matchbox.private_key_pem
  filename = "${path.module}/matchbox/etc/server.key"

  file_permission      = "0644"
  directory_permission = "0755"
}

