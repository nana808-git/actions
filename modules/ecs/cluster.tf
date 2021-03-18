resource "aws_ecs_cluster" "cluster" {
  name = "${var.app["name"]}-${var.app["env"]}-ecs-node"  
}

resource "aws_cloudwatch_log_group" "web-app" {
  name = "${var.app["name"]}-${var.app["env"]}-logs"

  tags = {
    Application = var.cluster_name
  }
}

