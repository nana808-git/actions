output "vpc_id" {
  value       = var.vpc_id
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