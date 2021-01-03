variable "subnet" {
  type        = string
  description = "Subnet of the minicluster"
  default     = "192.168.32.0/24"
}

variable "matchbox_domain" {
  type        = string
  description = "Matchbox domain"
  default     = "bootmaster.lan"
}
