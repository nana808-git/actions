locals {
  application_name       = "ss"
  env_name               = "dev"
  domain                 = "nana808test.com"
  application_name_lower = replace(lower(local.application_name), "/[^a-z0-9]/", "")

  environment            = "dev"
  region                 = "us-east-1"
  azs                    = ["us-east-1a", "us-east-1b"]
}

data "aws_acm_certificate" "ssl-cert" {
  domain      = local.domain
  statuses    = ["ISSUED"]
  most_recent = true
}

module "vpc" {
  source = "../../../modules/vpc"

  #azs             = local.azs
  cidr            = "10.100.96.0/20"
  public_subnets  = ["10.100.96.0/22", "10.100.100.0/22"]
  private_subnets = ["10.100.104.0/22", "10.100.108.0/22"]
  region          = local.region 
  cluster_name    = local.application_name
  environment     = local.environment
}

