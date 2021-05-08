variable "app" {
  type        = string
  description = "app name"
  default     = ""
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

variable "ssl_web_prefix" {
  type        = string
  description = "HTTPS web prefix"
  default     = ""
}

variable "cluster_name" {
  description = "The cluster_name"
}

variable "container_name" {
  description = "The container name"
}

variable "repository_url" {
  description = "The ecr URI"
}

variable "db_endpoint" {
  description = "RDS Host name"
}

variable "image_tag" {
  description = "The container image"
}

variable "vpc_id" {
  type        = string
  description = "The VPC id"
}

variable "app_repository_name" {
  description = "Name of ECR Repository"
}

variable "repository_name" {
  description = "Full name of ECR Repository"
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

variable "desired_tasks" {
  description = "Number of containers desired to run the application task"
}

variable "desired_task_cpu" {
  description = "Task CPU Limit"
}

variable "desired_task_memory" {
  description = "Task Memory Limit"
}

variable "min_tasks" {
  description = "Minimum"
}

variable "max_tasks" {
  description = "Maximum"
}

variable "cpu_to_scale_up" {
  description = "CPU % to Scale Up the number of containers"
}

variable "cpu_to_scale_down" {
  description = "CPU % to Scale Down the number of containers"
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

variable "subnet_ids" {
  type    = string
  default = "module.vpc.aws_subnet.public.*.id"
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

variable "ASANA_SECRET_KEY" {
  description = "secret key"
  default     = ""
}

variable "WORDPRESS_SECRET_KEY" {
  description = "WP secret"
  default     = ""
}
