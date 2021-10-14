resource "docker_image" "netauthd" {
  name = "ghcr.io/netauth/netauthd:v0.5.0"
}

resource "docker_container" "netauthd" {
  name  = "netauthd"
  image = docker_image.netauthd.latest

  command = [
    "--tls.PWN_ME",
    "--server.bootstrap=admin:password",
  ]

  volumes {
    container_path = "/config.toml"
    host_path      = abspath(join("/", [path.root, "netauth", "config.toml"]))
  }

  volumes {
    container_path = "/netauth"
    host_path      = abspath(join("/", [path.root, "netauth"]))
  }

  ports {
    internal = 1729
    external = 1729
  }

  restart  = "always"
  start    = true
  must_run = true
}

resource "docker_image" "netauth_ldap" {
  name = "ghcr.io/netauth/ldap:v0.2.3"
}

resource "docker_container" "netauth_ldap" {
  name  = "ldap"
  image = docker_image.netauth_ldap.latest

  volumes {
    container_path = "/config.toml"
    host_path      = abspath(join("/", [path.root, "netauth", "config.toml"]))
  }

  volumes {
    container_path = "/netauth"
    host_path      = abspath(join("/", [path.root, "netauth"]))
  }

  ports {
    internal = 389
    external = 389
  }

  restart  = "always"
  start    = true
  must_run = true
}
