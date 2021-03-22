output "id" { 
  value = "${aws_vpc.vpc.id}" 
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public.*.id}"] 
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private.*.id}"] 
}

output "default_security_group_id" {
  value = "${aws_security_group.main.id}" 
}

output "private_route_tables" {
  value = ["${aws_route_table.private.*.id}"] 
}

output "public_route_table" {
  value = "${aws_route_table.public.id}" 
}

output "zone_id" {
  value = "${aws_route53_zone.main.zone_id}"
}

output "public_subnets" {
  value = ["${aws_subnet.public.*.cidr_block}"]
}

output "private_subnets" {
  value = ["${aws_subnet.private.*.cidr_block}"]
}  
