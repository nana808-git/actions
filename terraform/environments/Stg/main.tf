data "aws_acm_certificate" "ssl-cert" {
  domain      = var.ssl_cert
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
  app                   = "aop-stg"
  ssl_web_prefix        = "https://"

  helth_check_path      = "/"
  environment_variables = var.environment_variables
  ssl_certificate_arn   = var.certificate_arn
  domain_name           = var.domain
  availability_zones    = module.vpc.public_subnet_ids
}

module "cdn" {

  source = "../../../modules/cdn"
  vpc_id                = module.vpc.id
  cluster_name          = "${var.app["name"]}"
  app                   = "aop-stg"
  environment           = "${var.app["env"]}"
  alb_dns_name          = module.ecs.alb_dns_name
  app_repository_name   = "${var.app["name"]}"
  alb_port              = "80"
  container_port        = "3000"
  helth_check_path      = "/"
  environment_variables = var.environment_variables
  #ssl_certificate_id    = var.cloudfront_certificate_id
  domain_name           = var.domain
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

module "pipeline" {
  source = "../../../modules/pipeline"
  vpc_id          = module.vpc.id
  cluster_name                   = "${var.app["name"]}"
  environment                    = "${var.app["env"]}"
  image                          = var.image
  #codestar_connector_credentials = var.codestar_connector_credentials
  container_name                 = var.container_name
  app_repository_name            = "${var.app["name"]}"
  repository_url                 = var.repository_url
  repository_name                = var.repository_name
  app_service_name               = var.app_service_name
  environment_variables          = var.environment_variables

  build_options                  = var.build_options
  build_args                     = var.build_args
  subnet_ids                     = module.vpc.private_subnet_ids
  security_group                 = module.vpc.default_security_group_id
  db_endpoint                    = var.db_endpoint
  ssl_web_prefix                 = "https://"
  #app                            = "aop"
  domain_name                    = var.domain
  pipeline_s3_arn                = var.pipeline_s3_arn
  #APP_WEB_URL                    = "${var.ssl_web_prefix}${var.app}.${var.domain_name}"
  JUNGLESCOUT_USERNAME           = local.aop-secret-credentials.JUNGLESCOUT_USERNAME
  JUNGLESCOUT_PASSWORD           = local.aop-secret-credentials.JUNGLESCOUT_PASSWORD
  SQL_DB_USER                    = local.aop-secret-credentials.SQL_DB_USER
  SQL_DB_PASSWORD                = local.aop-secret-credentials.SQL_DB_PASSWORD
  WORDPRESS_SECRET_KEY           = local.aop-secret-credentials.WORDPRESS_SECRET_KEY

  prd_env                        = "prd"

  git_repository = {
    BranchName       = "main"
    FullRepositoryId = "naboagye-eng/sleestak"
    ConnectionArn    = "arn:aws:codestar-connections:us-west-1:667736119737:connection/c4b85da7-c515-468c-997f-b216610ba7ee"
  }
}


