output "vpc_id" {
  value       = "aws_vpc.main.id"
  description = "vpc id."
}

output "vpc_public_subnet_ids" {
  value       = "aws_subnet.public.*.id"
  description = "List of IDs of VPC public subnets."
}

output "vpc_private_subnet_ids" {
  value       = "aws_subnet.private.*.id"
  description = "List of IDs of VPC private subnets."
}
