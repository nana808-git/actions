resource "aws_db_subnet_group" "db-subnet-grp" {
  name        = "${var.app["name"]}-${var.app["env"]}-db-sgrp"
  description = "Database Subnet Group"
  subnet_ids  = aws_subnet.private.*.id
}

resource "aws_db_instance" "db" {
  identifier        = "${var.app["name"]}-${var.app["env"]}-db-instance"
  allocated_storage = var.db_allocated_storage
  engine            = var.db_engine
  engine_version    = var.db_version
  port              = var.db_port
  instance_class    = var.db_instance_type
  name              = var.db_name
  username          = var.db_user
  password          = data.aws_ssm_parameter.dbpassword.value
  availability_zone      = var.private_subnets
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.db-subnet-grp.id
  parameter_group_name   = "default.mariadb.10"
  publicly_accessible    = false
  skip_final_snapshot    = true

  tags = {
    Name = "${var.app["name"]}-${var.app["env"]}-db"
  }
}