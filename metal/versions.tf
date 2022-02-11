terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
    linuxkit = {
      source  = "resinstack/linuxkit"
      version = "0.0.7"
    }
  }
  required_version = ">= 0.13"
}
