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


variable "container_name" {
  description = "Container name"
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
