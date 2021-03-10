locals {
  application_name       = "ss"
  env_name               = "dev"
  domain                 = "*.isvc.tech"
  application_name_lower = replace(lower(local.application_name), "/[^a-z0-9]/", "")

  environment = "dev"

  azs = ["us-west-1c", "us-west-1b"]
}

data "aws_acm_certificate" "ssl-cert" {
  domain      = local.domain
  statuses    = ["ISSUED"]
  most_recent = true
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.application_name

  azs             = local.azs
  cidr            = "10.100.96.0/20"
  public_subnets  = ["10.100.96.0/22", "10.100.100.0/22"]

  enable_ipv6 = false

  tags = {
    Terraform   = "true"
    Application = local.application_name
    Environment = local.env_name
  }
}

module "ecs-pipeline" {
  source = "../../.."

  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets

  cluster_name        = local.application_name
  app_repository_name = local.application_name
  container_name      = local.application_name
  image               = "710789462061.dkr.ecr.us-west-1.amazonaws.com/ss-dev-ecr-node:latest"
  environment         = local.environment

  alb_port         = "80"
  container_port   = "3000"
  helth_check_path = "/"

  git_repository = {
    BranchName       = "main"
    FullRepositoryId = "naboagye-eng/sleestak"
    ConnectionArn    = "arn:aws:codestar-connections:us-west-1:710789462061:connection/024d34e3-7643-4ffe-ab6a-93053546f46f"
  }

  domain_name         = local.domain
  ssl_certificate_arn = "arn:aws:acm:us-west-1:710789462061:certificate/5841c2c4-403a-436b-bf03-91f891677fba"
}











