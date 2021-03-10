output "vpc_id" {
  value       = var.vpc_id
  description = "vpc id."
}

output "vpc_network" {
  value       = var.network
  description = "vpc id."
}

output "vpc_public_subnet_ids" {
  value       = var.public_subnets
  description = "List of IDs of VPC public subnets."
}

output "vpc_private_subnet_ids" {
  value       = var.private_subnets
  description = "List of IDs of VPC private subnets."
}

output "ecs_repository_url" {
  value       = module.ecs.repository_url
  description = "URL of ECR with build artifacts."
}

output "app_sg_id" {
  value       = module.ecs.app_sg_id
  description = "ID of application security group. (ALB and ECS adapted)"
}

output "alb_sg_id" {
  value       = module.ecs.alb_sg_id
  description = "ID of ALB security group."
}

output "ecs_sg_id" {
  value       = module.ecs.ecs_sg_id
  description = "ID of ECS security group."
}

output "cloudwatch_log_group_arn" {
  value       = module.ecs.cloudwatch_log_group_arn
  description = "ARN of ecs cloudwatch log group."
}

output code_pipeline_artifact_s3_id {
  value       = module.pipeline.pipeline_s3_id
  description = "ID of s3 bucket for code pipeline artifact store."
}

output code_pipeline_id {
  value       = module.pipeline.pipeline_id
  description = "ID of code pipeline."
}

output "enable_custom_domain" {
  value       = module.ecs.enable_custom_domain
  description = "Bool value of domain is valid or not."
}

output "enable_ssl" {
  value       = module.ecs.enable_ssl
  description = "Bool value of ssl is valid or not."
}

output "alb_dns_name" {
  value       = module.ecs.alb_dns_name
  description = "DNS address linked to ALB. (automatically)"
}

output "availability_zones" { value = "${var.availability_zones}" }
output "certificate_arn" { value = "${var.certificate_arn}" }
output "region" { value = "${var.region}" }
#output "network" { value = "${var.network}" }
output "ami_id" { value = "${var.ami_id}" }
#output "vpc_id" { value = "${var.vpc_id}" }
output "app" { value = "${var.app}" }
output "node_volume_size" { value = "${var.node_volume_size}" }
output "node_instance_type" { value = "${var.node_instance_type}" }
output "nosql_volume_size" { value = "${var.nosql_volume_size}" }
output "nosql_instance_type" { value = "${var.nosql_instance_type}" }
output "nat_count" { value = "${var.nat_count}" }
output "escluster_instance_type" { value = "${var.escluster_instance_type}" }
output "escluster_instance_count" { value = "${var.escluster_instance_count}" }