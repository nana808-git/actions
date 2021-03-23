data "aws_secretsmanager_secret_version" "creds" {
  # write your secret name here
  secret_id = "dev/sleestack/mariadb"
}

locals {
  your_secret = jsondecode(
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
  #public_subnets  = ["subnet-0db9434846a05d32c", "subnet-0f3e4ea68b5ac54f3"]
  #private_subnets = ["subnet-0042af9d4fab239e9", "subnet-05ce47c128e2fe4f0"]
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
  db_user              = "local.your_secret.username"
  db_password          = "local.your_secret.password"
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












