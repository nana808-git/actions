resource "aws_eip" "nat" {
  count = "${var.nat_count}"
  vpc   = true

  tags = {
    Name        = "${var.app["name"]}-${var.app["env"]}-eip"
    Application = "${var.app["name"]}"
    Environment = "${var.app["env"]}"
  }
}

resource "aws_nat_gateway" "nat" {
  count         = "${var.nat_count}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"

  tags = {
    Name        = "${var.app["name"]}-${var.app["env"]}-ng"
    Application = "${var.app["name"]}"
    Environment = "${var.app["env"]}"
  }
}