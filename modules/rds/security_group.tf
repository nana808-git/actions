resource "aws_security_group" "db-sg" {
  name        = "${var.cluster_name}-${var.environment}-db-sg"
  description = "Access to the RDS instances from the VPC"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    #cidr_blocks = var.cidr
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    #cidr_blocks = var.cidr
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-${var.environment}-db-sg"
  }
}