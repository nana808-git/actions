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
}

module "vpc" { 
  source = "../../../modules/vpc" 

  availability_zones = var.availability_zones
  nat_count          = var.nat_count
  network            = var.network
  app                = var.app
}

module "ecs-infra" {
  source = "../../.."

  vpc_id          = module.vpc.id
  public_subnets  = module.vpc.public_subnet_ids
  private_subnets = module.vpc.private_subnet_ids
  cidr            = ["${var.network["cidr"]}"]
  azs             = var.availability_zones
  region          = var.region
  security_group  = module.vpc.default_security_group_id

  app                 = "aop"
  ssl_web_prefix      = "https://"
  cluster_name        = "${var.app["name"]}"
  app_repository_name = "${var.app["name"]}"
  container_name      = "${var.app["name"]}"
  environment         = "${var.app["env"]}"
  repository_name     = "${var.app["name"]}-${var.app["env"]}-ecr-node" 
  db_endpoint           = var.db_endpoint

  alb_port         = "80"
  container_port   = "3000"
  helth_check_path = "/"

  db_instance_type     = "db.m5.large"
  db_initialize        = "yes"
  db_port              = "3306"
  db_engine            = "mariadb"
  db_version           = "10.4.13"
  db_profile           = "mariadb"
  db_allocated_storage = "5"
  db_name              = "sleestak"

  domain_name         = var.domain
  ssl_certificate_arn = var.certificate_arn
  #cloudfront_ssl      = var.cloudfront_certificate_id
}

module "pipeline" {
  source = "../../../modules/pipeline"
  vpc_id          = module.vpc.id
  cluster_name                   = "${var.app["name"]}"
  environment                    = "${var.app["env"]}"
  image                          = var.image
  #codestar_connector_credentials = var.codestar_connector_credentials
  container_name                 = var.container_name
  app_repository_name            = var.repository_name
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
  #APP_WEB_URL                    = "${var.ssl_web_prefix}${var.app}.${var.domain_name}"
  JUNGLESCOUT_USERNAME           = local.aop-secret-credentials.JUNGLESCOUT_USERNAME
  JUNGLESCOUT_PASSWORD           = local.aop-secret-credentials.JUNGLESCOUT_PASSWORD
  SQL_DB_USER                    = local.aop-secret-credentials.SQL_DB_USER
  SQL_DB_PASSWORD                = local.aop-secret-credentials.SQL_DB_PASSWORD
  WORDPRESS_SECRET_KEY           = local.aop-secret-credentials.WORDPRESS_SECRET_KEY

  git_repository = {
    BranchName       = "main"
    FullRepositoryId = "naboagye-eng/sleestak"
    ConnectionArn    = "arn:aws:codestar-connections:us-west-1:667736119737:connection/c4b85da7-c515-468c-997f-b216610ba7ee"
  }
}


