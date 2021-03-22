resource "aws_security_group" "main" {
  name        = "${var.app["name"]}-${var.app["env"]}-sg-default"
  description = "Default VPC security group"
  vpc_id      = "${aws_vpc.vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.app["name"]}-${var.app["env"]}-sg-default"
    Application = "${var.app["name"]}"
    Environment = "${var.app["env"]}"
    Purpose     = "default"
  }
}