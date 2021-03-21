resource "aws_ecs_cluster" "cluster" {
  name = "${var.cluster_name}-${var.environment}-ecs-node"  
}

resource "aws_cloudwatch_log_group" "web-app" {
  name = "${var.cluster_name}-${var.environment}-logs"

  tags = {
    Application = var.cluster_name
  }
}

