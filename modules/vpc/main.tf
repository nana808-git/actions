
resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = {
    Name = "${var.cluster_name}-${var.environment}-vpc"
  }
}

resource "aws_subnet" "private" {
  cidr_block        = "var.private_subnets"
  #availability_zone = var.azs
  vpc_id            = aws_vpc.main.id
  tags = {
    Name = "${var.cluster_name}-${var.environment}-sn-private"
  }
}

resource "aws_subnet" "public" {
  cidr_block              = "var.public_subnets"
  #availability_zone       = var.azs
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.cluster_name}-${var.environment}-sn-public"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.cluster_name}-${var.environment}-igw"
  }
}

resource "aws_route" "public-route" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_eip" "eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "${var.cluster_name}-${var.environment}-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  subnet_id     = element(aws_subnet.public.*.id)
  allocation_id = element(aws_eip.eip.*.id)
  tags = {
    Name = "${var.cluster_name}-${var.environment}-ng"
  }
}

resource "aws_route_table" "private-route-table" {
  #count  = var.az_count
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat.*.id)
  }
  tags = {
    Name = "${var.cluster_name}-${var.environment}-rt-private"
  }
}


resource "aws_route_table_association" "route-association" {
  #count          = var.az_count
  subnet_id      = element(aws_subnet.private.*.id)
  route_table_id = element(aws_route_table.private-route-table.*.id)
}