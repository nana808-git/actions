

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

