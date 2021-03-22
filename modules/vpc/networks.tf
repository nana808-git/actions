resource "aws_subnet" "public" {
  count             = "2"
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.network["publicAz${count.index + 1}"]}"
  availability_zone = "${var.availability_zones["${count.index}"]}"

  tags = {
    Name        = "${var.app["name"]}-${var.app["env"]}-sn-public"
    Application = "${var.app["name"]}"
    Environment = "${var.app["env"]}"
    Purpose     = "public"
  }
}

resource "aws_subnet" "private" {
  count             = "2"
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.network["privateAz${count.index + 1}"]}"
  availability_zone = "${var.availability_zones["${count.index}"]}"

  tags = {
    Name        = "${var.app["name"]}-${var.app["env"]}-sn-private"
    Application = "${var.app["name"]}"
    Environment = "${var.app["env"]}"
    Purpose = "private"
  }
}