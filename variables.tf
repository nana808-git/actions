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

variable "public_subnets" {
  type        = list(string)
  description = "public subnet array (length>=2)"
}

variable "private_subnets" {
  type        = list(string)
  description = "public subnet array (length>=2)"
}

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
  #default = "arn:aws:codestar-connections:us-west-1:710789462061:connection/024d34e3-7643-4ffe-ab6a-93053546f46f"
  default = ""
}

variable "app" {
  type = "map"
  default = {
    name = "cc"
    env  = "dev"
  }
}

variable "availability_zones" {
  type = "list"
  default = [
    "us-east-1a", 
    "us-east-1b",
  ]
}

variable "region" {
  type = "string"
  default = "us-east-1"
}

variable "network" {
  type = "map"
  default = {
    cidr       = "10.100.80.0/20"
    publicAz1  = "10.100.80.0/22"
    publicAz2  = "10.100.84.0/22"
    privateAz1 = "10.100.88.0/22"
    privateAz2 = "10.100.92.0/22"
  }
}

variable "ami_id" {
  type = "string"
  default = "ami-05170f6170a3069ac"
}

variable "certificate_arn" {
  type = "string"
  default = "arn:aws:acm:us-east-1:667736119737:certificate/8a4cdeec-e44c-42c0-b4ce-c1d2dc12f657"
}

variable "node_volume_size" {
  type = "string"
  default = "10"
}

variable "node_instance_type" {
  type = "string"
  default = "t2.large"
}

variable "nosql_volume_size" {
  type = "string"
  default = "10"
}

variable "nosql_instance_type" {
  type = "string"
  default = "t2.large"
}

variable "nat_count" {
  type = "string"
  default = "1"
}

variable "escluster_instance_count" {
  type = "string"
  default = "2"
}

variable "escluster_instance_type" {
  type = "string"
  default = "t2.medium.elasticsearch"
}

output "availability_zones" { value = "${var.availability_zones}" }
output "certificate_arn" { value = "${var.certificate_arn}" }
output "region" { value = "${var.region}" }
output "network" { value = "${var.network}" }
output "ami_id" { value = "${var.ami_id}" }
output "app" { value = "${var.app}" }
output "node_volume_size" { value = "${var.node_volume_size}" }
output "node_instance_type" { value = "${var.node_instance_type}" }
output "nosql_volume_size" { value = "${var.nosql_volume_size}" }
output "nosql_instance_type" { value = "${var.nosql_instance_type}" }
output "nat_count" { value = "${var.nat_count}" }
output "escluster_instance_type" { value = "${var.escluster_instance_type}" }
output "escluster_instance_count" { value = "${var.escluster_instance_count}" }


