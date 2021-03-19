output "availability_zones" { value = "var.availability_zones" }
output "certificate_arn" { value = "var.certificate_arn" }
output "region" { value = "var.region" }
output "network" { value = "var.network" }
output "ami_id" { value = "var.ami_id" }
output "vpc_id" { value = "aws_vpc.vpc.id" }
output "public_subnet_ids" { value = "var.public_subnet_ids" }
output "private_subnet_ids" { value = "aws_subnet.private.ids" }
output "public_subnets" { value = "aws_subnet.private.ids" }
output "private_subnets" { value = "var.private_subnet_ids" }
output "app" { value = "var.app" }
output "node_volume_size" { value = "var.node_volume_size" }
output "node_instance_type" { value = "var.node_instance_type" }
output "nosql_volume_size" { value = "var.nosql_volume_size" }
output "nosql_instance_type" { value = "var.nosql_instance_type" }
output "nat_count" { value = "var.nat_count" }
output "escluster_instance_type" { value = "var.escluster_instance_type" }
output "escluster_instance_count" { value = "var.escluster_instance_count" }