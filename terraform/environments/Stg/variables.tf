variable "app" {
  type = map
  default = {
    name = "zz"
    env  = "stg"
  }
}

variable "availability_zones" {
  type = list
  default = [
    "us-east-1a", 
    "us-east-1b",
  ]
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "network" {
  type = map
  default = {
    cidr       = "10.100.96.0/20"
    publicAz1  = "10.100.96.0/22"
    publicAz2  = "10.100.100.0/22"
    privateAz1 = "10.100.104.0/22"
    privateAz2 = "10.100.108.0/22"
  }
}

variable "certificate_arn" {
  type = string
  default = "arn:aws:acm:us-east-1:667736119737:certificate/8a4cdeec-e44c-42c0-b4ce-c1d2dc12f657"
}

variable "domain" {
  type = string
  default = "nana808test.com"
}

variable "ssl_cert" {
  type = string
  default = "nana808test.com"
}

variable "node_volume_size" {
  type = string
  default = "10"
}

variable "node_instance_type" {
  type = string
  default = "t2.large"
}

variable "nosql_volume_size" {
  type = string
  default = "10"
}

variable "nosql_instance_type" {
  type = string
  default = "t2.large"
}

variable "nat_count" {
  type = string
  default = "1"
}

variable "escluster_instance_count" {
  type = string
  default = "2"
}

variable "escluster_instance_type" {
  type = string
  default = "t2.medium.elasticsearch"
}

variable "helth_check_path" {
  type        = string
  description = "target group helth check path"
  default     = ""
}

variable "desired_tasks" {
  type        = number
  description = "number of containers desired to run app task"
  default     = ""
}

variable "min_tasks" {
  type        = number
  description = "minimum"
  default     = ""
}

variable "max_tasks" {
  type        = number
  description = "maximum"
  default     = ""
}

variable "cpu_to_scale_up" {
  type        = number
  description = "cpu % to scale up the number of containers"
  default     = ""
}

variable "cpu_to_scale_down" {
  type        = number
  description = "cpu % to scale down the number of containers"
  default     = ""
}

variable "desired_task_cpu" {
  type        = string
  description = "desired cpu to run your tasks"
  default     = ""
}

variable "desired_task_memory" {
  type        = string
  description = "desired memory to run your tasks"
  default     = ""
}

variable "build_options" {
  type        = string
  default     = ""
  description = "Docker build options. ex: '-f ./build/Dockerfile' "
}

variable "build_args" {
  description = "docker build args."
  type        = map(string)
  default     = {}
}

variable "image" {
  description = "The container image"
  type        = string
  default     = ""
}

variable "repository_name" {
  description = "Full name of ECR Repository"
  default     = ""
}

variable "container_name" {
  type        = string
  description = "container app name"
  default     = ""
}

variable "s3-bucket" {
  type        = string
  description = "staging s3-bucket name"
  default     = ""
}

variable "pipeline_s3_arn" {
  description = "The s3 pipeline arn"
  default     = ""
}

variable "db_endpoint" {
  description = "RDS Host name"
  default     = ""
}

variable "repository_url" {
  description = "The url of the ECR repository"
  default     = ""
}

variable "app_service_name" {
  description = "Service name"
  default     = ""
}

variable "alb_port" {
  type        = string
  description = "origin application load balancer port"
  default     = ""
}

variable "environment_variables" {
  type        = map(string)
  description = "ecs task environment variables"

  default = {
    SQL_DB_NAME = "sleestak",
    SQL_PORT = "3306",
  }
}