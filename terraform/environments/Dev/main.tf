data "aws_secretsmanager_secret_version" "creds" {
  secret_id = "ss-dev-db-creds"
}

locals {
  ss-dev-db-creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

data "aws_acm_certificate" "ssl-cert" {
  domain      = var.domain
  statuses    = ["ISSUED"]
  most_recent = true
}

module "vpc" { 
  source = "../../../modules/vpc" 

  availability_zones = var.availability_zones
  nat_count          = var.nat_count
  network            = var.network
  app                = var.app
  
}

module "ecs-pipeline" {
  source = "../../.."

  vpc_id          = module.vpc.id
  public_subnets   = module.vpc.public_subnet_ids
  private_subnets  = module.vpc.private_subnet_ids
  cidr            = ["${var.network["cidr"]}"]
  azs             = var.availability_zones
  region              = var.region

  cluster_name        = "${var.app["name"]}"
  app_repository_name = "${var.app["name"]}"
  container_name      = "${var.app["name"]}"
  environment         = "${var.app["env"]}"
  repository_name     = "${var.app["name"]}-${var.app["env"]}-ecr-node" 

  alb_port         = "80"
  container_port   = "3000"
  helth_check_path = "/"

  db_instance_type     = "db.r4.2xlarge"
  db_user              = "local.ss-dev-db-creds.db_user"
  db_password          = "local.ss-dev-db-creds.db_password"
  db_initialize        = "yes"
  db_port              = "3306"
  db_engine            = "mariadb"
  db_version           = "10.4.13"
  db_profile           = "mariadb"
  db_allocated_storage = "5"
  db_name              = "sleestak"

  git_repository = {
    BranchName       = "main"
    FullRepositoryId = "nana808-git/sleestack"
    ConnectionArn    = "arn:aws:codestar-connections:us-east-1:667736119737:connection/fc834fd4-ccfc-43a9-a4cc-12133eee0c30"
  }

  domain_name         = var.domain
  ssl_certificate_arn = var.certificate_arn
}












