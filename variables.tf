variable "env_name" {
  type        = string
  description = "which environment"
  default     = ""
}

variable "cluster_name" {
  type        = string
  description = "ecs cluster name"
  default     = ""
}

variable "image" {
  description = "The container image"
  type        = string
  default     = ""
}

variable "vpc_id" {
  type        = string
  description = "vpc for provisioning resources"
}

#variable "public_subnets" {
#  type        = list(string)
#  description = "public subnet array (length>=2)"
#}

#variable "private_subnets" {
#  type        = list(string)
#  description = "public subnet array (length>=2)"
#}

variable "alb_port" {
  type        = string
  description = "origin application load balancer port"
}

variable "container_port" {
  type        = string
  description = "destination application load balancer port"
}

variable "app_repository_name" {
  type        = string
  description = "ecr repository name"
  default     = ""
}

variable "container_name" {
  type        = string
  description = "container app name"
  default     = ""
}

variable "environment" {
  type        = string
  description = "which environment"
  default     = ""
}

variable "git_repository" {
  type        = map(string)
  description = "git repository. It must contain the following key: owner, name, branch"
}

variable "helth_check_path" {
  type        = string
  description = "target group helth check path"
  default     = "/"
}

variable "desired_tasks" {
  type        = number
  description = "number of containers desired to run app task"
  default     = 2
}

variable "min_tasks" {
  type        = number
  description = "minimum"
  default     = 2
}

variable "max_tasks" {
  type        = number
  description = "maximum"
  default     = 4
}

variable "cpu_to_scale_up" {
  type        = number
  description = "cpu % to scale up the number of containers"
  default     = 80
}

variable "cpu_to_scale_down" {
  type        = number
  description = "cpu % to scale down the number of containers"
  default     = 30
}

variable "desired_task_cpu" {
  type        = string
  description = "desired cpu to run your tasks"
  default     = "256"
}

variable "desired_task_memory" {
  type        = string
  description = "desired memory to run your tasks"
  default     = "512"
}

variable "environment_variables" {
  type        = map(string)
  description = "ecs task environment variables"

  default = {
    KEY = "value"
  }
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

variable "ssl_certificate_arn" {
  type        = string
  description = "ssl certification arn"
  default     = ""
}

variable "domain_name" {
  description = "domain name. (must be created in route53)"
  type        = string
  default     = ""
}

variable "codestar_connector_credentials" {
  type = string
  default = ""
}

variable "availability_zones" {
  type = "list"
  default = [
    "", 
    "",
  ]
}

variable "region" {
  type = "string"
  default = ""
}

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

variable "public_subnets" {
  type = "map"
  default = {
    publicAz1  = "10.100.80.0/22"
    publicAz2  = "10.100.84.0/22"
  }
}

variable "private_subnets" {
  type = "map"
  default = {
    privateAz1 = "10.100.88.0/22"
    privateAz2 = "10.100.92.0/22"
  }
}

#variable "public_subnets" {
#  type = "map"
#  default = {
#    publicAz1  = ""
#    publicAz2  = ""
#  }
#}

#variable "private_subnets" {
#  type = "map"
#  default = {
#    privateAz1 = ""
#    privateAz2 = ""
#  }
#}

variable "app" {
  type = "map"
  default = {
    name = ""
    env  = ""
  }
}

variable "ami_id" {
  type = "string"
  default = ""
}

variable "certificate_arn" {
  type = "string"
  default = ""
}

variable "node_volume_size" {
  type = "string"
  default = ""
}

variable "node_instance_type" {
  type = "string"
  default = ""
}

variable "nosql_volume_size" {
  type = "string"
  default = ""
}

variable "nosql_instance_type" {
  type = "string"
  default = ""
}

variable "nat_count" {
  type = "string"
  default = ""
}

variable "escluster_instance_count" {
  type = "string"
  default = ""
}

variable "escluster_instance_type" {
  type = "string"
  default = ""
}

variable "public_subnet_ids" {
  type = "list"
}

variable "private_subnet_ids" {
  type = "list"
}
