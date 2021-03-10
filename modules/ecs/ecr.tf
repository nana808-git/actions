resource "aws_ecr_repository" "web-app" {
  name = "${var.cluster_name}-${var.environment}-ecr-node"  
}

