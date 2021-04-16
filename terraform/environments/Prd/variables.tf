variable "app" {
  type = map
  default = {
    name = "ss"
    env  = "prd"
  }
}

variable "availability_zones" {
  type = list
  default = [
    "us-east-2a", 
    "us-east-2b",
  ]
}

variable "region" {
  type = string
  default = "us-east-2"
}

variable "network" {
  type = map
  default = {
    cidr       = "10.100.208.0/20"
    publicAz1  = "10.100.208.0/22"
    publicAz2  = "10.100.212.0/22"
    privateAz1 = "10.100.216.0/22"
    privateAz2 = "10.100.220.0/22"
  }
}

variable "certificate_arn" {
  type = string
  default = "arn:aws:iam::710789462061:server-certificate/Star_dtmediagrp.com"
}

variable "cloudfront_certificate_id" {
  type = string
  default = "ASCA2K7S2PAWRMDVOM4LW"
}

variable "domain" {
  type = string
  default = "dtmediagrp.com"
}

variable "ssl_cert" {
  type = string
  default = "*.dtmediagrp.com"
}

variable "node_volume_size" {
  type = string
  default = "10"
}

variable "node_instance_type" {
  type = string
  default = "t2.large"
}

variable "nosql_volume_size" {
  type = string
  default = "10"
}

variable "nosql_instance_type" {
  type = string
  default = "t2.large"
}

variable "nat_count" {
  type = string
  default = "1"
}

variable "escluster_instance_count" {
  type = string
  default = "2"
}

variable "escluster_instance_type" {
  type = string
  default = "t2.medium.elasticsearch"
}