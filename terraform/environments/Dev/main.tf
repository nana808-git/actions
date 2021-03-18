

module "vpc" { 
  source = "github.com/nana808-git/vpc-DT-clone" 

  availability_zones = var.availability_zones
  nat_count          = var.nat_count
  network            = var.network
  app                = var.app
}


