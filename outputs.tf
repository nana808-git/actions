output "vpc_id" {
  value = "var.vpc_id"
}

output "vpc_cidr" {
  value = "module.vpc.aws_vpc.vpc.cidr_block"
}

output "public_subnets" {
  value = "module.vpc.aws_subnet.public[*].cidr_block"
}

output "private_subnets" {
  value = "module.vpc.aws_subnet.private[*].cidr_block"
}

output "public_subnet_ids" {
  value = "module.vpc.aws_subnet.public[*].id"
}

output "private_subnet_ids" {
  value = "module.vpc.aws_subnet.private[*].id"
}

output "repository_name" {
  value = module.ecs.repository_name
}

output "ecs_repository_url" {
  value       = module.ecs.repository_url
  description = "URL of ECR with build artifacts."
}

#output "lb_arn" {
#  value = aws_lb.app_nlb.arn
#}

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



