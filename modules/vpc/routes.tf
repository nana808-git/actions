resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name        = "${var.app["name"]}-${var.app["env"]}-rt-public"
    Application = "${var.app["name"]}"
    Environment = "${var.app["env"]}"
    Purpose     = "public"
  }
}

resource "aws_route" "public" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

resource "aws_route_table_association" "public" {
  count          = "2"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"
  count  = "2"

  tags = {
    Name        = "${var.app["name"]}-${var.app["env"]}-rt-private"
    Application = "${var.app["name"]}"
    Environment = "${var.app["env"]}"
    Purpose     = "private"
  }
}

resource "aws_route" "private" {
  count                  = "2"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  nat_gateway_id         = "${var.nat_count == "1" ? aws_nat_gateway.nat.0.id : element(aws_nat_gateway.nat.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private" {
  count = "2"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route" "peering" {
  count                  = "2"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  vpc_peering_connection_id = var.vpc_peering_connection_id
  destination_cidr_block = var.peered_cidr
}