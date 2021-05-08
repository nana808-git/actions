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

variable "app" {
  type        = string
  description = "app name"
  default     = ""
}

variable "helth_check_path" {
  description = ""
  default     = "/"
}

variable "ssl_certificate_id" {
  type        = string
  description = "ssl certification id"
  default     = ""
}

variable "ssl_cert" {
  type = string
  default = ""
}

variable "domain_name" {
  type    = string
  default = ""
}

variable "alb_dns_name" {
  type    = string
  default = ""
}

variable "cloudfront_ssl" {
  type        = string
  description = "ssl cloudfront arn"
  default     = ""
}