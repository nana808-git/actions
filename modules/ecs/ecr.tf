resource "aws_ecr_repository" "web-app" {
  name = "${var.app["name"]}-${var.app["env"]}-ecr-node"  
}

