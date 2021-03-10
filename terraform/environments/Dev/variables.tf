variable "app" {
  type = "map"
  default = {
    name = "ss"
    env  = "dev"
  }
}

variable "availability_zones" {
  type = "list"
  default = [
    "us-east-1a", 
    "us-east-1b",
  ]
}

variable "region" {
  type = "string"
  default = "us-east-1"
}

variable "network" {
  type = "map"
  default = {
    cidr       = "10.100.80.0/20"
    publicAz1  = "10.100.80.0/22"
    publicAz2  = "10.100.84.0/22"
    privateAz1 = "10.100.88.0/22"
    privateAz2 = "10.100.92.0/22"
  }
}

variable "ami_id" {
  type = "string"
  default = "ami-05170f6170a3069ac"
}

variable "certificate_arn" {
  type = "string"
  default = "arn:aws:acm:us-east-1:667736119737:certificate/8a4cdeec-e44c-42c0-b4ce-c1d2dc12f657"
}

variable "node_volume_size" {
  type = "string"
  default = "10"
}

variable "node_instance_type" {
  type = "string"
  default = "t2.large"
}

variable "nosql_volume_size" {
  type = "string"
  default = "10"
}

variable "nosql_instance_type" {
  type = "string"
  default = "t2.large"
}

variable "nat_count" {
  type = "string"
  default = "1"
}

variable "escluster_instance_count" {
  type = "string"
  default = "2"
}

variable "escluster_instance_type" {
  type = "string"
  default = "t2.medium.elasticsearch"
}

output "availability_zones" { value = "${var.availability_zones}" }
output "certificate_arn" { value = "${var.certificate_arn}" }
output "region" { value = "${var.region}" }
output "network" { value = "${var.network}" }
output "ami_id" { value = "${var.ami_id}" }
output "app" { value = "${var.app}" }
output "node_volume_size" { value = "${var.node_volume_size}" }
output "node_instance_type" { value = "${var.node_instance_type}" }
output "nosql_volume_size" { value = "${var.nosql_volume_size}" }
output "nosql_instance_type" { value = "${var.nosql_instance_type}" }
output "nat_count" { value = "${var.nat_count}" }
output "escluster_instance_type" { value = "${var.escluster_instance_type}" }
output "escluster_instance_count" { value = "${var.escluster_instance_count}" }
