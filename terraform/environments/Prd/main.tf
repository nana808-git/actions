data "aws_acm_certificate" "ssl-cert" {
  domain      = "nana808test.com"
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_secretsmanager_secret_version" "creds" {
  secret_id = "aop-secret-credentials"
}

locals {
  aop-secret-credentials = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
  #db_endpoint = mudule.rds.db_endpoint
}

module "vpc" { 
  source = "../../../modules/vpc" 
  availability_zones = var.availability_zones
  nat_count          = var.nat_count
  network            = var.network
  app                = var.app
}

module "ecs" {
  source                = "../../../modules/ecs"
  vpc_id                = module.vpc.id
  cluster_name          = "${var.app["name"]}"
  environment           = "${var.app["env"]}"
  image                 = var.image
  region                = var.region
  repository_url        = module.ecs.repository_url
  db_endpoint           = mudule.rds.db_endpoint
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
  app                   = "aop"
  ssl_web_prefix        = "https://"

  helth_check_path      = "/"
  environment_variables = var.environment_variables
  ssl_certificate_arn   = "arn:aws:acm:us-east-2:667736119737:certificate/06695160-eb02-4be0-96d5-e1d86e50847c"
  domain_name           = "nana808test.com"
  availability_zones    = module.vpc.public_subnet_ids
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
  environment_variables = var.environment_variables
  #ssl_certificate_id    = "arn:aws:acm:us-east-2:667736119737:certificate/06695160-eb02-4be0-96d5-e1d86e50847c"
  domain_name           = "nana808test.com"
}

module "rds" {
  source = "../../../modules/rds"
  db_instance_type               = "db.m5.large"
  db_name                        = "sleestak"
  db_port                        = "3306"
  db_profile                     = "mariadb"
  db_initialize                  = "yes"
  db_engine                      = "mariadb"
  db_version                     = "10.4.13"
  db_allocated_storage           = "20"
  cluster_name                   = "${var.app["name"]}"
  environment                    = "${var.app["env"]}"
  vpc_id                         = module.vpc.id
  cidr                           = ["${var.network["cidr"]}"]
  subnet_ids                     = module.vpc.private_subnet_ids
}


