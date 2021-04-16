data "aws_acm_certificate" "ssl-cert" {
  domain      = var.ssl_cert
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

  alb_port         = "80"
  container_port   = "3000"
  helth_check_path = "/"

  db_instance_type     = "db.m5.large"
  db_initialize        = "yes"
  db_port              = "3306"
  db_engine            = "mariadb"
  db_version           = "10.4.13"
  db_profile           = "mariadb"
  db_allocated_storage = "50"
  db_name              = "sleestak"

  git_repository = {
    BranchName       = "main"
    FullRepositoryId = "DigitalTrends/sleestak"
    ConnectionArn    = "arn:aws:codestar-connections:us-west-1:710789462061:connection/ea01e68c-4c90-46b4-aba6-b1c10521a04f"
  }

  domain_name         = var.domain
  ssl_certificate_arn = var.certificate_arn
  cloudfront_ssl      = var.cloudfront_certificate_id
}






