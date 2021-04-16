terraform {
  backend "s3" {
    bucket = "dt-infra"
    key    = "ss/prd/terraform/terraform.tfstate"
    region = "us-east-2"
  }
}