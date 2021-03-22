data "aws_subnet" "subnet1" {
  id = "module.vpc.aws_subnet.private[0].id"
}

data "aws_subnet" "subnet2" {
  id = "module.vpc.aws_subnet.private[1].id"
}

resource "aws_db_subnet_group" "default" {
  name        = "cse-cr"
  description = "Private subnets for RDS instance"
  subnet_ids  = [data.aws_subnet.subnet1.id, data.aws_subnet.subnet2.id]
}

resource "aws_db_subnet_group" "db-subnet-grp" {
  name        = "${var.cluster_name}-${var.environment}-db-sgrp"
  description = "Database Subnet Group"
  subnet_ids  = [data.aws_subnet.subnet1.id, data.aws_subnet.subnet2.id]
}

resource "aws_db_instance" "db" {
  identifier        = "${var.cluster_name}-${var.environment}-db-instance"
  allocated_storage = var.db_allocated_storage
  engine            = var.db_engine
  engine_version    = var.db_version
  port              = var.db_port
  instance_class    = var.db_instance_type
  name              = var.db_name
  username          = var.db_user
  password          = var.db_password
  #availability_zone      = var.region
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.db-subnet-grp.id
  parameter_group_name   = "default.mariadb.10"
  publicly_accessible    = false
  skip_final_snapshot    = true

  tags = {
    Name = "${var.cluster_name}-${var.environment}-db"
  }
}