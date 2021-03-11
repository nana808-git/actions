variable "cluster_name" {
  description = "The cluster_name"
}

variable "env_name" {
  description = "which environment"
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

variable "region" {
  description = "The region to use"
  default     = "us-west-1"
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
  #default = "arn:aws:codestar-connections:us-west-1:710789462061:connection/024d34e3-7643-4ffe-ab6a-93053546f46f"
}