terraform {
  backend "s3" {
    bucket = "infra-tf-backend"
    key    = "rr/stg/terraform/terraform.tfstate"
    region = "us-east-1"
  }
}
