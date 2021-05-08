data "aws_iam_server_certificate" "ssl-cert" {
  name_prefix = "Star_dtmediagrp.com"
  latest      = true
}

data "aws_secretsmanager_secret_version" "creds" {
  secret_id = "aop-secret-credentials"
}

locals {
  aop-secret-credentials = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

module "vpc" { 
  source = "../../../modules/vpc" 

  availability_zones        = var.availability_zones
  nat_count                 = var.nat_count
  network                   = var.network
  app                       = var.app
  vpc_peering_connection_id = "pcx-0940ede3ef7b14df4"
  peered_cidr               = "10.100.96.0/20"
}

module "ecs" {
  source                = "../../../modules/ecs"

  vpc_id                = module.vpc.id
  cluster_name          = "${var.app["name"]}"
  environment           = "${var.app["env"]}"
  region                = var.region
  repository_url        = module.ecs.repository_url
  db_endpoint           = module.rds.db_endpoint
  container_name        = "${var.app["name"]}"
  app_repository_name   = "${var.app["name"]}"
  repository_name       = module.ecs.repository_name
  alb_port              = "80"
  container_port        = "3000"
  min_tasks             = "2"
  max_tasks             = "4"
  cpu_to_scale_up       = "80"
  cpu_to_scale_down     = "30"
  desired_tasks         = "2"
  desired_task_cpu      = "256"
  desired_task_memory   = "512"
  image_tag             = "latest"
  app                   = "aop"
  ssl_web_prefix        = "https://"

  APP_WEB_URL           = local.aop-secret-credentials.APP_WEB_URL
  JUNGLESCOUT_USERNAME  = local.aop-secret-credentials.JUNGLESCOUT_USERNAME
  JUNGLESCOUT_PASSWORD  = local.aop-secret-credentials.JUNGLESCOUT_PASSWORD
  SQL_DB_USER           = local.aop-secret-credentials.SQL_DB_USER
  SQL_DB_PASSWORD       = local.aop-secret-credentials.SQL_DB_PASSWORD
  WORDPRESS_SECRET_KEY  = local.aop-secret-credentials.WORDPRESS_SECRET_KEY
  ASANA_SECRET_KEY      = local.aop-secret-credentials.ASANA_SECRET_KEY

  helth_check_path      = "/"
  environment_variables = var.environment_variables
  ssl_certificate_arn   = "arn:aws:iam::710789462061:server-certificate/Star_dtmediagrp.com"
  domain_name           = "dtmediagrp.com"
  availability_zones    = module.vpc.public_subnet_ids
}

module "rds" {
  source = "../../../modules/rds"

  db_instance_type               = "db.t3.medium"
  db_name                        = "sleestak"
  db_port                        = "3306"
  db_profile                     = "mariadb"
  db_initialize                  = "yes"
  db_engine                      = "mariadb"
  db_version                     = "10.4.13"
  db_allocated_storage           = "20"
  backup_retention_period        = "7"
  backup_window                  = "05:00-06:00"
  cluster_name                   = "${var.app["name"]}"
  environment                    = "${var.app["env"]}"
  vpc_id                         = module.vpc.id
  cidr                           = ["${var.network["cidr"]}"]
  subnet_ids                     = module.vpc.private_subnet_ids
}

module "cdn" {
  source = "../../../modules/cdn"

  vpc_id                = module.vpc.id
  cluster_name          = "${var.app["name"]}"
  app                   = "aop"
  environment           = "${var.app["env"]}"
  alb_dns_name          = module.ecs.alb_dns_name
  app_repository_name   = "${var.app["name"]}"
  alb_port              = "80"
  container_port        = "3000"
  helth_check_path      = "/"
  domain_name           = "dtmediagrp.com"
  ssl_certificate_id    = "ASCA2K7S2PAWRMDVOM4LW"
}

module "pipeline" {
  source = "../../../modules/pipelines/Prd"

  vpc_id                         = module.vpc.id
  cidr                           = "${var.network["cidr"]}"
  cluster_name                   = "${var.app["name"]}"
  environment                    = "${var.app["env"]}"
  container_name                 = "${var.app["name"]}"
  app_repository_name            = "${var.app["name"]}"
  repository_url                 = module.ecs.repository_url
  repository_name                = module.ecs.repository_name
  environment_variables          = var.environment_variables

  build_options                  = var.build_options
  build_args                     = var.build_args
  subnet_ids                     = module.vpc.private_subnet_ids
  security_group                 = module.vpc.default_security_group_id
  db_endpoint                    = module.rds.db_endpoint
  ssl_web_prefix                 = "https://"
  domain_name                    = "dtmediagrp.com"

  vpc_peering_connection_id      = "pcx-0940ede3ef7b14df4"

  APP_WEB_URL                    = local.aop-secret-credentials.APP_WEB_URL
  JUNGLESCOUT_USERNAME           = local.aop-secret-credentials.JUNGLESCOUT_USERNAME
  JUNGLESCOUT_PASSWORD           = local.aop-secret-credentials.JUNGLESCOUT_PASSWORD
  SQL_DB_USER                    = local.aop-secret-credentials.SQL_DB_USER
  SQL_DB_PASSWORD                = local.aop-secret-credentials.SQL_DB_PASSWORD
  WORDPRESS_SECRET_KEY           = local.aop-secret-credentials.WORDPRESS_SECRET_KEY
  ASANA_SECRET_KEY               = local.aop-secret-credentials.ASANA_SECRET_KEY
  STG_SQL_SERVER                 = local.aop-secret-credentials.STG_SQL_SERVER

  git_repository = {
    BranchName       = "main"
    FullRepositoryId = "DigitalTrends/sleestak"
    ConnectionArn    = "arn:aws:codestar-connections:us-west-1:710789462061:connection/ea01e68c-4c90-46b4-aba6-b1c10521a04f"
  }
}