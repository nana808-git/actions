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
  peered_cidr               = "10.100.208.0/20"
}


module "pipeline" {
  source = "../../../modules/pipelines/Stg"

  vpc_id                         = module.vpc.id
  cidr                           = "${var.network["cidr"]}"
  cluster_name                   = "${var.app["name"]}"
  environment                    = "${var.app["env"]}"
  container_name                 = "${var.app["name"]}"
  app_repository_name            = "${var.app["name"]}"
  repository_url                 = "bbb"
  repository_name                = "vvv"
  environment_variables          = var.environment_variables

  build_options                  = var.build_options
  build_args                     = var.build_args
  subnet_ids                     = module.vpc.private_subnet_ids
  security_group                 = module.vpc.default_security_group_id
  db_endpoint                    = "xxx"
  ssl_web_prefix                 = "https://"
  domain_name                    = "dtmediagrp.com"

  peered_vpc_id               = "vpc-0e309e682ea9e3f0f"
  peered_region               = "us-east-2"
  peered_cidr                 = "10.100.208.0/20"
  
  APP_WEB_URL                    = local.aop-secret-credentials.APP_WEB_URL
  JUNGLESCOUT_USERNAME           = local.aop-secret-credentials.JUNGLESCOUT_USERNAME
  JUNGLESCOUT_PASSWORD           = local.aop-secret-credentials.JUNGLESCOUT_PASSWORD
  SQL_DB_USER                    = local.aop-secret-credentials.SQL_DB_USER
  SQL_DB_PASSWORD                = local.aop-secret-credentials.SQL_DB_PASSWORD
  WORDPRESS_SECRET_KEY           = local.aop-secret-credentials.WORDPRESS_SECRET_KEY
  ASANA_SECRET_KEY               = local.aop-secret-credentials.ASANA_SECRET_KEY

  region                         = "us-west-1"
  prd_env                        = "prd"
  prd_region                     = "us-east-2"

  git_repository = {
    BranchName       = "main"
    FullRepositoryId = "DigitalTrends/sleestak"
    ConnectionArn    = "arn:aws:codestar-connections:us-west-1:710789462061:connection/ea01e68c-4c90-46b4-aba6-b1c10521a04f"
  }
}