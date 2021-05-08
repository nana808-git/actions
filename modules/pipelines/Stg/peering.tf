resource "aws_vpc_peering_connection" "main" {
  peer_vpc_id   = var.peered_vpc_id
  vpc_id        = var.vpc_id
  peer_region   = var.peered_region

  tags = {
    Name = "${var.cluster_name}-${var.environment}-vpc-peering"
  }
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr
}

resource "aws_vpc" "peered" {
  cidr_block = var.peered_cidr
}
