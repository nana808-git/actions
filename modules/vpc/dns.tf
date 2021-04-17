resource "aws_route53_zone" "main" {
  name          = "${var.app["name"]}-${var.app["env"]}.internal"
  force_destroy = true

  vpc {
    vpc_id = "${aws_vpc.vpc.id}"
  }

  lifecycle {
    ignore_changes = [vpc]
  }
}