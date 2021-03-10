variable "cluster_name" {
  description = "The cluster_name"
}

variable "container_name" {
  description = "The container name"
}

variable "image" {
  description = "The container image"
}

variable "env_name" {
  description = "which environment"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "availability_zones" {
  type        = list(string)
  description = "The azs to use"
}

//variable "public_subnets" {
//  description = "Public Subnet array"
//}

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

variable "app" {
  type = "map"
  default = {
    name = ""
    env  = ""
  }
}

#variable "availability_zones" {
#  type = "list"
#  default = [
#    "", 
#    "",
#  ]
#}

variable "network" {
  type = "map"
  default = {
    cidr       = ""
    publicAz1  = ""
    publicAz2  = ""
    privateAz1 = ""
    privateAz2 = ""
  }
}

