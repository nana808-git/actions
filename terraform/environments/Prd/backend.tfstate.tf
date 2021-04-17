terraform {
  backend "s3" {
    bucket = "dt-infra"
    key    = "zz/prd/terraform/terraform.tfstate"
    region = "us-east-2"
  }
}