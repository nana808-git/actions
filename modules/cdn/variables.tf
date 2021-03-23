variable "app" {
  type = map
  default = {}
}

variable "availability_zones" {
  type = list
  default = []
}

variable "region" {
  type = string
  default = ""
}

variable "network" {
  type = map
  default = {}
}

variable "cluster_name" {
  description = "The cluster_name"
}

variable "vpc_id" {
  type        = string
  description = "The VPC id"
}

variable "app_repository_name" {
  description = "Name of ECR Repository"
}

variable "environment" {
  description = "which environment"
}

variable "alb_port" {
  description = "ALB listener port"
}

variable "container_port" {
  description = "ALB target port"
}


variable "helth_check_path" {
  description = ""
  default     = "/"
}

variable "environment_variables" {
  type        = map(string)
  description = "ecs task environment variables"
}

variable "ssl_certificate_arn" {
  type        = string
  description = "ssl certification arn"
  default     = ""
}

variable "domain_name" {
  type    = string
  default = ""
}

variable "alb_dns_name" {
  type    = string
  default = ""
}

