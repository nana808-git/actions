variable "network" {
  type = map
}

variable "app" {
  type = map
}

variable "availability_zones" {
  type = list
}

variable "nat_count" {
  type    = string
  default = "1"
}

variable "vpc_peering_connection_id" {
  type        = string
  description = "vpc peering vpc_peering_connection_id"
}

variable "peered_cidr" {
  type        = string
  description = "vpc peering peered vpc cidr"
}
