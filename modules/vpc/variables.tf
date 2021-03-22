variable "network" {
  type = "map"
}

variable "app" {
  type = "map"
}

variable "availability_zones" {
  type = "list"
}

variable "nat_count" {
  type    = "string"
  default = "1"
}