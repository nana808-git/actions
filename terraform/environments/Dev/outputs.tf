#output "availability_zones" { value = "var.availability_zones" }
#output "certificate_arn" { value = "var.certificate_arn" }
#output "region" { value = "var.region" }
#output "network" { value = "var.network" }
#output "ami_id" { value = "var.ami_id" }
#output "vpc_id" { value = "module.vpc.aws_vpc.vpc.id" }
#output "cidr_block" { value = "module.vpc.aws_vpc.vpc.cidr_block" }
#output "public_subnet_ids" { value = "module.vpc.aws_subnet.public[*].id" }
#output "private_subnet_ids" { value = "module.vpc.aws_subnet.private[*].id" }
#output "public_subnets" { value = "module.vpc.aws_subnet.public[*].cidr_block" }
#output "private_subnets" { value = "module.vpc.aws_subnet.private[*].cidr_block" }
#output "app" { value = "var.app" }
#output "node_volume_size" { value = "var.node_volume_size" }
#output "node_instance_type" { value = "var.node_instance_type" }
#output "nosql_volume_size" { value = "var.nosql_volume_size" }
#output "nosql_instance_type" { value = "var.nosql_instance_type" }
#output "nat_count" { value = "var.nat_count" }
#output "escluster_instance_type" { value = "var.escluster_instance_type" }
#output "escluster_instance_count" { value = "var.escluster_instance_count" }




output "vpc_id" {
  value = "module.vpc.aws_vpc.vpc.id"
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