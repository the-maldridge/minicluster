resource "docker_image" "step_certificates" {
  name = "smallstep/step-ca:0.20.0"
}

resource "docker_volume" "step_certificates" {
  name = "step-data"
}

resource "docker_container" "step_certificates" {
  name  = "step-ca"
  image = docker_image.step_certificates.latest

  volumes {
    container_path = "/home/step"
    volume_name    = docker_volume.step_certificates.name
  }

  env = [
    "DOCKER_STEPCA_INIT_NAME=minicluster trust services",
    "DOCKER_STEPCA_INIT_DNS_NAMES=bootmaster.lan",

    # Yes, you have found a password, it will let you grant certs
    # against the minicluster.  Since this entire environment is meant
    # to be duplicable as a learning excersize, passwords are not
    # obscured in this repo and are clearly called out.
    "DOCKER_STEPCA_INIT_PASSWORD=password",
  ]

  network_mode = "host"

  restart  = "always"
  start    = true
  must_run = true
}

# Once  you  apply  this  terraform,  you  have  to  enable  the  ACME
# provisioner with the following command:
#
# $ docker exec step-ca step ca provisioner add acme --type ACME`
