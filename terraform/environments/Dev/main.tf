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
  source = "github.com/nana808-git/vpc-DT-clone" 

  availability_zones = var.availability_zones
  nat_count          = var.nat_count
  network            = var.network
  app                = var.app
}


