variable "db_instance_type" {
  description = "RDS instance type"
  default     = ""
}

variable "db_name" {
  description = "RDS DB name"
  default     = ""
}

variable "db_port" {
  description = "RDS DB port"
  default     = ""
}

variable "db_version" {
  description = "RDS DB version"
  default     = ""
}

variable "db_user" {
  description = "RDS DB username"
  default     = ""
}

variable "db_engine" {
  description = "RDS DB engine"
  default     = ""
}

variable "db_allocated_storage" {
  description = "RDS DB allocated_storage"
  default     = ""
}


variable "db_password" {
  description = "RDS DB password"
}

variable "db_profile" {
  description = "RDS Profile"
  default     = ""
}

variable "db_initialize" {
  description = "RDS initialize"
  default     = ""
}

variable "cluster_name" {
  type        = string
  description = "ecs cluster name"
  default     = ""
}

variable "region" {
  description = "The region"
  type        = string
  default     = ""
}

variable "vpc_id" {
  type        = string
  description = "vpc for provisioning resources"
}

variable "environment" {
  type        = string
  description = "which environment"
  default     = ""
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet ids"
}