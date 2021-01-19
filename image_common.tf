data "linuxkit_kernel" "kernel" {
  image   = "linuxkit/kernel:5.6.11"
  cmdline = "console=tty0 console=ttyS0 console=ttyAMA0"
}

data "linuxkit_init" "init" {
  containers = [
    "linuxkit/init:v0.8",
    "linuxkit/runc:v0.8",
    "linuxkit/containerd:v0.8",
    "linuxkit/ca-certificates:v0.8",
  ]
}

data "linuxkit_image" "sysctl" {
  name  = "sysctl"
  image = "linuxkit/sysctl:v0.8"
}

data "linuxkit_image" "rngd1" {
  name    = "rngd1"
  image   = "linuxkit/rngd:v0.8"
  command = ["/sbin/rngd", "-1"]
}

data "linuxkit_image" "getty" {
  name  = "getty"
  image = "linuxkit/getty:v0.8"
  env   = ["INSECURE=true"]
}

data "linuxkit_image" "rngd" {
  name  = "rngd"
  image = "linuxkit/rngd:v0.8"
}

data "linuxkit_image" "dhcp_boot" {
  name    = "dhcpcd_boot"
  image   = "linuxkit/dhcpcd:v0.8"
  command = ["/sbin/dhcpcd", "-f", "/dhcpcd.conf", "-1", "-4"]
}

data "linuxkit_image" "dhcpcd" {
  name  = "dhcpcd"
  image = "linuxkit/dhcpcd:v0.8"
}

data "linuxkit_image" "metadata" {
  name    = "metadata"
  image   = "linuxkit/metadata:2cf1db0f0d2c9916b4894318bd76f1c97d8c8f7b"
  command = ["/usr/bin/metadata", "metaldata"]
}
