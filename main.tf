data "aws_secretsmanager_secret_version" "creds" {
  secret_id = "aop-secret-credentials"
}

locals {
  aop-secret-credentials = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

module "pipeline" {
  source = "./modules/pipeline"
  cluster_name                   = var.cluster_name
  environment                    = var.environment
  image                          = var.image
  codestar_connector_credentials = var.codestar_connector_credentials
  container_name                 = var.container_name
  app_repository_name            = var.app_repository_name
  repository_name                = var.repository_name
  git_repository                 = var.git_repository
  repository_url                 = module.ecs.repository_url
  app_service_name               = module.ecs.service_name
  environment_variables          = var.environment_variables
  vpc_id                         = var.vpc_id
  db_endpoint                    = module.rds.db_endpoint
  s3-bucket                      = module.cdn.s3-bucket

  build_options                  = var.build_options
  build_args                     = var.build_args
  subnet_ids                     = var.private_subnets
  security_group                 = var.security_group
  ssl_web_prefix                 = var.ssl_web_prefix
  app                            = var.app
  domain_name                    = var.domain_name
  APP_WEB_URL                    = "${var.ssl_web_prefix}${var.app}.${var.domain_name}"

  JUNGLESCOUT_USERNAME           = local.aop-secret-credentials.JUNGLESCOUT_USERNAME
  JUNGLESCOUT_PASSWORD           = local.aop-secret-credentials.JUNGLESCOUT_PASSWORD
  SQL_DB_USER                    = local.aop-secret-credentials.SQL_DB_USER
  SQL_DB_PASSWORD                = local.aop-secret-credentials.SQL_DB_PASSWORD
  WORDPRESS_SECRET_KEY           = local.aop-secret-credentials.WORDPRESS_SECRET_KEY
}

module "ecs" {
  source                = "./modules/ecs"
  vpc_id                = var.vpc_id
  cluster_name          = var.cluster_name
  environment           = var.environment
  image                 = var.image
  region                = var.region
  repository_url        = module.ecs.repository_url
  db_endpoint           = module.rds.db_endpoint
  container_name        = var.container_name
  app_repository_name   = var.app_repository_name
  repository_name       = var.repository_name
  alb_port              = var.alb_port
  container_port        = var.container_port
  min_tasks             = var.min_tasks
  max_tasks             = var.max_tasks
  cpu_to_scale_up       = var.cpu_to_scale_up
  cpu_to_scale_down     = var.cpu_to_scale_down
  desired_tasks         = var.desired_tasks
  desired_task_cpu      = var.desired_task_cpu
  desired_task_memory   = var.desired_task_memory
  app                   = var.app
  ssl_web_prefix        = var.ssl_web_prefix

  helth_check_path      = var.helth_check_path
  environment_variables = var.environment_variables
  ssl_certificate_arn   = var.ssl_certificate_arn
  domain_name           = var.domain_name

  availability_zones    = var.public_subnets
}

module "cdn" {

  source = "./modules/cdn"
  vpc_id                = var.vpc_id
  cluster_name          = var.cluster_name
  app                   = var.app
  environment           = var.environment
  alb_dns_name          = module.ecs.alb_dns_name
  app_repository_name   = var.app_repository_name
  alb_port              = var.alb_port
  container_port        = var.container_port
  helth_check_path      = var.helth_check_path
  environment_variables = var.environment_variables
  ssl_certificate_id    = var.cloudfront_ssl
  domain_name           = var.domain_name 
}

module "rds" {
  source = "./modules/rds"
  db_instance_type               = var.db_instance_type
  db_name                        = var.db_name
  db_port                        = var.db_port
  db_profile                     = var.db_profile
  db_initialize                  = var.db_initialize
  db_engine                      = var.db_engine
  db_version                     = var.db_version
  db_allocated_storage           = var.db_allocated_storage 
  cluster_name                   = var.cluster_name
  environment                    = var.environment
  vpc_id                         = var.vpc_id
  cidr                           = var.cidr
  subnet_ids                     = var.private_subnets
}


