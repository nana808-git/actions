resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = var.vpc_peering_connection_id
  auto_accept               = true

  tags = {
    Name = "${var.cluster_name}-${var.environment}-vpc-peering"
  }
}
