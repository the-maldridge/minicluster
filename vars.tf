variable "subnet" {
  type        = string
  description = "Subnet of the minicluster"
  default     = "192.168.32.0/24"
}

variable "shoelaces_host" {
  type        = string
  description = "Hostname of the shoelaces host"
  default     = "bootmaster.lan"
}
