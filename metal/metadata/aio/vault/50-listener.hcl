listener "tcp" {
  address = "0.0.0.0:8200"

  tls_cert_file = "/run/config/step/node.crt"
  tls_key_file = "/run/config/step/node.key"
  
  telemetry {
    unauthenticated_metrics_access = true
    promtheus_retention_time = "240s"
  }
}
