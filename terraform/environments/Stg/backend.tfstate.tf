terraform {
  backend "s3" {
    bucket = "infra-tf-backend"
    key    = "kk/stg/terraform/terraform.tfstate"
    region = "us-east-1"
  }
}
