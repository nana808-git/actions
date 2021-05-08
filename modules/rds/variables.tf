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

variable "db_instance_type" {
  description = "RDS instance type"
  default     = ""
}

variable "backup_retention_period" {
  description = "RDS instance backup retention period"
  default     = ""
}

variable "backup_window" {
  description = "RDS instance backup window"
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


variable "db_engine" {
  description = "RDS DB engine"
  default     = ""
}

variable "db_allocated_storage" {
  description = "RDS DB allocated_storage"
  default     = ""
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


variable "vpc_id" {
  type        = string
  description = "vpc for provisioning resources"
}

variable "environment" {
  type        = string
  description = "which environment"
  default     = ""
}

variable "cidr" {
  type        = list(string)
  description = "vpc cidr block"
}

variable "subnet_ids" {
  type        = list(string)
  description = "vpc subnet cidr block"
}

