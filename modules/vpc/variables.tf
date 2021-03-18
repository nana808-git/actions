variable "region" {
  description = "The region"
  type        = string
  default     = ""
}

variable "public_subnets" {
  type        = list(string)
  description = "public subnet array (length>=2)"
}

variable "private_subnets" {
  type        = string
  description = "private subnet array (length>=2)"
}

variable "cluster_name" {
  type        = string
  description = "ecs cluster name"
  default     = ""
}

variable "environment" {
  type        = string
  description = "which environment"
  default     = ""
}

variable "cidr" {
  type        = string
  description = "vpc cidr block"
}

