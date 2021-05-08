resource "aws_db_subnet_group" "db-subnet-grp" {
  name        = "${var.cluster_name}-${var.environment}-db-sgrp"
  description = "Database Subnet Group"
  subnet_ids  = var.subnet_ids
}

data "aws_secretsmanager_secret_version" "creds" {
  secret_id = "aop-secret-credentials"
}

locals {
  aop-secret-credentials = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

resource "aws_db_instance" "db" {
  identifier        = "${var.cluster_name}-${var.environment}-db-instance"
  allocated_storage = var.db_allocated_storage
  engine            = var.db_engine
  engine_version    = var.db_version
  port              = var.db_port
  instance_class    = var.db_instance_type
  name              = var.db_name
  username          = local.aop-secret-credentials.username
  password          = local.aop-secret-credentials.password
  
  vpc_security_group_ids  = [aws_security_group.db-sg.id]
  multi_az                = false
  db_subnet_group_name    = aws_db_subnet_group.db-subnet-grp.id
  publicly_accessible     = false
  skip_final_snapshot     = true
  apply_immediately       = true
  deletion_protection     = true
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  enabled_cloudwatch_logs_exports = ["general", "error"]

  tags = {
    Name = "${var.cluster_name}-${var.environment}-db"
  }
}


