

data "aws_acm_certificate" "ssl-cert" {
  domain      = var.domain
  statuses    = ["ISSUED"]
  most_recent = true
}

module "vpc" { 
  source = "github.com/nana808-git/vpc-DT-clone" 

  availability_zones = var.availability_zones
  nat_count          = var.nat_count
  network            = var.network
  app                = var.app
  
}

module "ecs-pipeline" {
  source = "../../.."

  vpc_id          = "module.vpc.aws_vpc.vpc.id"
  #public_subnets  = "${var.network["publicAz1, publicAz1"]}"
  #private_subnets = "${var.network["privateAz1, privateAz1"]}"
  public_subnets   = ["module.vpc.aws_subnet.public[0].cidr_block", "module.vpc.aws_subnet.public[1].cidr_block"]
  private_subnets  = ["module.vpc.aws_subnet.private[0].cidr_block", "module.vpc.aws_subnet.private[1].cidr_block"]
  #public_subnet_ids = [aws_subnet.public.*.id]
  #private_subnet_ids = [module.vpc.aws_subnet.private.*.id]
  cidr            = ["${var.network["cidr"]}"]
  #cidr             = ["module.vpc.aws_vpc.vpc.cidr_block"]
  azs             = var.availability_zones
  #subnet_ids      = flatten([module.vpc.public_subnets, module.vpc.private_subnets])

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
  db_user              = "root"
  db_password          = "admin"
  db_initialize        = "yes"
  db_port              = "3306"
  db_engine            = "mariadb"
  db_version           = "10.4.13"
  db_profile           = "mariadb"
  db_allocated_storage = "5"
  db_name              = "${var.app["name"]}-${var.app["env"]}-db"

  git_repository = {
    BranchName       = "main"
    FullRepositoryId = "nana808-git/sleestack"
    ConnectionArn    = "arn:aws:codestar-connections:us-east-1:667736119737:connection/fc834fd4-ccfc-43a9-a4cc-12133eee0c30"
  }

  domain_name         = var.domain
  ssl_certificate_arn = var.certificate_arn
}












