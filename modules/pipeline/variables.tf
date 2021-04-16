variable "app" {
  type        = string
  description = "app name"
  default     = ""
}

variable "domain_name" {
  type    = string
  default = ""
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

variable "image" {
  description = "The container image"
}

variable "app_repository_name" {
  description = "ECR Repository name"
}

variable "app_service_name" {
  description = "Service name"
}

variable "git_repository" {
  type        = map(string)
  description = "ecs task environment variables"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "security_group" {
  type        = set(string)
  description = "security group"
  #default     = ""
}

variable "environment" {
  description = "which environment"
}

variable "repository_url" {
  description = "The url of the ECR repository"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet ids"
}

variable "environment_variables" {
  type        = map(string)
  description = "ecs task environment variables"
}

variable "container_name" {
  description = "Container name"
}

variable "db_endpoint" {
  description = "RDS Host name"
}

variable "build_args" {
  type    = map(string)
  default = {}
}

variable "build_options" {
  type        = string
  default     = ""
  description = "Docker build options. ex: '-f ./build/Dockerfile' "
}

variable "codestar_connector_credentials" {
  type = string
}

variable "codepipeline_events_enabled" {
  default = false
}

variable "ssm_allowed_parameters" {
  description = "List of ssm parameters that can be acceesed by the Fargate task during execution. Could be an ARN or just the name of the parameter path prefix"
  default     = ""
}

variable "repository_name" {
  description = "Full name of ECR Repository"
}

variable "JUNGLESCOUT_USERNAME" {
  description = "RDS JS username"
  default     = ""
}

variable "JUNGLESCOUT_PASSWORD" {
  description = "RDS JS password"
  default     = ""
}

variable "SQL_DB_USER" {
  description = "RDS DB user"
  default     = ""
}

variable "SQL_DB_PASSWORD" {
  description = "RDS DB password"
  default     = ""
}

variable "APP_WEB_URL" {
  description = "staging site"
  default     = ""
}

variable "WORDPRESS_SECRET_KEY" {
  description = "WP secret"
  default     = ""
}

variable "ssl_web_prefix" {
  type        = string
  description = "HTTPS web prefix"
  default     = ""
}

variable "s3-bucket" {
  type        = string
  description = "staging s3-bucket name"
  default     = ""
}