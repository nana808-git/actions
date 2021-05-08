# App Security Group
resource "aws_security_group" "app_sg" {
  name        = "${var.cluster_name}-${var.environment}-node-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = var.vpc_id

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }

  tags = {
    Environment = var.cluster_name
    Name = "${var.cluster_name}-${var.environment}-node-sg"
  }
}

# ALB Security Group
resource "aws_security_group" "alb_sg" {
  name        = "${var.cluster_name}-${var.environment}-alb-sg"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443" #"${var.container_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port   = "22"
    to_port     = "22" 
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-${var.environment}-alb-sg"
  }
}

# ECS Cluster Security Group
resource "aws_security_group" "ecs_sg" {
  vpc_id      = var.vpc_id
  name        = "${var.cluster_name}-${var.environment}-ecs-svc-sg"
  description = "Allow egress from container"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "80"
    #to_port     = var.container_port
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.cluster_name}-${var.environment}-ecs-svc-sg"
    Environment = var.cluster_name
  }
}

