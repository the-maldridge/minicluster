vault {
  address = "https://node1.lan:8200"
  ca_cert = "/run/config/step/root_ca.crt"
}

auto_auth {
  method {
    type = "cert"
    mount_path = "auth/resin_fleet"

    config = {
      ca_cert = "/run/config/step/root_ca.crt"
      client_cert = "/run/config/step/node.crt"
      client_key = "/run/config/step/node.key"
    }
  }

  sink {
    type = "file"

    config = {
      path = "/tmp/.host-token"
    }
  }
}
