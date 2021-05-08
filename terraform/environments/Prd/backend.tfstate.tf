terraform {
  backend "s3" {
    bucket = "infra-tf-backend"
    key    = "ss/prd/terraform/terraform.tfstate"
    region = "us-east-1"
  }
}