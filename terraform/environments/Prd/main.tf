locals {
  application_name       = "ss"
  env_name               = "dev"
  domain                 = "nana808test.com"
  application_name_lower = replace(lower(local.application_name), "/[^a-z0-9]/", "")

  environment = "dev"

  azs = ["us-east-1a", "us-east-1b"]
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
  cidr            = "10.10.96.0/20"
  public_subnets  = ["10.10.96.0/22", "10.10.100.0/22"]
  #private_subnets = ["10.10.104.0/22", "10.10.108.0/22"]

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
  environment         = local.environment

  alb_port         = "80"
  container_port   = "3000"
  helth_check_path = "/ping"
 
  #build_options = "-f ./build/Dockerfile"
  #build_args = {
  #  is_build_mode_prod  = "true"
  #  build_configuration = "dev"
  #}

  git_repository = {
    BranchName       = "master"
    FullRepositoryId = "nana808-git/AWS-React-Project"
    ConnectionArn    = "arn:aws:codestar-connections:us-east-1:667736119737:connection/de8b7714-0993-451e-b525-123611d6d915"
  }

  domain_name         = local.domain
  ssl_certificate_arn = "arn:aws:acm:us-east-1:667736119737:certificate/8a4cdeec-e44c-42c0-b4ce-c1d2dc12f657"
}










