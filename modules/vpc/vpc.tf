resource "aws_vpc" "vpc" {
  cidr_block           = "${var.network["cidr"]}"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  instance_tenancy     = "default"

  tags = {
    Name        = "${var.app["name"]}-${var.app["env"]}-vpc"
    Application = "${var.app["name"]}"
    Environment = "${var.app["env"]}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name        = "${var.app["name"]}-${var.app["env"]}-igw"
    Application = "${var.app["name"]}"
    Environment = "${var.app["env"]}"
  }
}