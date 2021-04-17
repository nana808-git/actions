output "repository_url" {
  value = aws_ecr_repository.web-app.repository_url
}

output "repository_name" {
  value = aws_ecr_repository.web-app.name
}

output "service_name" {
  value = aws_ecs_service.web-api.name
}

output "app_sg_id" {
  value = aws_security_group.app_sg.id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id
}

output "cloudwatch_log_group_arn" {
  value = aws_cloudwatch_log_group.web-app.arn
}

output "enable_custom_domain" {
  value = local.can_domain
}

output "enable_ssl" {
  value = local.can_ssl
}

output "alb_dns_name" {
  value = aws_alb.app_alb.dns_name
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS Cluster"
  value       = aws_ecs_cluster.cluster.arn
}

output "ecr_repository_arns" {
  description = "List of ARNs of ECR repositories"
  value       = aws_ecr_repository.web-app.*.arn
}

output "ecr_repository_urls" {
  description = "List of URLs of ECR repositories"
  value       = aws_ecr_repository.web-app.*.repository_url
}

